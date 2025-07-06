const outputEl = document.getElementById('output');
const inputEl = document.getElementById('command-input');
const varsList = document.getElementById('vars-list');
let ws;
function appendOutput(txt){
  outputEl.textContent += txt;
  outputEl.scrollTop = outputEl.scrollHeight;
}
function updateVars(str){
  varsList.innerHTML='';
  str.split(',').filter(v=>v).forEach(v=>{
    const li=document.createElement('li');
    li.textContent=v.trim();
    varsList.appendChild(li);
  });
}
function sendVarRequest(){
  ws.send('0printf("<VARS>%s</VARS>\\n", strjoin(who(), ","));\n');
}
function connect(){
  const loc = window.location;
  const wsUrl = (loc.protocol === 'https:' ? 'wss://' : 'ws://') + loc.host + '/ws';
  ws = new WebSocket(wsUrl,['gotty']);
  ws.addEventListener('open',()=>{
    const search = location.search.slice(1);
    ws.send(JSON.stringify({Arguments: search? '?' + search : '', AuthToken: ''}));
    setInterval(()=>{ws.send('1');},30000);
    sendVarRequest();
  });
  ws.addEventListener('message',evt=>{
    const data=evt.data;
    if(!data)return;
    const code=data[0];
    const payload=data.slice(1);
    if(code==='0'){
      const text=atob(payload);
      if(text.startsWith('<VARS>')&&text.includes('</VARS>')){
        const vars=text.substring(6,text.indexOf('</VARS>'));
        updateVars(vars);
      }else{
        appendOutput(text);
      }
    }
  });
}
inputEl.addEventListener('keydown',e=>{
  if(e.key==='Enter'){
    const cmd=inputEl.value;
    inputEl.value='';
    ws.send('0'+cmd+'\n');
    sendVarRequest();
  }
});
connect();
