const express = require('express');
const cors = require('cors');
const path = require('path');
const controllers = require('./controllers');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Cargar archivos del frontend desde la carpeta public
app.use(express.static(path.join(__dirname, '..', 'public')));

const router = express.Router();

for (const ctrl of Object.values(controllers)) {
  ctrl.registerRoutes(router);
}

app.use('/api', router);

// Mostrar el frontend al entrar a localhost:3000
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '..', 'public', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});