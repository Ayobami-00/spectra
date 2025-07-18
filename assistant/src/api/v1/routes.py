from fastapi import APIRouter

from .endpoints import session_router

router = APIRouter()
router.include_router(session_router, tags=["session"])
