from typing import List
from fastapi import APIRouter
from schemas.matches_schema import MatchCreateSchema, MatchUpdateSchema, MatchResponseSchema
from controllers.matches_controller import MatchController


match_router = APIRouter()

@match_router.get('/all', tags=['Item'], response_model=List[MatchResponseSchema])
async def all():
    return await MatchController.get_all()

@match_router.get('/show/{id}', tags=['Item'], response_model=MatchResponseSchema)
async def show(id: str):
    return await MatchController.get(id)

@match_router.post('/create', tags=['Item'], response_model=MatchResponseSchema)
async def creater(data: MatchCreateSchema):
    return await MatchController.create(data)

@match_router.put('/update/{id}', tags=['Item'], response_model=MatchResponseSchema)
async def updater(id: str, data: MatchUpdateSchema):
    return await MatchController.update(id, data)

@match_router.delete('/delete/{id}', tags=['Item'], response_model=MatchResponseSchema)
async def delete(id: str):
    return await MatchController.delete(id)