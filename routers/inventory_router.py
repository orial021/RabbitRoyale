from typing import List
from fastapi import APIRouter, Depends, HTTPException
from models.user_model import User
from controllers.inventory_controller import inventory_controller
from schemas.inventory_schema import InventoryCreateSchema, InventoryResponseSchema
from .auth_router import decode_token


inventory_router = APIRouter()

@inventory_router.get('/all', tags=['Inventory'], response_model=List[InventoryResponseSchema])
async def all():
    return await inventory_controller.get_all()

@inventory_router.get('/show/{id}', tags=['Inventory'], response_model=InventoryResponseSchema)
async def show(id: str):
    return await inventory_controller.get(id)

@inventory_router.post('/create', tags=['Inventory'], response_model=InventoryResponseSchema)
async def creater(data: InventoryCreateSchema):
    return await inventory_controller.create(data)

@inventory_router.put('/update/{id}', tags=['Inventory'], response_model=InventoryResponseSchema)
async def updater(id: str, data: InventoryCreateSchema, current_user: User = Depends(decode_token)):
    user = await inventory_controller.get_owner(id)
    if user != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to update this user")
    return await inventory_controller.update(id, data)