# octave-docker/Dockerfile
FROM debian:bookworm-slim

# ------------------------------
# 1) Sistema base + Octave
# ------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        octave gnuplot-nox ca-certificates curl python3 && \
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
# 3) Archivos de ejercicios
# ------------------------------
WORKDIR /opt/exercises
COPY *.m .

# ------------------------------
# 4) Archivos web estáticos
# ------------------------------
WORKDIR /opt/web
COPY index.html script.js styles.css ./

COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 80 8080

CMD ["/usr/local/bin/start.sh"]

