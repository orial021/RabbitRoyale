from datetime import datetime
from typing import Optional
from pydantic import BaseModel, EmailStr
import uuid
from enum import Enum

class GenderEnum(Enum):
    MALE = "male"
    FEMALE = "female"
    OTHER = "other"

class User(BaseModel):
    id : uuid.UUID
    username : str
    password : str
    email : EmailStr
    gender : GenderEnum
    coins : int = 0
    date_of_birth : Optional[datetime] = None
    las_connection : Optional[datetime] = None
    is_active : bool = True
    is_premium : bool = False
    matches_played: int = 0
    wins: int = 0
    kills: int = 0
    inventory_capacity: int = 3
    
    model_config = {
        'json_schema_extra':{
            'example': {
                'username': 'john_doe',
                'password': 'securepassword123',
                'email': 'john_doe@gmail.com',
                'gender': 'male',
                'date_of_birth': '1990-01-01T00:00:00Z',
                'las_connection': '2023-10-01T12:00:00Z',
                'is_active': True,
                'is_premium': False,
                'matches_played': 0,
                'wins': 0,
                'kills': 0,
                'inventory_capacity': 100

            }
        }
    }
    
class UserCreateSchema(BaseModel):
    username : str
    password : str
    email : EmailStr
    gender : GenderEnum
    date_of_birth : Optional[datetime] = None
        
    model_config = {
        'json_schema_extra': {
        'example': {
                'username': 'john_doe',
                'password': 'securepassword123',
                'email': 'john_doe@gmail.com',
                'gender': 'male',
                'date_of_birth': '1990-01-01T00:00:00Z',
            }
        }
    }
    
class UserResponseSchema(BaseModel):
    id : uuid.UUID
    username : str
    created_at : datetime
    updated_at : datetime
    deleted_at : Optional[datetime] = None
        
    model_config = {
        'json_schema_extra': {
            'example': {
                'id' : '123e4567-e89b-12d3-a456-426614174000',
                'username': 'john_doe',
                'created_at': '2023-10-01T12:00:00Z',
                'updated_at': '2023-10-01T12:00:00Z',
                'deleted_at': None
            }
        }
    }