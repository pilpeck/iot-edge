from capabilities.capability import Capability


class TelemetryCapability(
    Capability
):

    NAME = "telemetry"

    async def invoke(
        self,
        device
    ):
        return await device.driver.get_status()
