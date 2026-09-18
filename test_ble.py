import asyncio
from bleak import BleakScanner


async def main():

    print("Scanning for BLE devices...")
    print()

    devices = await BleakScanner.discover(
        timeout=15
    )

    if not devices:
        print("No devices found")
        return

    for device in devices:
        print(device)


asyncio.run(main())
