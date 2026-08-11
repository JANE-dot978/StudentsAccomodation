const express = require('express');
const app = express();
const PORT = 8080;

console.log('[1] Requiring modules...');

try {
  console.log('[2] Creating Express app...');
  app.get('/test', (req, res) => {
    console.log('[REQUEST] GET /test');
    res.json({ status: 'ok', time: new Date().toISOString() });
  });
  
  console.log('[3] Starting to listen on port ' + PORT + '...');
  const server = app.listen(PORT, '0.0.0.0', () => {
    console.log('[4] ✅ Server is listening on http://0.0.0.0:' + PORT);
  });
  
  server.on('error', (err) => {
    console.error('[ERROR] Server error:', err.message);
  });
  
  console.log('[5] Server object created');
  
} catch (e) {
  console.error('[EXCEPTION]:', e.message);
  process.exit(1);
}
