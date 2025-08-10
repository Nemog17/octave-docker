#!/bin/bash
set -e

# Iniciar servidor web estático
python3 -m http.server 80 --directory /opt/web &

# Lanzar GoTTY con Octave
cd /opt/exercises
exec gotty --permit-write --port 8080 bash -lc "octave --no-gui -q --persist Longitud_Tuberia.m 2>/dev/null"
