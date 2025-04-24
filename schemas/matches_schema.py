from datetime import datetime
from typing import Optional
from pydantic import BaseModel
import uuid
from enum import Enum

class EMatchStatus(Enum):
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    CANCELLED = "cancelled"
    
class Match(BaseModel):
    id: uuid.UUID
    start_time: datetime
    end_time: Optional[datetime] = None
    total_time: Optional[int] = None
    status: EMatchStatus = EMatchStatus.PENDING
    map_name: Optional[str] = None
    kills: Optional[int] = None
    deads: Optional[int] = None
    players: Optional[list[uuid.UUID]] = None
    creator: Optional[str] = None
    
    class Config:
        from_attributes = True
        
class MatchCreateSchema(BaseModel):
    start_time: datetime
    end_time: Optional[datetime] = None
    status: EMatchStatus = EMatchStatus.PENDING
    map_name: Optional[str] = None
    creator: Optional[str] = None
    
    class Config:
        from_attributes = True
        
class MatchUpdateSchema(BaseModel):
    end_time: Optional[datetime] = None
    status: Optional[EMatchStatus] = None
    kills: Optional[int] = None
    deads: Optional[int] = None
    players: Optional[list[uuid.UUID]] = None
    
    class Config:
        from_attributes = True
        
class MatchResponseSchema(BaseModel):
    id: uuid.UUID
    start_time: datetime
    end_time: Optional[datetime] = None
    total_time: Optional[int] = None
    status: EMatchStatus = EMatchStatus.PENDING
    map_name: Optional[str] = None
    kills: Optional[int] = None
    deads: Optional[int] = None
    players: Optional[list[uuid.UUID]] = None
    creator: Optional[str] = None
    
    class Config:
        from_attributes = True