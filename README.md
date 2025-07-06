# Octave Docker

Este contenedor provee una interfaz web para ejecutar Octave utilizando [GoTTY](https://github.com/yudai/gotty). Al iniciar la imagen se expone un servidor en el puerto **8080**. Accede a `http://localhost:8080` desde tu navegador para usar el terminal de Octave.

Si prefieres trabajar directamente desde la consola en lugar de la web, puedes sobreescribir el *entrypoint* al ejecutar el contenedor:

```bash
docker run -it --rm --entrypoint /usr/local/bin/entrypoint.sh ghcr.io/nemog17/octave-docker
```

El script `entrypoint.sh` inicia Octave en modo no interactivo cuando se pasa el nombre de un script `.m` a través del parámetro `?arg`. Sin argumentos se abre el REPL de Octave.

Para construir la imagen localmente:

```bash
docker build -t octave-docker .
```

Luego ejecútala con:

```bash
docker run -it --rm -p 8080:8080 octave-docker
```

