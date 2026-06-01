USE Grupo1_BancoUCR;
GO

-- =============================================
-- 3. ACTUALIZAR PESOS DE RIESGO
-- =============================================

-- Profesion (ya existia la columna)
UPDATE Profesion SET N_peso_riesgo = 10 WHERE C_id_profesion = 1; -- Ingeniero
UPDATE Profesion SET N_peso_riesgo = 15 WHERE C_id_profesion = 2; -- Abogado
UPDATE Profesion SET N_peso_riesgo = 5  WHERE C_id_profesion = 3; -- Profesor
UPDATE Profesion SET N_peso_riesgo = 10 WHERE C_id_profesion = 4; -- Contador
UPDATE Profesion SET N_peso_riesgo = 12 WHERE C_id_profesion = 5; -- Medico
UPDATE Profesion SET N_peso_riesgo = 8  WHERE C_id_profesion = 6; -- Enfermero
UPDATE Profesion SET N_peso_riesgo = 15 WHERE C_id_profesion = 7; -- Administrador
UPDATE Profesion SET N_peso_riesgo = 5  WHERE C_id_profesion = 8; -- Programador
UPDATE Profesion SET N_peso_riesgo = 10 WHERE C_id_profesion = 9; -- Arquitecto
UPDATE Profesion SET N_peso_riesgo = 2  WHERE C_id_profesion = 10; -- Estudiante

-- Actividad_Economica
UPDATE Actividad_Economica SET N_peso_riesgo = 15 WHERE C_id_actividad = 1;  -- Tecnologia
UPDATE Actividad_Economica SET N_peso_riesgo = 5  WHERE C_id_actividad = 2;  -- Educacion
UPDATE Actividad_Economica SET N_peso_riesgo = 10 WHERE C_id_actividad = 3;  -- Salud
UPDATE Actividad_Economica SET N_peso_riesgo = 20 WHERE C_id_actividad = 4;  -- Comercio
UPDATE Actividad_Economica SET N_peso_riesgo = 25 WHERE C_id_actividad = 5;  -- Construccion
UPDATE Actividad_Economica SET N_peso_riesgo = 20 WHERE C_id_actividad = 6;  -- Turismo
UPDATE Actividad_Economica SET N_peso_riesgo = 10 WHERE C_id_actividad = 7;  -- Agricultura
UPDATE Actividad_Economica SET N_peso_riesgo = 15 WHERE C_id_actividad = 8;  -- Ganaderia
UPDATE Actividad_Economica SET N_peso_riesgo = 20 WHERE C_id_actividad = 9;  -- Servicios Profesionales
UPDATE Actividad_Economica SET N_peso_riesgo = 15 WHERE C_id_actividad = 10; -- Transporte

-- Estado_Civil
UPDATE Estado_Civil SET N_peso_riesgo = 2 WHERE C_id_estado_civil = 1; -- Soltero
UPDATE Estado_Civil SET N_peso_riesgo = 2 WHERE C_id_estado_civil = 2; -- Casado
UPDATE Estado_Civil SET N_peso_riesgo = 5 WHERE C_id_estado_civil = 3; -- Divorciado
UPDATE Estado_Civil SET N_peso_riesgo = 3 WHERE C_id_estado_civil = 4; -- Viudo
UPDATE Estado_Civil SET N_peso_riesgo = 4 WHERE C_id_estado_civil = 5; -- Union Libre

-- Pais
UPDATE Pais SET N_peso_riesgo = 1  WHERE C_id_pais = 1;  -- Costa Rica
UPDATE Pais SET N_peso_riesgo = 5  WHERE C_id_pais = 2;  -- Estados Unidos
UPDATE Pais SET N_peso_riesgo = 10 WHERE C_id_pais = 3;  -- Panama
UPDATE Pais SET N_peso_riesgo = 15 WHERE C_id_pais = 4;  -- Nicaragua
UPDATE Pais SET N_peso_riesgo = 10 WHERE C_id_pais = 5;  -- El Salvador
UPDATE Pais SET N_peso_riesgo = 10 WHERE C_id_pais = 6;  -- Guatemala
UPDATE Pais SET N_peso_riesgo = 15 WHERE C_id_pais = 7;  -- Honduras
UPDATE Pais SET N_peso_riesgo = 10 WHERE C_id_pais = 8;  -- Mexico
UPDATE Pais SET N_peso_riesgo = 5  WHERE C_id_pais = 9;  -- Espana
UPDATE Pais SET N_peso_riesgo = 10 WHERE C_id_pais = 10; -- Colombia

-- Provincia (peso base geografico)
UPDATE Provincia SET N_peso_riesgo = 5  WHERE C_id_provincia = 1; -- San Jose
UPDATE Provincia SET N_peso_riesgo = 3  WHERE C_id_provincia = 2; -- Alajuela
UPDATE Provincia SET N_peso_riesgo = 3  WHERE C_id_provincia = 3; -- Cartago
UPDATE Provincia SET N_peso_riesgo = 4  WHERE C_id_provincia = 4; -- Heredia
UPDATE Provincia SET N_peso_riesgo = 8  WHERE C_id_provincia = 5; -- Guanacaste
UPDATE Provincia SET N_peso_riesgo = 6  WHERE C_id_provincia = 6; -- Puntarenas
UPDATE Provincia SET N_peso_riesgo = 7  WHERE C_id_provincia = 7; -- Limon
GO

-- =============================================
-- 4. STORED PROCEDURE: sp_CalcularRiesgoCliente
-- =============================================
CREATE OR ALTER PROCEDURE sp_CalcularRiesgoCliente
    @C_id_cliente INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PuntajeBajo INT = 30;
    DECLARE @PuntajeMedio INT = 60;

    DELETE FROM Evaluacion_Riesgo
    WHERE (@C_id_cliente IS NULL OR C_id_cliente = @C_id_cliente);

    ;WITH Calculo AS (
        SELECT
            c.C_id_cliente,
            tp.D_descripcion AS D_tipo_cliente,
            ISNULL(p.N_peso_riesgo, 0)     AS N_puntaje_profesion,
            ISNULL(ae.N_peso_riesgo, 0)    AS N_puntaje_actividad,
            ISNULL(ec.N_peso_riesgo, 0)    AS N_puntaje_estado_civil,
            ISNULL(pa.N_peso_riesgo, 0)    AS N_puntaje_pais,
            ISNULL(pr.N_peso_riesgo, 0)    AS N_puntaje_provincia,
            ISNULL(ca.N_peso_riesgo, 0)    AS N_puntaje_canton,
            ISNULL(di.N_peso_riesgo, 0)    AS N_puntaje_distrito,
            CASE
                WHEN c.N_ingresos IS NULL THEN 0
                WHEN c.N_ingresos <= 500000 THEN 2
                WHEN c.N_ingresos <= 2000000 THEN 10
                ELSE 25
            END AS N_puntaje_ingresos
        FROM Cliente c
        LEFT JOIN Tipo_Persona tp ON c.C_id_tipo_persona = tp.C_id_tipo_persona
        LEFT JOIN Profesion p ON c.C_id_profesion = p.C_id_profesion
        LEFT JOIN Actividad_Economica ae ON c.C_id_actividad_economica = ae.C_id_actividad
        LEFT JOIN Estado_Civil ec ON c.C_id_estado_civil = ec.C_id_estado_civil
        LEFT JOIN Pais pa ON c.C_id_pais = pa.C_id_pais
        LEFT JOIN Distrito di ON c.C_id_distrito = di.C_id_distrito
        LEFT JOIN Canton ca ON di.C_id_canton = ca.C_id_canton
        LEFT JOIN Provincia pr ON ca.C_id_provincia = pr.C_id_provincia
        WHERE (c.C_id_cliente = @C_id_cliente OR @C_id_cliente IS NULL)
    )
    INSERT INTO Evaluacion_Riesgo (
        C_id_cliente, D_tipo_cliente, D_factor,
        N_puntaje_profesion, N_puntaje_ingresos,
        N_puntaje_provincia, N_puntaje_canton, N_puntaje_distrito,
        N_puntaje_total, D_nivel_riesgo, F_fecha_evaluacion
    )
    SELECT
        C_id_cliente,
        ISNULL(D_tipo_cliente, 'Fisica'),
        'Evaluacion integral de riesgo',
        N_puntaje_profesion,
        N_puntaje_ingresos,
        N_puntaje_provincia,
        N_puntaje_canton,
        N_puntaje_distrito,
        -- Puntaje total
        N_puntaje_profesion + N_puntaje_actividad + N_puntaje_estado_civil
        + N_puntaje_pais + N_puntaje_provincia + N_puntaje_canton
        + N_puntaje_distrito + N_puntaje_ingresos AS N_puntaje_total,
        -- Nivel de riesgo
        CASE
            WHEN N_puntaje_profesion + N_puntaje_actividad + N_puntaje_estado_civil
                 + N_puntaje_pais + N_puntaje_provincia + N_puntaje_canton
                 + N_puntaje_distrito + N_puntaje_ingresos <= @PuntajeBajo THEN 'Bajo'
            WHEN N_puntaje_profesion + N_puntaje_actividad + N_puntaje_estado_civil
                 + N_puntaje_pais + N_puntaje_provincia + N_puntaje_canton
                 + N_puntaje_distrito + N_puntaje_ingresos <= @PuntajeMedio THEN 'Medio'
            ELSE 'Alto'
        END AS D_nivel_riesgo,
        GETDATE() AS F_fecha_evaluacion
    FROM Calculo;
END;
GO

-- =============================================
-- 5. EJEMPLO DE USO
-- =============================================
-- Evaluar un cliente especifico:
-- EXEC sp_CalcularRiesgoCliente @C_id_cliente = 1;
--
-- Evaluar todos los clientes:
-- EXEC sp_CalcularRiesgoCliente;
--
-- Consultar resultados:
-- SELECT * FROM Evaluacion_Riesgo;
GO