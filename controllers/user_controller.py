from fastapi import HTTPException
from schemas.user_schema import UserCreateSchema, UserUpdateSchema
from models.user_model import User
from services.user_service import UserService
import uuid

class UserController:
    def __init__(self):
        self.service = UserService(User, UserCreateSchema)

    async def create(self, data: UserCreateSchema):
        if await User.exists(username=data.username):
            raise HTTPException(status_code=400, detail="Usuario ya existe")
        return await self.service.create(data)

    async def get_all(self):
        """
        Get all users.
        :return: List of User instances
        """
        return await self.service.get_all()

    async def get(self, id: uuid.UUID):
        """
        Get a user by ID.
        :param id: User ID
        :return: User instance or raise HTTPException if not found
        """
        user = await self.service.get_by_id(id)
        if user is None:
            raise HTTPException(status_code=404, detail='User not found')
        return user

    async def update(self, id: int, data: UserUpdateSchema):
        """
        Update a user by ID.
        :param id: User ID
        :param data: UserCreateSchema
        :return: Updated User instance or raise HTTPException if not found
        """
        user = await self.service.update(id, data)
        if user is None:
            raise HTTPException(status_code=404, detail='User not found')
        return user

    async def delete(self, id: int):
        """
        Soft delete a user by ID.
        :param id: User ID
        :return: Deleted User instance or raise HTTPException if not found
        """
        user = await self.service.delete(id)
        if user is None:
            raise HTTPException(status_code=404, detail='User not found')
        return user

user_controller = UserController()
