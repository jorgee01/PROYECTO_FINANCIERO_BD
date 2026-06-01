USE Grupo1_BancoUCR;
GO

USE master

-- =============================================
-- FUNCION: Busca en el padron electoral con criterios flexibles
-- =============================================
IF OBJECT_ID('dbo.FN_BuscarPadron', 'IF') IS NOT NULL DROP FUNCTION dbo.FN_BuscarPadron;
GO
CREATE FUNCTION dbo.FN_BuscarPadron
(
    @D_cedula       VARCHAR(20) = NULL,
    @D_nombre       VARCHAR(100) = NULL,
    @D_apellido1    VARCHAR(100) = NULL,
    @D_apellido2    VARCHAR(100) = NULL,
    @D_provincia    VARCHAR(50) = NULL,
    @D_canton       VARCHAR(50) = NULL,
    @D_distrito     VARCHAR(100) = NULL
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        p.Cedula,
        p.Nombre,
        p.PrimerApellido,
        p.SegundoApellido,
        p.Codelec,
        d.Provincia,
        d.Canton,
        d.Distrito,
        CASE WHEN c.C_id_cliente IS NOT NULL THEN 1 ELSE 0 END AS B_es_cliente,
        ISNULL(cp.cantidad_productos, 0) AS N_cantidad_productos,
        RANK() OVER (ORDER BY
            CASE WHEN p.Cedula = @D_cedula THEN 0 ELSE 5 END +
            CASE WHEN p.Nombre = @D_nombre THEN 0 ELSE 5 END +
            CASE WHEN p.PrimerApellido = @D_apellido1 THEN 0 ELSE 5 END +
            CASE WHEN p.SegundoApellido = @D_apellido2 THEN 0 ELSE 5 END
        ) AS N_relevancia
    FROM TMP_PADRON p
    LEFT JOIN TMP_DISTELEC d ON p.Codelec = d.Codelec
    LEFT JOIN Cliente c ON c.D_identificacion = p.Cedula
    LEFT JOIN (
        SELECT C_id_cliente, COUNT(*) AS cantidad_productos
        FROM Cliente_Producto GROUP BY C_id_cliente
    ) cp ON c.C_id_cliente = cp.C_id_cliente
    WHERE
        (@D_cedula IS NULL OR p.Cedula LIKE '%' + @D_cedula + '%')
        AND (@D_nombre IS NULL OR p.Nombre LIKE '%' + @D_nombre + '%' COLLATE Latin1_General_CI_AI)
        AND (@D_apellido1 IS NULL OR p.PrimerApellido LIKE '%' + @D_apellido1 + '%' COLLATE Latin1_General_CI_AI)
        AND (@D_apellido2 IS NULL OR p.SegundoApellido LIKE '%' + @D_apellido2 + '%' COLLATE Latin1_General_CI_AI)
        AND (@D_provincia IS NULL OR d.Provincia LIKE '%' + @D_provincia + '%' COLLATE Latin1_General_CI_AI)
        AND (@D_canton IS NULL OR d.Canton LIKE '%' + @D_canton + '%' COLLATE Latin1_General_CI_AI)
        AND (@D_distrito IS NULL OR d.Distrito LIKE '%' + @D_distrito + '%' COLLATE Latin1_General_CI_AI)
);
GO

-- =============================================
-- SP: Busqueda en padron (wrapper que llama la funcion)
-- =============================================
IF OBJECT_ID('dbo.SP_BuscarPadron', 'P') IS NOT NULL DROP PROCEDURE dbo.SP_BuscarPadron;
GO
CREATE PROCEDURE dbo.SP_BuscarPadron
    @D_cedula       VARCHAR(20) = NULL,
    @D_nombre       VARCHAR(100) = NULL,
    @D_apellido1    VARCHAR(100) = NULL,
    @D_apellido2    VARCHAR(100) = NULL,
    @D_provincia    VARCHAR(50) = NULL,
    @D_canton       VARCHAR(50) = NULL,
    @D_distrito     VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.FN_BuscarPadron(@D_cedula, @D_nombre, @D_apellido1, @D_apellido2, @D_provincia, @D_canton, @D_distrito)
    ORDER BY B_es_cliente DESC, N_relevancia;
END
GO

-- =============================================
-- FUNCION: Autocomplete padron
-- =============================================
IF OBJECT_ID('dbo.FN_AutocompletarPadron', 'IF') IS NOT NULL DROP FUNCTION dbo.FN_AutocompletarPadron;
GO
CREATE FUNCTION dbo.FN_AutocompletarPadron
(
    @D_termino VARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 20
        p.Cedula,
        p.Nombre,
        p.PrimerApellido,
        p.SegundoApellido,
        CASE
            WHEN p.Cedula LIKE @D_termino + '%' THEN 0
            WHEN p.Nombre LIKE @D_termino + '%' THEN 1
            WHEN p.PrimerApellido LIKE @D_termino + '%' THEN 2
            WHEN p.SegundoApellido LIKE @D_termino + '%' THEN 3
            ELSE 4
        END AS N_prioridad
    FROM TMP_PADRON p
    WHERE
        p.Cedula LIKE @D_termino + '%'
        OR p.Nombre LIKE @D_termino + '%' COLLATE Latin1_General_CI_AI
        OR p.PrimerApellido LIKE @D_termino + '%' COLLATE Latin1_General_CI_AI
        OR p.SegundoApellido LIKE @D_termino + '%' COLLATE Latin1_General_CI_AI
    ORDER BY N_prioridad, p.Nombre
);
GO

-- =============================================
-- SP: Autocomplete padron
-- =============================================
IF OBJECT_ID('dbo.SP_AutocompletarPadron', 'P') IS NOT NULL DROP PROCEDURE dbo.SP_AutocompletarPadron;
GO
CREATE PROCEDURE dbo.SP_AutocompletarPadron
    @D_termino VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.FN_AutocompletarPadron(@D_termino);
END
GO

-- =============================================
-- FUNCION: Busqueda inteligente de clientes
-- =============================================
IF OBJECT_ID('dbo.FN_BuscarClientesInteligente', 'IF') IS NOT NULL DROP FUNCTION dbo.FN_BuscarClientesInteligente;
GO
CREATE FUNCTION dbo.FN_BuscarClientesInteligente
(
    @D_nombre       VARCHAR(100) = NULL,
    @D_apellido     VARCHAR(100) = NULL,
    @D_cedula       VARCHAR(20) = NULL,
    @C_id_provincia INT = NULL,
    @C_id_canton    INT = NULL,
    @C_id_distrito  INT = NULL
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        c.C_id_cliente,
        c.D_nombre,
        c.D_apellido,
        c.D_correo,
        c.N_ingresos,
        c.B_activo,
        c.F_fecha_registro,
        ISNULL(cp.cantidad_productos, 0) AS N_cantidad_productos,
        CASE
            WHEN c.D_nombre + ' ' + c.D_apellido = @D_nombre + ' ' + @D_apellido THEN 1
            WHEN c.D_nombre = @D_nombre OR c.D_apellido = @D_apellido THEN 2
            ELSE 3
        END AS N_relevancia
    FROM Cliente c
    LEFT JOIN (
        SELECT C_id_cliente, COUNT(*) AS cantidad_productos
        FROM Cliente_Producto
        GROUP BY C_id_cliente
    ) cp ON c.C_id_cliente = cp.C_id_cliente
    WHERE
        (@D_nombre IS NULL OR c.D_nombre LIKE '%' + @D_nombre + '%' COLLATE Latin1_General_CI_AI)
        AND (@D_apellido IS NULL OR c.D_apellido LIKE '%' + @D_apellido + '%' COLLATE Latin1_General_CI_AI)
        AND (@C_id_distrito IS NULL OR c.C_id_distrito = @C_id_distrito)
        AND (@C_id_canton IS NULL OR EXISTS (
            SELECT 1 FROM Distrito di
            WHERE di.C_id_distrito = c.C_id_distrito AND di.C_id_canton = @C_id_canton
        ))
        AND (@C_id_provincia IS NULL OR EXISTS (
            SELECT 1 FROM Distrito di
            JOIN Canton ca ON di.C_id_canton = ca.C_id_canton
            WHERE di.C_id_distrito = c.C_id_distrito AND ca.C_id_provincia = @C_id_provincia
        ))
);
GO

-- =============================================
-- SP: Busqueda inteligente de clientes
-- =============================================
IF OBJECT_ID('dbo.SP_BuscarClientesInteligente', 'P') IS NOT NULL DROP PROCEDURE dbo.SP_BuscarClientesInteligente;
GO
CREATE PROCEDURE dbo.SP_BuscarClientesInteligente
    @D_nombre       VARCHAR(100) = NULL,
    @D_apellido     VARCHAR(100) = NULL,
    @D_cedula       VARCHAR(20) = NULL,
    @C_id_provincia INT = NULL,
    @C_id_canton    INT = NULL,
    @C_id_distrito  INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.FN_BuscarClientesInteligente(@D_nombre, @D_apellido, @D_cedula, @C_id_provincia, @C_id_canton, @C_id_distrito)
    ORDER BY N_relevancia, N_cantidad_productos DESC;
END
GO

-- =============================================
-- FUNCION: Autocomplete clientes
-- =============================================
IF OBJECT_ID('dbo.FN_AutocompletarCliente', 'IF') IS NOT NULL DROP FUNCTION dbo.FN_AutocompletarCliente;
GO
CREATE FUNCTION dbo.FN_AutocompletarCliente
(
    @D_termino VARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 20
        C_id_cliente,
        D_nombre,
        D_apellido,
        CASE
            WHEN D_nombre LIKE @D_termino + '%' THEN 0
            WHEN D_apellido LIKE @D_termino + '%' THEN 1
            ELSE 2
        END AS N_prioridad
    FROM Cliente
    WHERE
        D_nombre LIKE @D_termino + '%' COLLATE Latin1_General_CI_AI
        OR D_apellido LIKE @D_termino + '%' COLLATE Latin1_General_CI_AI
    ORDER BY N_prioridad, D_nombre
);
GO

-- =============================================
-- SP: Autocomplete clientes
-- =============================================
IF OBJECT_ID('dbo.SP_AutocompletarCliente', 'P') IS NOT NULL DROP PROCEDURE dbo.SP_AutocompletarCliente;
GO
CREATE PROCEDURE dbo.SP_AutocompletarCliente
    @D_termino VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.FN_AutocompletarCliente(@D_termino);
END
GO
