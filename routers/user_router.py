from typing import List
from fastapi import APIRouter, Depends, HTTPException
from models.user_model import User
from schemas.user_schema import UserCreateSchema, UserResponseSchema
from controllers.user_controller import UserController
from .auth_router import decode_token

user_router = APIRouter()

@user_router.get('/all', tags=['User'], response_model=List[UserResponseSchema])
async def all(current_user: User = Depends(decode_token)):
    return await UserController.get_all()

@user_router.get('/show/{id}', tags=['User'], response_model=UserResponseSchema)
async def show(id):
    return await UserController.get(id)

@user_router.post('/create', tags=['User'], response_model=UserResponseSchema)
async def creater(data: UserCreateSchema):
    return await UserController.create(data)

@user_router.put('/update/{id}', tags=['User'], response_model=UserResponseSchema)
async def updater(id: int, data: UserCreateSchema, current_user: User = Depends(decode_token)):
    user = await UserController.get(id)
    if user.id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to update this user")
    return await UserController.update(id, data)

@user_router.delete('/delete/{id}', tags=['User'], response_model=UserResponseSchema)
async def delete(id: int, current_user: User = Depends(decode_token)):
    user = await UserController.get(id)
    if user.id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to delete this user")
    return await UserController.delete(id)
