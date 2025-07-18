import json
from redis import Redis
from fastapi import WebSocket
from src.core.config import settings


class RedisWebSocket:
    """A Redis-backed WebSocket proxy"""

    def __init__(self, session_id: str):
        self.session_id = session_id
        self.redis_client = Redis(
            host=settings.REDIS_HOST,
            port=settings.REDIS_PORT,
            db=0,
            username=settings.REDIS_USERNAME,
            password=settings.REDIS_PASSWORD,
        )

    async def send_text(self, data: str):
        # Push message to Redis list
        self.redis_client.rpush(f"websocket:{self.session_id}", data)


    def store_session(self, session_id: str):
        self.redis_client.set(f"session_active:{session_id}", "1")


    def remove_session(self, session_id: str):
        self.redis_client.delete(f"session_active:{session_id}")


    def is_session_active(self, session_id: str) -> bool:
        return bool(self.redis_client.get(f"session_active:{session_id}"))
