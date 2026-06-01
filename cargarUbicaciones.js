const sql = require('mssql');
const fs = require('fs');

const config = {
    server: '(localdb)\\MSSQLLocalDB',
    database: 'Grupo1_BancoUCR',
    options: {
        trustedConnection: true,
        trustServerCertificate: true
    }
};

async function cargarUbicaciones() {

    const json = JSON.parse(
        fs.readFileSync('./ubicaciones.json', 'utf8')
    );

    const pool = await sql.connect(config);

    try {

        for (const [provinciaId, provincia] of Object.entries(json.provincias)) {

            for (const [cantonId, canton] of Object.entries(provincia.cantones)) {

                const codigoCanton =
                    parseInt(`${provinciaId}${cantonId}`);

                await pool.request()
                    .input('id', sql.Int, codigoCanton)
                    .input('nombre', sql.VarChar(100), canton.nombre)
                    .input('provincia', sql.Int, parseInt(provinciaId))
                    .query(`
                        IF NOT EXISTS (
                            SELECT 1
                            FROM Canton
                            WHERE C_id_canton = @id
                        )
                        INSERT INTO Canton
                        (
                            C_id_canton,
                            D_nombre,
                            C_id_provincia
                        )
                        VALUES
                        (
                            @id,
                            @nombre,
                            @provincia
                        )
                    `);

                console.log(
                    `Cantón insertado: ${codigoCanton} - ${canton.nombre}`
                );

                for (const [distritoId, distritoNombre] of Object.entries(canton.distritos)) {

                    const codigoDistrito =
                        parseInt(
                            `${provinciaId}${cantonId}${distritoId}`
                        );

                    await pool.request()
                        .input('id', sql.Int, codigoDistrito)
                        .input('nombre', sql.VarChar(100), distritoNombre)
                        .input('canton', sql.Int, codigoCanton)
                        .query(`
                            IF NOT EXISTS (
                                SELECT 1
                                FROM Distrito
                                WHERE C_id_distrito = @id
                            )
                            INSERT INTO Distrito
                            (
                                C_id_distrito,
                                D_nombre,
                                C_id_canton
                            )
                            VALUES
                            (
                                @id,
                                @nombre,
                                @canton
                            )
                        `);

                    console.log(
                        `Distrito insertado: ${codigoDistrito} - ${distritoNombre}`
                    );
                }
            }
        }

        console.log('Carga completada');

    } catch (error) {

        console.error(error);

    } finally {

        await pool.close();
    }
}

cargarUbicaciones();