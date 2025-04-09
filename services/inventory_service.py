from typing import Type, TypeVar, Generic
from pydantic import BaseModel
from tortoise.models import Model
from schemas.inventory_schema import InventoryCreateSchema
from models.inventory_models import Inventory

T = TypeVar('T', bound=BaseModel)
M = TypeVar('M', bound=Model)

class CRUDService(Generic[T, M]):
    def __init__(self, model: Type[M], schema: Type[T]):
        self.model = model
        self.schema = schema

    async def create(self, data: T):
        return await self.model.create(**data.model_dump())

    async def get_all(self):
        return await self.model.filter(deleted_at=None)
    
    async def get_owner(self, id: int):
        instance = await self.get_by_id(id)
        if instance:
            return instance.user_id
        return None

    async def get_by_id(self, id: int):
        return await self.model.get_or_none(id=id)

    async def update(self, id: int, data: T):
        instance = await self.get_by_id(id)
        if instance:
            await instance.update_from_dict(data.model_dump())
            await instance.save()
            return instance
        return None


class InventoryService(CRUDService[InventoryCreateSchema, Inventory]):
    pass


inventory_service = InventoryService(Inventory, InventoryCreateSchema)
