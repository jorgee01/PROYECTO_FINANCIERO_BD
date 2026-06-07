const sql = require('mssql/msnodesqlv8');

const config = {
    connectionString: `Driver={ODBC Driver 17 for SQL Server};Server=PCJEREMY;Database=Grupo1_BancoUCR;Trusted_Connection=yes;`,
    connectionTimeout: 10000,
    requestTimeout: 10000,
    options: {
        trustServerCertificate: true
    }
};

let pool;

async function getPool() {
    if (!pool) {
        pool = await sql.connect(config);
    }
    return pool;
}

module.exports = {
    getPool,
    sql
};