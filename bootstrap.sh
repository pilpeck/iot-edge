#!/bin/bash

set -e

echo "Creating IoT Edge Platform Structure..."

mkdir -p \
    connectors/bluetooth \
    connectors/wifi \
    connectors/mqtt \
    drivers/flymo \
    engine \
    devices \
    api \
    web \
    config \
    logs \
    tests

###################################################
# Device Definition
###################################################

cat > devices/flymo-front.json << 'EOF'
{
  "id": "flymo-front",
  "name": "Front Lawn",
  "type": "mower",
  "manufacturer": "Flymo",
  "model": "EasiLife Go 500",

  "connector": {
    "type": "bluetooth"
  },

  "driver": {
    "type": "flymo"
  },

  "capabilities": [
    "startable",
    "stoppable",
    "parkable",
    "telemetry",
    "battery"
  ]
}
EOF

###################################################
# Registry
###################################################

cat > engine/registry.py << 'EOF'
import json
from pathlib import Path


class DeviceRegistry:

    def __init__(self, device_folder="devices"):
        self.device_folder = Path(device_folder)
        self.devices = []

    def load(self):

        self.devices = []

        for file in self.device_folder.glob("*.json"):

            with open(file) as f:
                self.devices.append(json.load(f))

        return self.devices
EOF

###################################################
# Bluetooth Connector
###################################################

cat > connectors/bluetooth/connector.py << 'EOF'
class BluetoothConnector:

    async def connect(self):
        pass

    async def disconnect(self):
        pass

    async def discover(self):
        pass
EOF

###################################################
# Flymo Driver
###################################################

cat > drivers/flymo/driver.py << 'EOF'
class FlymoDriver:

    def __init__(self, connector):
        self.connector = connector

    async def get_status(self):
        pass

    async def start(self):
        pass

    async def stop(self):
        pass

    async def park(self):
        pass
EOF

###################################################
# Main Test Program
###################################################

cat > main.py << 'EOF'
from engine.registry import DeviceRegistry

registry = DeviceRegistry()

devices = registry.load()

for device in devices:
    print(
        f"{device['name']} ({device['type']})"
    )
EOF

###################################################
# Requirements
###################################################

cat > requirements.txt << 'EOF'
fastapi
uvicorn
bleak
pydantic
jinja2
aiofiles
pyyaml
EOF

echo ""
echo "Project structure created."
echo ""
echo "Test using:"
echo ""
echo "python3 main.py"
echo ""
