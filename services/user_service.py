from typing import Type, TypeVar, Generic
from pydantic import BaseModel
from tortoise.models import Model
from datetime import datetime
from schemas.user_schema import UserCreateSchema, UserUpdateSchema
from models.user_model import User, hash_password
import uuid

T = TypeVar('T', bound=BaseModel)
M = TypeVar('M', bound=Model)

class CRUDService(Generic[T, M]):
    def __init__(self, model: Type[M], schema: Type[T]):
        self.model = model
        self.schema = schema
        
    async def authenticate_user(self, username: str, password: str):
        user = await User.get_or_none(username=username)
        if user and user.verify_password(password):
            return user
        return None


    async def create(self, data: T):
        return await self.model.create(**data.model_dump())

    async def get_all(self):
        return await self.model.filter(deleted_at=None)

    async def get_by_id(self, id: uuid.UUID):
        return await self.model.get_or_none(id=id, deleted_at=None)
    
    async def get_by_username(self, username: str):
        try:
            user = await self.model.get_or_none(username=username, deleted_at=None)
            if user:
                return user
            return None
        except Exception as e:
            print(f"Error retrieving user by username: {e}")
            return None


    async def update(self, id: uuid.UUID, data: UserUpdateSchema):
        instance = await self.get_by_id(id)
        if instance:
            update_data = data.model_dump(exclude_unset=True)
            if 'password' in update_data:
                update_data['password'] = hash_password(update_data['password'])
            await instance.update_from_dict(update_data)
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


class UserService(CRUDService[UserCreateSchema, User]):
    pass


user_service = UserService(User, UserCreateSchema)
