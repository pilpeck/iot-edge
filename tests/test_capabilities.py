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
