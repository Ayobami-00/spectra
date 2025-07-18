import os
from pathlib import Path
from typing import List

from dotenv import load_dotenv
from pydantic import BaseSettings

path = Path.cwd()

env_path = path / ".env"

load_dotenv(dotenv_path=env_path)

ENVIRONMENT = os.environ.get("ENVIRONMENT", "DEVELOPMENT")


backend_api_url = None
backend_admin_email = None
backend_admin_password = None
redis_host = None
redis_port = None
redis_username = None
redis_password = None
openai_api_key = None
openai_model = None
api_key = None
livekit_url = None
livekit_api_key = None
livekit_api_secret = None

if ENVIRONMENT == "PRODUCTION":
    """
    set prod environment variables

    """

    backend_api_url = os.getenv("BACKEND_API_URL")
    backend_admin_email = os.getenv("BACKEND_ADMIN_EMAIL")
    backend_admin_password = os.getenv("BACKEND_ADMIN_PASSWORD")
    redis_host = os.getenv("REDIS_HOST")
    redis_port = os.getenv("REDIS_PORT")
    redis_username = os.getenv("REDIS_USERNAME")
    redis_password = os.getenv("REDIS_PASSWORD")
    openai_api_key = os.getenv("OPENAI_API_KEY")
    openai_model = os.getenv("OPENAI_MODEL", "gpt-4")
    api_key = os.getenv("API_KEY")
    livekit_url = os.getenv("LIVEKIT_URL")
    livekit_api_key = os.getenv("LIVEKIT_API_KEY")
    livekit_api_secret = os.getenv("LIVEKIT_API_SECRET")
    pass

elif ENVIRONMENT == "DEVELOPMENT" or ENVIRONMENT == "LOCAL":
    """
    set dev environment variables

    """

    backend_api_url = os.getenv("BACKEND_API_URL")
    backend_admin_email = os.getenv("BACKEND_ADMIN_EMAIL")
    backend_admin_password = os.getenv("BACKEND_ADMIN_PASSWORD")
    redis_host = os.getenv("REDIS_HOST")
    redis_port = os.getenv("REDIS_PORT")
    redis_username = os.getenv("REDIS_USERNAME")
    redis_password = os.getenv("REDIS_PASSWORD")
    openai_api_key = os.getenv("OPENAI_API_KEY")
    openai_model = os.getenv("OPENAI_MODEL", "gpt-4")
    api_key = os.getenv("API_KEY")
    livekit_url = os.getenv("LIVEKIT_URL")
    livekit_api_key = os.getenv("LIVEKIT_API_KEY")
    livekit_api_secret = os.getenv("LIVEKIT_API_SECRET")

else:
    pass


class Settings(BaseSettings):
    """
    Set config variables on settings class

    """

    ENVIRONMENT = ENVIRONMENT
    API_TITLE: str = os.environ.get("API_TITLE", "SPECTRA ASSISTANT SERVICE API")
    API_ROOT_PATH: str = os.environ.get("API_ROOT_PATH", "/api")
    BACKEND_API_URL: str = backend_api_url
    BACKEND_ADMIN_EMAIL: str = backend_admin_email
    BACKEND_ADMIN_PASSWORD: str = backend_admin_password
    REDIS_HOST: str = redis_host
    REDIS_PORT: int = redis_port
    REDIS_USERNAME: str = redis_username
    REDIS_PASSWORD: str = redis_password
    OPENAI_API_KEY: str = openai_api_key
    OPENAI_MODEL: str = openai_model
    API_KEY: str = api_key
    LIVEKIT_URL: str = None
    LIVEKIT_API_KEY: str = None
    LIVEKIT_API_SECRET: str = None


settings = Settings()
