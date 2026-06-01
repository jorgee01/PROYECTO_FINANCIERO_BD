const express = require('express');
const cors = require('cors');
const controllers = require('./controllers');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

const router = express.Router();
for (const ctrl of Object.values(controllers)) {
  ctrl.registerRoutes(router);
}

app.use('/api', router);

app.get('/', (req, res) => {
  res.json({ message: 'API Banco UCR - CRUD Transaccional', endpoints: '/api/:recurso' });
});

app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
