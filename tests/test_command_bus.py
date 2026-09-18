import asyncio

from engine.command import Command
from engine.command_bus import CommandBus
from engine.event_bus import EventBus
from engine.runtime import RuntimeEngine


async def main():

    runtime = RuntimeEngine()
    runtime.load_devices()

    event_bus = EventBus()
    received_events = []

    async def event_logger(event):
        received_events.append(event)

        print(
            f"EVENT: {event.event_type} "
            f"source={event.source}"
        )

    event_bus.subscribe(
        "*",
        event_logger
    )

    command_bus = CommandBus(
        runtime=runtime,
        event_bus=event_bus
    )

    print("Testing valid command...")

    valid_result = await command_bus.execute(
        Command(
            device_id="flymo-front",
            capability="startable"
        )
    )

    assert valid_result.success is True
    assert valid_result.device_id == "flymo-front"
    assert valid_result.capability == "startable"

    print(
        "Valid command result:",
        valid_result
    )

    print()
    print("Testing unsupported capability...")

    unsupported_result = await command_bus.execute(
        Command(
            device_id="flymo-front",
            capability="dimmable"
        )
    )

    assert unsupported_result.success is False
    assert unsupported_result.error is not None

    print(
        "Unsupported command result:",
        unsupported_result
    )

    print()
    print("Testing unknown device...")

    unknown_result = await command_bus.execute(
        Command(
            device_id="unknown-device",
            capability="startable"
        )
    )

    assert unknown_result.success is False
    assert unknown_result.error is not None

    print(
        "Unknown device result:",
        unknown_result
    )

    assert len(received_events) == 3

    assert (
        received_events[0].event_type
        == "command.completed"
    )

    assert (
        received_events[1].event_type
        == "command.failed"
    )

    assert (
        received_events[2].event_type
        == "command.failed"
    )

    print()
    print(
        "All command and event bus tests passed."
    )


if __name__ == "__main__":
    asyncio.run(main())
