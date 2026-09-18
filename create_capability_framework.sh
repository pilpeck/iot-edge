#!/bin/bash

set -e

echo "Creating Capability Framework..."

mkdir -p \
    capabilities

#########################################################
# Base Capability
#########################################################

cat > capabilities/capability.py << 'EOF'
class Capability:

    NAME = "unknown"

    async def invoke(
        self,
        device,
        *args,
        **kwargs
    ):
        raise NotImplementedError()
EOF

#########################################################
# Startable
#########################################################

cat > capabilities/startable.py << 'EOF'
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
EOF

#########################################################
# Stoppable
#########################################################

cat > capabilities/stoppable.py << 'EOF'
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
EOF

#########################################################
# Parkable
#########################################################

cat > capabilities/parkable.py << 'EOF'
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
EOF

#########################################################
# Telemetry
#########################################################

cat > capabilities/telemetry.py << 'EOF'
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
EOF

#########################################################
# Battery
#########################################################

cat > capabilities/battery.py << 'EOF'
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
EOF

#########################################################
# Capability Factory
#########################################################

cat > engine/capability_factory.py << 'EOF'
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
EOF

#########################################################
# Extend Device Class
#########################################################

cat > engine/device.py << 'EOF'
from engine.capability_factory \
    import CapabilityFactory


class Device:

    def __init__(
        self,
        definition,
        connector,
        driver
    ):

        self.definition = definition
        self.connector = connector
        self.driver = driver

        self.capabilities = {}

        self.load_capabilities()

    def load_capabilities(self):

        for capability_name in \
                self.definition.get(
                    "capabilities",
                    []
                ):

            self.capabilities[
                capability_name
            ] = \
                CapabilityFactory.create(
                    capability_name
                )

    def supports(
        self,
        capability_name
    ):

        return (
            capability_name
            in self.capabilities
        )

    @property
    def id(self):
        return self.definition["id"]

    @property
    def name(self):
        return self.definition["name"]

    @property
    def type(self):
        return self.definition["type"]
EOF

#########################################################
# Capability Demo
#########################################################

cat > tests/test_capabilities.py << 'EOF'
from engine.runtime \
    import RuntimeEngine


runtime = RuntimeEngine()

runtime.load_devices()

for device in runtime.devices:

    print()

    print(
        f"Device: "
        f"{device.name}"
    )

    print(
        "Capabilities:"
    )

    for capability \
            in device.capabilities:

        print(
            f" - {capability}"
        )
EOF

echo
echo "Capability Framework Created"
echo
echo "Run:"
echo
echo "python tests/test_capabilities.py"
echo
