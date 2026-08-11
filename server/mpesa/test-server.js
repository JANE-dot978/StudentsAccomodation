const express = require('express');
const app = express();
const PORT = 8080;

app.get('/test', (req, res) => {
  res.json({ status: 'ok' });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Test server running on port ${PORT}`);
  console.log(`Listening at http://0.0.0.0:${PORT}`);
});
