from typing import List
from fastapi import APIRouter
from schemas.item_schema import ItemCreateSchema, ItemResponseSchema
from controllers.item_controller import item_controller


item_router = APIRouter()

@item_router.get('/all', tags=['Item'], response_model=List[ItemResponseSchema])
async def all():
    return await item_controller.get_all()

@item_router.get('/show/{id}', tags=['Item'], response_model=ItemResponseSchema)
async def show(id: str):
    return await item_controller.get(id)

@item_router.post('/create', tags=['Item'], response_model=ItemResponseSchema)
async def creater(data: ItemCreateSchema):
    return await item_controller.create(data)

@item_router.put('/update/{id}', tags=['Item'], response_model=ItemResponseSchema)
async def updater(id: str, data: ItemCreateSchema):
    return await item_controller.update(id, data)

@item_router.delete('/delete/{id}', tags=['Item'], response_model=ItemResponseSchema)
async def delete(id: str):
    return await item_controller.delete(id)