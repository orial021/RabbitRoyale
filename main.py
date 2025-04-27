# para crear la base de datos seria aerich init -t tortoise_conf.TORTOISE_ORM
# para crear migraciones aerich init-db
# para correr migraciones aerich migrate
# para actualizar migraciones aerich upgrade
# para levantar el servidor uvicorn main:app --reload

from fastapi import FastAPI
from fastapi.responses import RedirectResponse
from routers import routers
from tortoise.contrib.fastapi import register_tortoise
from utils.http_error_handler import HTTPErrorHandler
from tortoise_conf import TORTOISE_ORM
from dotenv import load_dotenv
import os

app = FastAPI()

app.add_middleware(HTTPErrorHandler)
load_dotenv()

app.title = 'Rabbit Royale'
app.version = '1.0.0'

secret_key = os.getenv("SECRET_KEY")
if not secret_key or not isinstance(secret_key, str):
    raise ValueError("SECRET_KEY environment variable not set or not a string")


register_tortoise(
    app,
    config = TORTOISE_ORM,
    generate_schemas = True,
    add_exception_handlers = True
)

for router, prefix in routers:
    app.include_router(router, prefix=prefix)


@app.get("/", include_in_schema=False)
async def root():
    return RedirectResponse(url="/docs")
