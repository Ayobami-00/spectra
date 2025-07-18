from datetime import datetime
from typing import Dict, List, Optional, AsyncGenerator
import json
from openai import NOT_GIVEN, OpenAI
from pydantic import BaseModel
from src.assistants.llm.llm import LLMProvider
import asyncio


class OpenAIProvider(LLMProvider):
    def __init__(self, api_key: str, model: str = "gpt-4o"):
        self.model = model
        # Initialize the client with the API key
        self.client = OpenAI(api_key=api_key)

    async def generate_stream(
        self,
        system_prompt: Optional[str] = None,
        user_prompt: Optional[str] = None,
        messages: Optional[List[Dict]] = None,
        max_tokens: Optional[int] = 1000,
    ) -> AsyncGenerator[Dict, None]:
        """Generate streaming completion using OpenAI API"""
        try:
            if system_prompt and user_prompt:
                messages = [
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": user_prompt},
                ]
            elif messages:
                messages = messages
            else:
                raise ValueError(
                    "Either system_prompt and user_prompt or messages must be provided"
                )
        

            # Create the completion with sync client and iterate over chunks
            for chunk in self.client.chat.completions.create(
                model=self.model,
                messages=messages,
                stream=True,
                max_tokens=max_tokens,
            ):
                if chunk.choices[0].delta.content is not None:
                    yield chunk.choices[0].delta.content
                    # Use asyncio.sleep to make this async-friendly
                    await asyncio.sleep(0)

        except Exception as e:
            raise Exception(f"OpenAI API error: {str(e)}")

    # @retry(stop=stop_after_attempt(3), wait=wait_exponential(min=1, max=10))
    def generate_completion(
        self,
        system_prompt: Optional[str] = None,
        user_prompt: Optional[str] = None,
        messages: Optional[List[Dict]] = None,
        max_tokens: Optional[int] = 1000,
        response_format: Optional[Dict] = None,
    ) -> Dict:
        """Generate completion using OpenAI API"""
        try:
            if messages and len(messages) > 0:

                messages = messages

            elif system_prompt and user_prompt:
                messages = [
                    {
                        "role": "system",
                        "content": system_prompt,
                        "timestamp": datetime.now().isoformat(),
                    },
                    {
                        "role": "user",
                        "content": user_prompt,
                        "timestamp": datetime.now().isoformat(),
                    },
                ]
            else:
                raise ValueError(
                    "Either system_prompt and user_prompt or messages must be provided"
                )

            # Convert tools to OpenAI schem

            if response_format:

                response = self.client.beta.chat.completions.parse(
                    model=self.model,
                    messages=messages,
                    max_tokens=max_tokens,
                    response_format=response_format
                )

            else:
                response = self.client.chat.completions.create(
                    model=self.model,
                    messages=messages,
                    max_tokens=max_tokens,
                )

            return response

        except Exception as e:
            raise Exception(f"OpenAI API error: {str(e)}")
