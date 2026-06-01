const { getPool, sql } = require('../config/database');

class BaseRepository {
  constructor(tableName, pkName, fnName, spInsert, spUpdate, spDelete) {
    this.tableName = tableName;
    this.pkName = pkName;
    this.fnName = fnName;
    this.spInsert = spInsert;
    this.spUpdate = spUpdate;
    this.spDelete = spDelete;
  }

  async getAll() {
    const pool = await getPool();
    const result = await pool.request().query(`SELECT * FROM ${this.fnName}(NULL)`);
    return result.recordset;
  }

  async getById(id) {
    const pool = await getPool();
    const result = await pool.request()
      .input('Id', sql.Int, id)
      .query(`SELECT * FROM ${this.fnName}(@Id)`);
    return result.recordset[0] || null;
  }

  async create(data) {
    const pool = await getPool();
    const request = pool.request();
    this._addParams(request, data);
    const result = await request.execute(this.spInsert);
    return result.recordset[0] || { success: true };
  }

  async update(id, data) {
    const pool = await getPool();
    const request = pool.request();
    request.input(this.pkName, sql.Int, id);
    this._addParams(request, data);
    await request.execute(this.spUpdate);
    return { success: true };
  }

  async delete(id) {
    const pool = await getPool();
    await pool.request()
      .input(this.pkName, sql.Int, id)
      .execute(this.spDelete);
    return { success: true };
  }

  async callFunction(fnName, params = []) {
    const pool = await getPool();
    const request = pool.request();
    for (const p of params) {
      request.input(p.name, p.value ?? null);
    }
    const placeholders = params.map(p => `@${p.name}`).join(', ');
    const result = await request.query(`SELECT * FROM ${fnName}(${placeholders})`);
    return result.recordset;
  }

  async executeSp(spName, params = {}) {
    const pool = await getPool();
    const request = pool.request();
    for (const [key, value] of Object.entries(params)) {
      if (value !== undefined) {
        request.input(key, value ?? null);
      }
    }
    const result = await request.execute(spName);
    return result.recordset;
  }

  _addParams(request, data) {
    for (const [key, value] of Object.entries(data)) {
      const sqlType = this._inferType(value);
      request.input(key, sqlType, value ?? null);
    }
  }

  _inferType(value) {
    if (value === null || value === undefined) return sql.NVarChar(255);
    if (typeof value === 'number') {
      if (Number.isInteger(value)) return sql.Int;
      return sql.Decimal(18, 2);
    }
    if (typeof value === 'boolean') return sql.Bit;
    if (value instanceof Date) return sql.DateTime;
    return sql.NVarChar(255);
  }
}

module.exports = BaseRepository;
