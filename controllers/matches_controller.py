from fastapi import HTTPException
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

    async def get(self, id: int):
        Item = await self.service.get_by_id(id)
        if Item is None:
            raise HTTPException(status_code=404, detail='Item not found')
        return Item

    async def update(self, id: int, data: MatchUpdateSchema):
        Item = await self.service.update(id, data)
        if Item is None:
            raise HTTPException(status_code=404, detail='Item not found')
        return Item

    async def delete(self, id: int):
        Item = await self.service.delete(id)
        if Item is None:
            raise HTTPException(status_code=404, detail='Item not found')
        return Item

match_controller = MatchController()
