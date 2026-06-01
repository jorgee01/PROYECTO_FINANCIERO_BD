-- =============================================
-- ESCENARIO 4 (Opcional):
-- Remesas, compra/venta de divisas, comisiones
-- de cajeros, SINPE y Swift.
-- Re-ejecutable: siempre inserta 5 grupos
-- de operaciones nuevas.
-- =============================================
-- EJECUTAR MANUALMENTE CUANDO SE DESEE:
--   sqlcmd -S "(localdb)\MSSQLLocalDB" -d Grupo1_BancoUCR -E -i "src\sql\sp_escenario4.sql"
-- LUEGO USAR: pnpm run escenario4
-- =============================================
USE Grupo1_BancoUCR;
GO

IF OBJECT_ID('dbo.SP_Escenario4', 'P') IS NOT NULL DROP PROCEDURE dbo.SP_Escenario4;
GO
CREATE PROCEDURE dbo.SP_Escenario4
AS
BEGIN
    SET NOCOUNT ON;

    IF (SELECT COUNT(*) FROM Cliente) < 5
    BEGIN
        RAISERROR('Se requieren al menos 5 clientes para Escenario 4.', 16, 1);
        RETURN;
    END;

    IF (SELECT COUNT(*) FROM Producto) < 5
    BEGIN
        RAISERROR('Se requieren al menos 5 productos para Escenario 4.', 16, 1);
        RETURN;
    END;

    DECLARE @anio INT = YEAR(GETDATE()), @mes INT = MONTH(GETDATE());

    -- 5 clientes aleatorios
    DECLARE @clientes TABLE (C_id_cliente INT, idx INT IDENTITY(1,1));
    INSERT INTO @clientes (C_id_cliente)
    SELECT TOP 5 C_id_cliente FROM Cliente ORDER BY NEWID();

    DECLARE @i INT = 1, @cid INT, @pid_rem INT, @pid_div INT, @pid_caj INT, @pid_trans INT;
    DECLARE @moneda INT, @monto DECIMAL(18,2), @tipo_cambio DECIMAL(10,4);
    DECLARE @total_rem INT = 0, @total_div INT = 0, @total_com INT = 0;

    WHILE @i <= 5
    BEGIN
        SELECT @cid = C_id_cliente FROM @clientes WHERE idx = @i;

        -- 1. REMESA (Tipo_Producto 11)
        SELECT TOP 1 @pid_rem = C_id_producto FROM Producto
        WHERE C_id_cliente = @cid AND C_id_tipo_producto = 11
        ORDER BY NEWID();

        IF @pid_rem IS NOT NULL
        BEGIN
            SET @monto = 50000 + (ABS(CHECKSUM(NEWID())) % 500000);
            SET @tipo_cambio = 500 + (ABS(CHECKSUM(NEWID())) % 100);
            SET @moneda = 1 + (ABS(CHECKSUM(NEWID())) % 3);

            INSERT INTO Transaccion (M_monto, D_tipo, F_fecha, B_estado, C_id_producto, C_id_moneda)
            VALUES (-@monto, 'Remesa enviada', DATEFROMPARTS(@anio, @mes, 1 + (ABS(CHECKSUM(NEWID())) % 28)), 1, @pid_rem, @moneda);

            DECLARE @tid_rem INT = SCOPE_IDENTITY();

            INSERT INTO Remesa (C_id_producto, D_pais_origen, D_pais_destino, N_monto, D_moneda, N_tipo_cambio, F_fecha, D_estado, C_id_transaccion)
            VALUES (@pid_rem,
                CASE ABS(CHECKSUM(NEWID())) % 4 WHEN 0 THEN 'Costa Rica' WHEN 1 THEN 'USA' WHEN 2 THEN 'España' ELSE 'Panamá' END,
                CASE ABS(CHECKSUM(NEWID())) % 4 WHEN 0 THEN 'Nicaragua' WHEN 1 THEN 'Colombia' WHEN 2 THEN 'México' ELSE 'China' END,
                @monto, CASE @moneda WHEN 1 THEN 'CRC' WHEN 2 THEN 'USD' ELSE 'EUR' END,
                @tipo_cambio, DATEFROMPARTS(@anio, @mes, 1 + (ABS(CHECKSUM(NEWID())) % 28)), 'Procesado', @tid_rem);

            -- Comision por remesa (ganancia del banco, 1-3%)
            INSERT INTO Transaccion (M_monto, D_tipo, F_fecha, B_estado, C_id_producto, C_id_moneda)
            VALUES (@monto * 0.02, 'Comision Remesa', DATEFROMPARTS(@anio, @mes, 1 + (ABS(CHECKSUM(NEWID())) % 28)), 1, @pid_rem, @moneda);

            SET @total_rem = @total_rem + 1;
        END;

        -- 2. COMPRA/VENTA DIVISAS (Tipo_Producto 12)
        SELECT TOP 1 @pid_div = C_id_producto FROM Producto
        WHERE C_id_cliente = @cid AND C_id_tipo_producto = 12
        ORDER BY NEWID();

        IF @pid_div IS NOT NULL
        BEGIN
            SET @monto = 100000 + (ABS(CHECKSUM(NEWID())) % 2000000);
            SET @tipo_cambio = 510 + (ABS(CHECKSUM(NEWID())) % 80);
            SET @moneda = 1 + (ABS(CHECKSUM(NEWID())) % 2);

            DECLARE @tipo_op VARCHAR(10) = CASE WHEN ABS(CHECKSUM(NEWID())) % 2 = 0 THEN 'Compra' ELSE 'Venta' END;

            INSERT INTO Transaccion (M_monto, D_tipo, F_fecha, B_estado, C_id_producto, C_id_moneda)
            VALUES (CASE @tipo_op WHEN 'Compra' THEN -@monto ELSE @monto END,
                'Divisa ' + @tipo_op, DATEFROMPARTS(@anio, @mes, 1 + (ABS(CHECKSUM(NEWID())) % 28)), 1, @pid_div, @moneda);

            DECLARE @tid_div INT = SCOPE_IDENTITY();

            INSERT INTO Compraventa_Divisa (C_id_producto, D_tipo, D_moneda_origen, D_moneda_destino, N_monto, N_tipo_cambio, F_fecha, D_estado)
            VALUES (@pid_div, @tipo_op,
                CASE @tipo_op WHEN 'Compra' THEN 'USD' ELSE 'CRC' END,
                CASE @tipo_op WHEN 'Compra' THEN 'CRC' ELSE 'USD' END,
                @monto, @tipo_cambio, DATEFROMPARTS(@anio, @mes, 1 + (ABS(CHECKSUM(NEWID())) % 28)), 'Ejecutado');

            -- Comision por cambio de divisas (0.5-1%)
            INSERT INTO Transaccion (M_monto, D_tipo, F_fecha, B_estado, C_id_producto, C_id_moneda)
            VALUES (@monto * (0.005 + (ABS(CHECKSUM(NEWID())) % 6) * 0.001),
                'Comision Divisa', DATEFROMPARTS(@anio, @mes, 1 + (ABS(CHECKSUM(NEWID())) % 28)), 1, @pid_div, @moneda);

            SET @total_div = @total_div + 1;
        END;

        -- 3. COMISION CAJERO (Tipo_Producto 18)
        SELECT TOP 1 @pid_caj = C_id_producto FROM Producto
        WHERE C_id_cliente = @cid AND C_id_tipo_producto = 18
        ORDER BY NEWID();

        IF @pid_caj IS NOT NULL
        BEGIN
            SET @monto = 10000 + (ABS(CHECKSUM(NEWID())) % 100000);
            SET @moneda = 1 + (ABS(CHECKSUM(NEWID())) % 2);

            INSERT INTO Cajero_Automatico (C_id_producto, D_numero_tarjeta, N_limite_diario, F_fecha_activacion, D_estado)
            VALUES (@pid_caj,
                'CR' + CAST(1000000000 + (ABS(CHECKSUM(NEWID())) % 900000000) AS VARCHAR),
                500000 + (ABS(CHECKSUM(NEWID())) % 500000),
                DATEFROMPARTS(@anio, @mes, 1 + (ABS(CHECKSUM(NEWID())) % 28)),
                'Activo');

            INSERT INTO Transaccion (M_monto, D_tipo, F_fecha, B_estado, C_id_producto, C_id_moneda)
            VALUES (-@monto, 'Retiro Cajero', DATEFROMPARTS(@anio, @mes, 1 + (ABS(CHECKSUM(NEWID())) % 28)), 1, @pid_caj, @moneda);

            -- Comision del cajero (₡1.500 fijo)
            INSERT INTO Transaccion (M_monto, D_tipo, F_fecha, B_estado, C_id_producto, C_id_moneda)
            VALUES (1500, 'Comision Cajero', DATEFROMPARTS(@anio, @mes, 1 + (ABS(CHECKSUM(NEWID())) % 28)), 1, @pid_caj, @moneda);

            SET @total_com = @total_com + 1;
        END;

        -- 4. SINPE / SWIFT (Tipo_Producto 10 - Transferencia)
        SELECT TOP 1 @pid_trans = C_id_producto FROM Producto
        WHERE C_id_cliente = @cid AND C_id_tipo_producto = 10
        ORDER BY NEWID();

        IF @pid_trans IS NOT NULL
        BEGIN
            SET @monto = 50000 + (ABS(CHECKSUM(NEWID())) % 500000);
            SET @moneda = 1 + (ABS(CHECKSUM(NEWID())) % 3);

            DECLARE @es_swift BIT = ABS(CHECKSUM(NEWID())) % 2;
            DECLARE @tipo_trans VARCHAR(20) = CASE WHEN @es_swift = 1 THEN 'Swift' ELSE 'SINPE' END;

            INSERT INTO Transferencia (C_id_producto, D_cuenta_origen, D_cuenta_destino, N_monto, D_tipo, F_fecha, D_estado)
            VALUES (@pid_trans,
                'CR' + CAST(100000000 + (ABS(CHECKSUM(NEWID())) % 900000000) AS VARCHAR),
                CASE WHEN @es_swift = 1
                    THEN 'SWIFT-' + CAST(100000 + (ABS(CHECKSUM(NEWID())) % 900000) AS VARCHAR)
                    ELSE 'CR' + CAST(100000000 + (ABS(CHECKSUM(NEWID())) % 900000000) AS VARCHAR)
                END,
                @monto, @tipo_trans, DATEFROMPARTS(@anio, @mes, 1 + (ABS(CHECKSUM(NEWID())) % 28)), 'Completado');

            INSERT INTO Transaccion (M_monto, D_tipo, F_fecha, B_estado, C_id_producto, C_id_moneda)
            VALUES (-@monto, 'Transferencia ' + @tipo_trans, DATEFROMPARTS(@anio, @mes, 1 + (ABS(CHECKSUM(NEWID())) % 28)), 1, @pid_trans, @moneda);

            -- Comision SINPE (₡500) o Swift (₡5.000 + 0.5%)
            DECLARE @com_monto DECIMAL(18,2) = CASE
                WHEN @es_swift = 1 THEN 5000 + (@monto * 0.005)
                ELSE 500
            END;

            INSERT INTO Transaccion (M_monto, D_tipo, F_fecha, B_estado, C_id_producto, C_id_moneda)
            VALUES (@com_monto, 'Comision ' + @tipo_trans, DATEFROMPARTS(@anio, @mes, 1 + (ABS(CHECKSUM(NEWID())) % 28)), 1, @pid_trans, @moneda);

            SET @total_com = @total_com + 1;
        END;

        SET @i = @i + 1;
    END;

    SELECT
        @total_rem AS remesas_creadas,
        @total_div AS compraventas_creadas,
        @total_com AS comisiones_creadas,
        @total_rem + @total_div + @total_com AS total_operaciones;
END;
GO

-- EXEC SP_Escenario4;
