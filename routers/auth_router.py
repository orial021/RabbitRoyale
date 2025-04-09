from typing import Annotated
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from datetime import datetime, timedelta
from jose import JWTError, jwt
from models.user_model import User
from services.user_service import user_service
import os
from dotenv import load_dotenv

auth_router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="auth/login")

load_dotenv()  # Carga las variables de entorno desde el archivo .env

secret_key = os.getenv("SECRET_KEY")
if not secret_key or not isinstance(secret_key, str):
    raise ValueError("SECRET_KEY environment variable not set or not a string")

def encode_token(user: User) -> str:
    expiration = datetime.now() + timedelta(hours=1)
    payload = {
        "sub": str(user.id),
        "username": user.username,
        "exp": expiration
    }
    return jwt.encode(payload, secret_key, algorithm='HS256')

async def decode_token(token: str = Depends(oauth2_scheme)) -> User:
    try:
        data = jwt.decode(token, secret_key, algorithms=['HS256'])
        user = await user_service.get_by_username(data['username'])
        if user is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail='Invalid authentication credentials',
                headers={'WWW-Authenticate': 'Bearer'}
            )
        return user
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token",
            headers={"WWW-Authenticate": "Bearer"}
        )

@auth_router.post('/login', tags=['Auth'])
async def login(form_data: Annotated[OAuth2PasswordRequestForm, Depends()]):
    user = await user_service.get_by_username(form_data.username)
    print(user)
    if user is None:
        raise HTTPException(status_code=400, detail='Usuario no encontrado')
    if not user.verify_password(form_data.password):
        raise HTTPException(status_code=400, detail='Contraseña incorrecta')
    token = encode_token(user)
    return {'access_token': token, 'token_type': 'bearer'}



@auth_router.get('/profile', tags=['Auth'])
async def profile(current_user: User = Depends(decode_token)):
    return current_user
