const sql = require('mssql/msnodesqlv8');
const { execSync } = require('child_process');

function getLocalDbPipe() {
    try {
        const out = execSync('SqlLocalDB info MSSQLLocalDB', { encoding: 'utf8' });
        const match = out.match(/canaliza[^\r\n]+:\s*(.+)/);
        if (match) {
            const pipe = match[1].replace('np:', '').trim();
            return pipe;
        }
    } catch (_) {}
    return '(localdb)\\MSSQLLocalDB';
}

const config = {
    connectionString: `Driver={ODBC Driver 17 for SQL Server};Server=${getLocalDbPipe()};Database=Grupo1_BancoUCR;Trusted_Connection=yes;`,
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