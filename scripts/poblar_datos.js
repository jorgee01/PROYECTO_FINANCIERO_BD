const { getPool } = require('../src/config/database');
const { readFileSync } = require('fs');
const { join } = require('path');

async function main() {
  const pool = await getPool();
  console.log('Ejecutando script_poblacion_datos.sql...');
  const sql = readFileSync(join(__dirname, '..', 'src', 'sql', 'script_poblacion_datos.sql'), 'utf8');
  const result = await pool.request().query(sql);
  const stats = result.recordsets[result.recordsets.length - 1];
  console.log('Resultado:', stats);
  process.exit(0);
}

main().catch(err => { console.error(err); process.exit(1); });
