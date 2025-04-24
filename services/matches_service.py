from typing import Type, TypeVar, Generic
from pydantic import BaseModel
from tortoise.models import Model
from datetime import datetime
from schemas.matches_schema import MatchCreateSchema, MatchUpdateSchema
from models.matches_model import Match

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

    async def get_by_id(self, id: int):
        return await self.model.get_or_none(id=id, deleted_at=None)

    async def update(self, id: int, data: MatchUpdateSchema):
        instance = await self.get_by_id(id)
        if instance:
            await instance.update_from_dict(data.model_dump())
            await instance.save()
            return instance
        return None

    async def delete(self, id: int):
        instance = await self.get_by_id(id)
        if instance:
            instance.deleted_at = datetime.now()
            await instance.save()
            return instance
        return None


class matchService(CRUDService[MatchCreateSchema, Match]):
    pass


match_service = matchService(Match, MatchCreateSchema)
