from enum import Enum
from typing import Dict, Optional
import uuid
from pydantic import BaseModel

class APIToMonitor(BaseModel):
    api_url: str