from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class TaskCreate(BaseModel):
    task_id: Optional[str] = Field(None, description="Unique identifier for the task")
    workflow_id: Optional[str] = Field(None, description="Unique identifier for the workflow")
    step_id: Optional[str] = Field(None, description="Unique identifier for the step")
    class Config:
        json_schema_extra = {
            "example": {
                "task_id": "550e8400-e29b-41d4-a716-446655440000"
            }
        } 

class TaskResponse(BaseModel):
    task_id: str
    status: str
    message: str 

    class Config:
        json_schema_extra = {
            "example": {
                "task_id": "550e8400-e29b-41d4-a716-446655440000",
                "status": "creating",
                "message": "Workflow creation initiated",
                "workflow_id": "0e156a40-4cfe-4234-a68f-c143dbd35f2a",
                "step_id": "e01821ca-ca60-457f-8316-828d1c3ffa30"
            }
        }