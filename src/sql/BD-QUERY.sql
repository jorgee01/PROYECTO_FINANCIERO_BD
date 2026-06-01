
GO
CREATE TABLE [dbo].[Actividad_Economica](
	[C_id_actividad] [int] NOT NULL,
	[D_codigo_actividad] [varchar](20) NULL,
	[D_descripcion] [varchar](100) NULL,
	[D_sector] [varchar](50) NULL,
	[D_estado] [varchar](20) NULL,
	[N_peso_riesgo] [int] NULL,
 CONSTRAINT [PK_Actividad_Economica] PRIMARY KEY CLUSTERED 
(
	[C_id_actividad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Archivo] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Archivo](
	[C_id_archivo] [int] NOT NULL,
	[D_tipo] [varchar](50) NULL,
	[F_fecha] [datetime] NULL,
	[B_estado] [bit] NULL,
	[D_nombre] [varchar](100) NULL,
 CONSTRAINT [PK_Archivo] PRIMARY KEY CLUSTERED 
(
	[C_id_archivo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Arrendamiento_Financiero] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Arrendamiento_Financiero](
	[C_id_arrendamiento] [int] IDENTITY(1,1) NOT NULL,
	[C_id_producto] [int] NOT NULL,
	[D_descripcion_bien] [varchar](200) NOT NULL,
	[N_valor_bien] [decimal](18, 2) NOT NULL,
	[N_cuota_mensual] [decimal](18, 2) NOT NULL,
	[N_plazo_meses] [int] NOT NULL,
	[N_tasa_interes] [decimal](5, 2) NOT NULL,
	[F_fecha_inicio] [date] NOT NULL,
	[F_fecha_fin] [date] NOT NULL,
	[D_estado] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Arrendamiento_Financiero] PRIMARY KEY CLUSTERED 
(
	[C_id_arrendamiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Aval_Garantia](
	[C_id_aval] [int] IDENTITY(1,1) NOT NULL,
	[C_id_producto] [int] NOT NULL,
	[D_tipo_garantia] [varchar](50) NOT NULL,
	[D_beneficiario] [varchar](100) NOT NULL,
	[N_monto] [decimal](18, 2) NOT NULL,
	[F_fecha_emision] [date] NOT NULL,
	[F_fecha_vencimiento] [date] NOT NULL,
	[D_estado] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Aval_Garantia] PRIMARY KEY CLUSTERED 
([C_id_aval] ASC)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Banca_Linea] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Banca_Linea](
	[C_id_banca_linea] [int] IDENTITY(1,1) NOT NULL,
	[C_id_producto] [int] NOT NULL,
	[D_usuario] [varchar](100) NOT NULL,
	[F_fecha_activacion] [date] NOT NULL,
	[F_ultimo_acceso] [datetime] NULL,
	[B_activo] [bit] NOT NULL,
 CONSTRAINT [PK_Banca_Linea] PRIMARY KEY CLUSTERED 
(
	[C_id_banca_linea] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Caja_Seguridad] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Caja_Seguridad](
	[C_id_caja] [int] IDENTITY(1,1) NOT NULL,
	[C_id_producto] [int] NOT NULL,
	[D_numero_caja] [varchar](20) NOT NULL,
	[D_tamano] [varchar](20) NOT NULL,
	[N_costo_mensual] [decimal](18, 2) NOT NULL,
	[F_fecha_inicio] [date] NOT NULL,
	[F_fecha_vencimiento] [date] NOT NULL,
	[D_estado] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Caja_Seguridad] PRIMARY KEY CLUSTERED 
(
	[C_id_caja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Cajero_Automatico] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Cajero_Automatico](
	[C_id_cajero] [int] IDENTITY(1,1) NOT NULL,
	[C_id_producto] [int] NOT NULL,
	[D_numero_tarjeta] [varchar](20) NOT NULL,
	[N_limite_diario] [decimal](18, 2) NOT NULL,
	[F_fecha_activacion] [date] NOT NULL,
	[D_estado] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Cajero_Automatico] PRIMARY KEY CLUSTERED 
(
	[C_id_cajero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Canton] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Canton](
	[C_id_canton] [int] NOT NULL,
	[D_nombre] [varchar](100) NULL,
	[C_id_provincia] [int] NULL,
	[N_peso_riesgo] [int] NULL,
 CONSTRAINT [PK_Canton] PRIMARY KEY CLUSTERED 
(
	[C_id_canton] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Cliente] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Cliente](
	[C_id_cliente] [int] IDENTITY(1,1) NOT NULL,
	[D_identificacion] [varchar](20) NULL,
	[D_nombre] [varchar](100) NULL,
	[D_apellido] [varchar](100) NULL,
	[D_correo] [varchar](100) NULL,
	[N_ingresos] [int] NULL,
	[B_activo] [bit] NULL,
	[F_fecha_registro] [datetime] NULL,
	[C_id_distrito] [int] NULL,
	[C_id_profesion] [int] NULL,
	[C_id_actividad_economica] [int] NULL,
	[C_id_tipo_persona] [int] NULL,
	[C_id_estado_civil] [int] NULL,
	[C_id_pais] [int] NULL,
 CONSTRAINT [PK_Cliente] PRIMARY KEY CLUSTERED 
(
	[C_id_cliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Cliente_Producto] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Cliente_Producto](
	[C_id_cliente] [int] NOT NULL,
	[C_id_producto] [int] NOT NULL,
 CONSTRAINT [PK_Cliente_Producto] PRIMARY KEY CLUSTERED 
(
	[C_id_cliente] ASC,
	[C_id_producto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Compraventa_Divisa] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Compraventa_Divisa](
	[C_id_compraventa] [int] IDENTITY(1,1) NOT NULL,
	[C_id_producto] [int] NOT NULL,
	[D_tipo] [varchar](10) NOT NULL,
	[D_moneda_origen] [varchar](10) NOT NULL,
	[D_moneda_destino] [varchar](10) NOT NULL,
	[N_monto] [decimal](18, 2) NOT NULL,
	[N_tipo_cambio] [decimal](10, 4) NOT NULL,
	[F_fecha] [date] NOT NULL,
	[D_estado] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Compraventa_Divisa] PRIMARY KEY CLUSTERED 
(
	[C_id_compraventa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Cuenta_Bancaria] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Cuenta_Bancaria](
	[C_id_cuenta] [int] IDENTITY(1,1) NOT NULL,
	[C_id_producto] [int] NOT NULL,
	[D_numero_cuenta] [varchar](30) NOT NULL,
	[N_tipo_cuenta] [int] NOT NULL,
	[N_saldo] [decimal](18, 2) NOT NULL,
	[N_moneda] [int] NOT NULL,
	[F_fecha_apertura] [date] NOT NULL,
	[D_estado] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Cuenta_Bancaria] PRIMARY KEY CLUSTERED 
(
	[C_id_cuenta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Cuenta_Expediente_Simplificado] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Cuenta_Expediente_Simplificado](
	[C_id_cuenta_expediente] [int] IDENTITY(1,1) NOT NULL,
	[C_id_producto] [int] NOT NULL,
	[D_numero_cuenta] [varchar](30) NOT NULL,
	[N_saldo] [decimal](18, 2) NOT NULL,
	[N_limite_mensual] [decimal](18, 2) NOT NULL,
	[F_fecha_apertura] [date] NOT NULL,
	[D_estado] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Cuenta_Expediente_Simplificado] PRIMARY KEY CLUSTERED 
(
	[C_id_cuenta_expediente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Cuenta_Planilla] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Cuenta_Planilla](
	[C_id_cuenta_planilla] [int] IDENTITY(1,1) NOT NULL,
	[C_id_producto] [int] NOT NULL,
	[D_numero_cuenta] [varchar](30) NOT NULL,
	[N_saldo] [decimal](18, 2) NOT NULL,
	[D_empleador] [varchar](100) NOT NULL,
	[N_salario] [decimal](18, 2) NOT NULL,
	[F_fecha_apertura] [date] NOT NULL,
	[D_estado] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Cuenta_Planilla] PRIMARY KEY CLUSTERED 
(
	[C_id_cuenta_planilla] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Cuenta_Vista] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Cuenta_Vista](
	[C_id_cuenta_vista] [int] IDENTITY(1,1) NOT NULL,
	[C_id_producto] [int] NOT NULL,
	[D_numero_cuenta] [varchar](30) NOT NULL,
	[N_saldo] [decimal](18, 2) NOT NULL,
	[N_saldo_disponible] [decimal](18, 2) NOT NULL,
	[F_fecha_apertura] [date] NOT NULL,
	[D_estado] [varchar](20) NOT NULL,
	[C_id_cliente] [int] NULL,
 CONSTRAINT [PK_Cuenta_Vista] PRIMARY KEY CLUSTERED 
(
	[C_id_cuenta_vista] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Deposito_Judicial] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Deposito_Judicial](
	[C_id_deposito_judicial] [int] IDENTITY(1,1) NOT NULL,
	[C_id_producto] [int] NOT NULL,
	[D_numero_expediente] [varchar](50) NOT NULL,
	[N_monto] [decimal](18, 2) NOT NULL,
	[D_juzgado] [varchar](100) NOT NULL,
	[F_fecha_deposito] [date] NOT NULL,
	[D_estado] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Deposito_Judicial] PRIMARY KEY CLUSTERED 
(
	[C_id_deposito_judicial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Deposito_Plazo] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Deposito_Plazo](
	[C_id_deposito] [int] IDENTITY(1,1) NOT NULL,
	[C_id_producto] [int] NOT NULL,
	[D_numero_deposito] [varchar](30) NOT NULL,
	[N_monto] [decimal](18, 2) NOT NULL,
	[N_tasa_interes] [decimal](5, 2) NOT NULL,
	[N_plazo_dias] [int] NOT NULL,
	[F_fecha_inicio] [date] NOT NULL,
	[F_fecha_vencimiento] [date] NOT NULL,
	[D_estado] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Deposito_Plazo] PRIMARY KEY CLUSTERED 
(
	[C_id_deposito] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Descuento_Factura] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Descuento_Factura](
	[C_id_descuento] [int] IDENTITY(1,1) NOT NULL,
	[C_id_producto] [int] NOT NULL,
	[D_numero_factura] [varchar](50) NOT NULL,
	[N_monto_factura] [decimal](18, 2) NOT NULL,
	[N_monto_descontado] [decimal](18, 2) NOT NULL,
	[N_tasa_descuento] [decimal](5, 2) NOT NULL,
	[F_fecha_emision] [date] NOT NULL,
	[F_fecha_vencimiento] [date] NOT NULL,
	[D_estado] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Descuento_Factura] PRIMARY KEY CLUSTERED 
(
	[C_id_descuento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Detalle_Archivo] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Detalle_Archivo](
	[C_id_detalle] [int] NOT NULL,
	[D_contenido] [varchar](max) NULL,
	[D_nivel_riesgo] [varchar](50) NULL,
	[N_puntaje] [int] NULL,
	[C_id_archivo] [int] NULL,
	[C_id_cliente] [int] NULL,
 CONSTRAINT [PK_Detalle_Archivo] PRIMARY KEY CLUSTERED 
(
	[C_id_detalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Detalle_Factor_Riesgo] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Detalle_Factor_Riesgo](
	[C_id_detalle] [int] NOT NULL,
	[N_puntaje] [int] NULL,
	[N_valor_obtenido] [int] NULL,
	[C_id_factor_riesgo] [int] NULL,
 CONSTRAINT [PK_Detalle_Factor_Riesgo] PRIMARY KEY CLUSTERED 
(
	[C_id_detalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Distrito] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Distrito](
	[C_id_distrito] [int] NOT NULL,
	[D_nombre] [varchar](100) NULL,
	[C_id_canton] [int] NULL,
	[N_peso_riesgo] [int] NULL,
 CONSTRAINT [PK_Distrito] PRIMARY KEY CLUSTERED 
(
	[C_id_distrito] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Entidad_Otras_Pensiones] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Entidad_Otras_Pensiones](
	[C_id_entidad] [int] NOT NULL,
	[D_identificacion] [varchar](50) NOT NULL,
	[D_descripcion] [varchar](200) NOT NULL,
	[B_estado] [bit] NOT NULL,
 CONSTRAINT [PK_Entidad_Otras_Pensiones] PRIMARY KEY CLUSTERED 
(
	[C_id_entidad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Entidad_Pensiones] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Entidad_Pensiones](
	[C_id_entidad] [int] NOT NULL,
	[D_identificacion] [varchar](50) NOT NULL,
	[D_descripcion] [varchar](200) NOT NULL,
	[B_estado] [bit] NOT NULL,
 CONSTRAINT [PK_Entidad_Pensiones] PRIMARY KEY CLUSTERED 
(
	[C_id_entidad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Estado_Civil] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Estado_Civil](
	[C_id_estado_civil] [int] NOT NULL,
	[D_descripcion] [varchar](50) NOT NULL,
	[N_peso_riesgo] [int] NULL,
 CONSTRAINT [PK_Estado_Civil] PRIMARY KEY CLUSTERED 
(
	[C_id_estado_civil] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Estado_Persona_Juridica] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Estado_Persona_Juridica](
	[C_id_estado] [int] NOT NULL,
	[D_descripcion] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Estado_Persona_Juridica] PRIMARY KEY CLUSTERED 
(
	[C_id_estado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Evaluacion_Riesgo] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Evaluacion_Riesgo](
	[C_id_evaluacion] [int] IDENTITY(1,1) NOT NULL,
	[C_id_cliente] [int] NOT NULL,
	[D_factor] [varchar](50) NULL,
	[N_valor_obtenido] [int] NULL,
	[N_puntaje] [int] NULL,
	[D_tipo_cliente] [varchar](20) NULL,
	[N_puntaje_provincia] [int] NULL,
	[N_puntaje_canton] [int] NULL,
	[N_puntaje_distrito] [int] NULL,
	[N_puntaje_profesion] [int] NULL,
	[N_puntaje_ingresos] [int] NULL,
	[N_puntaje_sociedad] [int] NULL,
	[N_puntaje_total] [int] NULL,
	[D_nivel_riesgo] [varchar](10) NULL,
	[F_fecha_evaluacion] [datetime] NULL,
 CONSTRAINT [PK_Evaluacion_Riesgo] PRIMARY KEY CLUSTERED 
(
	[C_id_evaluacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Evento_Extraordinario] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Evento_Extraordinario](
	[C_id_evento] [int] NOT NULL,
	[D_descripcion] [varchar](100) NOT NULL,
	[B_estado] [bit] NOT NULL,
 CONSTRAINT [PK_Evento_Extraordinario] PRIMARY KEY CLUSTERED 
(
	[C_id_evento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Factor_Riesgo] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Factor_Riesgo](
	[C_id_factor_riesgo] [int] NOT NULL,
	[D_nivel] [varchar](50) NULL,
	[B_estado] [bit] NULL,
	[C_id_cliente] [int] NULL,
 CONSTRAINT [PK_Factor_Riesgo] PRIMARY KEY CLUSTERED 
(
	[C_id_factor_riesgo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Fideicomiso] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Fideicomiso](
	[C_id_fideicomiso] [int] IDENTITY(1,1) NOT NULL,
	[C_id_producto] [int] NOT NULL,
	[D_tipo_fideicomiso] [varchar](50) NOT NULL,
	[D_beneficiario] [varchar](100) NOT NULL,
	[N_monto] [decimal](18, 2) NOT NULL,
	[F_fecha_inicio] [date] NOT NULL,
	[F_fecha_fin] [date] NULL,
	[D_estado] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Fideicomiso] PRIMARY KEY CLUSTERED 
(
	[C_id_fideicomiso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Ingreso] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Ingreso](
	[C_id_ingreso] [int] IDENTITY(1,1) NOT NULL,
	[C_id_cliente] [int] NOT NULL,
	[N_monto] [decimal](10, 2) NOT NULL,
	[D_fuente] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Ingreso] PRIMARY KEY CLUSTERED 
(
	[C_id_ingreso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Justificacion_Ingreso] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Justificacion_Ingreso](
	[C_id_justificacion] [int] NOT NULL,
	[D_descripcion] [varchar](100) NOT NULL,
	[B_estado] [bit] NOT NULL,
 CONSTRAINT [PK_Justificacion_Ingreso] PRIMARY KEY CLUSTERED 
(
	[C_id_justificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Linea_Credito] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Linea_Credito](
	[C_id_linea_credito] [int] IDENTITY(1,1) NOT NULL,
	[C_id_producto] [int] NOT NULL,
	[N_limite] [decimal](18, 2) NOT NULL,
	[N_saldo_utilizado] [decimal](18, 2) NOT NULL,
	[N_tasa_interes] [decimal](5, 2) NOT NULL,
	[F_fecha_apertura] [date] NOT NULL,
	[F_fecha_vencimiento] [date] NOT NULL,
	[D_estado] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Linea_Credito] PRIMARY KEY CLUSTERED 
(
	[C_id_linea_credito] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Medio_Comunicacion] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Medio_Comunicacion](
	[C_id_medio] [int] NOT NULL,
	[D_descripcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Medio_Comunicacion] PRIMARY KEY CLUSTERED 
(
	[C_id_medio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Moneda] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Moneda](
	[C_id_moneda] [int] NOT NULL,
	[C_codigo] [varchar](10) NULL,
	[D_nombre] [varchar](50) NULL,
	[D_simbolo] [varchar](10) NULL,
 CONSTRAINT [PK_Moneda] PRIMARY KEY CLUSTERED 
(
	[C_id_moneda] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Pais] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Pais](
	[C_id_pais] [int] NOT NULL,
	[D_codigo_alfa2] [varchar](2) NOT NULL,
	[D_descripcion] [varchar](100) NOT NULL,
	[D_codigo_area] [varchar](10) NULL,
	[B_estado] [bit] NOT NULL,
	[N_peso_riesgo] [int] NULL,
 CONSTRAINT [PK_Pais] PRIMARY KEY CLUSTERED 
(
	[C_id_pais] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Permiso] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Permiso](
	[C_id_permiso] [int] NOT NULL,
	[D_nombre_permiso] [varchar](50) NULL,
	[D_descripcion] [varchar](100) NULL,
 CONSTRAINT [PK_Permiso] PRIMARY KEY CLUSTERED 
(
	[C_id_permiso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Prestamo] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Prestamo](
	[C_id_prestamo] [int] IDENTITY(1,1) NOT NULL,
	[N_tasa_interes] [decimal](5, 2) NULL,
	[N_plazo_meses] [int] NULL,
	[M_monto_otorgado] [decimal](18, 2) NULL,
	[M_saldo_pendiente] [decimal](18, 2) NULL,
	[M_cuota_mensual] [decimal](18, 2) NULL,
	[F_fecha_inicio] [datetime] NULL,
	[F_fecha_fin] [datetime] NULL,
	[B_estado] [bit] NULL,
	[C_id_producto] [int] NULL,
 CONSTRAINT [PK_Prestamo] PRIMARY KEY CLUSTERED 
(
	[C_id_prestamo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Producto] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Producto](
	[C_id_producto] [int] IDENTITY(1,1) NOT NULL,
	[D_nombre] [varchar](100) NULL,
	[M_monto] [decimal](18, 2) NULL,
	[F_fecha_apertura] [datetime] NULL,
	[B_activo] [bit] NULL,
	[C_id_tipo_producto] [int] NULL,
	[C_id_cliente] [int] NULL,
 CONSTRAINT [PK_Producto] PRIMARY KEY CLUSTERED 
(
	[C_id_producto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Profesion] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Profesion](
	[C_id_profesion] [int] NOT NULL,
	[D_nombre] [varchar](100) NULL,
	[N_peso_riesgo] [int] NULL,
 CONSTRAINT [PK_Profesion] PRIMARY KEY CLUSTERED 
(
	[C_id_profesion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Provincia] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Provincia](
	[C_id_provincia] [int] NOT NULL,
	[D_nombre] [varchar](100) NULL,
	[N_peso_riesgo] [int] NULL,
 CONSTRAINT [PK_Provincia] PRIMARY KEY CLUSTERED 
(
	[C_id_provincia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Remesa] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Remesa](
	[C_id_remesa] [int] IDENTITY(1,1) NOT NULL,
	[C_id_producto] [int] NOT NULL,
	[D_pais_origen] [varchar](100) NOT NULL,
	[D_pais_destino] [varchar](100) NOT NULL,
	[N_monto] [decimal](18, 2) NOT NULL,
	[D_moneda] [varchar](10) NOT NULL,
	[N_tipo_cambio] [decimal](10, 4) NOT NULL,
	[F_fecha] [date] NOT NULL,
	[D_estado] [varchar](20) NOT NULL,
	[C_id_transaccion] [int] NULL,
 CONSTRAINT [PK_Remesa] PRIMARY KEY CLUSTERED 
(
	[C_id_remesa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Rol] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Rol](
	[C_id_rol] [int] NOT NULL,
	[D_nombre] [varchar](50) NULL,
	[D_descripcion] [varchar](100) NULL,
 CONSTRAINT [PK_Rol] PRIMARY KEY CLUSTERED 
(
	[C_id_rol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Sociedad_Anonima] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Sociedad_Anonima](
	[C_id_sociedad] [int] IDENTITY(1,1) NOT NULL,
	[C_id_cliente] [int] NOT NULL,
	[D_nombre] [varchar](100) NOT NULL,
	[D_tipo] [varchar](50) NOT NULL,
	[C_id_nivel_factor_riesgo] [int] NOT NULL,
 CONSTRAINT [PK_Sociedad_Anonima] PRIMARY KEY CLUSTERED 
(
	[C_id_sociedad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Tarjeta_Credito] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Tarjeta_Credito](
	[C_id_tarjeta] [int] IDENTITY(1,1) NOT NULL,
	[D_numero_tarjeta] [varchar](50) NULL,
	[M_limite_credito] [decimal](18, 2) NULL,
	[M_saldo_utilizado] [decimal](18, 2) NULL,
	[F_fecha_corte] [datetime] NULL,
	[F_fecha_pago] [datetime] NULL,
	[B_estado] [bit] NULL,
	[C_id_producto] [int] NULL,
 CONSTRAINT [PK_Tarjeta_Credito] PRIMARY KEY CLUSTERED 
(
	[C_id_tarjeta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Tarjeta_Debito] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

GO

GO
CREATE TABLE [dbo].[Tarjeta_Debito](
	[C_id_tarjeta_debito] [int] IDENTITY(1,1) NOT NULL,
	[D_numero_tarjeta] [varchar](50) NULL,
	[N_limite] [int] NULL,
	[D_codigo_seguridad] [varchar](10) NULL,
	[B_estado] [bit] NULL,
	[F_fecha_vencimiento] [datetime] NULL,
	[C_id_cuenta] [int] NULL,
 CONSTRAINT [PK_Tarjeta_Debito] PRIMARY KEY CLUSTERED 
(
	[C_id_tarjeta_debito] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Tipo_Identificacion] Fecha de script: 29/5/2026 5:31:57 p. m. ******/
CREATE TABLE [dbo].[Tipo_Identificacion](
	[C_id_tipo_identificacion] [int] NOT NULL,
	[D_descripcion] [varchar](100) NOT NULL,
	[B_estado] [bit] NOT NULL,
	[C_id_tipo_persona] [int] NOT NULL,
	[D_formato] [varchar](20) NULL,
	[D_expresion_regular] [varchar](100) NULL,
	[N_longitud] [int] NULL,
 CONSTRAINT [PK_Tipo_Identificacion] PRIMARY KEY CLUSTERED 
(
	[C_id_tipo_identificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Tipo_Ingreso] Fecha de script: 29/5/2026 5:31:57 p. m. ******/
CREATE TABLE [dbo].[Tipo_Ingreso](
	[C_id_tipo_ingreso] [int] NOT NULL,
	[D_descripcion] [varchar](100) NOT NULL,
	[B_estado] [bit] NOT NULL,
 CONSTRAINT [PK_Tipo_Ingreso] PRIMARY KEY CLUSTERED 
(
	[C_id_tipo_ingreso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Objeto: Table [dbo].[Tipo_Persona] Fecha de script: 29/5/2026 5:31:57 p. m. ******/
CREATE TABLE [dbo].[Tipo_Persona](
	[C_id_tipo_persona] [int] NOT NULL,
	[D_descripcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Tipo_Persona] PRIMARY KEY CLUSTERED 
(
	[C_id_tipo_persona] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Tipo_Producto] Fecha de script: 29/5/2026 5:31:57 p. m. ******/
CREATE TABLE [dbo].[Tipo_Producto](
	[C_id_tipo_producto] [int] NOT NULL,
	[D_nombre] [varchar](100) NULL,
 CONSTRAINT [PK_Tipo_Producto] PRIMARY KEY CLUSTERED 
(
	[C_id_tipo_producto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Tipo_Regimen] Fecha de script: 29/5/2026 5:31:57 p. m. ******/
CREATE TABLE [dbo].[Tipo_Regimen](
	[C_id_tipo_regimen] [int] NOT NULL,
	[D_descripcion] [varchar](150) NOT NULL,
	[B_estado] [bit] NOT NULL,
 CONSTRAINT [PK_Tipo_Regimen] PRIMARY KEY CLUSTERED 
(
	[C_id_tipo_regimen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Tipo_Relacion] Fecha de script: 29/5/2026 5:31:57 p. m. ******/
CREATE TABLE [dbo].[Tipo_Relacion](
	[C_id_tipo_relacion] [int] NOT NULL,
	[D_descripcion] [varchar](100) NOT NULL,
	[B_estado] [bit] NOT NULL,
 CONSTRAINT [PK_Tipo_Relacion] PRIMARY KEY CLUSTERED 
(
	[C_id_tipo_relacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Tipo_Transaccion] Fecha de script: 29/5/2026 5:31:57 p. m. ******/
CREATE TABLE [dbo].[Tipo_Transaccion](
	[C_id_tipo_transaccion] [int] NOT NULL,
	[D_descripcion] [varchar](50) NULL,
 CONSTRAINT [PK_Tipo_Transaccion] PRIMARY KEY CLUSTERED 
(
	[C_id_tipo_transaccion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[TMP_DISTELEC] Fecha de script: 29/5/2026 5:31:57 p. m. ******/
CREATE TABLE [dbo].[TMP_DISTELEC](
	[Codelec] [varchar](10) NULL,
	[Provincia] [varchar](50) NULL,
	[Canton] [varchar](50) NULL,
	[Distrito] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[TMP_PADRON] Fecha de script: 29/5/2026 5:31:57 p. m. ******/
CREATE TABLE [dbo].[TMP_PADRON](
	[Cedula] [varchar](20) NULL,
	[Codelec] [varchar](10) NULL,
	[Relleno] [varchar](10) NULL,
	[FechaCaducidad] [varchar](15) NULL,
	[Junta] [varchar](15) NULL,
	[Nombre] [varchar](100) NULL,
	[PrimerApellido] [varchar](100) NULL,
	[SegundoApellido] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Transaccion] Fecha de script: 29/5/2026 5:31:57 p. m. ******/
CREATE TABLE [dbo].[Transaccion](
	[C_id_transaccion] [int] IDENTITY(1,1) NOT NULL,
	[M_monto] [decimal](18, 2) NULL,
	[D_tipo] [varchar](50) NULL,
	[F_fecha] [datetime] NULL,
	[B_estado] [bit] NULL,
	[C_id_producto] [int] NULL,
	[C_id_moneda] [int] NULL,
 CONSTRAINT [PK_Transaccion] PRIMARY KEY CLUSTERED 
(
	[C_id_transaccion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Transferencia] Fecha de script: 29/5/2026 5:31:57 p. m. ******/
CREATE TABLE [dbo].[Transferencia](
	[C_id_transferencia] [int] IDENTITY(1,1) NOT NULL,
	[C_id_producto] [int] NOT NULL,
	[D_cuenta_origen] [varchar](30) NOT NULL,
	[D_cuenta_destino] [varchar](30) NOT NULL,
	[N_monto] [decimal](18, 2) NOT NULL,
	[D_tipo] [varchar](50) NOT NULL,
	[F_fecha] [date] NOT NULL,
	[D_estado] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Transferencia] PRIMARY KEY CLUSTERED 
(
	[C_id_transferencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Ubicacion] Fecha de script: 29/5/2026 5:31:57 p. m. ******/
CREATE TABLE [dbo].[Ubicacion](
	[C_id_ubicacion] [int] NOT NULL,
	[C_id_provincia] [int] NOT NULL,
	[C_id_canton] [int] NOT NULL,
	[C_id_distrito] [int] NOT NULL,
	[N_tipo_ubicacion] [int] NULL,
 CONSTRAINT [PK_Ubicacion] PRIMARY KEY CLUSTERED 
(
	[C_id_ubicacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Usuario] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

CREATE TABLE [dbo].[Usuario](
	[C_id_usuario] [int] NOT NULL,
	[D_usuario] [varchar](50) NULL,
	[D_contrasena] [varchar](100) NULL,
	[B_estado] [bit] NULL,
	[C_id_rol] [int] NULL,
 CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED 
(
	[C_id_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Usuario_Permiso] Fecha de script: 29/5/2026 5:31:57 p. m. ******/

CREATE TABLE [dbo].[Usuario_Permiso](
	[C_id_usuario] [int] NOT NULL,
	[C_id_permiso] [int] NOT NULL,
 CONSTRAINT [PK_Usuario_Permiso] PRIMARY KEY CLUSTERED 
(
	[C_id_usuario] ASC,
	[C_id_permiso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



ALTER TABLE [dbo].[Evaluacion_Riesgo] ADD  DEFAULT (getdate()) FOR [F_fecha_evaluacion]
GO
ALTER TABLE [dbo].[Arrendamiento_Financiero]  WITH CHECK ADD  CONSTRAINT [FK_Arrendamiento_Financiero_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Arrendamiento_Financiero] CHECK CONSTRAINT [FK_Arrendamiento_Financiero_Producto]
GO
ALTER TABLE [dbo].[Aval_Garantia]  WITH CHECK ADD  CONSTRAINT [FK_Aval_Garantia_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Aval_Garantia] CHECK CONSTRAINT [FK_Aval_Garantia_Producto]
GO
ALTER TABLE [dbo].[Banca_Linea]  WITH CHECK ADD  CONSTRAINT [FK_Banca_Linea_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Banca_Linea] CHECK CONSTRAINT [FK_Banca_Linea_Producto]
GO
ALTER TABLE [dbo].[Caja_Seguridad]  WITH CHECK ADD  CONSTRAINT [FK_Caja_Seguridad_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Caja_Seguridad] CHECK CONSTRAINT [FK_Caja_Seguridad_Producto]
GO
ALTER TABLE [dbo].[Cajero_Automatico]  WITH CHECK ADD  CONSTRAINT [FK_Cajero_Automatico_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Cajero_Automatico] CHECK CONSTRAINT [FK_Cajero_Automatico_Producto]
GO
ALTER TABLE [dbo].[Canton]  WITH CHECK ADD  CONSTRAINT [FK_Canton_Provincia] FOREIGN KEY([C_id_provincia])
REFERENCES [dbo].[Provincia] ([C_id_provincia])
GO
ALTER TABLE [dbo].[Canton] CHECK CONSTRAINT [FK_Canton_Provincia]
GO
ALTER TABLE [dbo].[Cliente]  WITH CHECK ADD  CONSTRAINT [FK_Cliente_Actividad_Economica] FOREIGN KEY([C_id_actividad_economica])
REFERENCES [dbo].[Actividad_Economica] ([C_id_actividad])
GO
ALTER TABLE [dbo].[Cliente] CHECK CONSTRAINT [FK_Cliente_Actividad_Economica]
GO
ALTER TABLE [dbo].[Cliente]  WITH CHECK ADD  CONSTRAINT [FK_Cliente_Profesion] FOREIGN KEY([C_id_profesion])
REFERENCES [dbo].[Profesion] ([C_id_profesion])
GO
ALTER TABLE [dbo].[Cliente] CHECK CONSTRAINT [FK_Cliente_Profesion]
GO
ALTER TABLE [dbo].[Cliente]  WITH CHECK ADD  CONSTRAINT [FK_Cliente_Tipo_Persona] FOREIGN KEY([C_id_tipo_persona])
REFERENCES [dbo].[Tipo_Persona] ([C_id_tipo_persona])
GO
ALTER TABLE [dbo].[Cliente] CHECK CONSTRAINT [FK_Cliente_Tipo_Persona]
GO
ALTER TABLE [dbo].[Cliente]  WITH CHECK ADD  CONSTRAINT [FK_Cliente_Estado_Civil] FOREIGN KEY([C_id_estado_civil])
REFERENCES [dbo].[Estado_Civil] ([C_id_estado_civil])
GO
ALTER TABLE [dbo].[Cliente] CHECK CONSTRAINT [FK_Cliente_Estado_Civil]
GO
ALTER TABLE [dbo].[Cliente]  WITH CHECK ADD  CONSTRAINT [FK_Cliente_Pais] FOREIGN KEY([C_id_pais])
REFERENCES [dbo].[Pais] ([C_id_pais])
GO
ALTER TABLE [dbo].[Cliente] CHECK CONSTRAINT [FK_Cliente_Pais]
GO
ALTER TABLE [dbo].[Cliente]  WITH CHECK ADD  CONSTRAINT [FK_Cliente_Distrito] FOREIGN KEY([C_id_distrito])
REFERENCES [dbo].[Distrito] ([C_id_distrito])
GO
ALTER TABLE [dbo].[Cliente] CHECK CONSTRAINT [FK_Cliente_Distrito]
GO
ALTER TABLE [dbo].[Cliente_Producto]  WITH CHECK ADD  CONSTRAINT [FK_CP_Cliente] FOREIGN KEY([C_id_cliente])
REFERENCES [dbo].[Cliente] ([C_id_cliente])
GO
ALTER TABLE [dbo].[Cliente_Producto] CHECK CONSTRAINT [FK_CP_Cliente]
GO
ALTER TABLE [dbo].[Cliente_Producto]  WITH CHECK ADD  CONSTRAINT [FK_CP_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Cliente_Producto] CHECK CONSTRAINT [FK_CP_Producto]
GO
ALTER TABLE [dbo].[Compraventa_Divisa]  WITH CHECK ADD  CONSTRAINT [FK_Compraventa_Divisa_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Compraventa_Divisa] CHECK CONSTRAINT [FK_Compraventa_Divisa_Producto]
GO
ALTER TABLE [dbo].[Cuenta_Bancaria]  WITH CHECK ADD  CONSTRAINT [FK_Cuenta_Bancaria_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Cuenta_Bancaria] CHECK CONSTRAINT [FK_Cuenta_Bancaria_Producto]
GO
ALTER TABLE [dbo].[Cuenta_Bancaria]  WITH CHECK ADD  CONSTRAINT [FK_Cuenta_Bancaria_Moneda] FOREIGN KEY([N_moneda])
REFERENCES [dbo].[Moneda] ([C_id_moneda])
GO
ALTER TABLE [dbo].[Cuenta_Bancaria] CHECK CONSTRAINT [FK_Cuenta_Bancaria_Moneda]
GO
ALTER TABLE [dbo].[Cuenta_Expediente_Simplificado]  WITH CHECK ADD  CONSTRAINT [FK_Cuenta_Expediente_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Cuenta_Expediente_Simplificado] CHECK CONSTRAINT [FK_Cuenta_Expediente_Producto]
GO
ALTER TABLE [dbo].[Cuenta_Planilla]  WITH CHECK ADD  CONSTRAINT [FK_Cuenta_Planilla_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Cuenta_Planilla] CHECK CONSTRAINT [FK_Cuenta_Planilla_Producto]
GO
ALTER TABLE [dbo].[Cuenta_Vista]  WITH CHECK ADD  CONSTRAINT [FK_Cuenta_Vista_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Cuenta_Vista] CHECK CONSTRAINT [FK_Cuenta_Vista_Producto]
GO
ALTER TABLE [dbo].[Cuenta_Vista]  WITH CHECK ADD  CONSTRAINT [FK_CuentaVista_Cliente] FOREIGN KEY([C_id_cliente])
REFERENCES [dbo].[Cliente] ([C_id_cliente])
GO
ALTER TABLE [dbo].[Cuenta_Vista] CHECK CONSTRAINT [FK_CuentaVista_Cliente]
GO

ALTER TABLE [dbo].[Deposito_Judicial]  WITH CHECK ADD  CONSTRAINT [FK_Deposito_Judicial_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Deposito_Judicial] CHECK CONSTRAINT [FK_Deposito_Judicial_Producto]
GO
ALTER TABLE [dbo].[Deposito_Plazo]  WITH CHECK ADD  CONSTRAINT [FK_Deposito_Plazo_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Deposito_Plazo] CHECK CONSTRAINT [FK_Deposito_Plazo_Producto]
GO

ALTER TABLE [dbo].[Descuento_Factura]  WITH CHECK ADD  CONSTRAINT [FK_Descuento_Factura_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Descuento_Factura] CHECK CONSTRAINT [FK_Descuento_Factura_Producto]
GO
ALTER TABLE [dbo].[Detalle_Archivo]  WITH CHECK ADD  CONSTRAINT [FK_Detalle_Archivo_Archivo] FOREIGN KEY([C_id_archivo])
REFERENCES [dbo].[Archivo] ([C_id_archivo])
GO
ALTER TABLE [dbo].[Detalle_Archivo] CHECK CONSTRAINT [FK_Detalle_Archivo_Archivo]
GO
ALTER TABLE [dbo].[Detalle_Archivo]  WITH CHECK ADD  CONSTRAINT [FK_Detalle_Archivo_Cliente] FOREIGN KEY([C_id_cliente])
REFERENCES [dbo].[Cliente] ([C_id_cliente])
GO
ALTER TABLE [dbo].[Detalle_Archivo] CHECK CONSTRAINT [FK_Detalle_Archivo_Cliente]
GO

ALTER TABLE [dbo].[Detalle_Factor_Riesgo]  WITH CHECK ADD  CONSTRAINT [FK_Detalle_Factor_Riesgo_Factor_Riesgo] FOREIGN KEY([C_id_factor_riesgo])
REFERENCES [dbo].[Factor_Riesgo] ([C_id_factor_riesgo])
GO
ALTER TABLE [dbo].[Detalle_Factor_Riesgo] CHECK CONSTRAINT [FK_Detalle_Factor_Riesgo_Factor_Riesgo]
GO
ALTER TABLE [dbo].[Distrito]  WITH CHECK ADD  CONSTRAINT [FK_Distrito_Canton] FOREIGN KEY([C_id_canton])
REFERENCES [dbo].[Canton] ([C_id_canton])
GO
ALTER TABLE [dbo].[Distrito] CHECK CONSTRAINT [FK_Distrito_Canton]
GO
ALTER TABLE [dbo].[Evaluacion_Riesgo]  WITH CHECK ADD  CONSTRAINT [FK_Evaluacion_Riesgo_Cliente] FOREIGN KEY([C_id_cliente])
REFERENCES [dbo].[Cliente] ([C_id_cliente])
GO
ALTER TABLE [dbo].[Evaluacion_Riesgo] CHECK CONSTRAINT [FK_Evaluacion_Riesgo_Cliente]
GO
ALTER TABLE [dbo].[Factor_Riesgo]  WITH CHECK ADD  CONSTRAINT [FK_Factor_Riesgo_Cliente] FOREIGN KEY([C_id_cliente])
REFERENCES [dbo].[Cliente] ([C_id_cliente])
GO
ALTER TABLE [dbo].[Factor_Riesgo] CHECK CONSTRAINT [FK_Factor_Riesgo_Cliente]
GO
ALTER TABLE [dbo].[Fideicomiso]  WITH CHECK ADD  CONSTRAINT [FK_Fideicomiso_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Fideicomiso] CHECK CONSTRAINT [FK_Fideicomiso_Producto]
GO
ALTER TABLE [dbo].[Ingreso]  WITH CHECK ADD  CONSTRAINT [FK_Ingreso_Cliente] FOREIGN KEY([C_id_cliente])
REFERENCES [dbo].[Cliente] ([C_id_cliente])
GO
ALTER TABLE [dbo].[Ingreso] CHECK CONSTRAINT [FK_Ingreso_Cliente]
GO
ALTER TABLE [dbo].[Linea_Credito]  WITH CHECK ADD  CONSTRAINT [FK_Linea_Credito_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Linea_Credito] CHECK CONSTRAINT [FK_Linea_Credito_Producto]
GO

ALTER TABLE [dbo].[Prestamo]  WITH CHECK ADD  CONSTRAINT [FK_Prestamo_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Prestamo] CHECK CONSTRAINT [FK_Prestamo_Producto]
GO
ALTER TABLE [dbo].[Producto]  WITH CHECK ADD  CONSTRAINT [FK_Producto_Tipo_Producto] FOREIGN KEY([C_id_tipo_producto])
REFERENCES [dbo].[Tipo_Producto] ([C_id_tipo_producto])
GO
ALTER TABLE [dbo].[Producto] CHECK CONSTRAINT [FK_Producto_Tipo_Producto]
GO
ALTER TABLE [dbo].[Producto]  WITH CHECK ADD  CONSTRAINT [FK_Producto_Cliente] FOREIGN KEY([C_id_cliente])
REFERENCES [dbo].[Cliente] ([C_id_cliente])
GO
ALTER TABLE [dbo].[Producto] CHECK CONSTRAINT [FK_Producto_Cliente]
GO
ALTER TABLE [dbo].[Remesa]  WITH CHECK ADD  CONSTRAINT [FK_Remesa_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Remesa] CHECK CONSTRAINT [FK_Remesa_Producto]
GO
ALTER TABLE [dbo].[Remesa]  WITH CHECK ADD  CONSTRAINT [FK_Remesa_Transaccion] FOREIGN KEY([C_id_transaccion])
REFERENCES [dbo].[Transaccion] ([C_id_transaccion])
GO
ALTER TABLE [dbo].[Remesa] CHECK CONSTRAINT [FK_Remesa_Transaccion]
GO
ALTER TABLE [dbo].[Sociedad_Anonima]  WITH CHECK ADD  CONSTRAINT [FK_Sociedad_Anonima_Cliente] FOREIGN KEY([C_id_cliente])
REFERENCES [dbo].[Cliente] ([C_id_cliente])
GO
ALTER TABLE [dbo].[Sociedad_Anonima] CHECK CONSTRAINT [FK_Sociedad_Anonima_Cliente]
GO
ALTER TABLE [dbo].[Sociedad_Anonima]  WITH CHECK ADD  CONSTRAINT [FK_Sociedad_Anonima_Factor_Riesgo] FOREIGN KEY([C_id_nivel_factor_riesgo])
REFERENCES [dbo].[Factor_Riesgo] ([C_id_factor_riesgo])
GO
ALTER TABLE [dbo].[Sociedad_Anonima] CHECK CONSTRAINT [FK_Sociedad_Anonima_Factor_Riesgo]
GO
ALTER TABLE [dbo].[Tarjeta_Credito]  WITH CHECK ADD  CONSTRAINT [FK_Tarjeta_Credito_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Tarjeta_Credito] CHECK CONSTRAINT [FK_Tarjeta_Credito_Producto]
GO
ALTER TABLE [dbo].[Tarjeta_Debito]  WITH CHECK ADD  CONSTRAINT [FK_Tarjeta_Debito_Cuenta_Bancaria] FOREIGN KEY([C_id_cuenta])
REFERENCES [dbo].[Cuenta_Bancaria] ([C_id_cuenta])
GO
ALTER TABLE [dbo].[Tarjeta_Debito] CHECK CONSTRAINT [FK_Tarjeta_Debito_Cuenta_Bancaria]
GO
ALTER TABLE [dbo].[Transaccion]  WITH CHECK ADD  CONSTRAINT [FK_Transaccion_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Transaccion] CHECK CONSTRAINT [FK_Transaccion_Producto]
GO
ALTER TABLE [dbo].[Transaccion]  WITH CHECK ADD  CONSTRAINT [FK_Transaccion_Moneda] FOREIGN KEY([C_id_moneda])
REFERENCES [dbo].[Moneda] ([C_id_moneda])
GO
ALTER TABLE [dbo].[Transaccion] CHECK CONSTRAINT [FK_Transaccion_Moneda]
GO
ALTER TABLE [dbo].[Transferencia]  WITH CHECK ADD  CONSTRAINT [FK_Transferencia_Producto] FOREIGN KEY([C_id_producto])
REFERENCES [dbo].[Producto] ([C_id_producto])
GO
ALTER TABLE [dbo].[Transferencia] CHECK CONSTRAINT [FK_Transferencia_Producto]
GO
ALTER TABLE [dbo].[Tipo_Identificacion]  WITH CHECK ADD  CONSTRAINT [FK_Tipo_Identificacion_Tipo_Persona] FOREIGN KEY([C_id_tipo_persona])
REFERENCES [dbo].[Tipo_Persona] ([C_id_tipo_persona])
GO
ALTER TABLE [dbo].[Tipo_Identificacion] CHECK CONSTRAINT [FK_Tipo_Identificacion_Tipo_Persona]
GO
ALTER TABLE [dbo].[Ubicacion]  WITH CHECK ADD  CONSTRAINT [FK_Ubicacion_Canton] FOREIGN KEY([C_id_canton])
REFERENCES [dbo].[Canton] ([C_id_canton])
GO
ALTER TABLE [dbo].[Ubicacion] CHECK CONSTRAINT [FK_Ubicacion_Canton]
GO
ALTER TABLE [dbo].[Ubicacion]  WITH CHECK ADD  CONSTRAINT [FK_Ubicacion_Distrito] FOREIGN KEY([C_id_distrito])
REFERENCES [dbo].[Distrito] ([C_id_distrito])
GO
ALTER TABLE [dbo].[Ubicacion] CHECK CONSTRAINT [FK_Ubicacion_Distrito]
GO
ALTER TABLE [dbo].[Ubicacion]  WITH CHECK ADD  CONSTRAINT [FK_Ubicacion_Provincia] FOREIGN KEY([C_id_provincia])
REFERENCES [dbo].[Provincia] ([C_id_provincia])
GO
ALTER TABLE [dbo].[Ubicacion] CHECK CONSTRAINT [FK_Ubicacion_Provincia]
GO
ALTER TABLE [dbo].[Usuario]  WITH CHECK ADD  CONSTRAINT [FK_Usuario_Rol] FOREIGN KEY([C_id_rol])
REFERENCES [dbo].[Rol] ([C_id_rol])
GO
ALTER TABLE [dbo].[Usuario] CHECK CONSTRAINT [FK_Usuario_Rol]
GO
ALTER TABLE [dbo].[Usuario_Permiso]  WITH CHECK ADD  CONSTRAINT [FK_Usuario_Permiso_Permiso] FOREIGN KEY([C_id_permiso])
REFERENCES [dbo].[Permiso] ([C_id_permiso])
GO
ALTER TABLE [dbo].[Usuario_Permiso] CHECK CONSTRAINT [FK_Usuario_Permiso_Permiso]
GO
ALTER TABLE [dbo].[Usuario_Permiso]  WITH CHECK ADD  CONSTRAINT [FK_Usuario_Permiso_Usuario] FOREIGN KEY([C_id_usuario])
REFERENCES [dbo].[Usuario] ([C_id_usuario])
GO
ALTER TABLE [dbo].[Usuario_Permiso] CHECK CONSTRAINT [FK_Usuario_Permiso_Usuario]
GO
