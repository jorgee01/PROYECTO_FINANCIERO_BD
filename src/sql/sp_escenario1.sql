USE Grupo1_BancoUCR;
GO

IF OBJECT_ID('dbo.SP_Escenario1', 'P') IS NOT NULL DROP PROCEDURE dbo.SP_Escenario1;
GO
CREATE PROCEDURE dbo.SP_Escenario1
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mes_actual INT = MONTH(GETDATE());
    DECLARE @anio_actual INT = YEAR(GETDATE());
    DECLARE @mes INT = 1;
    DECLARE @nuevos TABLE (C_id_cliente INT);

    WHILE @mes <= @mes_actual
    BEGIN
        INSERT INTO Cliente (D_identificacion, D_nombre, D_apellido, D_correo, N_ingresos, B_activo,
            F_fecha_registro, C_id_distrito, C_id_profesion, C_id_actividad_economica,
            C_id_tipo_persona, C_id_estado_civil, C_id_pais)
        OUTPUT INSERTED.C_id_cliente INTO @nuevos
        SELECT TOP 5
            p.Cedula,
            p.Nombre,
            p.PrimerApellido,
            LOWER(LEFT(p.Nombre,1) + '.' + p.PrimerApellido + '@correo.com'),
            300000 + (ABS(CHECKSUM(NEWID())) % 700000),
            1,
            DATEFROMPARTS(@anio_actual, @mes, 1 + (ABS(CHECKSUM(NEWID())) % 28)),
            (CASE ABS(CHECKSUM(NEWID())) % 7
                WHEN 0 THEN 10101 WHEN 1 THEN 20101
                WHEN 2 THEN 30101 WHEN 3 THEN 40101
                WHEN 4 THEN 50101 WHEN 5 THEN 60101
                WHEN 6 THEN 70101
            END),
            1 + (ABS(CHECKSUM(NEWID())) % 10),
            1 + (ABS(CHECKSUM(NEWID())) % 10),
            1 + (ABS(CHECKSUM(NEWID())) % 2),
            1 + (ABS(CHECKSUM(NEWID())) % 5),
            1
        FROM TMP_PADRON p
        WHERE NOT EXISTS (SELECT 1 FROM Cliente c WHERE c.D_identificacion = p.Cedula)
        ORDER BY NEWID();

        DECLARE @cid INT, @tprod INT, @pid INT, @j INT, @moneda INT;
        DECLARE cur CURSOR FOR SELECT C_id_cliente FROM @nuevos
        WHERE C_id_cliente NOT IN (SELECT C_id_cliente FROM Cliente_Producto);
        OPEN cur;
        FETCH NEXT FROM cur INTO @cid;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @tprod = 1 + (ABS(CHECKSUM(NEWID())) % 18);
            SET @moneda = 1 + (ABS(CHECKSUM(NEWID())) % 2);

            INSERT INTO Producto (D_nombre, M_monto, F_fecha_apertura, B_activo, C_id_tipo_producto, C_id_cliente)
            SELECT
                tp.D_nombre + ' - Cliente ' + CAST(@cid AS VARCHAR),
                CASE tp.C_id_tipo_producto
                    WHEN 4 THEN 1000000 WHEN 6 THEN 5000000
                    WHEN 9 THEN 2000000 WHEN 13 THEN 3000000
                    WHEN 14 THEN 1000000 WHEN 15 THEN 2000000
                    ELSE 100000
                END,
                DATEFROMPARTS(@anio_actual, @mes, 1 + (ABS(CHECKSUM(NEWID())) % 28)),
                1, @tprod, @cid
            FROM Tipo_Producto tp WHERE tp.C_id_tipo_producto = @tprod;

            SET @pid = SCOPE_IDENTITY();

            INSERT INTO Cliente_Producto (C_id_cliente, C_id_producto) VALUES (@cid, @pid);

            SET @j = 1;
            WHILE @j <= 5
            BEGIN
                INSERT INTO Transaccion (M_monto, D_tipo, F_fecha, B_estado, C_id_producto, C_id_moneda)
                VALUES (
                    CASE WHEN @j % 2 = 1 THEN 50000 ELSE -30000 END,
                    CASE @j
                        WHEN 1 THEN 'Ingreso mensual' WHEN 2 THEN 'Retiro'
                        WHEN 3 THEN 'SINPE' WHEN 4 THEN 'Transferencia'
                        WHEN 5 THEN 'Pago servicio'
                    END,
                    DATEADD(DAY, (@j - 1) * 7, DATEFROMPARTS(@anio_actual, @mes, 1)),
                    1, @pid, @moneda);
                SET @j = @j + 1;
            END;

            FETCH NEXT FROM cur INTO @cid;
        END;
        CLOSE cur; DEALLOCATE cur;

        SET @mes = @mes + 1;
    END;

    SELECT MONTH(F_fecha_registro) AS mes, COUNT(*) AS clientes
    FROM Cliente WHERE YEAR(F_fecha_registro) = @anio_actual
    GROUP BY MONTH(F_fecha_registro) ORDER BY mes;
END;
GO
