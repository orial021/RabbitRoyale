from datetime import datetime
from typing import Optional
from pydantic import BaseModel
import uuid
from enum import Enum

class ERarity(Enum):
    COMMON = "common"
    UNCOMMON = "uncommon"
    RARE = "rare"
    EPIC = "epic"
    LEGENDARY = "legendary"
    MYTHIC = "mythic"
    DIVINE = "divine"

class Item(BaseModel):
    id: uuid.UUID
    image_path: Optional[str] = None
    name: str
    description: str
    type: str
    rarity: ERarity
    value: int

    class Config:
        from_attributes = True
    
class ItemCreateSchema(BaseModel):
    image_path: Optional[str] = None
    name: str
    description: str
    type: str
    rarity: ERarity
    value: int
    
    class Config:
        from_attributes = True
        
class ItemResponseSchema(BaseModel):
    id: uuid.UUID
    created_at : datetime
    updated_at : datetime
    deleted_at : Optional[datetime] = None
    
    class Config:
        from_attributes = True