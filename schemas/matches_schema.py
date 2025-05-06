from datetime import datetime
from typing import Optional, Dict
from pydantic import BaseModel

class Match(BaseModel):
    id: int
    start_time: Optional[datetime] = None
    end_time: Optional[datetime] = None
    total_time: int = 300
    status: Optional[str] = "pending"
    map_name: Optional[str] = "Normal"
    kills: Optional[int] = None
    deads: Optional[int] = None
    players: Optional[Dict[str, Dict[str, int]]] = None
    creator: Optional[str] = None
    
    class Config:
        from_attributes = True
        
class MatchCreateSchema(BaseModel):
    status: Optional[str] = "pending"
    total_time: int = 300
    map_name: Optional[str] = "Normal"
    creator: Optional[str] = None
    players: Optional[Dict[str, Dict[str, int]]] = None
    
    class Config:
        from_attributes = True
        
class MatchUpdateSchema(BaseModel):
    kills: Optional[int] = None
    deads: Optional[int] = None
    players: Optional[Dict[str, Dict[str, int]]] = None
    status: Optional[str] = "pending"
    
    model_config = {
        'json_schema_extra': {
            'example': {
                'status': 'in_progress',
                'kills': 5,
                'deads': 2,
                'players': {
                    'player1': {'kills': 3, 'deads': 1},
                    'player2': {'kills': 2, 'deads': 1}
                }
            }
        }
    }
        
class MatchResponseSchema(BaseModel):
    id: int
    start_time: Optional[datetime] = None
    end_time: Optional[datetime] = None
    total_time: Optional[int] = None
    status: Optional[str] = "pending"
    map_name: Optional[str] = None
    kills: Optional[int] = None
    deads: Optional[int] = None
    players: Optional[Dict[str, Dict[str, int]]] = None
    creator: Optional[str] = None
    
    class Config:
        from_attributes = True