from capabilities.startable import (
    StartableCapability
)

from capabilities.stoppable import (
    StoppableCapability
)

from capabilities.parkable import (
    ParkableCapability
)

from capabilities.telemetry import (
    TelemetryCapability
)

from capabilities.battery import (
    BatteryCapability
)


class CapabilityFactory:

    MAP = {

        "startable":
            StartableCapability,

        "stoppable":
            StoppableCapability,

        "parkable":
            ParkableCapability,

        "telemetry":
            TelemetryCapability,

        "battery":
            BatteryCapability
    }

    @classmethod
    def create(
        cls,
        capability_name
    ):

        capability = \
            cls.MAP.get(
                capability_name
            )

        if not capability:

            raise ValueError(
                f"Unknown capability "
                f"{capability_name}"
            )

        return capability()
