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
