from fastapi import HTTPException
from datetime import datetime, timezone
from schemas.matches_schema import MatchCreateSchema, MatchUpdateSchema
from models.matches_model import Match
from services.matches_service import matchService

class MatchController:
    def __init__(self):
        self.service = matchService(Match, MatchCreateSchema)

    async def create(self, data: MatchCreateSchema):
        return await self.service.create(data)

    async def get_all(self):
        return await self.service.get_all()

    async def get(self, id: str):
        Item = await self.service.get_by_id(id)
        if Item is None:
            raise HTTPException(status_code=404, detail='Item not found')
        return Item

    async def update(self, id: str, data: MatchUpdateSchema):
        Item = await self.service.update(id, data)
        if Item is None:
            raise HTTPException(status_code=404, detail='Item not found')
        return Item
    
    async def get_last(self):
        Item = await self.service.get_last()
        if Item is None:
            raise HTTPException(status_code=404, detail='Item not found')
        return Item.id
    
    async def get_time(self):
        match = await self.service.get_last()
        if not match:
            raise HTTPException(status_code=404, detail='No hay partidas activas')
        if match.status == "in_progress":
            time_remaining = (match.end_time - datetime.now(timezone.utc)).total_seconds()
            return {"time_remaining_seconds": max(time_remaining, 0)}
        if match.status == "pending":
            return {"time_remaining_seconds": -1}
        raise HTTPException(status_code=404, detail='No hay partidas activas')


match_controller = MatchController()
