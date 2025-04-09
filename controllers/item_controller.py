from fastapi import HTTPException
from schemas.item_schema import ItemCreateSchema
from models.item_model import Item
from services.item_service import ItemService

class ItemController:
    def __init__(self):
        self.service = ItemService(Item, ItemCreateSchema)

    async def create(self, data: ItemCreateSchema):
        return await self.service.create(data)

    async def get_all(self):
        return await self.service.get_all()

    async def get(self, id: int):
        Item = await self.service.get_by_id(id)
        if Item is None:
            raise HTTPException(status_code=404, detail='Item not found')
        return Item

    async def update(self, id: int, data: ItemCreateSchema):
        Item = await self.service.update(id, data)
        if Item is None:
            raise HTTPException(status_code=404, detail='Item not found')
        return Item

    async def delete(self, id: int):
        Item = await self.service.delete(id)
        if Item is None:
            raise HTTPException(status_code=404, detail='Item not found')
        return Item

item_controller = ItemController()
