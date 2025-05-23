from typing import List
from fastapi import APIRouter, Depends, HTTPException
from models.user_model import User
from schemas.user_schema import UserCreateSchema, UserResponseSchema, UserUpdateSchema
from controllers.user_controller import user_controller
from .auth_router import decode_token

user_router = APIRouter()

@user_router.get('/all', tags=['User'], response_model=List[UserResponseSchema])
async def all():
    return await user_controller.get_all()

@user_router.get('/show/{id}', tags=['User'], response_model=UserResponseSchema)
async def show(id):
    return await user_controller.get(id)

@user_router.post('/create', tags=['User'], response_model=UserResponseSchema)
async def creater(data: UserCreateSchema):
    return await user_controller.create(data)

@user_router.put('/update/{id}', tags=['User'], response_model=UserResponseSchema)
async def updater(id: str, data: UserUpdateSchema, current_user: User = Depends(decode_token)):
    user = await user_controller.get(id)
    if user.id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to update this user")
    return await user_controller.update(id, data)

@user_router.delete('/delete/{id}', tags=['User'], response_model=UserResponseSchema)
async def delete(id: str, current_user: User = Depends(decode_token)):
    user = await user_controller.get(id)
    if user.id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to delete this user")
    return await user_controller.delete(id)
