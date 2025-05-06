from typing import List
from fastapi import APIRouter
from schemas.matches_schema import MatchCreateSchema, MatchUpdateSchema, MatchResponseSchema
from controllers.matches_controller import match_controller


match_router = APIRouter()

@match_router.get('/all', tags=['Matches'], response_model=List[MatchResponseSchema])
async def all():
    return await match_controller.get_all()

@match_router.get('/show/{id}', tags=['Matches'], response_model=MatchResponseSchema)
async def show(id: int):
    return await match_controller.get(id)

@match_router.get('/active', tags=['Matches'], response_model=List[MatchResponseSchema])
async def active(page: int = 1, limit: int = 6):
    return await match_controller.get_all_actives(page, limit)

@match_router.post('/create/', tags=['Matches'], response_model=MatchResponseSchema)
async def creater(data: MatchCreateSchema):
    return await match_controller.create(data)

@match_router.put('/update/{id}', tags=['Matches'], response_model=MatchResponseSchema)
async def updater(id: int, data: MatchUpdateSchema):
    return await match_controller.update(id, data)

@match_router.get('/last', tags=['Matches'])
async def last():
    return await match_controller.get_last()

@match_router.get('/time', tags=['Matches'])
async def time_remaining():
    return await match_controller.get_time()