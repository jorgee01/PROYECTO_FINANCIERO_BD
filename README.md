# Grupo1 — Banco UCR

Sistema CRUD transaccional para entidad financiera con Node.js + SQL Server (LocalDB). Incluye calificadora de riesgo, búsqueda inteligente, escenarios de prueba re-ejecutables y generación XML SICVECA.

---

## Arquitectura del CRUD (Node.js)

```
src/
├── config/
│   └── database.js          → Pool MSSQL con msnodesqlv8 + ODBC Driver 17
├── repositories/
│   ├── base.repository.js   → Genérico CRUD (getAll, getById, create, update, delete)
│   └── index.js             → 23 instancias, una por tabla transaccional
├── services/
│   ├── base.service.js      → Capa de negocio con validación de existencia
│   └── index.js             → 23 servicios instanciados automáticamente
├── controllers/
│   ├── base.controller.js   → GET/POST/PUT/DELETE genéricos + registro de rutas
│   ├── cliente.controller.js→ Extiende con /buscar y /autocomplete
│   ├── padron.controller.js → Búsqueda y autocomplete sobre TMP_PADRON
│   └── index.js             → 25 controladores registrados (23 genéricos + 2 custom)
└── app.js                   → Express con CORS, JSON, rutas bajo /api
```

### Capas

| Capa | Responsabilidad |
|------|----------------|
| **Repositorio** (`BaseRepository`) | Traduce llamadas a funciones SQL (SELECT) y SPs (INSERT/UPDATE/DELETE). Infiere tipos automáticamente. |
| **Servicio** (`BaseService`) | Valida que el registro exista antes de actualizar/eliminar. |
| **Controlador** (`BaseController`) | Maneja HTTP, parsea params, responde JSON con códigos 200/201/404/500. |
| **Ruteo** (`app.js`) | Escanea todos los controladores y registra sus rutas bajo `/api/:recurso`. |

### Principios de diseño

- **Un repositorio genérico** evita 23 archivos casi idénticos. Cada instancia recibe: nombre de tabla, PK, función de lectura, SPs de insert/update/delete.
- **Lectura por funciones SQL** (`FN_ObtenerX(@Id)`). Sin `@Id` devuelve todos; con `@Id` devuelve uno.
- **Escritura por SPs con transacciones** (`BEGIN TRY/BEGIN TRANSACTION/COMMIT/ROLLBACK`).
- **SP de actualización** usan `ISNULL(@param, columna)` para permitir actualizaciones parciales.
- **Controladores custom** extienden la clase base para agregar endpoints específicos (búsqueda inteligente, autocomplete).
- **Conexión a LocalDB** resuelve dinámicamente el named pipe con `SqlLocalDB info MSSQLLocalDB`.

---

## Endpoints

### CRUD genérico (aplica a 23 tablas)

| Método | Ruta | Acción |
|--------|------|--------|
| `GET` | `/api/:recurso` | Listar todos |
| `GET` | `/api/:recurso/:id` | Obtener por ID |
| `POST` | `/api/:recurso` | Crear |
| `PUT` | `/api/:recurso/:id` | Actualizar |
| `DELETE` | `/api/:recurso/:id` | Eliminar |

### Recursos disponibles

| Ruta | Tabla |
|------|-------|
| `/api/productos` | Producto |
| `/api/clientes-productos` | Cliente_Producto |
| `/api/transacciones` | Transaccion |
| `/api/transferencias` | Transferencia |
| `/api/cuentas-vista` | Cuenta_Vista |
| `/api/cuentas-planilla` | Cuenta_Planilla |
| `/api/cuentas-expediente` | Cuenta_Expediente_Simplificado |
| `/api/prestamos` | Prestamo |
| `/api/lineas-credito` | Linea_Credito |
| `/api/tarjetas-credito` | Tarjeta_Credito |
| `/api/tarjetas-debito` | Tarjeta_Debito |
| `/api/depositos-plazo` | Deposito_Plazo |
| `/api/depositos-judiciales` | Deposito_Judicial |
| `/api/remesas` | Remesa |
| `/api/compraventas-divisa` | Compraventa_Divisa |
| `/api/arrendamientos` | Arrendamiento_Financiero |
| `/api/avales-garantia` | Aval_Garantia |
| `/api/fideicomisos` | Fideicomiso |
| `/api/cajas-seguridad` | Caja_Seguridad |
| `/api/cajeros-automaticos` | Cajero_Automatico |
| `/api/banca-linea` | Banca_Linea |
| `/api/descuentos-factura` | Descuentos_Factura |

### Endpoints especiales

| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/api/clientes/buscar?param=valor` | Búsqueda inteligente con acentos |
| `GET` | `/api/clientes/autocomplete?q=texto` | Autocompletado de clientes |
| `GET` | `/api/padron/buscar?param=valor` | Búsqueda en padrón electoral |
| `GET` | `/api/padron/autocomplete?q=texto` | Autocompletado de padrón |

### Parámetros de búsqueda (`/api/clientes/buscar`)

```
D_nombre, D_apellido, D_cedula, C_id_provincia, C_id_canton, C_id_distrito
```

### Parámetros de búsqueda (`/api/padron/buscar`)

```
D_cedula, D_nombre, D_apellido1, D_apellido2, D_provincia, D_canton, D_distrito
```

---

## Base de datos: SQL Server

- **Motor**: LocalDB (`MSSQLLocalDB`)
- **Base**: `Grupo1_BancoUCR`
- **DRIVER**: ODBC Driver 17 for SQL Server
- **Esquema**: 59 tablas (23 transaccionales + 14 catálogos + ubicaciones + auxiliares)
- **Operaciones**: 27 funciones de lectura + 23 INSERT SPs + 22 UPDATE SPs + 23 DELETE SPs

### Archivos SQL

| Archivo | Contenido |
|---------|-----------|
| `script_copia_bd.md` | Definición completa del esquema |
| `padron-bd.sql` | Creación y población de TMP_PADRON |
| `script_inserts_catalogos.sql` | Datos de 14 tablas catálogo |
| `script_inserts_ubicaciones.sql` | 7 provincias, 82 cantones, 479 distritos |
| `src/sql/functions.sql` | 27 funciones SELECT |
| `src/sql/sp_insert.sql` | 23 SPs de inserción |
| `src/sql/sp_update.sql` | 22 SPs de actualización |
| `src/sql/sp_delete.sql` | 23 SPs de eliminación |
| `src/sql/sp_busqueda_inteligente.sql` | Búsqueda flexible + autocomplete |
| `script_calificadora_riesgo.sql` | SP de evaluación de riesgo |
| `src/sql/sp_escenario1.sql` | SP_Escenario1 |
| `src/sql/sp_escenario2.sql` | SP_Escenario2 |
| `src/sql/script_poblacion_datos.sql` | Población inicial: 5 clientes, 95 productos |
| `src/sql/sp_escenario4.sql` | SP_Escenario4 (opcional) |

---

## Requisitos

- **Node.js** v18 o superior — [nodejs.org/en/download](https://nodejs.org/en/download)
- **pnpm** — instalador de paquetes. Se instala vía npm:
  ```bash
  npm install -g pnpm
  ```
  Más opciones en [pnpm.io/installation](https://pnpm.io/installation#using-npm)
- **SQL Server LocalDB** + **ODBC Driver 17 for SQL Server** — vienen incluidos con Visual Studio / SSMS, o se instalan por separado.

---

## Instalación

```bash
# 1. Instalar dependencias del proyecto
pnpm install

# 2. Ejecutar contra LocalDB los scripts en este orden:
#    - script_copia_bd.md (esquema completo)
#    - padron-bd.sql (padrón ~3.7M registros)
#    - script_inserts_catalogos.sql
#    - script_inserts_ubicaciones.sql
#    - src/sql/functions.sql (funciones de lectura)
#    - src/sql/sp_insert.sql (SPs de inserción)
#    - src/sql/sp_update.sql (SPs de actualización)
#    - src/sql/sp_delete.sql (SPs de eliminación)
#    - src/sql/sp_busqueda_inteligente.sql
#    - script_calificadora_riesgo.sql
#    - src/sql/sp_escenario1.sql, sp_escenario2.sql (escenario4.sql opcional)

# 3. Poblar datos iniciales (ejecuta src/sql/script_poblacion_datos.sql)
pnpm run poblar

# 4. Iniciar servidor
pnpm start
```

---

## FRONTEND
```bash
# en bash/cmd node src/app.js

```

## Scripts disponibles

| Comando | Descripción |
|---------|-------------|
| `pnpm start` | Inicia el servidor Express |
| `pnpm run poblar` | Población inicial: ejecuta `src/sql/script_poblacion_datos.sql` (5 clientes, 95 productos) |
| `pnpm run escenario1` | +25 clientes del padrón, +125 transacciones |
| `pnpm run escenario2` | +27 transacciones aleatorias |
| `pnpm run escenario3` | Genera XML SICVECA con 7 cuadros |
| `pnpm run escenario4` | Remesas, divisas, comisiones (opcional) |

---

## Ejemplo rápido

```bash
# Iniciar API
pnpm start

# Listar clientes
curl http://localhost:3000/api/clientes

# Buscar cliente por apellido
curl "http://localhost:3000/api/clientes/buscar?D_apellido=torres"

# Buscar en el padrón
curl "http://localhost:3000/api/padron/buscar?D_nombre=Maria"
```

---

## Stack

- **Runtime**: Node.js
- **Framework**: Express 4
- **DB Driver**: `mssql/msnodesqlv8` + ODBC Driver 17
- **Base de datos**: SQL Server LocalDB
- **Gestor de paquetes**: pnpm
