const { getPool, sql } = require('../config/database');

class EscenarioController {
    registerRoutes(router) {

        router.get('/escenario/productos-persona', async (req, res) => {
            try {
                const cedula = req.query.cedula;

                if (!cedula) {
                    return res.status(400).json({
                        error: 'Debe enviar la cédula de la persona.'
                    });
                }

                const pool = await getPool();

                const result = await pool.request()
                    .input('cedula', sql.VarChar(20), cedula)
                    .query(`
                        SELECT 
                            Producto.C_id_producto,
                            Producto.D_nombre AS NombreProducto,
                            Producto.M_monto,
                            Producto.F_fecha_apertura,
                            Producto.B_activo,
                            Producto.C_id_tipo_producto,
                            Tipo_Producto.D_nombre AS TipoProducto
                        FROM Cliente
                        INNER JOIN Producto
                            ON Cliente.C_id_cliente = Producto.C_id_cliente
                        LEFT JOIN Tipo_Producto
                            ON Producto.C_id_tipo_producto = Tipo_Producto.C_id_tipo_producto
                        WHERE Cliente.D_identificacion = @cedula
                        ORDER BY Producto.C_id_producto DESC;
                    `);

                res.json(result.recordset);

            } catch (error) {
                res.status(500).json({
                    error: error.message
                });
            }
        });

        router.post('/escenario/manual', async (req, res) => {
            const pool = await getPool();
            const transaction = new sql.Transaction(pool);

            try {
                const { persona, producto } = req.body;

                if (!persona || !producto) {
                    return res.status(400).json({
                        error: 'Debe enviar una persona y un producto.'
                    });
                }

                if (!persona.Cedula || !persona.Nombre) {
                    return res.status(400).json({
                        error: 'La persona seleccionada no tiene datos completos.'
                    });
                }

                if (!producto.C_id_tipo_producto || !producto.D_nombre || !producto.M_monto) {
                    return res.status(400).json({
                        error: 'Debe completar los datos del producto.'
                    });
                }

                await transaction.begin();

                const buscarCliente = await new sql.Request(transaction)
                    .input('cedula', sql.VarChar(20), persona.Cedula)
                    .query(`
                        SELECT TOP 1
                            C_id_cliente
                        FROM Cliente
                        WHERE D_identificacion = @cedula;
                    `);

                let idCliente;

                if (buscarCliente.recordset.length > 0) {
                    idCliente = buscarCliente.recordset[0].C_id_cliente;
                } else {
                    const nombre = persona.Nombre || 'Cliente';
                    const apellido = `${persona.PrimerApellido || ''} ${persona.SegundoApellido || ''}`.trim() || 'Sin apellido';
                    const correo = `${persona.Cedula}@cliente.local`;
                    const ingresos = Number(producto.N_ingresos || 0);

                    if (!ingresos) {
                        throw new Error('Debe indicar los ingresos para registrar un cliente nuevo.');
                    }

                    const insertarCliente = await new sql.Request(transaction)
                        .input('D_nombre', sql.VarChar(100), nombre)
                        .input('D_apellido', sql.VarChar(100), apellido)
                        .input('D_correo', sql.VarChar(100), correo)
                        .input('N_ingresos', sql.Int, ingresos)
                        .input('B_activo', sql.Bit, true)
                        .input('C_id_distrito', sql.Int, null)
                        .input('C_id_profesion', sql.Int, 1)
                        .input('C_id_actividad_economica', sql.Int, 1)
                        .input('C_id_tipo_persona', sql.Int, 1)
                        .input('C_id_estado_civil', sql.Int, 1)
                        .input('C_id_pais', sql.Int, 1)
                        .input('D_identificacion', sql.VarChar(20), persona.Cedula)
                        .execute('SP_InsertarCliente');

                    idCliente = insertarCliente.recordset[0].C_id_cliente;
                }

                const insertarProducto = await new sql.Request(transaction)
                    .input('D_nombre', sql.VarChar(100), producto.D_nombre)
                    .input('M_monto', sql.Decimal(18, 2), Number(producto.M_monto))
                    .input('C_id_tipo_producto', sql.Int, Number(producto.C_id_tipo_producto))
                    .input('C_id_cliente', sql.Int, idCliente)
                    .execute('SP_InsertarProducto');

                const idProducto = insertarProducto.recordset[0].C_id_producto;

                await new sql.Request(transaction)
                    .input('idCliente', sql.Int, idCliente)
                    .input('idProducto', sql.Int, idProducto)
                    .query(`
                        IF NOT EXISTS (
                            SELECT 1
                            FROM Cliente_Producto
                            WHERE C_id_cliente = @idCliente
                              AND C_id_producto = @idProducto
                        )
                        BEGIN
                            INSERT INTO Cliente_Producto
                            (
                                C_id_cliente,
                                C_id_producto
                            )
                            VALUES
                            (
                                @idCliente,
                                @idProducto
                            );
                        END;
                    `);

                await transaction.commit();

                res.status(201).json({
                    mensaje: 'Escenario manual creado correctamente.',
                    C_id_cliente: idCliente,
                    C_id_producto: idProducto
                });

            } catch (error) {
                try {
                    if (transaction._aborted !== true) {
                        await transaction.rollback();
                    }
                } catch (_) {}

                res.status(500).json({
                    error: error.message
                });
            }
        });
    }
}

module.exports = EscenarioController;