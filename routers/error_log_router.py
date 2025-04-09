from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import APIKeyHeader
from services.error_log_service import error_log_service
from schemas.error_log_schema import ErrorLogResponse

router = APIRouter()
api_key_header = APIKeyHeader(name="X-API-Key")

async def validate_admin_key(api_key: str = Depends(api_key_header)):
    if api_key != "tu_super_secreto_admin_key":
        raise HTTPException(status_code=403, detail="Invalid API Key")

@router.get("/errors", response_model=list[ErrorLogResponse], dependencies=[Depends(validate_admin_key)])
async def get_errors(limit: int = 50):
    return await error_log_service.get_last_n(limit)