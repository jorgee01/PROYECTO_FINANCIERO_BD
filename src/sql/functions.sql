USE Grupo1_BancoUCR;
GO

-- =============================================
-- FUNCIONES DE LECTURA (tabla completa o por ID)
-- =============================================

-- Cliente
CREATE OR ALTER FUNCTION FN_ObtenerClientes(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Cliente WHERE @Id IS NULL OR C_id_cliente = @Id
);
GO

-- Producto
CREATE OR ALTER FUNCTION FN_ObtenerProductos(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Producto WHERE @Id IS NULL OR C_id_producto = @Id
);
GO

-- Cliente_Producto
CREATE OR ALTER FUNCTION FN_ObtenerClienteProducto(@IdCliente INT = NULL, @IdProducto INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Cliente_Producto
    WHERE (@IdCliente IS NULL OR C_id_cliente = @IdCliente)
      AND (@IdProducto IS NULL OR C_id_producto = @IdProducto)
);
GO

-- Transaccion
CREATE OR ALTER FUNCTION FN_ObtenerTransacciones(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Transaccion WHERE @Id IS NULL OR C_id_transaccion = @Id
);
GO

-- Transferencia
CREATE OR ALTER FUNCTION FN_ObtenerTransferencias(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Transferencia WHERE @Id IS NULL OR C_id_transferencia = @Id
);
GO

-- Cuenta_Vista
CREATE OR ALTER FUNCTION FN_ObtenerCuentasVista(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Cuenta_Vista WHERE @Id IS NULL OR C_id_cuenta_vista = @Id
);
GO

-- Cuenta_Planilla
CREATE OR ALTER FUNCTION FN_ObtenerCuentasPlanilla(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Cuenta_Planilla WHERE @Id IS NULL OR C_id_cuenta_planilla = @Id
);
GO

-- Cuenta_Expediente_Simplificado
CREATE OR ALTER FUNCTION FN_ObtenerCuentasExpSimplificado(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Cuenta_Expediente_Simplificado WHERE @Id IS NULL OR C_id_cuenta_expediente = @Id
);
GO

-- Prestamo
CREATE OR ALTER FUNCTION FN_ObtenerPrestamos(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Prestamo WHERE @Id IS NULL OR C_id_prestamo = @Id
);
GO

-- Linea_Credito
CREATE OR ALTER FUNCTION FN_ObtenerLineasCredito(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Linea_Credito WHERE @Id IS NULL OR C_id_linea_credito = @Id
);
GO

-- Tarjeta_Credito
CREATE OR ALTER FUNCTION FN_ObtenerTarjetasCredito(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Tarjeta_Credito WHERE @Id IS NULL OR C_id_tarjeta = @Id
);
GO

-- Tarjeta_Debito
CREATE OR ALTER FUNCTION FN_ObtenerTarjetasDebito(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Tarjeta_Debito WHERE @Id IS NULL OR C_id_tarjeta_debito = @Id
);
GO

-- Deposito_Plazo
CREATE OR ALTER FUNCTION FN_ObtenerDepositosPlazo(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Deposito_Plazo WHERE @Id IS NULL OR C_id_deposito = @Id
);
GO

-- Deposito_Judicial
CREATE OR ALTER FUNCTION FN_ObtenerDepositosJudiciales(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Deposito_Judicial WHERE @Id IS NULL OR C_id_deposito_judicial = @Id
);
GO

-- Remesa
CREATE OR ALTER FUNCTION FN_ObtenerRemesas(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Remesa WHERE @Id IS NULL OR C_id_remesa = @Id
);
GO

-- Compraventa_Divisa
CREATE OR ALTER FUNCTION FN_ObtenerCompraventasDivisa(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Compraventa_Divisa WHERE @Id IS NULL OR C_id_compraventa = @Id
);
GO

-- Arrendamiento_Financiero
CREATE OR ALTER FUNCTION FN_ObtenerArrendamientos(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Arrendamiento_Financiero WHERE @Id IS NULL OR C_id_arrendamiento = @Id
);
GO

-- Aval_Garantia
CREATE OR ALTER FUNCTION FN_ObtenerAvalesGarantia(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Aval_Garantia WHERE @Id IS NULL OR C_id_aval = @Id
);
GO

-- Fideicomiso
CREATE OR ALTER FUNCTION FN_ObtenerFideicomisos(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Fideicomiso WHERE @Id IS NULL OR C_id_fideicomiso = @Id
);
GO

-- Caja_Seguridad
CREATE OR ALTER FUNCTION FN_ObtenerCajasSeguridad(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Caja_Seguridad WHERE @Id IS NULL OR C_id_caja = @Id
);
GO

-- Cajero_Automatico
CREATE OR ALTER FUNCTION FN_ObtenerCajerosAutomaticos(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Cajero_Automatico WHERE @Id IS NULL OR C_id_cajero = @Id
);
GO

-- Banca_Linea
CREATE OR ALTER FUNCTION FN_ObtenerBancaLinea(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Banca_Linea WHERE @Id IS NULL OR C_id_banca_linea = @Id
);
GO

-- Descuento_Factura
CREATE OR ALTER FUNCTION FN_ObtenerDescuentosFactura(@Id INT = NULL)
RETURNS TABLE AS RETURN (
    SELECT * FROM Descuento_Factura WHERE @Id IS NULL OR C_id_descuento = @Id
);
GO
