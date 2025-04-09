from tortoise import fields
from tortoise.models import Model
from schemas.user_schema import GenderEnum
import uuid
import bcrypt

def hash_password(plain_password: str) -> str:
    salt = bcrypt.gensalt()
    hashed_password = bcrypt.hashpw(plain_password.encode(), salt)
    return hashed_password.decode()

class User(Model):
    id = fields.UUIDField(pk=True, default=uuid.uuid4)
    username = fields.CharField(max_length=50, unique=True)
    password = fields.CharField(max_length=255)
    email = fields.CharField(max_length=255, unique=True)
    gender = fields.CharEnumField(GenderEnum)
    coins = fields.IntField(default=0)
    date_of_birth = fields.DatetimeField(null=True)
    las_connection = fields.DatetimeField(null=True)
    is_active = fields.BooleanField(default=True)
    is_premium = fields.BooleanField(default=False)
    
    matches_played = fields.IntField(default=0)
    wins = fields.IntField(default=0)
    kills = fields.IntField(default=0)
    inventory_capacity = fields.IntField(default=3)
    
    created_at = fields.DatetimeField(auto_now_add=True)
    updated_at = fields.DatetimeField(auto_now=True)
    deleted_at = fields.DatetimeField(null=True)
    
    def verify_password(self, plain_password: str) -> bool:
        return bcrypt.checkpw(plain_password.encode(), self.password.encode())

    async def save(self, *args, **kwargs):
        if not self.password.startswith("$2b$"):
            self.password = hash_password(self.password)
        await super().save(*args, **kwargs)

    def __str__(self):
        return f"<User {self.username}>"
    
    class Meta:
        table = "users"
        ordering = ["-created_at"]
        indexes = [
            ("username", "email"),
        ]
