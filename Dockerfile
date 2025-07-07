# ---------- 1) build layer ----------
    FROM node:20-bookworm AS builder
    WORKDIR /srv/oo
    
    # Copiamos solo package.json y package-lock para cache npm
    COPY oos-src/front/package*.json oos-src/front/
    COPY oos-src/back/package*.json oos-src/back/
    
    # Instalamos dependencias front y back
    RUN cd oos-src/front && npm ci && npm run build      \
     && cd ../back && npm ci
    
    # Copiamos el resto del código (después de cachear deps)
    COPY oos-src/ ./oos-src/
    
    # ---------- 2) runtime layer ----------
    FROM ubuntu:22.04
    
    # 1. GNU Octave + Redis + Node runtime
    ENV DEBIAN_FRONTEND=noninteractive
    RUN apt-get update && \
        apt-get install -y --no-install-recommends \
            octave          \
            redis-server    \
            nodejs npm      \
            ca-certificates \
        && rm -rf /var/lib/apt/lists/*
    
    # 2. Copiar artefactos construidos
    WORKDIR /srv/oo
    COPY --from=builder /srv/oo/oos-src/front/dist ./front/dist
    COPY --from=builder /srv/oo/oos-src/back       ./back
    COPY config.hjson ./config.hjson
    
    # 3. Ajustes mínimos
    ENV REDIS_BIND=127.0.0.1
    EXPOSE 8080            # oo-front escucha 8080
    
    # 4. Entrypoint
    COPY entrypoint.sh /usr/local/bin/entrypoint.sh
    RUN chmod +x /usr/local/bin/entrypoint.sh
    ENTRYPOINT ["entrypoint.sh"]