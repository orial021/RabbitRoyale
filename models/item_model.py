from tortoise import fields
from tortoise.models import Model
import uuid

class Item(Model):
    id = fields.UUIDField(pk=True, default=uuid.uuid4)
    image_path = fields.CharField(max_length=255, null=True)
    name = fields.CharField(max_length=100)
    description = fields.TextField()
    type = fields.CharField(max_length=50)
    rarity = fields.CharField(max_length=50)
    value = fields.IntField()
    created_at = fields.DatetimeField(auto_now_add=True)
    updated_at = fields.DatetimeField(auto_now=True)
    deleted_at = fields.DatetimeField(null=True)
    
    def __str__(self):
        return f"<Item {self.name}>"

    class Meta:
        table = "items"
        ordering = ["-created_at"]
