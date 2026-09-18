#!/bin/bash

set -e

echo "Creating Discovery Framework..."

mkdir -p \
    data \
    scripts \
    connectors/bluetooth

#########################################################
# BLE Discovery Service
#########################################################

cat > scripts/discover_devices.py << 'EOF'
import asyncio
import json
from datetime import datetime
from bleak import BleakScanner


OUTPUT_FILE = "data/discovered_devices.json"


async def discover():

    print("Scanning for BLE devices...")

    devices = await BleakScanner.discover(
        timeout=20
    )

    results = []

    for device in devices:

        results.append(
            {
                "name": device.name,
                "address": device.address,
                "rssi": device.rssi,
                "discovered":
                    datetime.utcnow().isoformat()
            }
        )

    with open(
        OUTPUT_FILE,
        "w"
    ) as f:

        json.dump(
            results,
            f,
            indent=2
        )

    print(
        f"Discovered "
        f"{len(results)} devices"
    )


asyncio.run(discover())
EOF

#########################################################
# Device Registration Service
#########################################################

cat > scripts/register_device.py << 'EOF'
import json
import sys
from pathlib import Path


DEVICE_FOLDER = Path("devices")


def register(
    name,
    address
):

    output = {

        "id":
            name.lower()
                .replace(
                    " ",
                    "-"
                ),

        "name":
            name,

        "connector":
        {
            "type":
                "bluetooth",

            "address":
                address
        },

        "driver":
        {
            "type":
                "unknown"
        },

        "capabilities":
        []
    }

    filename = (
        DEVICE_FOLDER
        /
        f"{output['id']}.json"
    )

    with open(
        filename,
        "w"
    ) as f:

        json.dump(
            output,
            f,
            indent=2
        )

    print(
        f"Created "
        f"{filename}"
    )


if len(sys.argv) != 3:

    print(
        "Usage:"
    )

    print(
        "register_device.py "
        "<name> "
        "<address>"
    )

    exit(1)

register(
    sys.argv[1],
    sys.argv[2]
)
EOF

#########################################################
# Bluetooth Connector
#########################################################

cat > connectors/bluetooth/discovery.py << 'EOF'
from bleak import BleakScanner


class BluetoothDiscovery:

    async def discover(
        self,
        timeout=15
    ):
        return await \
            BleakScanner.discover(
                timeout=timeout
            )
EOF

echo ""
echo "Discovery Framework Created"
echo ""

echo "Run:"
echo ""

echo "source .venv/bin/activate"
echo "python scripts/discover_devices.py"
echo ""

echo "Results:"
echo ""
echo "data/discovered_devices.json"
echo ""
