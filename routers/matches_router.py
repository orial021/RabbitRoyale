from typing import List
from fastapi import APIRouter
from schemas.matches_schema import MatchCreateSchema, MatchUpdateSchema, MatchResponseSchema
from controllers.matches_controller import MatchController


match_router = APIRouter()

@match_router.get('/all', tags=['Item'], response_model=List[MatchResponseSchema])
async def all():
    return await MatchController.get_all()

@match_router.get('/show/{id}', tags=['Item'], response_model=MatchResponseSchema)
async def show(id: int):
    return await MatchController.get(id)

@match_router.post('/create', tags=['Item'], response_model=MatchResponseSchema)
async def creater(data: MatchCreateSchema):
    return await MatchController.create(data)

@match_router.put('/update/{id}', tags=['Item'], response_model=MatchResponseSchema)
async def updater(id: int, data: MatchUpdateSchema):
    return await MatchController.update(id, data)

@match_router.get('/time', tags=['Item'])
async def time_remaining():
    return await MatchController.get_time()