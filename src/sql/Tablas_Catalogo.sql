USE Grupo1_BancoUCR;
GO

-- =============================================
-- INSERTS PARA TABLAS DE CATALOGO
-- =============================================

-- Tipo_Persona
INSERT INTO Tipo_Persona (C_id_tipo_persona, D_descripcion) VALUES
(1, 'Fisica'),
(2, 'Juridica');

-- Tipo_Identificacion
INSERT INTO Tipo_Identificacion (C_id_tipo_identificacion, D_descripcion, B_estado, C_id_tipo_persona, D_formato, D_expresion_regular, N_longitud) VALUES
(1, 'Cedula Fisica',      1, 1, '########', '^\d{9}$',        9),
(2, 'Cedula Juridica',    1, 2, '########', '^\d{10}$',      10),
(3, 'DIMEX',              1, 1, '########', '^\d{11,12}$',   12),
(4, 'NITE',               1, 2, '########', '^\d{10}$',      10),
(5, 'Pasaporte',          1, 1, '########', '^[A-Z0-9]{6,20}$', 20);

-- Pais
INSERT INTO Pais (C_id_pais, D_codigo_alfa2, D_descripcion, D_codigo_area, B_estado) VALUES
(1, 'CR', 'Costa Rica',       '506', 1),
(2, 'US', 'Estados Unidos',   '1',   1),
(3, 'PA', 'Panama',           '507', 1),
(4, 'NI', 'Nicaragua',        '505', 1),
(5, 'SV', 'El Salvador',      '503', 1),
(6, 'GT', 'Guatemala',        '502', 1),
(7, 'HN', 'Honduras',         '504', 1),
(8, 'MX', 'Mexico',           '52',  1),
(9, 'ES', 'Espana',           '34',  1),
(10, 'CO', 'Colombia',        '57',  1);

-- Tipo_Ingreso
INSERT INTO Tipo_Ingreso (C_id_tipo_ingreso, D_descripcion, B_estado) VALUES
(1, 'Salario',          1),
(2, 'Pension',          1),
(3, 'Remesas',          1),
(4, 'Arrendamiento',    1),
(5, 'Dividendos',       1),
(6, 'Honorarios',       1),
(7, 'Venta de Bienes',  1),
(8, 'Otros',            1);

-- Justificacion_Ingreso
INSERT INTO Justificacion_Ingreso (C_id_justificacion, D_descripcion, B_estado) VALUES
(1, 'Declaracion Jurada',       1),
(2, 'Certificacion Contable',   1),
(3, 'Colilla de Pago',          1),
(4, 'Estados Financieros',      1),
(5, 'Declaracion de Renta',     1),
(6, 'Contrato Laboral',         1);

-- Entidad_Pensiones
INSERT INTO Entidad_Pensiones (C_id_entidad, D_identificacion, D_descripcion, B_estado) VALUES
(1, '3001000001', 'Caja Costarricense de Seguro Social',            1),
(2, '3002000001', 'Junta de Pensiones del Magisterio Nacional',    1),
(3, '3003000001', 'Pensiones del Poder Judicial',                  1),
(4, '3004000001', 'Municipalidad de San Jose',                     1);

-- Entidad_Otras_Pensiones
INSERT INTO Entidad_Otras_Pensiones (C_id_entidad, D_identificacion, D_descripcion, B_estado) VALUES
(1, '4001000001', 'INS',                   1),
(2, '4002000001', 'BN Vital',              1),
(3, '4003000001', 'Popular Pensiones',     1),
(4, '4004000001', 'BAC Pensiones',         1);

-- Medio_Comunicacion
INSERT INTO Medio_Comunicacion (C_id_medio, D_descripcion) VALUES
(1, 'Correo Electronico'),
(2, 'Telefono'),
(3, 'SMS'),
(4, 'Correo Postal'),
(5, 'Fax');

-- Tipo_Regimen
INSERT INTO Tipo_Regimen (C_id_tipo_regimen, D_descripcion, B_estado) VALUES
(1, 'Asalariado',              1),
(2, 'Pensionado',              1),
(3, 'Independiente',           1),
(4, 'Profesional Liberal',     1),
(5, 'Comerciante',             1),
(6, 'Servicio Domestico',      1);

-- Tipo_Relacion
INSERT INTO Tipo_Relacion (C_id_tipo_relacion, D_descripcion, B_estado) VALUES
(1, 'Titular',              1),
(2, 'Beneficiario',         1),
(3, 'Autorizado',           1),
(4, 'Representante Legal',  1),
(5, 'Garante',              1),
(6, 'Codeudor',             1),
(7, 'Apoderado',            1);

-- Estado_Persona_Juridica
INSERT INTO Estado_Persona_Juridica (C_id_estado, D_descripcion) VALUES
(1, 'Activa'),
(2, 'Inactiva'),
(3, 'Disuelta'),
(4, 'En Liquidacion'),
(5, 'Cancelada');

-- Evento_Extraordinario
INSERT INTO Evento_Extraordinario (C_id_evento, D_descripcion, B_estado) VALUES
(1, 'Bloqueo de Cuenta',           1),
(2, 'Robo de Tarjeta',            1),
(3, 'Extravio de Documentos',     1),
(4, 'Cambio de Firma',            1),
(5, 'Actualizacion de Datos',     1),
(6, 'Solicitud de Credito',       1),
(7, 'Cierre de Cuenta',           1),
(8, 'Reclamo',                    1);

-- Rol
INSERT INTO Rol (C_id_rol, D_nombre, D_descripcion) VALUES
(1, 'Administrador', 'Acceso total al sistema'),
(2, 'Operador',      'Gestion de clientes y productos'),
(3, 'Consultor',     'Consulta de datos unicamente'),
(4, 'Auditor',       'Acceso a reportes y auditoria');

-- Permiso
INSERT INTO Permiso (C_id_permiso, D_nombre_permiso, D_descripcion) VALUES
(1,  'CLIENTES_CREAR',       'Crear nuevos clientes'),
(2,  'CLIENTES_CONSULTAR',   'Consultar datos de clientes'),
(3,  'CLIENTES_ACTUALIZAR',  'Actualizar datos de clientes'),
(4,  'CLIENTES_ELIMINAR',    'Eliminar clientes'),
(5,  'PRODUCTOS_CREAR',      'Crear nuevos productos'),
(6,  'PRODUCTOS_CONSULTAR',  'Consultar productos'),
(7,  'PRODUCTOS_ACTUALIZAR', 'Actualizar productos'),
(8,  'PRODUCTOS_ELIMINAR',   'Eliminar productos'),
(9,  'TRANSACCIONES_REALIZAR',  'Realizar transacciones'),
(10, 'TRANSACCIONES_CONSULTAR', 'Consultar transacciones'),
(11, 'REPORTES_GENERAR',     'Generar reportes'),
(12, 'USUARIOS_ADMIN',       'Administrar usuarios'),
(13, 'RIESGO_EVALUAR',       'Evaluar riesgo de clientes'),
(14, 'CONFIGURACION',        'Configurar el sistema');
GO
