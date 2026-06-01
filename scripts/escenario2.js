const { getPool } = require('../src/config/database');

async function main() {
  const pool = await getPool();
  console.log('Ejecutando Escenario 2...');
  const result = await pool.request().execute('SP_Escenario2');
  console.log('Resultado:', result.recordsets);
  process.exit(0);
}

main().catch(err => { console.error(err); process.exit(1); });
