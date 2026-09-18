from engine.command import Command
from engine.command_result import CommandResult
from engine.event import Event
from engine.event_bus import EventBus


class CommandBus:

    def __init__(
        self,
        runtime,
        event_bus: EventBus
    ):
        self.runtime = runtime
        self.event_bus = event_bus

    async def execute(
        self,
        command: Command
    ) -> CommandResult:

        device = self.runtime.get_device(
            command.device_id
        )

        if device is None:
            result = CommandResult(
                command_id=command.command_id,
                device_id=command.device_id,
                capability=command.capability,
                success=False,
                error=(
                    f"Unknown device: "
                    f"{command.device_id}"
                )
            )

            await self._publish_result(result)
            return result

        if not device.supports(command.capability):
            result = CommandResult(
                command_id=command.command_id,
                device_id=command.device_id,
                capability=command.capability,
                success=False,
                error=(
                    f"Device {command.device_id} "
                    f"does not support capability "
                    f"{command.capability}"
                )
            )

            await self._publish_result(result)
            return result

        capability = device.capabilities[
            command.capability
        ]

        try:
            value = await capability.invoke(
                device,
                **command.arguments
            )

            result = CommandResult(
                command_id=command.command_id,
                device_id=command.device_id,
                capability=command.capability,
                success=True,
                result=value
            )

        except Exception as exc:
            result = CommandResult(
                command_id=command.command_id,
                device_id=command.device_id,
                capability=command.capability,
                success=False,
                error=str(exc)
            )

        await self._publish_result(result)
        return result

    async def _publish_result(
        self,
        result: CommandResult
    ) -> None:

        event_type = (
            "command.completed"
            if result.success
            else "command.failed"
        )

        await self.event_bus.publish(
            Event(
                event_type=event_type,
                source=result.device_id,
                data={
                    "command_id": result.command_id,
                    "capability": result.capability,
                    "success": result.success,
                    "result": result.result,
                    "error": result.error
                }
            )
        )
