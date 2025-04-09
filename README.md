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
   git clone https://github.com/orial021/RabbitRoyale.git
   cd RabbitRoyale
   ```

2. Instala las dependencias:

pip install -r requirements.txt

## Configuración de la Base de Datos
Inicializar Aerich
Para crear la base de datos, ejecuta el siguiente comando:

aerich init -t tortoise_conf.TORTOISE_ORM

## Crear Migraciones
Para crear las migraciones iniciales, usa:

aerich init-db

## Ejecutar Migraciones
Para aplicar las migraciones, ejecuta:

aerich migrate

## Actualizar Migraciones
Para actualizar la base de datos con las últimas migraciones, usa:

aerich upgrade

## Levantar el Servidor
Para iniciar el servidor, ejecuta:

uvicorn main:app --reload


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