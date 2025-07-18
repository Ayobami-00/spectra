import asyncio
import sys
import os
from livekit.plugins import silero

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from livekit.agents import (
    AutoSubscribe,
    JobContext,
    WorkerOptions,
    cli,
    JobProcess,
)
from livekit import rtc

from core.config import settings
from main import run_multimodal_agent


def prewarm(proc: JobProcess):
    proc.userdata["vad"] = silero.VAD.load()


async def entrypoint(ctx: JobContext):
    print(f"connecting to room {ctx.room.name}")

    await run_multimodal_agent(ctx)

    print("agent started")


if __name__ == "__main__":
    opts = WorkerOptions(
        entrypoint_fnc=entrypoint,
        prewarm_fnc=prewarm,
        ws_url=settings.LIVEKIT_URL,
        api_key=settings.LIVEKIT_API_KEY,
        api_secret=settings.LIVEKIT_API_SECRET,
    )

    cli.run_app(opts=opts)
