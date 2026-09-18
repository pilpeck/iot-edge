from engine.registry import DeviceRegistry

registry = DeviceRegistry()

devices = registry.load()

for device in devices:
    print(
        f"{device['name']} ({device['type']})"
    )
