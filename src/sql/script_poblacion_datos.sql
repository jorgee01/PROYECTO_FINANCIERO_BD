USE Grupo1_BancoUCR;
GO

-- =============================================
-- POBLACION DE DATOS: 5 CLIENTES x 19 PRODUCTOS = 95
-- =============================================

-- === 1. Insertar 5 clientes (miembros del grupo) ===
DECLARE @clientes TABLE (idx INT IDENTITY(1,1), nombre VARCHAR(100), apellido VARCHAR(100), correo VARCHAR(100), identificacion VARCHAR(20));

INSERT INTO @clientes (nombre, apellido, correo, identificacion)
VALUES
('Ema',    'torres',   'Ema.torres@correo.com',   '101230101'),
('Carlos',   'Mora',    'carlos.mora@correo.com',    '201440202'),
('Andrea',   'Vargas',  'andrea.vargas@correo.com',  '301550303'),
('Jose',     'Rivera',  'jose.rivera@correo.com',    '401660404'),
('Sofia',    'Castro',  'sofia.castro@correo.com',   '501770505');

DECLARE @cliente_ids TABLE (idx INT, C_id_cliente INT);

DECLARE @i INT = 1, @total INT = (SELECT COUNT(*) FROM @clientes);
WHILE @i <= @total
BEGIN
    DECLARE @nom VARCHAR(100), @ape VARCHAR(100), @cor VARCHAR(100), @ced VARCHAR(20), @tipo_persona INT, @ecivil INT;
    SELECT @nom = nombre, @ape = apellido, @cor = correo, @ced = identificacion FROM @clientes WHERE idx = @i;
    SET @tipo_persona = CASE WHEN @i % 2 = 1 THEN 1 ELSE 2 END; -- 1=fisica, 2=juridica
    SET @ecivil = CASE WHEN @i % 5 = 0 THEN 5 ELSE @i % 5 END; -- 1-5

    INSERT INTO Cliente (D_identificacion, D_nombre, D_apellido, D_correo, N_ingresos, B_activo,
        F_fecha_registro, C_id_distrito, C_id_profesion, C_id_actividad_economica,
        C_id_tipo_persona, C_id_estado_civil, C_id_pais)
    VALUES (@ced, @nom, @ape, @cor, 500000 + (@i * 250000), 1,
        DATEADD(MONTH, -@i, GETDATE()),
        CASE @i WHEN 1 THEN 10101 WHEN 2 THEN 20101 WHEN 3 THEN 30101 WHEN 4 THEN 40101 WHEN 5 THEN 50101 END,
        @i, @i,
        @tipo_persona, @ecivil, 1);

    INSERT INTO @cliente_ids (idx, C_id_cliente) VALUES (@i, SCOPE_IDENTITY());
    SET @i = @i + 1;
END;

-- === 2. Insertar 18 productos por cliente (vía Producto) = 90 productos ===
DECLARE @tipos TABLE (idx INT IDENTITY(1,1), C_id_tipo_producto INT, D_nombre VARCHAR(100), M_monto DECIMAL(18,2));
INSERT INTO @tipos (C_id_tipo_producto, D_nombre, M_monto)
VALUES
(1,  'Cuenta Vista',              100000),
(2,  'Cuenta Planilla',           200000),
(3,  'Cuenta Expediente Simplificado', 50000),
(4,  'Deposito a Plazo',          1000000),
(5,  'Deposito Judicial',         500000),
(6,  'Prestamo Directo',          3000000),
(6,  'Prestamo Hipotecario',      15000000),
(7,  'Tarjeta Credito',           500000),
(8,  'Tarjeta Debito',            200000),
(9,  'Linea Credito',             2000000),
(10, 'Transferencia',             0),
(11, 'Remesa',                    300000),
(12, 'Compra Venta Divisas',      1000000),
(13, 'Arrendamiento Financiero',  5000000),
(14, 'Aval y Garantia',           1000000),
(15, 'Fideicomiso',              2000000),
(16, 'Caja Seguridad',            150000),
(17, 'Banca en Linea',            0),
(18, 'Cajero Automatico',         0);

DECLARE @ci INT, @ti INT, @id_cliente INT, @id_tipo INT, @nom_prod VARCHAR(100), @monto DECIMAL(18,2);
DECLARE c CURSOR FOR SELECT c.idx, t.idx FROM @cliente_ids c CROSS JOIN @tipos t;
OPEN c;
FETCH NEXT FROM c INTO @ci, @ti;
WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @id_cliente = C_id_cliente FROM @cliente_ids WHERE idx = @ci;
    SELECT @id_tipo = C_id_tipo_producto, @nom_prod = D_nombre, @monto = M_monto FROM @tipos WHERE idx = @ti;

    -- Insertar en Producto con nombre unico
    INSERT INTO Producto (D_nombre, M_monto, F_fecha_apertura, B_activo, C_id_tipo_producto, C_id_cliente)
    VALUES (@nom_prod + ' - Cliente ' + CAST(@ci AS VARCHAR), @monto, DATEADD(DAY, -(@ci * 30 + @ti), GETDATE()), 1, @id_tipo, @id_cliente);

    FETCH NEXT FROM c INTO @ci, @ti;
END;
CLOSE c; DEALLOCATE c;

-- === 3. Insertar 90 registros en Cliente_Producto ===
INSERT INTO Cliente_Producto (C_id_cliente, C_id_producto)
SELECT C_id_cliente, C_id_producto
FROM Producto p
WHERE NOT EXISTS (SELECT 1 FROM Cliente_Producto cp WHERE cp.C_id_cliente = p.C_id_cliente AND cp.C_id_producto = p.C_id_producto);

-- === 4. Insertar 5 Descuento_Factura (uno por cliente) ===
INSERT INTO Descuento_Factura (C_id_producto, D_numero_factura, N_monto_factura, N_monto_descontado, N_tasa_descuento, F_fecha_emision, F_fecha_vencimiento, D_estado)
SELECT p.C_id_producto, 'FAC-' + CAST(c.idx AS VARCHAR) + '-001', 500000, 100000, 0.10, GETDATE(), DATEADD(DAY, 30, GETDATE()), 'Pendiente'
FROM @cliente_ids c
CROSS APPLY (SELECT TOP 1 C_id_producto FROM Producto WHERE C_id_cliente = c.C_id_cliente ORDER BY C_id_producto) p
WHERE NOT EXISTS (SELECT 1 FROM Descuento_Factura WHERE C_id_producto = p.C_id_producto);

-- === VERIFICACION ===
SELECT 'Clientes' AS tabla, COUNT(*) AS registros FROM Cliente
UNION ALL SELECT 'Productos', COUNT(*) FROM Producto
UNION ALL SELECT 'Cliente_Producto', COUNT(*) FROM Cliente_Producto
UNION ALL SELECT 'Descuento_Factura', COUNT(*) FROM Descuento_Factura;
GO
