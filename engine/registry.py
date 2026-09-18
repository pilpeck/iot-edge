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
