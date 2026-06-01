const { getPool } = require('../config/database');

class PadronController {
  registerRoutes(router) {
    router.get('/padron/buscar', async (req, res) => {
      try {
        const pool = await getPool();
        const request = pool.request();
        const params = ['D_cedula', 'D_nombre', 'D_apellido1', 'D_apellido2', 'D_provincia', 'D_canton', 'D_distrito'];
        for (const p of params) {
          if (req.query[p] !== undefined) {
            request.input(p, req.query[p]);
          }
        }
        const result = await request.execute('SP_BuscarPadron');
        res.json(result.recordset);
      } catch (err) {
        res.status(500).json({ error: err.message });
      }
    });

    router.get('/padron/autocomplete', async (req, res) => {
      try {
        const pool = await getPool();
        const result = await pool.request()
          .input('D_termino', req.query.q || '')
          .execute('SP_AutocompletarPadron');
        res.json(result.recordset);
      } catch (err) {
        res.status(500).json({ error: err.message });
      }
    });
  }
}

module.exports = PadronController;
