#!/usr/bin/env bash
# Primer argumento que llega vía ?arg=<fichero.m>
file="$1"

# Si viene solo el nombre, lo buscamos en /opt/exercises
if [[ -n "$file" ]]; then
  [[ -f "/opt/exercises/$file" ]] && file="/opt/exercises/$file"
fi

if [[ -f "$file" ]]; then
  exec bash -lc "octave --no-gui -q --persist \"$file\" 2>/dev/null"
else
  echo ">> No se recibió argumento ?arg=<script>.m válido – abriendo REPL"
  exec bash -lc "octave --no-gui -q --persist"
fi
