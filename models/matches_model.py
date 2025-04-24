from tortoise import fields
from tortoise.models import Model
import uuid

class Match(Model):
    id = fields.UUIDField(pk=True, default=uuid.uuid4)
    start_time = fields.DatetimeField()
    end_time = fields.DatetimeField(null=True)
    total_time = fields.IntField(null=True)
    status = fields.CharField(max_length=20, default="pending")
    map_name = fields.CharField(max_length=100, null=True)
    kills = fields.IntField(null=True)
    deads = fields.IntField(null=True)
    players = fields.JSONField(null=True)
    creator = fields.CharField(max_length=100, null=True)
    
    created_at = fields.DatetimeField(auto_now_add=True)
    updated_at = fields.DatetimeField(auto_now=True)

    def __str__(self):
        return f"<Match {self.id}>"

    class Meta:
        table = "matches"
        ordering = ["-start_time"]