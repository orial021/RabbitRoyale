from fastapi import  Request, status, HTTPException
from fastapi.responses import JSONResponse
from starlette.middleware.base import BaseHTTPMiddleware
import traceback
from models.error_log_model import ErrorLog


class HTTPErrorHandler(BaseHTTPMiddleware):  
    async def dispatch(self, request: Request, call_next):
        try:
            print("se salta el middle")
            return await call_next(request)
        except HTTPException as http_exc:
            print("error http_exc")
            error_info = {
                'error_type': 'HTTPException',
                'message': http_exc.detail,
                'traceback': traceback.format_exc()[35:],
                'url': str(request.url),
                'status_code': http_exc.status_code,
            }
            await ErrorLog.create(**error_info)
            return JSONResponse(content = {'detail' : http_exc.detail},
                                status_code = http_exc.status_code)
        except Exception as e:
            print("error e")
            error_info = {
                'error_type': type(e).__name__,
                'message': str(e),
                'traceback': traceback.format_exc()[35:],
                'url': str(request.url), 
                'status_code': status.HTTP_500_INTERNAL_SERVER_ERROR
            }
            await ErrorLog.create(**error_info)
            
            content = {'detail' : f'Unhandled server error: {str(e)}'}
            return JSONResponse(content = content, status_code = status.HTTP_500_INTERNAL_SERVER_ERROR)