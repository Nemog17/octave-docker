# octave-docker/Dockerfile
FROM debian:bookworm-slim

# ------------------------------
# 1) Sistema base + Octave + ttyd
# ------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        octave gnuplot-nox ca-certificates ttyd && \
    rm -rf /var/lib/apt/lists/*
ENV GNUTERM=dumb

# ------------------------------
# 2) Ejercicios
# ------------------------------
WORKDIR /opt/exercises
COPY *.m .

# ------------------------------
# 3) Script lanzador
# ------------------------------
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["ttyd","-p","8080","bash","-lc","/usr/local/bin/entrypoint.sh"]


