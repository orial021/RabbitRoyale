from .user_router import user_router
from .item_router import item_router
from .inventory_router import inventory_router
from .auth_router import auth_router
from .matches_router import match_router

routers = [
    (user_router, '/user'),
    (item_router, '/item'),
    (inventory_router, '/inventory'),
    (auth_router, '/auth'),
    (match_router, '/matches')
]