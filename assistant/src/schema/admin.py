from enum import Enum
from typing import List, Optional, Any, Dict, Union
import uuid

from pydantic import BaseModel


class AdminLoginIn(BaseModel):

    username: str
    password: str


class AdminOut(BaseModel):

    company_name: Optional[str] = ""
    company_accent_color: Optional[str] = ""
    company_logo_url: Optional[str] = ""
    webhook_url: Optional[str] = ""
