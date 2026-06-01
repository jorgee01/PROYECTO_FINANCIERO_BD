const { getPool } = require('../src/config/database');

async function main() {
  const pool = await getPool();
  console.log('Ejecutando Escenario 4 (Remesas, Divisas, Comisiones)...');
  const result = await pool.request().execute('SP_Escenario4');
  const stats = result.recordsets[0][0];
  console.log('Resultado:', stats);
  console.log(`  Remesas: ${stats.remesas_creadas}`);
  console.log(`  Compra/Venta Divisas: ${stats.compraventas_creadas}`);
  console.log(`  Comisiones: ${stats.comisiones_creadas}`);
  console.log(`  Total: ${stats.total_operaciones}`);
  process.exit(0);
}

main().catch(err => { console.error(err); process.exit(1); });
