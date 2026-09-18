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
