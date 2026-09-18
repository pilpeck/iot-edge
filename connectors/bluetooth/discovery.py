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
