# Guía de Pruebas: Escenarios 1-2-3

## Estado Inicial (pre-escenarios)

| Tabla | Registros | Detalle |
|-------|-----------|---------|
| `Cliente` | 1 | Ema torres (101230101) — miembro del grupo |
| `Producto` | 19 | 1 producto por cada tipo (18 tipos, Préstamo×2) |
| `Cliente_Producto` | 19 | Asociaciones cliente↔producto |
| `Descuento_Factura` | 1 | FAC-1-001, ₡500.000, Pendiente |
| `Transaccion` | 0 | — |
| `Evaluacion_Riesgo` | 0 | — |

### Consultas de verificación

```sql
-- Resumen general
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
```

---

## Escenario 1

### Qué hace
Inserta **5 clientes nuevos del padrón** por cada mes transcurrido del año actual (enero–mayo = 25 clientes). A cada uno le asigna **1 producto aleatorio** y **5 transacciones**.

### Ejecutar
```bash
pnpm run escenario1
```

### Estado después de la 1ª ejecución

| Tabla | Antes | Después | Diferencia |
|-------|-------|---------|------------|
| `Cliente` | 1 | **26** | +25 |
| `Producto` | 19 | **44** | +25 |
| `Cliente_Producto` | 19 | **44** | +25 |
| `Transaccion` | 0 | **125** | +125 |

```sql
-- Verificar distribución por mes
SELECT MONTH(F_fecha_registro) AS mes, COUNT(*) AS clientes
FROM Cliente
WHERE YEAR(F_fecha_registro) = YEAR(GETDATE())
GROUP BY MONTH(F_fecha_registro)
ORDER BY mes;

-- Verificar nuevos clientes (excluyendo Ema)
SELECT C_id_cliente, D_identificacion, D_nombre, D_apellido
FROM Cliente WHERE C_id_cliente > 1;

-- Total transacciones
SELECT COUNT(*) AS transacciones FROM Transaccion;
```

### Re-ejecutar (2ª, 3ª, ... vez)

```bash
pnpm run escenario1
```

Cada ejecución suma **+25 clientes** (nuevos del padrón, nunca repite cédulas), **+25 productos** y **+125 transacciones**.

| Ejecución | Clientes | Productos | Transacciones |
|-----------|----------|-----------|---------------|
| 1ª | 26 | 44 | 125 |
| 2ª | 51 | 69 | 250 |
| 3ª | 76 | 94 | 375 |

> TMP_PADRON tiene ~3.7M personas — hay margen para muchas ejecuciones.

---

## Escenario 2

### Qué hace
Inserta **27 transacciones aleatorias** del mes actual, para **5 clientes aleatorios** que tengan productos, con descripciones variadas (transporte, comida, servicios, etc.).

### Requisito previo
La BD debe tener al menos **5 clientes** y **5 productos**. Si no, lanza error:
> *"Debe ejecutarse primero el Escenario 1"*

### Ejecutar
```bash
pnpm run escenario2
```

### Estado después de la 1ª ejecución (post-escenario1)

| Tabla | Antes | Después | Diferencia |
|-------|-------|---------|------------|
| `Transaccion` | 125 | **152** | +27 |

```sql
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
```

### Re-ejecutar

Cada ejecución suma **+27 transacciones** nuevas:

| Ejecución | Transacciones totales |
|-----------|----------------------|
| Sólo escenario 1 | 125 |
| + 1ª escenario 2 | 152 |
| + 2ª escenario 2 | 179 |
| + 3ª escenario 2 | 206 |

---

## Calificadora de Riesgo

### Qué hace
Evalúa **todos los clientes** (o uno específico) calculando puntaje según profesión, ingresos, ubicación, país, estado civil y actividad económica. Asigna nivel: **Bajo** (≤30), **Medio** (≤60) o **Alto** (>60).

### Ejecutar
```sql
EXEC sp_CalcularRiesgoCliente;
```

### Estado después

| Tabla | Antes | Después | Diferencia |
|-------|-------|---------|------------|
| `Evaluacion_Riesgo` | 0 | **= n° clientes** | 1 por cliente |

```sql
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
```

> Es **re-ejecutable**: siempre reemplaza evaluaciones anteriores por las nuevas.

---

## Escenario 3 — Generar XML

### Qué hace
Genera `output/sicveca.xml` con 7 cuadros SICVECA basados en datos **agregados por nivel de riesgo**:

| Cuadro | Contenido | Fuente |
|--------|-----------|--------|
| **A** | Clientes por nivel de riesgo | `Evaluacion_Riesgo` |
| **D** | Operaciones activas (préstamos, líneas, tarjetas, descuentos) | `Producto` c/tipo 6,7,9 + `Descuento_Factura` |
| **E** | Operaciones pasivas (cuentas, depósitos) | `Producto` c/tipo 1–5 |
| **F** | Fuera de balance (avales, fideicomisos, arrendamientos) | `Producto` c/tipo 13,14,15 |
| **G** | Clientes únicos con operaciones | `Producto` |
| **H** | Reclasificaciones de riesgo | Historial `Evaluacion_Riesgo` |
| **I** | Clientes por país y riesgo | `Cliente` + `Pais` + `Evaluacion_Riesgo` |

### Ejecutar
```bash
pnpm run escenario3
```

### Verificar XML
```bash
# Ver estructura general
$xml = [xml](Get-Content output\sicveca.xml)
$xml.SICVECA.CuadroA.Registro | Format-Table

# Contar registros por cuadro
Select-String -Path output\sicveca.xml -Pattern "<Registro>" | Measure-Object
```

### Ejemplo de salida
```xml
<SICVECA>
  <Periodo><Anio>2026</Anio><Mes>5</Mes></Periodo>
  <CuadroA>
    <Registro>
      <Mes>5</Mes>
      <TipoRiesgo>BAJO</TipoRiesgo>
      <NumeroClientes>13</NumeroClientes>
      <PorcentajeClientes>17.33</PorcentajeClientes>
    </Registro>
    <Registro>
      <Mes>5</Mes>
      <TipoRiesgo>MEDIO</TipoRiesgo>
      <NumeroClientes>62</NumeroClientes>
      <PorcentajeClientes>82.67</PorcentajeClientes>
    </Registro>
  </CuadroA>
  ...
</SICVECA>
```

---

## Escenario 4 (Opcional) — Remesas, Divisas, Comisiones

### Qué hace
Selecciona **5 clientes aleatorios** con productos y les crea operaciones según los tipos de producto que tengan:

| Operación | Tabla destino | Tipo Producto | Comisión asociada |
|-----------|--------------|---------------|-------------------|
| **Remesa** | `Remesa` + `Transaccion` | 11 | 2% del monto |
| **Compra/Venta divisas** | `Compraventa_Divisa` + `Transaccion` | 12 | 0.5–1% del monto |
| **Comisión cajero** | `Cajero_Automatico` + `Transaccion` | 18 | ₡1.500 fijo |
| **SINPE** | `Transferencia` + `Transaccion` | 10 | ₡500 fijo |
| **Swift** | `Transferencia` + `Transaccion` | 10 | ₡5.000 + 0.5% |

Todas las comisiones se registran como ganancias de la entidad (`M_monto > 0` en `Transaccion`).

### Requisito previo
Al menos **5 clientes** y **5 productos** en BD.

### Instalación (solo una vez)
```cmd
sqlcmd -S "(localdb)\MSSQLLocalDB" -d Grupo1_BancoUCR -E -i "src\sql\sp_escenario4.sql"
```

### Ejecutar
```bash
pnpm run escenario4
```

### Estado después de la 1ª ejecución (post-escenario1+2)

| Tabla | Antes | Después (aprox) | Diferencia |
|-------|-------|-----------------|------------|
| `Remesa` | 0 | **1–5** | según clientes con tipo 11 |
| `Compraventa_Divisa` | 0 | **1–5** | según clientes con tipo 12 |
| `Cajero_Automatico` | 0 | **1–5** | según clientes con tipo 18 |
| `Transferencia` | 0 | **1–5** | según clientes con tipo 10 |
| `Transaccion` | +152 | **~+176** | +24–30 operaciones |

```sql
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
```

### Re-ejecutar

Cada ejecución suma un nuevo lote de operaciones para otros 5 clientes aleatorios. Los datos anteriores se conservan.

---
## Secuencia completa recomendada

```bash
# 1. Población inicial (5 miembros × 19 productos)
#    Ya debería estar ejecutado (script_poblacion_datos.sql)

# 2. Escenario 1 — 25 clientes del padrón
pnpm run escenario1

# 3. Escenario 2 — 27 transacciones aleatorias
pnpm run escenario2

# 4. Calificadora de riesgo — evaluar todos los clientes
sqlcmd -S "(localdb)\MSSQLLocalDB" -d Grupo1_BancoUCR -E -Q "EXEC sp_CalcularRiesgoCliente"

# 5. XML final
pnpm run escenario3
```

### Re-ejecutar todo de forma acumulativa
```bash
# Segundo ciclo (los datos anteriores se conservan)
pnpm run escenario1          # +25 clientes, +125 transacciones
pnpm run escenario2          # +27 transacciones
sqlcmd ... EXEC sp_CalcularRiesgoCliente   # re-evalúa todos
pnpm run escenario3          # XML actualizado
```

---

## Validaciones del XML

El generador aplica estas reglas de legitimación:

| Validación | Regla |
|-----------|-------|
| Riesgo Alto | Cliente con riesgo Alto marcado como WARNING |
| Transacciones negativas | Monto negativo con tipo "Ingreso mensual" genera WARNING |
| Porcentajes Cuadro A | Deben sumar ~100% |
