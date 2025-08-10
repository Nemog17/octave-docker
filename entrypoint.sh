#!/usr/bin/env bash
file="$1"

# Si no se pasa argumento, intenta usar el primer script en /opt/exercises
if [[ -z "$file" ]]; then
  file=$(find /opt/exercises -maxdepth 1 -name '*.m' 2>/dev/null | head -n 1)
fi

# Si viene solo el nombre, lo buscamos en /opt/exercises
if [[ -n "$file" ]]; then
  [[ -f "/opt/exercises/$file" ]] && file="/opt/exercises/$file"
fi

if [[ -f "$file" ]]; then
  exec bash -lc "octave --no-gui -q --persist \"$file\" 2>/dev/null"
else
  echo ">> No se encontró script .m válido – abriendo REPL"
  exec bash -lc "octave --no-gui -q --persist"
fi

