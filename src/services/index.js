const BaseService = require('./base.service');
const repositories = require('../repositories');

const services = {};
for (const [name, repo] of Object.entries(repositories)) {
  services[name] = new BaseService(repo);
}

module.exports = services;
