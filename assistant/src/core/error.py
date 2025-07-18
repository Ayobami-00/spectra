from fastapi.applications import FastAPI

from starlette import status
from starlette.requests import Request
from starlette.responses import JSONResponse


class InvalidRequest(Exception):
    pass


# The object does not exist in the database when queried by ID or name
class MissingResource(Exception):
    pass


# It exists, but the user does not have permission to do anything with it
class MissingPermission(Exception):
    pass


class InvalidLogin(Exception):
    pass


class InactiveAccount(Exception):
    pass


class InvalidToken(Exception):
    pass


class NotAuthenticated(Exception):
    pass


class AuthenticationError(Exception):
    """Raised when authentication with the backend fails"""
    pass


class APIError(Exception):
    """Raised when API calls to the backend fail"""
    pass


class TaskProcessingError(Exception):
    """Raised when task processing fails"""
    pass


async def not_authenticated_exception_handler(request: Request, exc: NotAuthenticated):
    return JSONResponse(status_code=401, content={"message": "Not authenticated"})


async def invalid_token_exception_handler(request: Request, exc: InvalidToken):
    return JSONResponse(
        status_code=401, content={"message": "Not authenticated, Invalid Token"}
    )


async def inactive_account_exception_handler(
    request: Request, exception: InactiveAccount
):
    return JSONResponse(
        status_code=401, content={"message": "Not authenticated, Account isn't active"}
    )


async def missing_resource_exception_handler(
    request: Request, exception: MissingResource
):
    return JSONResponse(status_code=404, content={"message": "No such resource"})


async def missing_premission_exception_handler(
    request: Request, exception: MissingPermission
):
    return JSONResponse(
        status_code=403, content={"message": "No permissions for resource"}
    )


async def invalid_login_exception_handler(request: Request, exception: InvalidLogin):
    return JSONResponse(
        status_code=401, content={"message": "Invalid username or password"}
    )


async def bad_request_exception_handler(request: Request, exception: InvalidRequest):
    return JSONResponse(status_code=400, content={"message": "Invalid request"})


def generic_error_response(status_code: int, message: str):
    return JSONResponse(status_code=status_code, content={"status": "success" if status_code == 200 or status_code == 201 else "failed", "message": message})

async def authentication_error_handler(request: Request, exception: AuthenticationError):
    return JSONResponse(status_code=401, content={"message": "Authentication failed"})

async def api_error_handler(request: Request, exception: APIError):
    return JSONResponse(status_code=500, content={"message": "API call failed"})    

async def task_processing_error_handler(request: Request, exception: TaskProcessingError):
    return JSONResponse(status_code=500, content={"message": "Task processing failed"})

exception_handlers = {
    NotAuthenticated: not_authenticated_exception_handler,
    InvalidLogin: invalid_login_exception_handler,
    InvalidRequest: bad_request_exception_handler,
    MissingPermission: missing_premission_exception_handler,
    MissingResource: missing_resource_exception_handler,
    InactiveAccount: inactive_account_exception_handler,
    AuthenticationError: authentication_error_handler,
    APIError: api_error_handler,
    InvalidToken: invalid_token_exception_handler,
    TaskProcessingError: task_processing_error_handler,
}
