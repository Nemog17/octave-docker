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
  const shell = pty.spawn('octave', ['--silent', '--no-line-editing'], {
    cols: 80,
    rows: 24,
    env: process.env
  });

  // Adjust prompts to behave like Octave Online and disable paging
  shell.write("PS1('>> '); PS2(''); more off;\n");
  shell.write('printf("<VARS>%s</VARS>\\n", strjoin(who(), ","));\n');

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
    shell.kill();
  });
});

const PORT = process.env.PORT || 8080;
server.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
