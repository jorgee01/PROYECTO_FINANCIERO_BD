const { getPool } = require('../src/config/database');

async function main() {
  const pool = await getPool();
  console.log('Limpiando datos de escenarios...');
  await pool.request().query(`
    DELETE FROM Evaluacion_Riesgo;
    DELETE FROM Transaccion WHERE C_id_transaccion > 0;
    DELETE FROM Cliente_Producto;
    DELETE FROM Descuento_Factura;
    DELETE FROM Producto;
    DELETE FROM Cliente;
    DBCC CHECKIDENT ('Cliente', RESEED, 0);
    DBCC CHECKIDENT ('Producto', RESEED, 0);
    DBCC CHECKIDENT ('Transaccion', RESEED, 0);
    DBCC CHECKIDENT ('Descuento_Factura', RESEED, 0);
  `);
  console.log('Datos limpiados. Listo para re-ejecutar.');
  process.exit(0);
}

main().catch(err => { console.error(err); process.exit(1); });
