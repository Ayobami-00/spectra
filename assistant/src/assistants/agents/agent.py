import asyncio
import uuid
from datetime import datetime
from typing import Dict, Any, List
from src.assistants.llm.llm import LLMProvider
from enum import Enum


class AgentType(Enum):
    HELPER = "helper"
    SUGGESTIONS_EXTRACTOR = "suggestions_extractor"

class Agent:
    def __init__(self, llm: LLMProvider, name: str, additional_prompt: str):
        self.llm = llm
        self.name = name
        self.id = f"{name}_{uuid.uuid4()}"
        self.additional_prompt = additional_prompt

    async def respond(
        self,
        prompt: str,
    ):
        """Execute a task with continuous LLM interaction"""
        try:
            pass

        except Exception as e:
            print(f"Error executing task: {e}")
