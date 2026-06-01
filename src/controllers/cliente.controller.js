const BaseController = require('./base.controller');
const { getPool } = require('../config/database');

class ClienteController extends BaseController {
  registerRoutes(router) {
    const base = '/clientes';

    router.get(`${base}/buscar`, async (req, res) => {
      try {
        const pool = await getPool();
        const request = pool.request();
        const params = ['D_nombre', 'D_apellido', 'D_cedula', 'C_id_provincia', 'C_id_canton', 'C_id_distrito'];
        for (const p of params) {
          if (req.query[p] !== undefined) {
            request.input(p, req.query[p]);
          }
        }
        const result = await request.execute('SP_BuscarClientesInteligente');
        res.json(result.recordset);
      } catch (err) {
        res.status(500).json({ error: err.message });
      }
    });

    router.get(`${base}/autocomplete`, async (req, res) => {
      try {
        const pool = await getPool();
        const result = await pool.request()
          .input('D_termino', req.query.q || '')
          .execute('SP_AutocompletarCliente');
        res.json(result.recordset);
      } catch (err) {
        res.status(500).json({ error: err.message });
      }
    });

    router.get(base, this.getAll());
    router.get(`${base}/:id`, this.getById());
    router.post(base, this.create());
    router.put(`${base}/:id`, this.update());
    router.delete(`${base}/:id`, this.delete());
  }
}

module.exports = ClienteController;
