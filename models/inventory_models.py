from tortoise import fields
from tortoise.models import Model
import uuid

class Inventory(Model):
    id = fields.UUIDField(pk=True, default=uuid.uuid4)
    user = fields.ForeignKeyField('models.User', related_name='inventory')
    item = fields.ForeignKeyField('models.Item', related_name='inventory')
    quantity = fields.IntField(default=1)
    created_at = fields.DatetimeField(auto_now_add=True)
    updated_at = fields.DatetimeField(auto_now=True)

    def __str__(self):
        return f"<Inventory {self.user.username} - {self.item.name} (x{self.quantity})>"

    class Meta:
        table = "inventory"
        ordering = ["-created_at"]
