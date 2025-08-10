#!/bin/bash
set -e

# Iniciar servidor web estático
python3 -m http.server 80 --directory /opt/web &

# Lanzar GoTTY con Octave (sin shell ni sesión persistente)
cd /opt/exercises
exec gotty --permit-write --port 8080 octave --no-gui -q Longitud_Tuberia.m
