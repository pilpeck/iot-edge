from engine.device import Device
from engine.connector_factory import ConnectorFactory
from engine.driver_factory import DriverFactory


class DeviceFactory:

    @staticmethod
    def create(
        definition
    ):

        connector = \
            ConnectorFactory.create(
                definition["connector"]
            )

        driver = \
            DriverFactory.create(
                definition["driver"],
                connector
            )

        return Device(
            definition,
            connector,
            driver
        )
