from capabilities.capability import Capability


class BatteryCapability(
    Capability
):

    NAME = "battery"

    async def invoke(
        self,
        device
    ):
        return await device.driver.get_battery()
