from abc import ABC, abstractmethod
from typing import AsyncGenerator, Dict, List, Optional


class LLMProvider(ABC):
    @abstractmethod
    def generate_completion(
        self,
        system_prompt: Optional[str] = None,
        user_prompt: Optional[str] = None,
        messages: Optional[List[Dict]] = None,
        max_tokens: Optional[int] = 1000,
        response_format: Optional[Dict] = None,
    ) -> Dict:
        pass

    @abstractmethod
    def generate_stream(
        self,
        system_prompt: Optional[str] = None,
        user_prompt: Optional[str] = None,
        messages: Optional[List[Dict]] = None,
        max_tokens: Optional[int] = 1000,
    ) -> AsyncGenerator[Dict, None]:
        pass
