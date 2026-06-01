const { getPool } = require('../src/config/database');

async function main() {
  const pool = await getPool();
  console.log('Ejecutando Escenario 1...');
  const result = await pool.request().execute('SP_Escenario1');
  console.log('Resultado:', result.recordset);
  process.exit(0);
}

main().catch(err => { console.error(err); process.exit(1); });
