from tortoise import fields
from tortoise.models import Model

class ErrorLog(Model):
    id = fields.IntField(pk=True)
    error_type = fields.CharField(max_length=100)
    message = fields.TextField()
    traceback = fields.TextField()
    url = fields.TextField()
    status_code = fields.CharField(max_length=15, null = True)
    created_at = fields.DatetimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.error_type} - {self.message}"
    
    class Meta:
        table = "error_log"