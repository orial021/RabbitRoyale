# Proyecto de Base de Datos con Tortoise ORM y Aerich

Este proyecto utiliza Tortoise ORM y Aerich para la gestión de la base de datos, y Uvicorn para levantar el servidor. A continuación, se detallan los comandos necesarios para configurar y ejecutar el proyecto.

## Requisitos

- Python 3.7+
- Tortoise ORM
- Aerich
- Uvicorn

## Instalación

1. Clona el repositorio:
   ```bash
   git clone https://github.com/orial021/RabbitRoyale.git -b manuel-b
   cd RabbitRoyale
   git checkout -b manuel-b
   git add .
   git commit.-m."first.commit"
   git push origin manuel-b
   git config --global user.email "manuelbarrerar98@gmail.com"
   git config --global user.name "Manuel Barrera"
   git clone https://github.com/orial021/RabbitRoyale.git -b manuel-b
   git switch manuel-b
   ```

2. Instala las dependencias:

```bash
pip3 install -r requirements.txt
```

## Configuración de la Base de Datos
Inicializar Aerich
Para crear la base de datos, ejecuta el siguiente comando:

```bash
aerich init -t tortoise_conf.TORTOISE_ORM
```

## Crear Migraciones
Para crear las migraciones iniciales, usa:

```bash
aerich init-db
```

## Ejecutar Migraciones
Para aplicar las migraciones, ejecuta:
```bash
aerich migrate
```

## Actualizar Migraciones
Para actualizar la base de datos con las últimas migraciones, usa:

```bash
aerich upgrade
```

## Levantar el Servidor
Para iniciar el servidor, ejecuta:

```bash
uvicorn main:app --reload
```

Para iniciar el servidor con multiples hilos paralelos (no usar con SQLite), ejecuta:

```bash
gunicorn -w 4 -k uvicorn.workers.UvicornWorker main:app
```
## Contribuir
Si deseas contribuir a este proyecto, por favor sigue los siguientes pasos:

Haz un fork del repositorio.
Crea una nueva rama (git checkout -b feature/nueva-funcionalidad).
Realiza tus cambios y haz commit (git commit -am 'Añadir nueva funcionalidad').
Empuja la rama (git push origin feature/nueva-funcionalidad).
Abre un Pull Request.

## Licencia
Este proyecto está bajo la Licencia MIT. Consulta el archivo LICENSE para más detalles.

¡Gracias por contribuir y aprender con nosotros!

Esta es la rama de Manuel Barrera