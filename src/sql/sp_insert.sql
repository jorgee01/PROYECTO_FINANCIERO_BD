USE Grupo1_BancoUCR;
GO

-- Cliente
CREATE OR ALTER PROCEDURE SP_InsertarCliente
    @D_nombre VARCHAR(100), @D_apellido VARCHAR(100), @D_correo VARCHAR(100),
    @N_ingresos INT, @B_activo BIT, @C_id_distrito INT = NULL,
    @C_id_profesion INT = NULL, @C_id_actividad_economica INT = NULL,
    @C_id_tipo_persona INT = NULL, @C_id_estado_civil INT = NULL, @C_id_pais INT = NULL,
    @D_identificacion VARCHAR(20) = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Cliente (D_nombre, D_apellido, D_correo, N_ingresos, B_activo,
            F_fecha_registro, C_id_distrito, C_id_profesion, C_id_actividad_economica,
            C_id_tipo_persona, C_id_estado_civil, C_id_pais, D_identificacion)
        VALUES (@D_nombre, @D_apellido, @D_correo, @N_ingresos, @B_activo,
            GETDATE(), @C_id_distrito, @C_id_profesion, @C_id_actividad_economica,
            @C_id_tipo_persona, @C_id_estado_civil, @C_id_pais, @D_identificacion);
        SELECT SCOPE_IDENTITY() AS C_id_cliente;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Producto
CREATE OR ALTER PROCEDURE SP_InsertarProducto
    @D_nombre VARCHAR(100), @M_monto DECIMAL(18,2) = NULL,
    @C_id_tipo_producto INT = NULL, @C_id_cliente INT = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Producto (D_nombre, M_monto, F_fecha_apertura, B_activo, C_id_tipo_producto, C_id_cliente)
        VALUES (@D_nombre, @M_monto, GETDATE(), 1, @C_id_tipo_producto, @C_id_cliente);
        SELECT SCOPE_IDENTITY() AS C_id_producto;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Cliente_Producto
CREATE OR ALTER PROCEDURE SP_InsertarClienteProducto
    @C_id_cliente INT, @C_id_producto INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Cliente_Producto (C_id_cliente, C_id_producto)
        VALUES (@C_id_cliente, @C_id_producto);
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Transaccion
CREATE OR ALTER PROCEDURE SP_InsertarTransaccion
    @M_monto DECIMAL(18,2) = NULL, @D_tipo VARCHAR(50) = NULL,
    @C_id_producto INT = NULL, @C_id_moneda INT = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Transaccion (M_monto, D_tipo, F_fecha, B_estado, C_id_producto, C_id_moneda)
        VALUES (@M_monto, @D_tipo, GETDATE(), 1, @C_id_producto, @C_id_moneda);
        SELECT SCOPE_IDENTITY() AS C_id_transaccion;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Transferencia
CREATE OR ALTER PROCEDURE SP_InsertarTransferencia
    @C_id_producto INT, @D_cuenta_origen VARCHAR(30), @D_cuenta_destino VARCHAR(30),
    @N_monto DECIMAL(18,2), @D_tipo VARCHAR(50), @D_estado VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Transferencia (C_id_producto, D_cuenta_origen, D_cuenta_destino, N_monto, D_tipo, F_fecha, D_estado)
        VALUES (@C_id_producto, @D_cuenta_origen, @D_cuenta_destino, @N_monto, @D_tipo, GETDATE(), @D_estado);
        SELECT SCOPE_IDENTITY() AS C_id_transferencia;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Cuenta_Vista
CREATE OR ALTER PROCEDURE SP_InsertarCuentaVista
    @C_id_producto INT, @D_numero_cuenta VARCHAR(30), @N_saldo DECIMAL(18,2),
    @N_saldo_disponible DECIMAL(18,2), @D_estado VARCHAR(20), @C_id_cliente INT = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Cuenta_Vista (C_id_producto, D_numero_cuenta, N_saldo, N_saldo_disponible, F_fecha_apertura, D_estado, C_id_cliente)
        VALUES (@C_id_producto, @D_numero_cuenta, @N_saldo, @N_saldo_disponible, GETDATE(), @D_estado, @C_id_cliente);
        SELECT SCOPE_IDENTITY() AS C_id_cuenta_vista;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Cuenta_Planilla
CREATE OR ALTER PROCEDURE SP_InsertarCuentaPlanilla
    @C_id_producto INT, @D_numero_cuenta VARCHAR(30), @N_saldo DECIMAL(18,2),
    @D_empleador VARCHAR(100), @N_salario DECIMAL(18,2), @D_estado VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Cuenta_Planilla (C_id_producto, D_numero_cuenta, N_saldo, D_empleador, N_salario, F_fecha_apertura, D_estado)
        VALUES (@C_id_producto, @D_numero_cuenta, @N_saldo, @D_empleador, @N_salario, GETDATE(), @D_estado);
        SELECT SCOPE_IDENTITY() AS C_id_cuenta_planilla;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Cuenta_Expediente_Simplificado
CREATE OR ALTER PROCEDURE SP_InsertarCuentaExpSimplificado
    @C_id_producto INT, @D_numero_cuenta VARCHAR(30), @N_saldo DECIMAL(18,2),
    @N_limite_mensual DECIMAL(18,2), @D_estado VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Cuenta_Expediente_Simplificado (C_id_producto, D_numero_cuenta, N_saldo, N_limite_mensual, F_fecha_apertura, D_estado)
        VALUES (@C_id_producto, @D_numero_cuenta, @N_saldo, @N_limite_mensual, GETDATE(), @D_estado);
        SELECT SCOPE_IDENTITY() AS C_id_cuenta_expediente;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Prestamo
CREATE OR ALTER PROCEDURE SP_InsertarPrestamo
    @C_id_producto INT = NULL, @N_tasa_interes DECIMAL(5,2) = NULL,
    @N_plazo_meses INT = NULL, @M_monto_otorgado DECIMAL(18,2) = NULL,
    @M_saldo_pendiente DECIMAL(18,2) = NULL, @M_cuota_mensual DECIMAL(18,2) = NULL,
    @F_fecha_inicio DATETIME = NULL, @F_fecha_fin DATETIME = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Prestamo (C_id_producto, N_tasa_interes, N_plazo_meses, M_monto_otorgado,
            M_saldo_pendiente, M_cuota_mensual, F_fecha_inicio, F_fecha_fin, B_estado)
        VALUES (@C_id_producto, @N_tasa_interes, @N_plazo_meses, @M_monto_otorgado,
            @M_saldo_pendiente, @M_cuota_mensual, @F_fecha_inicio, @F_fecha_fin, 1);
        SELECT SCOPE_IDENTITY() AS C_id_prestamo;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Linea_Credito
CREATE OR ALTER PROCEDURE SP_InsertarLineaCredito
    @C_id_producto INT, @N_limite DECIMAL(18,2), @N_saldo_utilizado DECIMAL(18,2),
    @N_tasa_interes DECIMAL(5,2), @F_fecha_vencimiento DATE, @D_estado VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Linea_Credito (C_id_producto, N_limite, N_saldo_utilizado, N_tasa_interes, F_fecha_apertura, F_fecha_vencimiento, D_estado)
        VALUES (@C_id_producto, @N_limite, @N_saldo_utilizado, @N_tasa_interes, GETDATE(), @F_fecha_vencimiento, @D_estado);
        SELECT SCOPE_IDENTITY() AS C_id_linea_credito;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Tarjeta_Credito
CREATE OR ALTER PROCEDURE SP_InsertarTarjetaCredito
    @C_id_producto INT = NULL, @D_numero_tarjeta VARCHAR(50) = NULL,
    @M_limite_credito DECIMAL(18,2) = NULL, @M_saldo_utilizado DECIMAL(18,2) = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Tarjeta_Credito (C_id_producto, D_numero_tarjeta, M_limite_credito, M_saldo_utilizado, F_fecha_corte, F_fecha_pago, B_estado)
        VALUES (@C_id_producto, @D_numero_tarjeta, @M_limite_credito, @M_saldo_utilizado, GETDATE(), GETDATE(), 1);
        SELECT SCOPE_IDENTITY() AS C_id_tarjeta;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Tarjeta_Debito
CREATE OR ALTER PROCEDURE SP_InsertarTarjetaDebito
    @D_numero_tarjeta VARCHAR(50) = NULL, @N_limite INT = NULL,
    @D_codigo_seguridad VARCHAR(10) = NULL, @C_id_cuenta INT = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Tarjeta_Debito (D_numero_tarjeta, N_limite, D_codigo_seguridad, B_estado, F_fecha_vencimiento, C_id_cuenta)
        VALUES (@D_numero_tarjeta, @N_limite, @D_codigo_seguridad, 1, DATEADD(YEAR, 3, GETDATE()), @C_id_cuenta);
        SELECT SCOPE_IDENTITY() AS C_id_tarjeta_debito;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Deposito_Plazo
CREATE OR ALTER PROCEDURE SP_InsertarDepositoPlazo
    @C_id_producto INT, @D_numero_deposito VARCHAR(30), @N_monto DECIMAL(18,2),
    @N_tasa_interes DECIMAL(5,2), @N_plazo_dias INT, @F_fecha_vencimiento DATE, @D_estado VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Deposito_Plazo (C_id_producto, D_numero_deposito, N_monto, N_tasa_interes, N_plazo_dias, F_fecha_inicio, F_fecha_vencimiento, D_estado)
        VALUES (@C_id_producto, @D_numero_deposito, @N_monto, @N_tasa_interes, @N_plazo_dias, GETDATE(), @F_fecha_vencimiento, @D_estado);
        SELECT SCOPE_IDENTITY() AS C_id_deposito;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Deposito_Judicial
CREATE OR ALTER PROCEDURE SP_InsertarDepositoJudicial
    @C_id_producto INT, @D_numero_expediente VARCHAR(50), @N_monto DECIMAL(18,2),
    @D_juzgado VARCHAR(100), @D_estado VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Deposito_Judicial (C_id_producto, D_numero_expediente, N_monto, D_juzgado, F_fecha_deposito, D_estado)
        VALUES (@C_id_producto, @D_numero_expediente, @N_monto, @D_juzgado, GETDATE(), @D_estado);
        SELECT SCOPE_IDENTITY() AS C_id_deposito_judicial;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Remesa
CREATE OR ALTER PROCEDURE SP_InsertarRemesa
    @C_id_producto INT, @D_pais_origen VARCHAR(100), @D_pais_destino VARCHAR(100),
    @N_monto DECIMAL(18,2), @D_moneda VARCHAR(10), @N_tipo_cambio DECIMAL(10,4),
    @D_estado VARCHAR(20), @C_id_transaccion INT = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Remesa (C_id_producto, D_pais_origen, D_pais_destino, N_monto, D_moneda, N_tipo_cambio, F_fecha, D_estado, C_id_transaccion)
        VALUES (@C_id_producto, @D_pais_origen, @D_pais_destino, @N_monto, @D_moneda, @N_tipo_cambio, GETDATE(), @D_estado, @C_id_transaccion);
        SELECT SCOPE_IDENTITY() AS C_id_remesa;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Compraventa_Divisa
CREATE OR ALTER PROCEDURE SP_InsertarCompraventaDivisa
    @C_id_producto INT, @D_tipo VARCHAR(10), @D_moneda_origen VARCHAR(10),
    @D_moneda_destino VARCHAR(10), @N_monto DECIMAL(18,2), @N_tipo_cambio DECIMAL(10,4), @D_estado VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Compraventa_Divisa (C_id_producto, D_tipo, D_moneda_origen, D_moneda_destino, N_monto, N_tipo_cambio, F_fecha, D_estado)
        VALUES (@C_id_producto, @D_tipo, @D_moneda_origen, @D_moneda_destino, @N_monto, @N_tipo_cambio, GETDATE(), @D_estado);
        SELECT SCOPE_IDENTITY() AS C_id_compraventa;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Arrendamiento_Financiero
CREATE OR ALTER PROCEDURE SP_InsertarArrendamiento
    @C_id_producto INT, @D_descripcion_bien VARCHAR(200), @N_valor_bien DECIMAL(18,2),
    @N_cuota_mensual DECIMAL(18,2), @N_plazo_meses INT, @N_tasa_interes DECIMAL(5,2),
    @F_fecha_fin DATE, @D_estado VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Arrendamiento_Financiero (C_id_producto, D_descripcion_bien, N_valor_bien, N_cuota_mensual, N_plazo_meses, N_tasa_interes, F_fecha_inicio, F_fecha_fin, D_estado)
        VALUES (@C_id_producto, @D_descripcion_bien, @N_valor_bien, @N_cuota_mensual, @N_plazo_meses, @N_tasa_interes, GETDATE(), @F_fecha_fin, @D_estado);
        SELECT SCOPE_IDENTITY() AS C_id_arrendamiento;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Aval_Garantia
CREATE OR ALTER PROCEDURE SP_InsertarAvalGarantia
    @C_id_producto INT, @D_tipo_garantia VARCHAR(50), @D_beneficiario VARCHAR(100),
    @N_monto DECIMAL(18,2), @F_fecha_vencimiento DATE, @D_estado VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Aval_Garantia (C_id_producto, D_tipo_garantia, D_beneficiario, N_monto, F_fecha_emision, F_fecha_vencimiento, D_estado)
        VALUES (@C_id_producto, @D_tipo_garantia, @D_beneficiario, @N_monto, GETDATE(), @F_fecha_vencimiento, @D_estado);
        SELECT SCOPE_IDENTITY() AS C_id_aval;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Fideicomiso
CREATE OR ALTER PROCEDURE SP_InsertarFideicomiso
    @C_id_producto INT, @D_tipo_fideicomiso VARCHAR(50), @D_beneficiario VARCHAR(100),
    @N_monto DECIMAL(18,2), @F_fecha_fin DATE = NULL, @D_estado VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Fideicomiso (C_id_producto, D_tipo_fideicomiso, D_beneficiario, N_monto, F_fecha_inicio, F_fecha_fin, D_estado)
        VALUES (@C_id_producto, @D_tipo_fideicomiso, @D_beneficiario, @N_monto, GETDATE(), @F_fecha_fin, @D_estado);
        SELECT SCOPE_IDENTITY() AS C_id_fideicomiso;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Caja_Seguridad
CREATE OR ALTER PROCEDURE SP_InsertarCajaSeguridad
    @C_id_producto INT, @D_numero_caja VARCHAR(20), @D_tamano VARCHAR(20),
    @N_costo_mensual DECIMAL(18,2), @F_fecha_vencimiento DATE, @D_estado VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Caja_Seguridad (C_id_producto, D_numero_caja, D_tamano, N_costo_mensual, F_fecha_inicio, F_fecha_vencimiento, D_estado)
        VALUES (@C_id_producto, @D_numero_caja, @D_tamano, @N_costo_mensual, GETDATE(), @F_fecha_vencimiento, @D_estado);
        SELECT SCOPE_IDENTITY() AS C_id_caja;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Cajero_Automatico
CREATE OR ALTER PROCEDURE SP_InsertarCajeroAutomatico
    @C_id_producto INT, @D_numero_tarjeta VARCHAR(20), @N_limite_diario DECIMAL(18,2), @D_estado VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Cajero_Automatico (C_id_producto, D_numero_tarjeta, N_limite_diario, F_fecha_activacion, D_estado)
        VALUES (@C_id_producto, @D_numero_tarjeta, @N_limite_diario, GETDATE(), @D_estado);
        SELECT SCOPE_IDENTITY() AS C_id_cajero;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Banca_Linea
CREATE OR ALTER PROCEDURE SP_InsertarBancaLinea
    @C_id_producto INT, @D_usuario VARCHAR(100)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Banca_Linea (C_id_producto, D_usuario, F_fecha_activacion, B_activo)
        VALUES (@C_id_producto, @D_usuario, GETDATE(), 1);
        SELECT SCOPE_IDENTITY() AS C_id_banca_linea;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Descuento_Factura
CREATE OR ALTER PROCEDURE SP_InsertarDescuentoFactura
    @C_id_producto INT, @D_numero_factura VARCHAR(50), @N_monto_factura DECIMAL(18,2),
    @N_monto_descontado DECIMAL(18,2), @N_tasa_descuento DECIMAL(5,2),
    @F_fecha_vencimiento DATE, @D_estado VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO Descuento_Factura (C_id_producto, D_numero_factura, N_monto_factura, N_monto_descontado, N_tasa_descuento, F_fecha_emision, F_fecha_vencimiento, D_estado)
        VALUES (@C_id_producto, @D_numero_factura, @N_monto_factura, @N_monto_descontado, @N_tasa_descuento, GETDATE(), @F_fecha_vencimiento, @D_estado);
        SELECT SCOPE_IDENTITY() AS C_id_descuento;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO
