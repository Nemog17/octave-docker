#!/usr/bin/env bash
# Si llega ?exercise=foo.m lo uso; si no, REPL interactivo
file="${QUERY_STRING#*=}"
if [[ -n "$file" && -f "/opt/exercises/$file" ]]; then
  exec bash -lc "octave --persist \"/opt/exercises/$file\" 2>/dev/null"
else
  echo ">> No se recibió parámetro ?exercise=   (cargando REPL Octave)"
  exec bash -lc "octave --persist"
fi
