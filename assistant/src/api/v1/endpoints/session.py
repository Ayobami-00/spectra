# internal lib imports
import asyncio
from base64 import b64encode
import json
import os
import logging
from datetime import datetime
import uuid
from dependency_injector.wiring import Provide, inject

# external lib imports
from typing import List, Optional, Dict, Any

# fast api imports
from fastapi_versioning import version
from fastapi.responses import JSONResponse
from fastapi import (
    APIRouter,
    Form,
    Header,
    Depends,
    Request,
    BackgroundTasks,
    HTTPException,
)
from fastapi.security import APIKeyHeader


# core imports
from src.service.backend_service import BackendService
from src.core.config import settings
from src.core.error import InvalidToken, MissingPermission, MissingResource
from src.core.container import Container
from src.core import error
from src.schema.task import TaskCreate, TaskResponse

# crud imports

# model imports

# schema imports
from src.schema.admin import AdminOut

# utils imports
from src.utils.auth import verify_api_key
from src.utils import constants

# Simple logger setup using existing configuration
logger = logging.getLogger(__name__)
import os
from livekit import api

router = APIRouter(prefix="/session")


@router.post("/{session_id}/token", status_code=200)
@version(1)
@inject
async def get_session_token(
    session_id: str,
    api_key: str = Depends(verify_api_key),
) -> Dict[str, str]:
    """
    Generate a LiveKit token for a specific session
    """

    backend_service = BackendService()
    # Fetch previous messages
    messages = backend_service.get_session_messages(session_id, is_public=True)

    print("messages", len(messages))

    if len(messages) >= constants.MAX_MESSAGES_LIMIT_PUBLIC_SESSION:

        raise HTTPException(
            status_code=403, detail=constants.MAX_MESSAGES_ERROR_MESSAGE
        )

    logger.info(f"Retrieving token for session_id: {session_id}")

    token = (
        api.AccessToken(os.getenv("LIVEKIT_API_KEY"), os.getenv("LIVEKIT_API_SECRET"))
        .with_identity("identity")
        .with_name(f"user_{session_id}")
        .with_grants(
            api.VideoGrants(
                room_join=True,
                room=session_id,
            )
        )
    )

    # Ensure we return a properly structured dictionary
    return {"token": str(token.to_jwt())}  # Convert token to string explicitly
