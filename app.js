const form = document.getElementById('input-form');
const input = document.getElementById('input');
const output = document.getElementById('output');
const varsDiv = document.getElementById('variables');
const variables = {};

form.addEventListener('submit', e => {
  e.preventDefault();
  const cmd = input.value.trim();
  if (cmd === '') return;
  print(`octave> ${cmd}`);
  processCommand(cmd);
  input.value = '';
});

function print(text) {
  const line = document.createElement('div');
  line.textContent = text;
  output.appendChild(line);
  output.scrollTop = output.scrollHeight;
}

function processCommand(cmd) {
  const assignMatch = cmd.match(/^([a-zA-Z]\w*)\s*=\s*(.+)$/);
  if (assignMatch) {
    const name = assignMatch[1];
    const expr = assignMatch[2];
    try {
      const value = evaluate(expr);
      variables[name] = value;
      print(String(value));
      updateVariables();
    } catch (err) {
      print(`error: ${err.message}`);
    }
  } else if (cmd === 'clear') {
    for (const k in variables) delete variables[k];
    output.textContent = '';
    updateVariables();
  } else {
    try {
      const value = evaluate(cmd);
      if (value !== undefined) {
        print(String(value));
      }
    } catch (err) {
      print(`error: ${err.message}`);
    }
  }
}

function evaluate(expr) {
  const names = Object.keys(variables);
  const params = names.join(',');
  const values = names.map(n => variables[n]);
  const func = new Function(params, `with (Math) { return ${expr}; }`);
  return func(...values);
}

function updateVariables() {
  varsDiv.innerHTML = '';
  for (const [name, value] of Object.entries(variables)) {
    const div = document.createElement('div');
    div.className = 'variable';
    const nameSpan = document.createElement('span');
    nameSpan.className = 'name';
    nameSpan.textContent = `${name} = `;
    const valueSpan = document.createElement('span');
    valueSpan.className = 'value';
    valueSpan.textContent = value;
    div.appendChild(nameSpan);
    div.appendChild(valueSpan);
    varsDiv.appendChild(div);
  }
}
