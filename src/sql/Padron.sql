USE Grupo1_BancoUCR;
GO



-- ==========================================
-- 1. LIMPIEZA: BORRAR LAS TABLAS SI YA EXISTEN
-- ==========================================
IF OBJECT_ID('dbo.TMP_DISTELEC', 'U') IS NOT NULL DROP TABLE dbo.TMP_DISTELEC;
IF OBJECT_ID('dbo.TMP_PADRON', 'U') IS NOT NULL DROP TABLE dbo.TMP_PADRON;
GO

-- ==========================================
-- 2. RECREAR TABLAS SIN LLAVE PRIMARIA (Para evitar el error)
-- ==========================================
CREATE TABLE TMP_DISTELEC (
    Codelec VARCHAR(10),
    Provincia VARCHAR(50),
    Canton VARCHAR(50),
    Distrito VARCHAR(100)
);

CREATE TABLE TMP_PADRON (
    Cedula VARCHAR(20) PRIMARY KEY,
    Codelec VARCHAR(10),
    Relleno VARCHAR(10),
    FechaCaducidad VARCHAR(15),
    Junta VARCHAR(15),
    Nombre VARCHAR(100),
    PrimerApellido VARCHAR(100),
    SegundoApellido VARCHAR(100)
);
GO

-- ==========================================
-- 3. EJECUTAR EL BULK INSERT DE NUEVO
-- ==========================================
BULK INSERT TMP_DISTELEC
FROM 'C:\padron\DISTELEC.TXT' 
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
);

BULK INSERT TMP_PADRON
FROM 'C:\padron\PADRON_COMPLETO.TXT' 
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
);
GO

-- ==========================================
-- 4. LIMPIEZA DE ESPACIOS
-- ==========================================
UPDATE TMP_DISTELEC 
SET Provincia = TRIM(Provincia), 
    Canton = TRIM(Canton), 
    Distrito = TRIM(Distrito);

UPDATE TMP_PADRON 
SET Nombre = TRIM(Nombre), 
    PrimerApellido = TRIM(PrimerApellido), 
    SegundoApellido = TRIM(SegundoApellido);
GO


----------------------------------
-------------------------------------

SELECT TOP 10 * FROM TMP_PADRON;


INSERT INTO Moneda (C_id_moneda, C_codigo, D_nombre, D_simbolo) VALUES
(1,'CRC','Colón Costarricense','₡'),
(2,'USD','Dólar Estadounidense','$'),
(3,'EUR','Euro','€');

INSERT INTO Estado_Civil (C_id_estado_civil, D_descripcion, N_peso_riesgo) VALUES
(1,'Soltero',5),
(2,'Casado',5),
(3,'Divorciado',10),
(4,'Viudo',10),
(5,'Unión Libre',5);

INSERT INTO Tipo_Producto VALUES
(1,'Cuenta Vista'),
(2,'Cuenta Planilla'),
(3,'Cuenta Expediente Simplificado'),
(4,'Depósito a Plazo'),
(5,'Depósito Judicial'),
(6,'Préstamo'),
(7,'Tarjeta Crédito'),
(8,'Tarjeta Débito'),
(9,'Línea Crédito'),
(10,'Transferencia'),
(11,'Remesa'),
(12,'Compra Venta Divisas'),
(13,'Arrendamiento Financiero'),
(14,'Aval y Garantía'),
(15,'Fideicomiso'),
(16,'Caja Seguridad'),
(17,'Banca en Línea'),
(18,'Cajero Automático');

INSERT INTO Tipo_Transaccion VALUES
(1,'Ingreso'),
(2,'Egreso'),
(3,'SINPE'),
(4,'Transferencia'),
(5,'Pago Servicio'),
(6,'Compra'),
(7,'Depósito'),
(8,'Retiro'),
(9,'Pago Tarjeta'),
(10,'Remesa');

INSERT INTO Profesion (C_id_profesion, D_nombre, N_peso_riesgo) VALUES
(1,'Ingeniero',10),
(2,'Abogado',15),
(3,'Profesor',5),
(4,'Contador',10),
(5,'Médico',5),
(6,'Enfermero',5),
(7,'Administrador',10),
(8,'Programador',10),
(9,'Arquitecto',10),
(10,'Estudiante',15);

INSERT INTO Actividad_Economica (C_id_actividad, D_descripcion, N_peso_riesgo) VALUES
(1,'Tecnología',15),
(2,'Educación',5),
(3,'Salud',5),
(4,'Comercio',20),
(5,'Construcción',15),
(6,'Turismo',10),
(7,'Agricultura',10),
(8,'Ganadería',10),
(9,'Servicios Profesionales',10),
(10,'Transporte',15);

INSERT INTO Factor_Riesgo (C_id_factor_riesgo, D_nivel, B_estado) VALUES
(1,'Ingresos elevados',1),
(2,'Transacciones frecuentes',1),
(3,'Cliente extranjero',1),
(4,'Actividad económica sensible',1),
(5,'Transferencias internacionales',1),
(6,'Compraventa de divisas',1),
(7,'PEP',1),
(8,'Zona geográfica de riesgo',1);