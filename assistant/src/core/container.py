from dependency_injector import containers, providers
from typing import AsyncGenerator

from src.assistants.agents.agent import AgentType
from src.assistants.llm.llm import LLMProvider
from src.assistants.agents.helper import HelperAgent
from src.service.backend_service import BackendService

from .config import settings


class Container(containers.DeclarativeContainer):

    wiring_config = containers.WiringConfiguration(
        modules=[
            "src.api.v1.endpoints.session",
            "src",
        ]
    )
    # Configuration
    config = providers.Configuration()

    # Core Services
    backend_service = providers.Singleton(BackendService)

    llm_provider = providers.Singleton(LLMProvider)

    helper_agent = providers.Singleton(
        HelperAgent,
        name=AgentType.HELPER,
        llm=llm_provider,
        additional_prompt="",
    )
