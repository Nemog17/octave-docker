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
    const name = v.trim();
    const li = document.createElement('li');
    li.dataset.var = name;

    const span = document.createElement('span');
    span.textContent = name;
    span.style.cursor = 'pointer';
    li.appendChild(span);

    const val = document.createElement('pre');
    val.style.display = 'none';
    val.style.whiteSpace = 'pre-wrap';
    li.appendChild(val);

    span.addEventListener('click', () => {
      if(val.textContent){
        val.style.display = val.style.display === 'none' ? 'block' : 'none';
      } else {
        requestVarValue(name);
      }
    });

    varsList.appendChild(li);
  });
}

function sendVarRequest () {
  // envía: printf("<VARS>%s</VARS>\n", strjoin(who(), ","));
  ws.send('printf("<VARS>%s</VARS>\\n", strjoin(who(), ","));\n');
}

function requestVarValue(name){
  ws.send('printf("<VAL:' + name + '>%s</VAL:' + name + '>\\n", evalc("disp(' + name + ')"));\n');
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
      } else if(text.startsWith('<VAL:') && text.includes('>')){
        const endTagStart = text.indexOf('>');
        const name = text.substring(5, endTagStart);
        const closeTag = '</VAL:' + name + '>';
        const closeIndex = text.indexOf(closeTag);
        if(closeIndex !== -1){
          const val = text.substring(endTagStart + 1, closeIndex).trim();
          const li = varsList.querySelector('li[data-var="' + name + '"] pre');
          if(li){
            li.textContent = val;
            li.style.display = 'block';
          }
        } else {
          appendOutput(text);
        }
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
  }
});

connect();
