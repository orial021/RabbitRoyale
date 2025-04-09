from datetime import datetime
from pydantic import BaseModel
import uuid

class Inventory(BaseModel):
    id: uuid.UUID
    user_id: uuid.UUID
    item_id: uuid.UUID
    quantity: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class InventoryCreateSchema(BaseModel):
    user_id: uuid.UUID
    item_id: uuid.UUID
    quantity: int

    class Config:
        from_attributes = True
        
class InventoryResponseSchema(BaseModel):
    id: uuid.UUID
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True