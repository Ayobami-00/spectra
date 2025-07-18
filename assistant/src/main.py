from typing import List
import uuid
from fastapi import WebSocket, Depends
from src.assistants.agents.suggestions_extractor import SuggestionsExtractorAgent
from src.assistants.agents.agent import AgentType as AgentType
from src.assistants.llm.openai import OpenAIProvider
from src.assistants.agents.helper import HelperAgent
from src.service.backend_service import BackendService
from src.core.container import Container
from src.core.setup import create_app
import asyncio
from src.core.config import settings  # Assuming you have a config module
from dependency_injector.wiring import Provide, inject
import json
from fastapi import WebSocketDisconnect
from livekit import rtc
from livekit.agents import (
    AutoSubscribe,
    JobContext,
    WorkerOptions,
    cli,
    llm,
)
from livekit.agents.multimodal import MultimodalAgent
from livekit.agents.pipeline import VoicePipelineAgent, AgentTranscriptionOptions
from livekit.agents.llm import ChatMessage, ChatImage
from livekit.plugins import openai
import uvloop
from src.utils.redis_ws import RedisWebSocket


from src.utils.data_context import data_context
from src.utils import constants

# Before creating the app, set the event loop policy
asyncio.set_event_loop_policy(uvloop.EventLoopPolicy())

app = create_app()


async def get_video_track(room: rtc.Room):
    """Find and return the first available remote video track in the room."""
    for participant_id, participant in room.remote_participants.items():
        for track_id, track_publication in participant.track_publications.items():
            if track_publication.track and isinstance(
                track_publication.track, rtc.RemoteVideoTrack
            ):
                print(
                    f"Found video track {track_publication.track.sid} "
                    f"from participant {participant_id}"
                )
                return track_publication.track
    raise ValueError("No remote video track found in the room")


async def get_latest_image(room: rtc.Room):
    """Capture and return a single frame from the video track."""
    video_stream = None
    try:
        video_track = await get_video_track(room)
        video_stream = rtc.VideoStream(video_track)
        async for event in video_stream:
            print("Captured latest video frame")
            return event.frame
    except Exception as e:
        print(f"Failed to get latest image: {e}")
        return None
    finally:
        if video_stream:
            await video_stream.aclose()


async def before_llm_cb(assistant: VoicePipelineAgent, chat_ctx: llm.ChatContext):
    """
    Callback that runs right before the LLM generates a response.
    Captures the current video frame and adds it to the conversation context.
    """
    try:
        if not hasattr(assistant, "_room"):
            print("Room not available in assistant")
            return
        latest_image = await get_latest_image(assistant._room)
        if latest_image:
            image_content = [ChatImage(image=latest_image)]
            chat_ctx.messages.append(ChatMessage(role="user", content=image_content))
            print("Added latest frame to conversation context")
        else:
            print("No image captured from video stream")
    except Exception as e:
        print(f"Error in before_llm_cb: {e}")


async def run_multimodal_agent(ctx: JobContext):
    """Initialize and start the voice agent"""

    print("starting multimodal agent")

    initial_ctx = llm.ChatContext().append(
        role="system",
        text=(
            "You are a very helpful voice assistant that can both see and hear. "
            "You should use short and concise responses, avoiding unpronounceable punctuation. "
            "When you see an image in our conversation, naturally incorporate what you see "
            "into your response. Keep visual descriptions brief but informative."
            "Do not tell the user that you are seeing an image, just use it in your response "
            "as if you are seeing it. "
            "You should be able to answer any question the user asks you."
        ),
    )

    print(f"connecting to room {ctx.room.name}")

    await ctx.connect(auto_subscribe=AutoSubscribe.SUBSCRIBE_ALL)

    # Wait for the first participant to connect
    participant = await ctx.wait_for_participant()
    print(f"starting voice assistant for participant {participant.identity}")

    # Configure the voice pipeline agent
    agent = VoicePipelineAgent(
        vad=ctx.proc.userdata["vad"],
        stt=openai.STT(),
        llm=openai.LLM(),
        tts=openai.TTS(),
        chat_ctx=initial_ctx,
        before_llm_cb=before_llm_cb,  # Add the callback here
    )

    llm_provider = OpenAIProvider(
        model="gpt-4o-mini",
        api_key=settings.OPENAI_API_KEY,
    )

    helper_agent = HelperAgent(
        name=AgentType.HELPER,
        llm=llm_provider,
        additional_prompt="",
    )

    session_id = ctx.room.name

    async def on_transcript(
        transcript: str, is_user: bool, session_id: str, llm_provider, helper_agent
    ):
        print(f"New transcript: {transcript}")

        backend_service = BackendService()

        websocket = RedisWebSocket(session_id)

        message_dict = {
            "role": "assistant" if not is_user else "user",
            "content": transcript.content,
        }

        # await websocket.send_text(json.dumps(message_dict))

    agent.on(
        "user_speech_committed",
        lambda transcript: asyncio.create_task(
            on_transcript(transcript, True, session_id, llm_provider, helper_agent)
        ),
    )
    agent.on(
        "agent_speech_committed",
        lambda transcript: asyncio.create_task(
            on_transcript(transcript, False, session_id, llm_provider, helper_agent)
        ),
    )

    agent.start(ctx.room, participant)

    await agent.say(
        "Hey! Welcome to Companion Mode. How can I help you today?",
        allow_interruptions=True,
    )


class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def broadcast(self, message: str):
        for connection in self.active_connections:
            await connection.send_text(message)


manager = ConnectionManager()


@app.websocket("/ws/public/session/{session_id}")
async def websocket_endpoint(websocket: WebSocket, session_id: uuid.UUID):
    try:
        await websocket.accept()
        print("Connected to websocket", session_id)

        # redis_ws = RedisWebSocket(session_id)

        # # Store session in Redis
        # redis_ws.store_session(str(session_id))

        backend_service = BackendService()

        llm_provider = OpenAIProvider(
            model="gpt-4o-mini",
            api_key=settings.OPENAI_API_KEY,
        )

        helper_agent = HelperAgent(
            name=AgentType.HELPER,
            llm=llm_provider,
            additional_prompt="",
        )

        # Start message polling loop
        while True:
            # Also check for WebSocket messages
            try:
                data = await websocket.receive_text()

                if not data or data == "KEEP_ALIVE":
                    continue

                print("data", data)

                data = json.loads(data)

                await handle_agent_response(
                    content=data["content"],
                    session_id=session_id,
                    backend_service=backend_service,
                    websocket=websocket,
                    llm_provider=llm_provider,
                    helper_agent=helper_agent,
                    is_user=True,
                )

                # if (
                #     data.get("content")
                #     and isinstance(data["content"], str)
                #     and "[VOICE_" in data["content"]
                # ):

                #     is_voice_agent = "[VOICE_AGENT]" in data["content"]

                #     message_content = (
                #         data["content"]
                #         .replace("[VOICE_AGENT] ", "")
                #         .replace("[VOICE_USER] ", "")
                #     )

                #     print("Processing voice message:", message_content)

                #     backend_service.store_message(
                #         session_id=session_id,
                #         role="assistant" if is_voice_agent else "user",
                #         content=message_content,
                #         is_public=True,
                #     )

                # else:

            except WebSocketDisconnect:
                # Don't close the websocket here, let the finally block handle it
                break

    finally:
        # Only close the websocket and clean up resources once
        # redis_ws.remove_session(str(session_id))
        if not websocket.client_state.DISCONNECTED:  # Check if not already disconnected
            await websocket.close()


async def handle_agent_response(
    content: str,
    session_id: uuid.UUID,
    backend_service: BackendService,
    websocket: WebSocket,
    llm_provider: OpenAIProvider,
    helper_agent: HelperAgent,
    is_user: bool = False,
):

    session_id = str(session_id)

    # Fetch previous messages
    messages = backend_service.get_session_messages(session_id, is_public=True)


    if len(messages) >= constants.MAX_MESSAGES_LIMIT_PUBLIC_SESSION:

        full_response = ""

        for chunk in constants.MAX_MESSAGES_ERROR_MESSAGE.split(" "):

            if chunk.strip() != "":
                chunk += " "
            full_response += chunk
            message_dict = {
                "has_reached_limit": True,
                "role": "assistant",
                "content": chunk,
            }

            await websocket.send_text(json.dumps(message_dict))

        await websocket.send_text(
            json.dumps(
                {
                    "has_reached_limit": True,
                    "role": "assistant",
                    "content": "DONE",
                }
            )
        )

    else:

        # Generate and stream response
        full_response = ""
        async for chunk in helper_agent.respond(
            prompt=f"""
                    Given the following previous interaction with the user:
                    {messages}

                    Respond to the following message:
                    {content}
                    """
        ):
            full_response += chunk
            message_dict = {
                "role": "assistant",
                "content": chunk,
            }

            await websocket.send_text(json.dumps(message_dict))

        await websocket.send_text(
            json.dumps(
                {
                    "role": "assistant",
                    "content": "DONE",
                }
            )
        )

        suggestions_extractor_agent = SuggestionsExtractorAgent(
            name=AgentType.SUGGESTIONS_EXTRACTOR,
            llm=llm_provider,
            additional_prompt="",
        )

        suggestions = suggestions_extractor_agent.respond(
            prompt=f"""
                    Based on the following previous interaction with the user:
                    {messages}

                    Extract relevant suggestions for next steps:
                    {full_response}
                    """
        )

        print("Suggestions", suggestions)
        await websocket.send_text(
            json.dumps(
                {
                    "type": "suggestions",
                    "suggestions": suggestions.suggestions,
                }
            )
        )

    backend_service.store_message(
        session_id=session_id,
        role="assistant",
        content=full_response,
        is_public=True,
    )
