--Consultas de verificación

USE Grupo1_BancoUCR;
GO

SELECT 'Clientes' AS t, COUNT(*) FROM Cliente
UNION ALL SELECT 'Productos', COUNT(*) FROM Producto
UNION ALL SELECT 'Cliente_Producto', COUNT(*) FROM Cliente_Producto
UNION ALL SELECT 'Transaccion', COUNT(*) FROM Transaccion
UNION ALL SELECT 'Evaluacion_Riesgo', COUNT(*) FROM Evaluacion_Riesgo;

-- Cliente único con sus 19 productos
SELECT tp.D_nombre, p.M_monto
FROM Producto p
JOIN Tipo_Producto tp ON p.C_id_tipo_producto = tp.C_id_tipo_producto
WHERE p.C_id_cliente = 1
ORDER BY tp.C_id_tipo_producto;

--ESCENARIO 1

--EJECUTAR desde el CRUD con pnpm run escenario1

-- Cada ejecución suma  clientes nuevos por cada mes del año
-- (Mayo = +25 clientes nuevos del padrón, nunca repite cédulas), +25 productos y +125 transacciones.

SELECT 'Clientes' AS t, COUNT(*) FROM Cliente
UNION ALL SELECT 'Productos', COUNT(*) FROM Producto
UNION ALL SELECT 'Cliente_Producto', COUNT(*) FROM Cliente_Producto
UNION ALL SELECT 'Transaccion', COUNT(*) FROM Transaccion
UNION ALL SELECT 'Evaluacion_Riesgo', COUNT(*) FROM Evaluacion_Riesgo;

--Probar con diferentes clientes cambiando el p.C_id_cliente

SELECT tp.D_nombre, p.M_monto
FROM Producto p
JOIN Tipo_Producto tp ON p.C_id_tipo_producto = tp.C_id_tipo_producto
WHERE p.C_id_cliente = 1
ORDER BY tp.C_id_tipo_producto;

-- Escenario 2

-- Inserta 27 transacciones aleatorias del mes actual, para 5 clientes aleatorios que tengan productos,
-- con descripciones variadas (transporte, comida, servicios, etc.).

-- Requisito previo
-- La BD debe tener al menos 5 clientes y 5 productos. Si no, lanza error:

-- "Debe ejecutarse primero el Escenario 1"

-- EJECUTAR desde el CRUD con pnpm run escenario2

-- Verificar transacciones del mes actual
SELECT YEAR(F_fecha) AS anio, MONTH(F_fecha) AS mes, COUNT(*) AS total
FROM Transaccion
GROUP BY YEAR(F_fecha), MONTH(F_fecha)
ORDER BY anio, mes;

-- Ver distribución de descripciones
SELECT D_tipo, COUNT(*) AS cantidad
FROM Transaccion
GROUP BY D_tipo
ORDER BY cantidad DESC;

-- Re-ejecutar pnpm run escenario2
-- Cada ejecución suma +27 transacciones nuevas


-- Calificadora de Riesgo
-- Qué hace
-- Evalúa todos los clientes (o uno específico) calculando puntaje según profesión,
-- ingresos, ubicación, país, estado civil y actividad económica. Asigna nivel: Bajo (≤30), Medio (≤60) o Alto (>60).

-- Ejecutar
EXEC sp_CalcularRiesgoCliente;


-- Distribución de riesgo
SELECT D_nivel_riesgo, COUNT(*) AS clientes
FROM Evaluacion_Riesgo
GROUP BY D_nivel_riesgo;

-- Ver puntajes detallados
SELECT c.C_id_cliente, c.D_identificacion, c.D_nombre,
       er.D_nivel_riesgo, er.N_puntaje_total,
       er.N_puntaje_profesion, er.N_puntaje_ingresos,
       er.N_puntaje_provincia, er.N_puntaje_distrito
FROM Evaluacion_Riesgo er
JOIN Cliente c ON er.C_id_cliente = c.C_id_cliente
ORDER BY er.N_puntaje_total DESC;

-- Es re-ejecutable: siempre reemplaza evaluaciones anteriores por las nuevas.


-- Escenario 3 — Generar XML

-- Qué hace
-- Genera output/sicveca.xml con 7 cuadros SICVECA basados en datos agregados por nivel de riesgo:

-- Cuadro	Contenido	                                                    Fuente
    
-- A	    Clientes por nivel de riesgo	                                Evaluacion_Riesgo
-- D	    Operaciones activas (préstamos, líneas, tarjetas, descuentos)	Producto c/tipo 6,7,9 + Descuento_Factura
-- E	    Operaciones pasivas (cuentas, depósitos)	                    Producto c/tipo 1–5
-- F	    Fuera de balance (avales, fideicomisos, arrendamientos)	        Producto c/tipo 13,14,15
-- G	    Clientes únicos con operaciones	                                Producto
-- H	    Reclasificaciones de riesgo	                                    Historial Evaluacion_Riesgo
-- I	    Clientes por país y riesgo	                                    Cliente + Pais + Evaluacion_Riesgo

--Ejecutar en el CRUD pnpm run escenario3

-- Verificar XML en output/sicveca.xml (Dentro del CRUD)


-- Escenario 4 (Opcional) — Remesas, Divisas, Comisiones

-- Qué hace
-- Selecciona 5 clientes aleatorios con productos y les crea operaciones según los tipos de producto que tengan:

-- Requisito previo
-- Al menos 5 clientes y 5 productos en BD.

-- Ejecutar
-- pnpm run escenario4 desde el CRUD

-- Verificar por tipo de operación
SELECT D_tipo, COUNT(*) AS cantidad, SUM(M_monto) AS total_ganancias
FROM Transaccion
WHERE D_tipo LIKE 'Comision%'
GROUP BY D_tipo
ORDER BY total_ganancias DESC;

-- Ver remesas creadas
SELECT r.*, p.C_id_cliente
FROM Remesa r JOIN Producto p ON r.C_id_producto = p.C_id_producto;

-- Ver compraventas
SELECT * FROM Compraventa_Divisa;

-- Re-ejecutar
-- Cada ejecución suma un nuevo lote de operaciones para otros 5 clientes aleatorios. Los datos anteriores se conservan.



-- Re-ejecutar todo de forma acumulativa
-- # Segundo ciclo (los datos anteriores se conservan)

-- pnpm run escenario1          # +25 clientes, +125 transacciones
-- pnpm run escenario2          # +27 transacciones
-- EXEC sp_CalcularRiesgoCliente   # re-evalúa todos
-- pnpm run escenario3          # XML actualizado
-- pnpm run escenario4          # (Opcional) — Remesas, Divisas, Comisiones
