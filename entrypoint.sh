#!/usr/bin/env bash
set -e

# 1. Arrancar Redis en background
redis-server --daemonize yes --bind ${REDIS_BIND:-127.0.0.1}
echo "🔄 Redis arrancado"

# 2. Arrancar oo-back en background
NODE_ENV=production \
node /srv/oo/back/app.js &
echo "🔄 oo-back arrancado"

# 3. Arrancar oo-front (proceso principal)
echo "✅ Lanzando oo-front en puerto 8080..."
NODE_ENV=production \
node /srv/oo/front/dist/app.js --config /srv/oo/config.hjson
