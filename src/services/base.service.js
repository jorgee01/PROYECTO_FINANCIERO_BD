class BaseService {
  constructor(repository) {
    this.repo = repository;
  }

  async list() {
    return await this.repo.getAll();
  }

  async get(id) {
    const record = await this.repo.getById(id);
    if (!record) throw new Error('Registro no encontrado');
    return record;
  }

  async create(data) {
    return await this.repo.create(data);
  }

  async update(id, data) {
    await this.get(id);
    return await this.repo.update(id, data);
  }

  async delete(id) {
    await this.get(id);
    return await this.repo.delete(id);
  }
}

module.exports = BaseService;
