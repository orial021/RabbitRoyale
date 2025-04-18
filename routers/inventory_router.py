from typing import List
from fastapi import APIRouter, Depends, HTTPException
from models.user_model import User
from controllers.inventory_controller import InventoryController
from schemas.inventory_schema import InventoryCreateSchema, InventoryResponseSchema
from .auth_router import decode_token


inventory_router = APIRouter()

@inventory_router.get('/all', tags=['Inventory'], response_model=List[InventoryResponseSchema])
async def all():
    return await InventoryController.get_all()

@inventory_router.get('/show/{id}', tags=['Inventory'], response_model=InventoryResponseSchema)
async def show(id: int):
    return await InventoryController.get(id)

@inventory_router.post('/create', tags=['Inventory'], response_model=InventoryResponseSchema)
async def creater(data: InventoryCreateSchema):
    return await InventoryController.create(data)

@inventory_router.put('/update/{id}', tags=['Inventory'], response_model=InventoryResponseSchema)
async def updater(id: int, data: InventoryCreateSchema, current_user: User = Depends(decode_token)):
    user = await InventoryController.get_owner(id)
    if user != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to update this user")
    return await InventoryController.update(id, data)