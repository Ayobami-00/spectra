from datetime import datetime, time
import json
from typing import Any, Dict, List
from src.assistants.agents.agent import Agent, AgentType
from src.assistants.llm.llm import LLMProvider


class HelperAgent(Agent):

    def __init__(
        self,
        name: str,
        llm: LLMProvider,
        additional_prompt: str,
    ):
        self.name = name
        self.agent_type = AgentType.HELPER
        self.llm = llm
        self.additional_prompt = additional_prompt

        super().__init__(
            name=self.name,
            llm=self.llm,
            additional_prompt=self.additional_prompt,
        )

        self.system_prompt = f"""
        
            You are a very helpful assistant.

            Help the user with their request by providing a detailed and accurate response.

            SOME ADDITIONAL INSTRUCTIONS:
            {self.additional_prompt}
            """

    async def respond(
        self,
        prompt: str,
    ):
        """Respond to a prompt"""

        result = self.llm.generate_stream(
            system_prompt=self.system_prompt,
            user_prompt=prompt,
            max_tokens=1000,
        )

        async for chunk in result:

            yield chunk
