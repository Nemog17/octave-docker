# Octave Docker

Este contenedor provee una interfaz web sencilla para ejecutar Octave desde el navegador.
Al iniciar la imagen se expone el puerto **8080** y se sirve un terminal interactivo.

## Construcción

```bash
docker build -t octave-web .
```

## Ejecución

```bash
docker run -it --rm -p 8080:8080 octave-web
```
