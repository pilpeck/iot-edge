from capabilities.capability import Capability


class StartableCapability(
    Capability
):

    NAME = "startable"

    async def invoke(
        self,
        device
    ):
        return await device.driver.start()
