import logging

import os

import logging.config

from typing import Dict, Optional, Type, Union, Callable

from fastapi import FastAPI, exception_handlers, status, Request
from fastapi.staticfiles import StaticFiles
from fastapi.responses import JSONResponse
from fastapi_versioning import VersionedFastAPI
from starlette.exceptions import ExceptionMiddleware
from starlette.middleware.cors import CORSMiddleware
from starlette.routing import Mount

from src.core.container import Container
from src.api.api import router, ws_router
from src.core.error import exception_handlers
from src.core.config import settings

import time
import os

environment = os.environ.get("ENVIRONMENT", "DEVELOPMENT")

# if environment == "PRODUCTION":
#     sentry_sdk.init(
#     dsn=settings.SENTRY_DSN,
#     environment=os.environ.get("ENVIRONMENT", "DEVELOPMENT"),
#     traces_sample_rate=settings.SENTRY_TRACES_SAMPLE_RATE,
# )


# setup loggers
# logging.config.fileConfig("src/logging.conf", disable_existing_loggers=False)


# get root logger
# the __name__ resolve to "main" since we are at the root of the project.
logger = logging.getLogger(__name__)
# This will get the root logger since no logger in the configuration has this name.



def version_app(
    app: FastAPI,
    exception_handlers: Optional[Dict[Union[int, Type[Exception]], Callable]],
    **kwargs,
):
    app = VersionedFastAPI(
        app,
        version_format="{major}",
        prefix_format= "/v{major}",
        exception_handlers=exception_handlers,
        **kwargs,
    )

    # Hack: Register exception handlers in all mounted subapps
    # We need this workaround because fastapi-versioning is not passing them downstream to sub-apps by default
    mounted_routes = [route for route in app.routes if isinstance(route, Mount)]

    if exception_handlers is not None:
        for mounted_route in mounted_routes:
            for exc, exc_handler in exception_handlers.items():
                mounted_route.app.add_exception_handler(exc, exc_handler)

    return app


def create_app():
    container = Container()
    container.init_resources()

    app = FastAPI(
        title=settings.API_TITLE,
        root_path=settings.API_ROOT_PATH,
    )

    app.include_router(router)

    app.include_router(ws_router)

    app = version_app(app, exception_handlers=exception_handlers)
    
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    # if environment == "PRODUCTION":
    #       app.add_middleware(SentryAsgiMiddleware)
    

    return app
