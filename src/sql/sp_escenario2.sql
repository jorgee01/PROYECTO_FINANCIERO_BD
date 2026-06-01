USE Grupo1_BancoUCR;
GO

-- =============================================
-- ESCENARIO 2: 27 transacciones aleatorias del mes actual,
-- para 5 clientes random, distribuidas en sus productos.
-- Re-ejecutable: siempre inserta 27 transacciones nuevas.
-- =============================================
IF OBJECT_ID('dbo.SP_Escenario2', 'P') IS NOT NULL DROP PROCEDURE dbo.SP_Escenario2;
GO
CREATE PROCEDURE dbo.SP_Escenario2
AS
BEGIN
    SET NOCOUNT ON;

    IF (SELECT COUNT(*) FROM Cliente) < 5
    BEGIN
        RAISERROR('Debe ejecutarse primero el Escenario 1 (menos de 5 clientes en BD).', 16, 1);
        RETURN;
    END;

    IF (SELECT COUNT(*) FROM Producto) < 5
    BEGIN
        RAISERROR('Debe ejecutarse primero el Escenario 1 (menos de 5 productos en BD).', 16, 1);
        RETURN;
    END;

    DECLARE @anio INT = YEAR(GETDATE()), @mes INT = MONTH(GETDATE());

    DECLARE @clientes TABLE (C_id_cliente INT);
    INSERT INTO @clientes (C_id_cliente)
    SELECT TOP 5 C_id_cliente FROM Cliente ORDER BY NEWID();

    DECLARE @descripciones TABLE (idx INT IDENTITY(1,1), D_tipo VARCHAR(100), M_monto INT);
    INSERT INTO @descripciones (D_tipo, M_monto)
    VALUES
    ('Transporte - Gasolina',    -15000),   ('Transporte - Uber',        -5000),
    ('Transporte - Bus',         -650),     ('Transporte - Taxi',        -3000),
    ('Transporte - Mototaxi',    -2000),    ('Comida afuera',            -8000),
    ('El diario',                -5000),    ('Gym',                      -35000),
    ('Entrenador personal',      -45000),   ('Nutricionista',            -25000),
    ('Psicologo',                -30000),   ('Agua',                     -12000),
    ('Luz',                      -18000),   ('Internet',                 -15000),
    ('Celular',                  -22000),   ('Netflix',                  -5000),
    ('Ropa',                     -25000),   ('Zapatos',                  -35000),
    ('Hobbie',                   -10000),   ('Juego en linea',           -5000),
    ('SINPE movil',              -20000),   ('Depositos',                50000),
    ('Deposito del plazo',       100000),   ('Pago de planilla',         350000),
    ('Deposito de pensiones',    250000),   ('Comida del gato',          -8000),
    ('Pago tarjeta credito',     -50000);

    DECLARE @i INT = 1, @cid INT, @pid INT, @did INT, @monto INT, @desc VARCHAR(100);

    WHILE @i <= 27
    BEGIN
        SELECT TOP 1 @cid = C_id_cliente FROM @clientes ORDER BY NEWID();

        SELECT TOP 1 @pid = p.C_id_producto
        FROM Producto p WHERE p.C_id_cliente = @cid
        ORDER BY NEWID();

        SELECT TOP 1 @did = idx, @desc = D_tipo, @monto = M_monto
        FROM @descripciones ORDER BY NEWID();

        INSERT INTO Transaccion (C_id_producto, D_tipo, M_monto, F_fecha, B_estado, C_id_moneda)
        VALUES (@pid, @desc, @monto,
            DATEFROMPARTS(@anio, @mes, 1 + (ABS(CHECKSUM(NEWID())) % 28)),
            1, 1 + (ABS(CHECKSUM(NEWID())) % 2));

        SET @i = @i + 1;
    END;

    SELECT COUNT(*) AS total_transacciones_mes_actual FROM Transaccion
    WHERE YEAR(F_fecha) = @anio AND MONTH(F_fecha) = @mes;

    SELECT COUNT(DISTINCT C_id_producto) AS productos_afectados FROM Transaccion
    WHERE YEAR(F_fecha) = @anio AND MONTH(F_fecha) = @mes;
END;
GO
