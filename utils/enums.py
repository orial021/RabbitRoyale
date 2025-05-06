from enum import Enum

class EMatchStatus(str, Enum):
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    CANCELLED = "cancelled"

class EMapName(Enum):
    MAP1 = "Normal"
    MAP2 = "Suden Death"
    MAP3 = "Death Match"
    MAP4 = "Team Death Match"
    
class EMatchTime(Enum):
    NORMAL = 300      # 5 minutos
    SUDDEN_DEATH = 180  # 3 minutos
    DEATH_MATCH = 600   # 10 minutos
    TEAM_DEATH = 480    # 8 minutos