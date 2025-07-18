from datetime import datetime, time
import json
from typing import Any, Dict, List

from pydantic import BaseModel
from src.assistants.agents.agent import Agent, AgentType
from src.assistants.llm.llm import LLMProvider


class Suggestions(BaseModel):
    suggestions: list[str]


class SuggestionsExtractorAgent(Agent):

    def __init__(
        self,
        name: str,
        llm: LLMProvider,
        additional_prompt: str,
    ):
        self.name = name
        self.agent_type = AgentType.SUGGESTIONS_EXTRACTOR
        self.llm = llm
        self.additional_prompt = additional_prompt

        super().__init__(
            name=self.name,
            llm=self.llm,
            additional_prompt=self.additional_prompt,
        )

        self.system_prompt = f"""
        
            You are a very helpful and suqggestion extractor

            Based on the user's interaction, extract relevant suggestions for next steps based on these functions;

            - Exporting content to PDF/DOC
            - Creating flashcards for learning
            - Sending summaries or content via email.

            For example, if a user is learning about a new topic, you might suggest creating flashcards for learning.

            If a user is reading a book, you might suggest exporting the content to PDF/DOC.

            If a user is reading a book, you might suggest summarizing the content via email.

            Make sure the suggestion are 5 to 6 words long and relevant to the user's interaction.

            SOME ADDITIONAL INSTRUCTIONS:
            {self.additional_prompt}
            """

    def respond(
        self,
        prompt: str,
    ):
        """Respond to a prompt"""

        result = self.llm.generate_completion(
            system_prompt=self.system_prompt,
            user_prompt=prompt,
            max_tokens=1000,
            response_format=Suggestions,
        )

        return result.choices[0].message.parsed

