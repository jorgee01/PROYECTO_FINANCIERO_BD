class BaseController {
  constructor(service, routeName) {
    this.service = service;
    this.routeName = routeName;
  }

  getAll() {
    return async (req, res) => {
      try {
        const data = await this.service.list();
        res.json(data);
      } catch (err) {
        res.status(500).json({ error: err.message });
      }
    };
  }

  getById() {
    return async (req, res) => {
      try {
        const data = await this.service.get(Number(req.params.id));
        res.json(data);
      } catch (err) {
        res.status(err.message === 'Registro no encontrado' ? 404 : 500)
           .json({ error: err.message });
      }
    };
  }

  create() {
    return async (req, res) => {
      try {
        const result = await this.service.create(req.body);
        res.status(201).json(result);
      } catch (err) {
        res.status(500).json({ error: err.message });
      }
    };
  }

  update() {
    return async (req, res) => {
      try {
        const result = await this.service.update(Number(req.params.id), req.body);
        res.json(result);
      } catch (err) {
        res.status(err.message === 'Registro no encontrado' ? 404 : 500)
           .json({ error: err.message });
      }
    };
  }

  delete() {
    return async (req, res) => {
      try {
        const result = await this.service.delete(Number(req.params.id));
        res.json(result);
      } catch (err) {
        res.status(err.message === 'Registro no encontrado' ? 404 : 500)
           .json({ error: err.message });
      }
    };
  }

  registerRoutes(router) {
    const base = `/${this.routeName}`;
    router.get(base, this.getAll());
    router.get(`${base}/:id`, this.getById());
    router.post(base, this.create());
    router.put(`${base}/:id`, this.update());
    router.delete(`${base}/:id`, this.delete());
  }
}

module.exports = BaseController;
