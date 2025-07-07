FROM node:18-bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends octave gnuplot && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

COPY public ./public
COPY server.js ./

EXPOSE 8080
CMD ["npm", "start"]
