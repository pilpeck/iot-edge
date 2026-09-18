#!/bin/bash

set -e

echo "Creating Engine Framework..."

mkdir -p \
    engine \
    connectors/bluetooth \
    connectors/wifi \
    connectors/mqtt \
    drivers/flymo

#########################################################
# Connector Factory
#########################################################

cat > engine/connector_factory.py << 'EOF'
from connectors.bluetooth.connector import BluetoothConnector


class ConnectorFactory:

    @staticmethod
    def create(connector_config):

        connector_type = \
            connector_config["type"]

        if connector_type == "bluetooth":
            return BluetoothConnector()

        raise ValueError(
            f"Unknown connector "
            f"type: {connector_type}"
        )
EOF

#########################################################
# Driver Factory
#########################################################

cat > engine/driver_factory.py << 'EOF'
from drivers.flymo.driver import FlymoDriver


class DriverFactory:

    @staticmethod
    def create(
        driver_config,
        connector
    ):

        driver_type = \
            driver_config["type"]

        if driver_type == "flymo":

            return FlymoDriver(
                connector
            )

        raise ValueError(
            f"Unknown driver "
            f"type: {driver_type}"
        )
EOF

#########################################################
# Device Class
#########################################################

cat > engine/device.py << 'EOF'
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
# Device Factory
#########################################################

cat > engine/device_factory.py << 'EOF'
from engine.device import Device
from engine.connector_factory import ConnectorFactory
from engine.driver_factory import DriverFactory


class DeviceFactory:

    @staticmethod
    def create(
        definition
    ):

        connector = \
            ConnectorFactory.create(
                definition["connector"]
            )

        driver = \
            DriverFactory.create(
                definition["driver"],
                connector
            )

        return Device(
            definition,
            connector,
            driver
        )
EOF

#########################################################
# Runtime Engine
#########################################################

cat > engine/runtime.py << 'EOF'
from engine.registry import DeviceRegistry
from engine.device_factory import DeviceFactory


class RuntimeEngine:

    def __init__(self):

        self.devices = []

    def load_devices(self):

        registry = DeviceRegistry()

        definitions = \
            registry.load()

        for definition \
                in definitions:

            device = \
                DeviceFactory.create(
                    definition
                )

            self.devices.append(
                device
            )

    def list_devices(self):

        for device in self.devices:

            print(
                f"{device.name} "
                f"({device.type})"
            )
EOF

#########################################################
# Main Program
#########################################################

cat > main.py << 'EOF'
from engine.runtime \
    import RuntimeEngine


runtime = RuntimeEngine()

runtime.load_devices()

runtime.list_devices()
EOF

echo
echo "Engine Framework Created"
echo
echo "Run:"
echo
echo "python3 main.py"
echo
