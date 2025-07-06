window.addEventListener('DOMContentLoaded', () => {
  const outputEl = document.getElementById('output');
  const inputEl = document.getElementById('command-input');
  const varsEl = document.getElementById('vars-panel');

  function append(text) {
    outputEl.textContent += text;
    outputEl.scrollTop = outputEl.scrollHeight;
  }

  const wsProtocol = location.protocol === 'https:' ? 'wss://' : 'ws://';
  const wsUrl = wsProtocol + location.host + '/ws';
  const search = location.search.replace(/^\?/, '');
  const ws = new WebSocket(wsUrl, ['gotty']);

  ws.addEventListener('open', () => {
    ws.send(JSON.stringify({
      Arguments: search ? '?' + search : '',
      AuthToken: window.gotty_auth_token || ''
    }));
    setInterval(() => ws.send('1'), 30000);
  });

  ws.addEventListener('message', evt => {
    const msg = evt.data;
    const code = msg[0];
    const payload = msg.slice(1);
    if (code === '0') {
      const text = atob(payload);
      const start = text.indexOf('<VARS>');
      const end = text.indexOf('</VARS>');
      if (start !== -1 && end !== -1) {
        const before = text.substring(0, start);
        const after = text.substring(end + 7);
        append(before + after);
        const vars = text.substring(start + 6, end).split(',').map(v => v.trim()).filter(Boolean);
        varsEl.innerHTML = '<ul>' + vars.map(v => `<li>${v}</li>`).join('') + '</ul>';
      } else {
        append(text);
      }
    }
  });

  inputEl.addEventListener('keydown', e => {
    if (e.key === 'Enter') {
      e.preventDefault();
      const cmd = inputEl.value;
      inputEl.value = '';
      ws.send('0' + cmd + '\n');
      ws.send('0printf("<VARS>%s</VARS>\\n", strjoin(who(), ","));\n');
    }
  });
});
