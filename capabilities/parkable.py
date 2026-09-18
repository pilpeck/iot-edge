from capabilities.capability import Capability


class ParkableCapability(
    Capability
):

    NAME = "parkable"

    async def invoke(
        self,
        device
    ):
        return await device.driver.park()
