const outputEl = document.getElementById('output');
const inputEl = document.getElementById('command-input');
const varsList = document.getElementById('vars-list');
let ws;

function appendOutput(txt){
  outputEl.textContent += txt;
  outputEl.scrollTop = outputEl.scrollHeight;
}

function updateVars(str){
  varsList.innerHTML = '';
  str.split(',').filter(Boolean).forEach(v => {
    const li = document.createElement('li');
    li.textContent = v.trim();
    varsList.appendChild(li);
  });
}

function sendVarRequest () {
  // envía: 0printf("<VARS>%s</VARS>\n", strjoin(who(), ","));
  ws.send('0printf("<VARS>%s</VARS>\\n", strjoin(who(), ","));\n');
}

function connect(){
  const loc = window.location;
  const wsUrl = (loc.protocol === 'https:' ? 'wss://' : 'ws://') + loc.host;
  ws = new WebSocket(wsUrl);
  ws.addEventListener('open', () => {
    sendVarRequest();
  });
  ws.addEventListener('message', evt => {
    const text = evt.data;
    if(text.startsWith('<VARS>') && text.includes('</VARS>')){
      const vars = text.substring(6, text.indexOf('</VARS>'));
      updateVars(vars);
    } else {
      appendOutput(text);
    }
  });
}

inputEl.addEventListener('keydown', e => {
  if(e.key === 'Enter'){
    const cmd = inputEl.value;
    inputEl.value = '';
    ws.send(cmd + '\n');
    setTimeout(sendVarRequest, 50);
  }
});

connect();
