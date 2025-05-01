from fastapi import HTTPException
from schemas.inventory_schema import InventoryCreateSchema
from models.inventory_models import Inventory
from services.inventory_service import InventoryService

class InventoryController:
    def __init__(self):
        self.service = InventoryService(Inventory, InventoryCreateSchema)

    async def create(self, data: InventoryCreateSchema):
        return await self.service.create(data)

    async def get_all(self):
        return await self.service.get_all()

    async def get(self, id: int):
        Item = await self.service.get_by_id(id)
        if Item is None:
            raise HTTPException(status_code=404, detail='Inventory not found')
        return Item
    
    async def get_owner(self, id: int):
        owner_id = await self.service.get_owner(id)
        if owner_id is None:
            raise HTTPException(status_code=404, detail='Inventory not found')
        return owner_id

    async def update(self, id: int, data: InventoryCreateSchema):
        Item = await self.service.update(id, data)
        if Item is None:
            raise HTTPException(status_code=404, detail='Inventory not found')
        return Item

inventory_controller = InventoryController()
