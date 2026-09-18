from capabilities.capability import Capability


class StoppableCapability(
    Capability
):

    NAME = "stoppable"

    async def invoke(
        self,
        device
    ):
        return await device.driver.stop()
