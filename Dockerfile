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

# ------------------------------
# 4) Archivos web
# ------------------------------
RUN mkdir -p /opt/octave-web
COPY octave-web/* /opt/octave-web/

# ------------------------------
# 5) Script lanzador
# ------------------------------
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["bash","-lc","exec gotty --permit-arguments --permit-write --index /opt/octave-web/index.html --port 8080 --title-format Octave /usr/local/bin/entrypoint.sh"]


