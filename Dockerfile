# octave-docker/Dockerfile
FROM debian:bookworm-slim

# ------------------------------
# 1) Sistema base + Octave
# ------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        octave gnuplot-nox ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*
ENV GNUTERM=dumb

# ------------------------------
# 2) GoTTY (terminal web)
# ------------------------------
ARG GOTTY_VERSION=1.0.1
RUN curl -L https://github.com/yudai/gotty/releases/download/v${GOTTY_VERSION}/gotty_linux_amd64.tar.gz \
        | tar -xz -C /usr/local/bin && \
    chmod +x /usr/local/bin/gotty

# ------------------------------
# 3) Ejercicios
# ------------------------------
WORKDIR /opt/exercises
COPY *.m .

EXPOSE 8080
# Ejecutar Octave en modo silencioso para evitar el mensaje inicial
CMD ["gotty", "--permit-write", "--port", "8080", \
      "bash", "-lc", "octave --no-gui -q --persist Longitud_Tuberia.m 2>/dev/null"]

