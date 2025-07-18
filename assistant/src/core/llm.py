import json
from typing import List, Dict, Any, Optional
from abc import ABC, abstractmethod
from openai import NOT_GIVEN, AsyncOpenAI
from tenacity import retry, stop_after_attempt, wait_exponential


class LLMProvider(ABC):
    @abstractmethod
    async def generate_completion(
        self,
        system_prompt: Optional[str] = None,
        user_prompt: Optional[str] = None,
        functions: Optional[List[Dict]] = None,
        messages: Optional[List[Dict]] = None,
    ) -> Dict:
        pass


class OpenAIProvider(LLMProvider):
    def __init__(self, api_key: str, model: str = "gpt-4"):
        self.model = model
        # Initialize the client with the API key
        self.client = AsyncOpenAI(api_key=api_key)

    # @retry(stop=stop_after_attempt(3), wait=wait_exponential(min=1, max=10))
    async def generate_completion(
        self,
        system_prompt: Optional[str] = None,
        user_prompt: Optional[str] = None,
        functions: List[Dict] = None,
        messages: Optional[List[Dict]] = None,
    ) -> Dict:
        """Generate completion using OpenAI API"""
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

            response = await self.client.chat.completions.create(
                model=self.model,
                messages=messages,
                tools=(
                    NOT_GIVEN
                    if functions is None or len(functions) == 0
                    else [
                        {"type": "function", "function": f} for f in (functions or [])
                    ]
                ),
                tool_choice=(
                    NOT_GIVEN
                    if functions is None or len(functions) == 0
                    else {"type": "function", "function": {"name": "create_workflow"}}
                ),
            )

            # Extract the function call response
            if functions and response.choices[0].message.tool_calls:
                tool_call = response.choices[0].message.tool_calls[0]
                return json.loads(tool_call.function.arguments)

            return response.choices[0].message.content

        except Exception as e:
            raise Exception(f"OpenAI API error: {str(e)}")
