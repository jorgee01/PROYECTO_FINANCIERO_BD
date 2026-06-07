const BaseController = require('./base.controller');
const ClienteController = require('./cliente.controller');
const PadronController = require('./padron.controller');
const services = require('../services');
const EscenarioController = require('./escenario.controller');
const ROUTES = {
  Producto: 'productos',
  Cliente_Producto: 'clientes-productos',
  Transaccion: 'transacciones',
  Transferencia: 'transferencias',
  Cuenta_Vista: 'cuentas-vista',
  Cuenta_Planilla: 'cuentas-planilla',
  Cuenta_Expediente_Simplificado: 'cuentas-expediente',
  Prestamo: 'prestamos',
  Linea_Credito: 'lineas-credito',
  Tarjeta_Credito: 'tarjetas-credito',
  Tarjeta_Debito: 'tarjetas-debito',
  Deposito_Plazo: 'depositos-plazo',
  Deposito_Judicial: 'depositos-judiciales',
  Remesa: 'remesas',
  Compraventa_Divisa: 'compraventas-divisa',
  Arrendamiento_Financiero: 'arrendamientos',
  Aval_Garantia: 'avales-garantia',
  Fideicomiso: 'fideicomisos',
  Caja_Seguridad: 'cajas-seguridad',
  Cajero_Automatico: 'cajeros-automaticos',
  Banca_Linea: 'banca-linea',
  Descuento_Factura: 'descuentos-factura',
};

const controllers = {};
for (const [serviceName, route] of Object.entries(ROUTES)) {
  controllers[serviceName] = new BaseController(services[serviceName], route);
}

controllers.Cliente = new ClienteController(services.Cliente, 'clientes');
controllers.Padron = new PadronController();
controllers.Escenario = new EscenarioController();
module.exports = controllers;
