const { getPool } = require('../src/config/database');
const fs = require('fs');
const path = require('path');

function X(v) { return (v ?? 0); }

async function generarXML() {
  const pool = await getPool();
  const anio = new Date().getFullYear();
  const mes = new Date().getMonth() + 1;

  // --- Latest evaluation per client (handle duplicates) ---
  const evaluaciones = (await pool.request().query(`
    SELECT e.C_id_cliente, e.D_nivel_riesgo, e.N_puntaje_total,
           e.D_tipo_cliente, e.N_puntaje_profesion, e.N_puntaje_ingresos,
           e.N_puntaje_provincia, e.N_puntaje_canton, e.N_puntaje_distrito,
           e.F_fecha_evaluacion, p.D_descripcion AS pais
    FROM Evaluacion_Riesgo e
    LEFT JOIN Cliente c ON e.C_id_cliente = c.C_id_cliente
    LEFT JOIN Pais p ON c.C_id_pais = p.C_id_pais
    INNER JOIN (
      SELECT C_id_cliente, MAX(F_fecha_evaluacion) AS max_fecha
      FROM Evaluacion_Riesgo GROUP BY C_id_cliente
    ) latest ON e.C_id_cliente = latest.C_id_cliente
            AND e.F_fecha_evaluacion = latest.max_fecha
  `)).recordset;

  const totalClientes = evaluaciones.length;

  // Helper: group by risk level
  function byRisk(arr) {
    const groups = {};
    for (const r of arr) {
      const rl = r.TipoRiesgo || 'BAJO';
      if (!groups[rl]) groups[rl] = { ...r, CantidadOperaciones: 0, MontoTotal: 0, ClientesConOperaciones: 0, NumeroClientes: 0, PorcentajeClientes: 0 };
      groups[rl].CantidadOperaciones += X(r.CantidadOperaciones);
      groups[rl].MontoTotal += X(r.MontoTotal);
      groups[rl].ClientesConOperaciones += X(r.ClientesConOperaciones);
      groups[rl].NumeroClientes += X(r.NumeroClientes);
    }
    return Object.values(groups);
  }

  // --- Cuadro A: Total clientes por riesgo ---
  const cuadroA = {};
  for (const e of evaluaciones) {
    const rl = (e.D_nivel_riesgo || 'BAJO').toUpperCase();
    if (!cuadroA[rl]) cuadroA[rl] = 0;
    cuadroA[rl]++;
  }
  const cuadroAData = Object.entries(cuadroA).map(([rl, cnt]) => ({
    TipoRiesgo: rl, NumeroClientes: cnt,
    PorcentajeClientes: totalClientes > 0 ? ((cnt / totalClientes) * 100).toFixed(2) : '0.00'
  }));

  // --- Productos con riesgo para cuadros D, E, F ---
  const productosRiesgo = (await pool.request().query(`
    SELECT DISTINCT p.C_id_producto, p.C_id_cliente, p.C_id_tipo_producto,
           p.M_monto, tp.D_nombre AS tipo,
           COALESCE(er.D_nivel_riesgo, 'BAJO') AS riesgo
    FROM Producto p
    LEFT JOIN Cliente c ON p.C_id_cliente = c.C_id_cliente
    LEFT JOIN (
      SELECT C_id_cliente, D_nivel_riesgo, F_fecha_evaluacion,
             ROW_NUMBER() OVER (PARTITION BY C_id_cliente ORDER BY F_fecha_evaluacion DESC) AS rn
      FROM Evaluacion_Riesgo
    ) er ON c.C_id_cliente = er.C_id_cliente AND er.rn = 1
    LEFT JOIN Tipo_Producto tp ON p.C_id_tipo_producto = tp.C_id_tipo_producto
  `)).recordset;

  // --- Cuadro D: Activas (Prestamo=6, Tarjeta Credito=7, Linea Credito=9, Descuento Factura) ---
  const activasIDs = [6, 7, 9];
  const activas = productosRiesgo
    .filter(p => activasIDs.includes(p.C_id_tipo_producto))
    .reduce((acc, p) => {
      const rl = (p.riesgo || 'BAJO').toUpperCase();
      if (!acc[rl]) acc[rl] = { TipoRiesgo: rl, CantidadOperaciones: 0, MontoTotal: 0 };
      acc[rl].CantidadOperaciones++;
      acc[rl].MontoTotal += Number(p.M_monto || 0);
      return acc;
    }, {});

  // Also include Descuento_Factura
  const descuentos = (await pool.request().query(`
    SELECT df.C_id_producto, COALESCE(er.D_nivel_riesgo, 'BAJO') AS riesgo,
           df.N_monto_factura AS monto
    FROM Descuento_Factura df
    JOIN Producto p ON df.C_id_producto = p.C_id_producto
    LEFT JOIN Cliente c ON p.C_id_cliente = c.C_id_cliente
    LEFT JOIN (
      SELECT C_id_cliente, D_nivel_riesgo, F_fecha_evaluacion,
             ROW_NUMBER() OVER (PARTITION BY C_id_cliente ORDER BY F_fecha_evaluacion DESC) AS rn
      FROM Evaluacion_Riesgo
    ) er ON c.C_id_cliente = er.C_id_cliente AND er.rn = 1
  `)).recordset;

  for (const d of descuentos) {
    const rl = (d.riesgo || 'BAJO').toUpperCase();
    if (!activas[rl]) activas[rl] = { TipoRiesgo: rl, CantidadOperaciones: 0, MontoTotal: 0 };
    activas[rl].CantidadOperaciones++;
    activas[rl].MontoTotal += Number(d.monto || 0);
  }
  const cuadroDData = Object.values(activas);

  // --- Cuadro E: Pasivas (Cuenta Vista=1, Cuenta Planilla=2, Cuenta Exp Simplif=3, Deposito Plazo=4, Deposito Judicial=5) ---
  const pasivasIDs = [1, 2, 3, 4, 5];
  const pasivas = productosRiesgo
    .filter(p => pasivasIDs.includes(p.C_id_tipo_producto))
    .reduce((acc, p) => {
      const rl = (p.riesgo || 'BAJO').toUpperCase();
      if (!acc[rl]) acc[rl] = { TipoRiesgo: rl, CantidadOperaciones: 0, MontoTotal: 0 };
      acc[rl].CantidadOperaciones++;
      acc[rl].MontoTotal += Number(p.M_monto || 0);
      return acc;
    }, {});
  const cuadroEData = Object.values(pasivas);

  // --- Cuadro F: Fuera de Balance (Arrendamiento=13, Aval=14, Fideicomiso=15) ---
  const offBalanceIDs = [13, 14, 15];
  const fueraBalance = productosRiesgo
    .filter(p => offBalanceIDs.includes(p.C_id_tipo_producto))
    .reduce((acc, p) => {
      const rl = (p.riesgo || 'BAJO').toUpperCase();
      if (!acc[rl]) acc[rl] = { TipoRiesgo: rl, CantidadOperaciones: 0, MontoTotal: 0 };
      acc[rl].CantidadOperaciones++;
      acc[rl].MontoTotal += Number(p.M_monto || 0);
      return acc;
    }, {});
  const cuadroFData = Object.values(fueraBalance);

  // --- Cuadro G: Clientes unicos con operaciones por riesgo ---
  const clientesOperaciones = {};
  for (const p of productosRiesgo) {
    const rl = (p.riesgo || 'BAJO').toUpperCase();
    if (!clientesOperaciones[rl]) clientesOperaciones[rl] = new Set();
    clientesOperaciones[rl].add(p.C_id_cliente);
  }
  const cuadroGData = Object.entries(clientesOperaciones).map(([rl, s]) => ({
    TipoRiesgo: rl, ClientesConOperaciones: s.size
  }));

  // --- Cuadro H: Reclasificaciones (requires history, skip if no prior data) ---
  const reclasificaciones = (await pool.request().query(`
    SELECT Antes.D_nivel_riesgo AS riesgo_anterior, Despues.D_nivel_riesgo AS riesgo_nuevo, COUNT(*) AS cantidad
    FROM Evaluacion_Riesgo Antes
    JOIN Evaluacion_Riesgo Despues ON Antes.C_id_cliente = Despues.C_id_cliente
    WHERE Antes.F_fecha_evaluacion < Despues.F_fecha_evaluacion
      AND Antes.D_nivel_riesgo <> Despues.D_nivel_riesgo
    GROUP BY Antes.D_nivel_riesgo, Despues.D_nivel_riesgo
  `)).recordset;
  const cuadroHData = reclasificaciones.map(r => ({
    RiesgoAnterior: r.riesgo_anterior.toUpperCase(),
    RiesgoNuevo: r.riesgo_nuevo.toUpperCase(),
    CantidadClientes: r.cantidad
  }));

  // --- Cuadro I: Clientes por pais y riesgo ---
  const jurisdiccion = {};
  for (const e of evaluaciones) {
    const pais = e.pais || 'NO ESPECIFICADO';
    const rl = (e.D_nivel_riesgo || 'BAJO').toUpperCase();
    const key = pais + '|' + rl;
    if (!jurisdiccion[key]) jurisdiccion[key] = { Pais: pais, TipoRiesgo: rl, CantidadClientes: 0 };
    jurisdiccion[key].CantidadClientes++;
  }
  const cuadroIData = Object.values(jurisdiccion);

  // --- Build XML ---
  function tag(name, value) {
    return `        <${name}>${X(value)}</${name}>`;
  }

  function cuadroRows(data, fields) {
    return data.map(r => {
      const rows = fields.map(f => tag(f, r[f] || r[f.toLowerCase()] || 0));
      return `    <Registro>\n${rows.join('\n')}\n    </Registro>`;
    }).join('\n');
  }

  let xml = '<?xml version="1.0" encoding="UTF-8"?>\n';
  xml += '<SICVECA xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">\n';
  xml += `    <Periodo>\n${tag('Anio', anio)}\n${tag('Mes', mes)}\n    </Periodo>\n`;

  // Cuadro A
  xml += '    <CuadroA>\n';
  xml += cuadroAData.map(r =>
    `    <Registro>\n        <Mes>${mes}</Mes>\n        <TipoRiesgo>${r.TipoRiesgo}</TipoRiesgo>\n        <NumeroClientes>${r.NumeroClientes}</NumeroClientes>\n        <PorcentajeClientes>${r.PorcentajeClientes}</PorcentajeClientes>\n    </Registro>`
  ).join('\n');
  xml += '\n    </CuadroA>\n';

  // Cuadro D
  xml += '    <CuadroD>\n';
  xml += cuadroDData.map(r =>
    `    <Registro>\n        <Mes>${mes}</Mes>\n        <TipoRiesgo>${r.TipoRiesgo}</TipoRiesgo>\n        <CantidadOperaciones>${r.CantidadOperaciones}</CantidadOperaciones>\n        <MontoTotal>${r.MontoTotal}</MontoTotal>\n    </Registro>`
  ).join('\n');
  xml += '\n    </CuadroD>\n';

  // Cuadro E
  xml += '    <CuadroE>\n';
  xml += cuadroEData.map(r =>
    `    <Registro>\n        <Mes>${mes}</Mes>\n        <TipoRiesgo>${r.TipoRiesgo}</TipoRiesgo>\n        <CantidadOperaciones>${r.CantidadOperaciones}</CantidadOperaciones>\n        <MontoTotal>${r.MontoTotal}</MontoTotal>\n    </Registro>`
  ).join('\n');
  xml += '\n    </CuadroE>\n';

  // Cuadro F
  xml += '    <CuadroF>\n';
  xml += cuadroFData.map(r =>
    `    <Registro>\n        <Mes>${mes}</Mes>\n        <TipoRiesgo>${r.TipoRiesgo}</TipoRiesgo>\n        <CantidadOperaciones>${r.CantidadOperaciones}</CantidadOperaciones>\n        <MontoTotal>${r.MontoTotal}</MontoTotal>\n    </Registro>`
  ).join('\n');
  xml += '\n    </CuadroF>\n';

  // Cuadro G
  xml += '    <CuadroG>\n';
  xml += cuadroGData.map(r =>
    `    <Registro>\n        <Mes>${mes}</Mes>\n        <TipoRiesgo>${r.TipoRiesgo}</TipoRiesgo>\n        <ClientesConOperaciones>${r.ClientesConOperaciones}</ClientesConOperaciones>\n    </Registro>`
  ).join('\n');
  xml += '\n    </CuadroG>\n';

  // Cuadro H
  xml += '    <CuadroH>\n';
  xml += cuadroHData.length > 0 ? cuadroHData.map(r =>
    `    <Registro>\n        <Mes>${mes}</Mes>\n        <RiesgoAnterior>${r.RiesgoAnterior}</RiesgoAnterior>\n        <RiesgoNuevo>${r.RiesgoNuevo}</RiesgoNuevo>\n        <CantidadClientes>${r.CantidadClientes}</CantidadClientes>\n    </Registro>`
  ).join('\n') : '    <!-- Sin reclasificaciones en el periodo -->';
  xml += '\n    </CuadroH>\n';

  // Cuadro I
  xml += '    <CuadroI>\n';
  xml += cuadroIData.map(r =>
    `    <Registro>\n        <Pais>${r.Pais}</Pais>\n        <TipoRiesgo>${r.TipoRiesgo}</TipoRiesgo>\n        <CantidadClientes>${r.CantidadClientes}</CantidadClientes>\n    </Registro>`
  ).join('\n');
  xml += '\n    </CuadroI>\n';

  xml += '</SICVECA>';

  // --- Validate ---
  const validaciones = [];
  const clientes = evaluaciones;
  for (const e of clientes) {
    if (e.D_nivel_riesgo === 'Alto') {
      validaciones.push({
        tipo: 'WARNING', cliente: e.C_id_cliente,
        mensaje: `Cliente ${e.C_id_cliente} con riesgo Alto requiere atencion especial`
      });
    }
  }

  // Write XML
  const outputDir = path.join(__dirname, '..', 'output');
  if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir);
  const filePath = path.join(outputDir, 'sicveca.xml');
  fs.writeFileSync(filePath, xml, 'utf8');

  console.log('=== REPORTE GENERACION XML SICVECA ===');
  console.log(`Archivo: ${filePath}`);
  console.log(`Periodo: ${anio}/${mes}`);
  console.log(`Clientes evaluados: ${clientes.length}`);
  console.log(`Cuadro A (clientes por riesgo): ${cuadroAData.length} registros`);
  console.log(`Cuadro D (operaciones activas): ${cuadroDData.length} registros`);
  console.log(`Cuadro E (operaciones pasivas): ${cuadroEData.length} registros`);
  console.log(`Cuadro F (fuera de balance): ${cuadroFData.length} registros`);
  console.log(`Cuadro G (clientes con operaciones): ${cuadroGData.length} registros`);
  console.log(`Cuadro H (reclasificaciones): ${cuadroHData.length} registros`);
  console.log(`Cuadro I (jurisdiccion): ${cuadroIData.length} registros`);
  console.log('');
  console.log('=== VALIDACIONES ===');
  if (validaciones.length === 0) {
    console.log('Todas las validaciones pasaron correctamente.');
  } else {
    for (const v of validaciones) {
      console.log(`[${v.tipo}] ${v.mensaje}`);
    }
  }

  return { xml, validaciones };
}

generarXML().then(() => {
  console.log('XML generado exitosamente.');
  process.exit(0);
}).catch(err => {
  console.error('Error:', err);
  process.exit(1);
});
