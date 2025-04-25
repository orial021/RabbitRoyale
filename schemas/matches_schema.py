from datetime import datetime
from typing import Optional
from pydantic import BaseModel
from utils import EMatchStatus, EMapName, EMatchTime

class Match(BaseModel):
    id: int
    start_time: datetime
    end_time: Optional[datetime] = None
    total_time: EMatchTime = EMatchTime.NORMAL
    status: EMatchStatus = EMatchStatus.PENDING
    map_name: EMapName = EMapName.MAP1
    kills: Optional[int] = None
    deads: Optional[int] = None
    players: Optional[list[str]] = None
    creator: Optional[str] = None
    
    class Config:
        from_attributes = True
        
class MatchCreateSchema(BaseModel):
    status: EMatchStatus = EMatchStatus.PENDING
    total_time: EMatchTime = EMatchTime.NORMAL
    map_name: EMapName = EMapName.MAP1
    creator: Optional[str] = None
    players: Optional[list[str]] = None
    
    class Config:
        from_attributes = True
        
class MatchUpdateSchema(BaseModel):
    end_time: Optional[datetime] = None
    status: Optional[EMatchStatus] = None
    kills: Optional[int] = None
    deads: Optional[int] = None
    players: Optional[list[str]] = None
    
    class Config:
        from_attributes = True
        
class MatchResponseSchema(BaseModel):
    id: int
    start_time: datetime
    end_time: Optional[datetime] = None
    total_time: Optional[int] = None
    status: EMatchStatus = EMatchStatus.PENDING
    map_name: Optional[str] = None
    kills: Optional[int] = None
    deads: Optional[int] = None
    players: Optional[list[str]] = None
    creator: Optional[str] = None
    
    class Config:
        from_attributes = True