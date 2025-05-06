from typing import Type, TypeVar, Generic
from pydantic import BaseModel
from datetime import datetime, timedelta, timezone
from tortoise.expressions import Q
from apscheduler.schedulers.asyncio import AsyncIOScheduler
from tortoise.models import Model
from schemas.matches_schema import Match, MatchCreateSchema, MatchUpdateSchema
from models.matches_model import Match

T = TypeVar('T', bound=BaseModel)
M = TypeVar('M', bound=Model)

scheduler = AsyncIOScheduler()

class CRUDService(Generic[T, M]):
    def __init__(self, model: Type[M], schema: Type[T]):
        self.model = model
        self.schema = schema

    async def create(self, data: T):
        # await self._end_existing_matches()
        
        data.players = {
            player: {
                'kills': stats['kills'] or 0,
                'deads': stats['deads'] or 0
            } for player, stats in data.players.items()
        }
        data.status = data.status.value
        return await self.model.create(**data.model_dump())

    async def get_all(self):
        return await self.model.all().order_by('-created_at').limit(6)

    async def get_by_id(self, id: int):
        return await self.model.get_or_none(id=id)

    async def get_all_actives(self, page: int = 1, limit: int = 6):
        offset = (page - 1) * 6
        return await self.model.filter(Q(status="pending") | Q(status="in_progress")).order_by('-created_at').offset(offset).limit(limit)
    
    async def update(self, id: int, data: MatchUpdateSchema):
        instance : Match = await self.get_by_id(id)
        if instance:
            if 'players' in data.model_dump(exclude_unset=True):
                current_players = instance.players or {}
                kills : int = 0
                deads : int = 0
                data.kills = 0
                data.deads = 0 
                for player, stats in data.model_dump()['players'].items():
                    if player in current_players:
                        current_players[player]['kills'] = stats['kills']
                        current_players[player]['deads'] = stats['deads']
                        kills += stats['kills']
                        deads += stats['deads']
                    else:
                        current_players[player] = {
                            'kills': stats['kills'] or 0,
                            'deads': stats['deads'] or 0
                        }
                data.kills += kills
                data.deads += deads
                data.players = current_players
            
            if instance.status == "pending":
                instance.status = "in_progress"
                instance.start_time = datetime.now(timezone.utc)
                instance.end_time = instance.start_time + timedelta(seconds=instance.total_time)
                try:
                    scheduler.add_job(self.end_match, 'date', run_date=instance.end_time, args=[instance.id])
                except Exception as e:
                    print(500, "No se pudo programar la partida, error: ", e)
            await instance.update_from_dict(data.model_dump())
            await instance.save()
            return instance
        return None
    

    async def get_last(self):
        instance = await self.model.filter(
            Q(status="in_progress") | Q(status="pending")
            ).order_by('-created_at').first()
        return instance


    async def end_match(self, id: int):
        instance : Match = await self.get_by_id(id)
        if instance:
            now = datetime.now(timezone.utc)
            if instance.status == "in_progress":
                instance.status = "completed"
                instance.end_time = now
                if instance.start_time.tzinfo is None:
                    instance.start_time = instance.start_time.replace(tzinfo=timezone.utc)
                instance.total_time = (instance.end_time - instance.start_time).seconds
                await instance.save()
                
            elif instance.status == "pending":
                instance.status = "cancelled"
                instance.total_time = 0
                await instance.save()
            return instance
        return None

    async def _end_existing_matches(self):
        active_matches = await self.model.filter(Q(status="pending") | Q(status="in_progress"))
        
        for match in active_matches:
        #     if match.status == "in_progress":
        #         now = datetime.now(timezone.utc)
        #         if match.end_time < now:
        #             match.status = "completed"
        #             match.end_time = now
        #             match.total_time = (match.end_time - match.start_time).seconds
        #             await match.save()
        
        
            if match.status == "pending":
                now = datetime.now(timezone.utc)
                match.start_time = match.created_at
                match.end_time = match.start_time + timedelta(seconds=match.total_time)
                if match.end_time < now:
                    match.status = "cancelled"
                    match.total_time = 0
                    await match.save()
            #await self.end_match(match.id)
            
class matchService(CRUDService[MatchCreateSchema, Match]):
    pass


match_service = matchService(Match, MatchCreateSchema)

scheduler.start()