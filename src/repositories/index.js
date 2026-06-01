const BaseRepository = require('./base.repository');

const TABLES = [
  { name: 'Cliente',                pk: 'C_id_cliente',           fn: 'FN_ObtenerClientes',            spI: 'SP_InsertarCliente',            spU: 'SP_ActualizarCliente',            spD: 'SP_EliminarCliente' },
  { name: 'Producto',               pk: 'C_id_producto',          fn: 'FN_ObtenerProductos',           spI: 'SP_InsertarProducto',           spU: 'SP_ActualizarProducto',           spD: 'SP_EliminarProducto' },
  { name: 'Cliente_Producto',       pk: 'C_id_cliente',           fn: 'FN_ObtenerClienteProducto',     spI: 'SP_InsertarClienteProducto',    spU: null,                               spD: 'SP_EliminarClienteProducto' },
  { name: 'Transaccion',            pk: 'C_id_transaccion',       fn: 'FN_ObtenerTransacciones',       spI: 'SP_InsertarTransaccion',        spU: 'SP_ActualizarTransaccion',         spD: 'SP_EliminarTransaccion' },
  { name: 'Transferencia',          pk: 'C_id_transferencia',     fn: 'FN_ObtenerTransferencias',      spI: 'SP_InsertarTransferencia',      spU: null,                               spD: 'SP_EliminarTransferencia' },
  { name: 'Cuenta_Vista',           pk: 'C_id_cuenta_vista',      fn: 'FN_ObtenerCuentasVista',        spI: 'SP_InsertarCuentaVista',        spU: 'SP_ActualizarCuentaVista',         spD: 'SP_EliminarCuentaVista' },
  { name: 'Cuenta_Planilla',        pk: 'C_id_cuenta_planilla',   fn: 'FN_ObtenerCuentasPlanilla',     spI: 'SP_InsertarCuentaPlanilla',     spU: null,                               spD: 'SP_EliminarCuentaPlanilla' },
  { name: 'Cuenta_Expediente_Simplificado', pk: 'C_id_cuenta_expediente', fn: 'FN_ObtenerCuentasExpSimplificado', spI: 'SP_InsertarCuentaExpSimplificado', spU: null, spD: 'SP_EliminarCuentaExpSimplificado' },
  { name: 'Prestamo',               pk: 'C_id_prestamo',          fn: 'FN_ObtenerPrestamos',           spI: 'SP_InsertarPrestamo',           spU: 'SP_ActualizarPrestamo',            spD: 'SP_EliminarPrestamo' },
  { name: 'Linea_Credito',          pk: 'C_id_linea_credito',     fn: 'FN_ObtenerLineasCredito',       spI: 'SP_InsertarLineaCredito',       spU: null,                               spD: 'SP_EliminarLineaCredito' },
  { name: 'Tarjeta_Credito',        pk: 'C_id_tarjeta',           fn: 'FN_ObtenerTarjetasCredito',     spI: 'SP_InsertarTarjetaCredito',     spU: 'SP_ActualizarTarjetaCredito',      spD: 'SP_EliminarTarjetaCredito' },
  { name: 'Tarjeta_Debito',         pk: 'C_id_tarjeta_debito',    fn: 'FN_ObtenerTarjetasDebito',      spI: 'SP_InsertarTarjetaDebito',      spU: 'SP_ActualizarTarjetaDebito',       spD: 'SP_EliminarTarjetaDebito' },
  { name: 'Deposito_Plazo',         pk: 'C_id_deposito',          fn: 'FN_ObtenerDepositosPlazo',      spI: 'SP_InsertarDepositoPlazo',      spU: null,                               spD: 'SP_EliminarDepositoPlazo' },
  { name: 'Deposito_Judicial',      pk: 'C_id_deposito_judicial', fn: 'FN_ObtenerDepositosJudiciales', spI: 'SP_InsertarDepositoJudicial',   spU: null,                               spD: 'SP_EliminarDepositoJudicial' },
  { name: 'Remesa',                 pk: 'C_id_remesa',            fn: 'FN_ObtenerRemesas',             spI: 'SP_InsertarRemesa',             spU: null,                               spD: 'SP_EliminarRemesa' },
  { name: 'Compraventa_Divisa',     pk: 'C_id_compraventa',       fn: 'FN_ObtenerCompraventasDivisa',  spI: 'SP_InsertarCompraventaDivisa',  spU: null,                               spD: 'SP_EliminarCompraventaDivisa' },
  { name: 'Arrendamiento_Financiero', pk: 'C_id_arrendamiento',   fn: 'FN_ObtenerArrendamientos',      spI: 'SP_InsertarArrendamiento',      spU: null,                               spD: 'SP_EliminarArrendamiento' },
  { name: 'Aval_Garantia',          pk: 'C_id_aval',              fn: 'FN_ObtenerAvalesGarantia',      spI: 'SP_InsertarAvalGarantia',       spU: null,                               spD: 'SP_EliminarAvalGarantia' },
  { name: 'Fideicomiso',            pk: 'C_id_fideicomiso',       fn: 'FN_ObtenerFideicomisos',        spI: 'SP_InsertarFideicomiso',        spU: null,                               spD: 'SP_EliminarFideicomiso' },
  { name: 'Caja_Seguridad',         pk: 'C_id_caja',              fn: 'FN_ObtenerCajasSeguridad',      spI: 'SP_InsertarCajaSeguridad',      spU: null,                               spD: 'SP_EliminarCajaSeguridad' },
  { name: 'Cajero_Automatico',      pk: 'C_id_cajero',            fn: 'FN_ObtenerCajerosAutomaticos',  spI: 'SP_InsertarCajeroAutomatico',   spU: null,                               spD: 'SP_EliminarCajeroAutomatico' },
  { name: 'Banca_Linea',            pk: 'C_id_banca_linea',       fn: 'FN_ObtenerBancaLinea',          spI: 'SP_InsertarBancaLinea',         spU: null,                               spD: 'SP_EliminarBancaLinea' },
  { name: 'Descuento_Factura',      pk: 'C_id_descuento',         fn: 'FN_ObtenerDescuentosFactura',   spI: 'SP_InsertarDescuentoFactura',   spU: null,                               spD: 'SP_EliminarDescuentoFactura' },
];

const repositories = {};
for (const t of TABLES) {
  repositories[t.name] = new BaseRepository(t.name, t.pk, t.fn, t.spI, t.spU, t.spD);
}

module.exports = repositories;
