from connectors.bluetooth.connector import BluetoothConnector


class ConnectorFactory:

    @staticmethod
    def create(connector_config):

        connector_type = \
            connector_config["type"]

        if connector_type == "bluetooth":
            return BluetoothConnector()

        raise ValueError(
            f"Unknown connector "
            f"type: {connector_type}"
        )
