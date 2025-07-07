const express = require('express');
const { WebSocketServer } = require('ws');
const pty = require('node-pty');
const path = require('path');

const app = express();
const server = require('http').createServer(app);
const wss = new WebSocketServer({ server });

app.use(express.static(path.join(__dirname, 'public')));

app.get('/', (req, res) => {
  res.sendFile('index.html', { root: path.join(__dirname, 'public') });
});

wss.on('connection', (ws) => {
  const shell = pty.spawn('octave', ['--silent', '--no-line-editing', '--eval', 'more off'], {
    cols: 80,
    rows: 24,
    env: process.env
  });

  // Default prompts are preserved

  shell.on('data', (data) => {
    ws.send(data);
  });

  ws.on('message', (msg) => {
    const input = msg.toString();
    shell.write(input);

    const isVarCmd = input.startsWith('printf("<VARS>') || input.startsWith('printf("<VAL:');

    if(!isVarCmd){
      if(!input.endsWith('\n')){
        shell.write('\n');
      }
      shell.write('printf("<VARS>%s</VARS>\\n", strjoin(who(), ","));\n');
    }
  });

  ws.on('close', () => {
    // Ask Octave to terminate gracefully before killing the PTY.
    try {
      shell.write('quit;\n');
    } catch (e) {}
    setTimeout(() => {
      try {
        shell.kill();
      } catch (e) {}
    }, 100);
  });
});

const PORT = process.env.PORT || 8080;
server.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
