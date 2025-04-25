from typing import Type, TypeVar, Generic
from pydantic import BaseModel
from datetime import datetime, timedelta
from apscheduler.schedulers.asyncio import AsyncIOScheduler
from tortoise.models import Model
from schemas.matches_schema import MatchCreateSchema, MatchUpdateSchema
from models.matches_model import Match

T = TypeVar('T', bound=BaseModel)
M = TypeVar('M', bound=Model)

scheduler = AsyncIOScheduler()

class CRUDService(Generic[T, M]):
    def __init__(self, model: Type[M], schema: Type[T]):
        self.model = model
        self.schema = schema

    async def create(self, data: T):
        active_matches = await self.model.filter(
            status="in_progress",
            deleted_at=None
        ).all()
        for match in active_matches:
            match.status = "completed"
            await match.save()
            scheduler.remove_job(match.id)
        if 'players' in data.model_dump(exclude_unset=True):
            data.players = [player for player in data.players]
        if 'status' in data.model_dump(exclude_unset=True):
            data.status = data.status.value
        return await self.model.create(**data.model_dump())

    async def get_all(self):
        return await self.model.filter(deleted_at=None)

    async def get_by_id(self, id: int):
        return await self.model.get_or_none(id=id, deleted_at=None)

    async def update(self, id: int, data: MatchUpdateSchema):
        instance = await self.get_by_id(id)
        if instance:
            if 'players' in data.model_dump(exclude_unset=True):
                data.players = [player for player in data.players]
            if 'status' in data.model_dump(exclude_unset=True):
                data.status = data.status.value
            if data.status.value == "pending":
                instance.status = "in_progress"
                instance.start_time = datetime.now()
                instance.end_time = instance.start_time + instance.total_time
                try:
                    scheduler.add_job(self.end_match, 'date', run_date=instance.end_time, args=[instance.id])
                except Exception as e:
                    print(500, "No se pudo programar la partida, error: ", e)
            await instance.update_from_dict(data.model_dump())
            await instance.save()
            return instance
        return None
    
    async def get_last(self):
        return await self.model.filter(
            status="in_progress",
            deleted_at=None
        ).order_by('-created_at').first()

    async def end_match(self, id: int):
        instance = await self.get_by_id(id)
        if instance and instance.status == "in_progress":
            instance.status = "completed"
            instance.end_time = datetime.now()
            instance.total_time = (instance.end_time - instance.start_time).seconds
            await instance.save()
            return instance
        return None

class matchService(CRUDService[MatchCreateSchema, Match]):
    pass


match_service = matchService(Match, MatchCreateSchema)

scheduler.start()