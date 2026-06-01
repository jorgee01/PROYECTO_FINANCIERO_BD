USE Grupo1_BancoUCR;
GO

-- Cliente
CREATE OR ALTER PROCEDURE SP_ActualizarCliente
    @C_id_cliente INT, @D_nombre VARCHAR(100)=NULL, @D_apellido VARCHAR(100)=NULL,
    @D_correo VARCHAR(100)=NULL, @N_ingresos INT=NULL, @B_activo BIT=NULL,
    @C_id_distrito INT=NULL, @C_id_profesion INT=NULL, @C_id_actividad_economica INT=NULL,
    @C_id_tipo_persona INT=NULL, @C_id_estado_civil INT=NULL, @C_id_pais INT=NULL,
    @D_identificacion VARCHAR(20)=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Cliente SET
            D_nombre = ISNULL(@D_nombre, D_nombre),
            D_apellido = ISNULL(@D_apellido, D_apellido),
            D_correo = ISNULL(@D_correo, D_correo),
            N_ingresos = ISNULL(@N_ingresos, N_ingresos),
            B_activo = ISNULL(@B_activo, B_activo),
            C_id_distrito = ISNULL(@C_id_distrito, C_id_distrito),
            C_id_profesion = ISNULL(@C_id_profesion, C_id_profesion),
            C_id_actividad_economica = ISNULL(@C_id_actividad_economica, C_id_actividad_economica),
            C_id_tipo_persona = ISNULL(@C_id_tipo_persona, C_id_tipo_persona),
            C_id_estado_civil = ISNULL(@C_id_estado_civil, C_id_estado_civil),
            C_id_pais = ISNULL(@C_id_pais, C_id_pais),
            D_identificacion = ISNULL(@D_identificacion, D_identificacion)
        WHERE C_id_cliente = @C_id_cliente;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Producto
CREATE OR ALTER PROCEDURE SP_ActualizarProducto
    @C_id_producto INT, @D_nombre VARCHAR(100)=NULL, @M_monto DECIMAL(18,2)=NULL,
    @B_activo BIT=NULL, @C_id_tipo_producto INT=NULL, @C_id_cliente INT=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Producto SET
            D_nombre = ISNULL(@D_nombre, D_nombre),
            M_monto = ISNULL(@M_monto, M_monto),
            B_activo = ISNULL(@B_activo, B_activo),
            C_id_tipo_producto = ISNULL(@C_id_tipo_producto, C_id_tipo_producto),
            C_id_cliente = ISNULL(@C_id_cliente, C_id_cliente)
        WHERE C_id_producto = @C_id_producto;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Transaccion
CREATE OR ALTER PROCEDURE SP_ActualizarTransaccion
    @C_id_transaccion INT, @M_monto DECIMAL(18,2)=NULL, @D_tipo VARCHAR(50)=NULL,
    @B_estado BIT=NULL, @C_id_producto INT=NULL, @C_id_moneda INT=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Transaccion SET
            M_monto = ISNULL(@M_monto, M_monto),
            D_tipo = ISNULL(@D_tipo, D_tipo),
            B_estado = ISNULL(@B_estado, B_estado),
            C_id_producto = ISNULL(@C_id_producto, C_id_producto),
            C_id_moneda = ISNULL(@C_id_moneda, C_id_moneda)
        WHERE C_id_transaccion = @C_id_transaccion;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Cuenta_Vista
CREATE OR ALTER PROCEDURE SP_ActualizarCuentaVista
    @C_id_cuenta_vista INT, @N_saldo DECIMAL(18,2)=NULL, @N_saldo_disponible DECIMAL(18,2)=NULL,
    @D_estado VARCHAR(20)=NULL, @C_id_cliente INT=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Cuenta_Vista SET
            N_saldo = ISNULL(@N_saldo, N_saldo),
            N_saldo_disponible = ISNULL(@N_saldo_disponible, N_saldo_disponible),
            D_estado = ISNULL(@D_estado, D_estado),
            C_id_cliente = ISNULL(@C_id_cliente, C_id_cliente)
        WHERE C_id_cuenta_vista = @C_id_cuenta_vista;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Prestamo
CREATE OR ALTER PROCEDURE SP_ActualizarPrestamo
    @C_id_prestamo INT, @N_tasa_interes DECIMAL(5,2)=NULL, @N_plazo_meses INT=NULL,
    @M_monto_otorgado DECIMAL(18,2)=NULL, @M_saldo_pendiente DECIMAL(18,2)=NULL,
    @M_cuota_mensual DECIMAL(18,2)=NULL, @B_estado BIT=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Prestamo SET
            N_tasa_interes = ISNULL(@N_tasa_interes, N_tasa_interes),
            N_plazo_meses = ISNULL(@N_plazo_meses, N_plazo_meses),
            M_monto_otorgado = ISNULL(@M_monto_otorgado, M_monto_otorgado),
            M_saldo_pendiente = ISNULL(@M_saldo_pendiente, M_saldo_pendiente),
            M_cuota_mensual = ISNULL(@M_cuota_mensual, M_cuota_mensual),
            B_estado = ISNULL(@B_estado, B_estado)
        WHERE C_id_prestamo = @C_id_prestamo;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Tarjeta_Credito
CREATE OR ALTER PROCEDURE SP_ActualizarTarjetaCredito
    @C_id_tarjeta INT, @M_limite_credito DECIMAL(18,2)=NULL,
    @M_saldo_utilizado DECIMAL(18,2)=NULL, @B_estado BIT=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Tarjeta_Credito SET
            M_limite_credito = ISNULL(@M_limite_credito, M_limite_credito),
            M_saldo_utilizado = ISNULL(@M_saldo_utilizado, M_saldo_utilizado),
            B_estado = ISNULL(@B_estado, B_estado)
        WHERE C_id_tarjeta = @C_id_tarjeta;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Tarjeta_Debito
CREATE OR ALTER PROCEDURE SP_ActualizarTarjetaDebito
    @C_id_tarjeta_debito INT, @N_limite INT=NULL, @B_estado BIT=NULL, @C_id_cuenta INT=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Tarjeta_Debito SET
            N_limite = ISNULL(@N_limite, N_limite),
            B_estado = ISNULL(@B_estado, B_estado),
            C_id_cuenta = ISNULL(@C_id_cuenta, C_id_cuenta)
        WHERE C_id_tarjeta_debito = @C_id_tarjeta_debito;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Arrendamiento_Financiero
CREATE OR ALTER PROCEDURE SP_ActualizarArrendamiento
    @C_id_arrendamiento INT,
    @D_descripcion_bien VARCHAR(200)=NULL, @N_valor_bien DECIMAL(18,2)=NULL,
    @N_cuota_mensual DECIMAL(18,2)=NULL, @N_plazo_meses INT=NULL,
    @N_tasa_interes DECIMAL(5,2)=NULL, @D_estado VARCHAR(20)=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Arrendamiento_Financiero SET
            D_descripcion_bien = ISNULL(@D_descripcion_bien, D_descripcion_bien),
            N_valor_bien = ISNULL(@N_valor_bien, N_valor_bien),
            N_cuota_mensual = ISNULL(@N_cuota_mensual, N_cuota_mensual),
            N_plazo_meses = ISNULL(@N_plazo_meses, N_plazo_meses),
            N_tasa_interes = ISNULL(@N_tasa_interes, N_tasa_interes),
            D_estado = ISNULL(@D_estado, D_estado)
        WHERE C_id_arrendamiento = @C_id_arrendamiento;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Aval_Garantia
CREATE OR ALTER PROCEDURE SP_ActualizarAvalGarantia
    @C_id_aval INT,
    @D_tipo_garantia VARCHAR(50)=NULL, @D_beneficiario VARCHAR(100)=NULL,
    @N_monto DECIMAL(18,2)=NULL, @D_estado VARCHAR(20)=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Aval_Garantia SET
            D_tipo_garantia = ISNULL(@D_tipo_garantia, D_tipo_garantia),
            D_beneficiario = ISNULL(@D_beneficiario, D_beneficiario),
            N_monto = ISNULL(@N_monto, N_monto),
            D_estado = ISNULL(@D_estado, D_estado)
        WHERE C_id_aval = @C_id_aval;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Banca_Linea
CREATE OR ALTER PROCEDURE SP_ActualizarBancaLinea
    @C_id_banca_linea INT,
    @D_usuario VARCHAR(50)=NULL, @B_activo BIT=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Banca_Linea SET
            D_usuario = ISNULL(@D_usuario, D_usuario),
            B_activo = ISNULL(@B_activo, B_activo)
        WHERE C_id_banca_linea = @C_id_banca_linea;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Caja_Seguridad
CREATE OR ALTER PROCEDURE SP_ActualizarCajaSeguridad
    @C_id_caja INT,
    @D_numero_caja VARCHAR(30)=NULL, @D_tamano VARCHAR(20)=NULL,
    @N_costo_mensual DECIMAL(18,2)=NULL, @D_estado VARCHAR(20)=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Caja_Seguridad SET
            D_numero_caja = ISNULL(@D_numero_caja, D_numero_caja),
            D_tamano = ISNULL(@D_tamano, D_tamano),
            N_costo_mensual = ISNULL(@N_costo_mensual, N_costo_mensual),
            D_estado = ISNULL(@D_estado, D_estado)
        WHERE C_id_caja = @C_id_caja;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Cajero_Automatico
CREATE OR ALTER PROCEDURE SP_ActualizarCajeroAutomatico
    @C_id_cajero INT,
    @D_numero_tarjeta VARCHAR(30)=NULL, @N_limite_diario DECIMAL(18,2)=NULL,
    @D_estado VARCHAR(20)=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Cajero_Automatico SET
            D_numero_tarjeta = ISNULL(@D_numero_tarjeta, D_numero_tarjeta),
            N_limite_diario = ISNULL(@N_limite_diario, N_limite_diario),
            D_estado = ISNULL(@D_estado, D_estado)
        WHERE C_id_cajero = @C_id_cajero;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Compraventa_Divisa
CREATE OR ALTER PROCEDURE SP_ActualizarCompraventaDivisa
    @C_id_compraventa INT,
    @D_tipo VARCHAR(10)=NULL, @D_moneda_origen VARCHAR(10)=NULL,
    @D_moneda_destino VARCHAR(10)=NULL, @N_monto DECIMAL(18,2)=NULL,
    @N_tipo_cambio DECIMAL(10,4)=NULL, @D_estado VARCHAR(20)=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Compraventa_Divisa SET
            D_tipo = ISNULL(@D_tipo, D_tipo),
            D_moneda_origen = ISNULL(@D_moneda_origen, D_moneda_origen),
            D_moneda_destino = ISNULL(@D_moneda_destino, D_moneda_destino),
            N_monto = ISNULL(@N_monto, N_monto),
            N_tipo_cambio = ISNULL(@N_tipo_cambio, N_tipo_cambio),
            D_estado = ISNULL(@D_estado, D_estado)
        WHERE C_id_compraventa = @C_id_compraventa;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Cuenta_Expediente_Simplificado
CREATE OR ALTER PROCEDURE SP_ActualizarCuentaExpSimplificado
    @C_id_cuenta_expediente INT,
    @N_saldo DECIMAL(18,2)=NULL, @N_limite_mensual DECIMAL(18,2)=NULL,
    @D_estado VARCHAR(20)=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Cuenta_Expediente_Simplificado SET
            N_saldo = ISNULL(@N_saldo, N_saldo),
            N_limite_mensual = ISNULL(@N_limite_mensual, N_limite_mensual),
            D_estado = ISNULL(@D_estado, D_estado)
        WHERE C_id_cuenta_expediente = @C_id_cuenta_expediente;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Cuenta_Planilla
CREATE OR ALTER PROCEDURE SP_ActualizarCuentaPlanilla
    @C_id_cuenta_planilla INT,
    @N_saldo DECIMAL(18,2)=NULL, @D_empleador VARCHAR(100)=NULL,
    @N_salario DECIMAL(18,2)=NULL, @D_estado VARCHAR(20)=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Cuenta_Planilla SET
            N_saldo = ISNULL(@N_saldo, N_saldo),
            D_empleador = ISNULL(@D_empleador, D_empleador),
            N_salario = ISNULL(@N_salario, N_salario),
            D_estado = ISNULL(@D_estado, D_estado)
        WHERE C_id_cuenta_planilla = @C_id_cuenta_planilla;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Deposito_Judicial
CREATE OR ALTER PROCEDURE SP_ActualizarDepositoJudicial
    @C_id_deposito_judicial INT,
    @N_monto DECIMAL(18,2)=NULL, @D_juzgado VARCHAR(100)=NULL,
    @D_estado VARCHAR(20)=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Deposito_Judicial SET
            N_monto = ISNULL(@N_monto, N_monto),
            D_juzgado = ISNULL(@D_juzgado, D_juzgado),
            D_estado = ISNULL(@D_estado, D_estado)
        WHERE C_id_deposito_judicial = @C_id_deposito_judicial;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Deposito_Plazo
CREATE OR ALTER PROCEDURE SP_ActualizarDepositoPlazo
    @C_id_deposito INT,
    @N_monto DECIMAL(18,2)=NULL, @N_tasa_interes DECIMAL(5,2)=NULL,
    @N_plazo_dias INT=NULL, @D_estado VARCHAR(20)=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Deposito_Plazo SET
            N_monto = ISNULL(@N_monto, N_monto),
            N_tasa_interes = ISNULL(@N_tasa_interes, N_tasa_interes),
            N_plazo_dias = ISNULL(@N_plazo_dias, N_plazo_dias),
            D_estado = ISNULL(@D_estado, D_estado)
        WHERE C_id_deposito = @C_id_deposito;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Descuento_Factura
CREATE OR ALTER PROCEDURE SP_ActualizarDescuentoFactura
    @C_id_descuento INT,
    @D_numero_factura VARCHAR(50)=NULL, @N_monto_factura DECIMAL(18,2)=NULL,
    @N_monto_descontado DECIMAL(18,2)=NULL, @N_tasa_descuento DECIMAL(5,2)=NULL,
    @D_estado VARCHAR(20)=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Descuento_Factura SET
            D_numero_factura = ISNULL(@D_numero_factura, D_numero_factura),
            N_monto_factura = ISNULL(@N_monto_factura, N_monto_factura),
            N_monto_descontado = ISNULL(@N_monto_descontado, N_monto_descontado),
            N_tasa_descuento = ISNULL(@N_tasa_descuento, N_tasa_descuento),
            D_estado = ISNULL(@D_estado, D_estado)
        WHERE C_id_descuento = @C_id_descuento;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Fideicomiso
CREATE OR ALTER PROCEDURE SP_ActualizarFideicomiso
    @C_id_fideicomiso INT,
    @D_tipo_fideicomiso VARCHAR(50)=NULL, @D_beneficiario VARCHAR(100)=NULL,
    @N_monto DECIMAL(18,2)=NULL, @D_estado VARCHAR(20)=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Fideicomiso SET
            D_tipo_fideicomiso = ISNULL(@D_tipo_fideicomiso, D_tipo_fideicomiso),
            D_beneficiario = ISNULL(@D_beneficiario, D_beneficiario),
            N_monto = ISNULL(@N_monto, N_monto),
            D_estado = ISNULL(@D_estado, D_estado)
        WHERE C_id_fideicomiso = @C_id_fideicomiso;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Linea_Credito
CREATE OR ALTER PROCEDURE SP_ActualizarLineaCredito
    @C_id_linea_credito INT,
    @N_limite DECIMAL(18,2)=NULL, @N_saldo_utilizado DECIMAL(18,2)=NULL,
    @N_tasa_interes DECIMAL(5,2)=NULL, @D_estado VARCHAR(20)=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Linea_Credito SET
            N_limite = ISNULL(@N_limite, N_limite),
            N_saldo_utilizado = ISNULL(@N_saldo_utilizado, N_saldo_utilizado),
            N_tasa_interes = ISNULL(@N_tasa_interes, N_tasa_interes),
            D_estado = ISNULL(@D_estado, D_estado)
        WHERE C_id_linea_credito = @C_id_linea_credito;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Remesa
CREATE OR ALTER PROCEDURE SP_ActualizarRemesa
    @C_id_remesa INT,
    @D_pais_origen VARCHAR(50)=NULL, @D_pais_destino VARCHAR(50)=NULL,
    @N_monto DECIMAL(18,2)=NULL, @D_moneda VARCHAR(10)=NULL,
    @N_tipo_cambio DECIMAL(10,4)=NULL, @D_estado VARCHAR(20)=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Remesa SET
            D_pais_origen = ISNULL(@D_pais_origen, D_pais_origen),
            D_pais_destino = ISNULL(@D_pais_destino, D_pais_destino),
            N_monto = ISNULL(@N_monto, N_monto),
            D_moneda = ISNULL(@D_moneda, D_moneda),
            N_tipo_cambio = ISNULL(@N_tipo_cambio, N_tipo_cambio),
            D_estado = ISNULL(@D_estado, D_estado)
        WHERE C_id_remesa = @C_id_remesa;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO

-- Transferencia
CREATE OR ALTER PROCEDURE SP_ActualizarTransferencia
    @C_id_transferencia INT,
    @D_cuenta_origen VARCHAR(30)=NULL, @D_cuenta_destino VARCHAR(30)=NULL,
    @N_monto DECIMAL(18,2)=NULL, @D_tipo VARCHAR(50)=NULL, @D_estado VARCHAR(20)=NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE Transferencia SET
            D_cuenta_origen = ISNULL(@D_cuenta_origen, D_cuenta_origen),
            D_cuenta_destino = ISNULL(@D_cuenta_destino, D_cuenta_destino),
            N_monto = ISNULL(@N_monto, N_monto),
            D_tipo = ISNULL(@D_tipo, D_tipo),
            D_estado = ISNULL(@D_estado, D_estado)
        WHERE C_id_transferencia = @C_id_transferencia;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END;
GO
