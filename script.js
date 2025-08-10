const terminalFrame = document.getElementById('terminal');
const cmdInput = document.getElementById('command-input');
const varsList = document.getElementById('variables-list');

cmdInput.addEventListener('keydown', (e) => {
  if (e.key === 'Enter') {
    e.preventDefault();
    const cmd = cmdInput.value.trim();
    if (cmd !== '') {
      terminalFrame.contentWindow.postMessage(cmd, '*');
      cmdInput.value = '';
      fetchVariables();
    }
  }
});

async function fetchVariables() {
  try {
    const res = await fetch('/variables');
    if (!res.ok) return;
    const vars = await res.json();
    renderVariables(vars);
  } catch (err) {
    console.error(err);
  }
}

function renderVariables(vars) {
  varsList.innerHTML = '';
  Object.entries(vars).forEach(([name, value]) => {
    const li = document.createElement('li');
    const nameSpan = document.createElement('span');
    nameSpan.className = 'var-name';
    nameSpan.textContent = name + ' = ';
    const valueSpan = document.createElement('span');
    const className = isNaN(Number(value)) ? 'var-non-num' : 'var-num';
    valueSpan.className = `var-value ${className}`;
    valueSpan.textContent = value;
    li.appendChild(nameSpan);
    li.appendChild(valueSpan);
    varsList.appendChild(li);
  });
}

setInterval(fetchVariables, 2000);
