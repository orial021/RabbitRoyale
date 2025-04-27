from tortoise import fields
from tortoise.models import Model

class Match(Model):
    id = fields.IntField(pk=True)
    start_time = fields.DatetimeField(null = True)
    end_time = fields.DatetimeField(null=True)
    total_time = fields.IntField(default = 300)
    status = fields.CharField(max_length=50, default="pending")
    map_name = fields.CharField(max_length=100, default="Normal")
    kills = fields.IntField(null=True)
    deads = fields.IntField(null=True)
    players = fields.JSONField(
        null=True,
        default=dict
        )
    creator = fields.CharField(max_length=100, null=True)
    
    created_at = fields.DatetimeField(auto_now_add=True)
    updated_at = fields.DatetimeField(auto_now=True)

    def __str__(self):
        return f"<Match {self.id}>"

    class Meta:
        table = "matches"
        ordering = ["-start_time"]