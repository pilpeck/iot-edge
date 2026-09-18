from engine.device_factory import DeviceFactory
from engine.registry import DeviceRegistry


class RuntimeEngine:

    def __init__(self):
        self.devices = []
        self._devices_by_id = {}

    def load_devices(self):

        # Make repeated calls safe and deterministic.
        self.devices = []
        self._devices_by_id = {}

        registry = DeviceRegistry()
        definitions = registry.load()

        for definition in definitions:
            device = DeviceFactory.create(definition)

            if device.id in self._devices_by_id:
                raise ValueError(
                    f"Duplicate device ID: {device.id}"
                )

            self.devices.append(device)
            self._devices_by_id[device.id] = device

        return self.devices

    def get_device(self, device_id):
        return self._devices_by_id.get(device_id)

    def list_devices(self):

        for device in self.devices:
            print(
                f"{device.name} "
                f"({device.type})"
            )
