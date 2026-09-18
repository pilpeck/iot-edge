from drivers.flymo.driver import FlymoDriver


class DriverFactory:

    @staticmethod
    def create(
        driver_config,
        connector
    ):

        driver_type = \
            driver_config["type"]

        if driver_type == "flymo":

            return FlymoDriver(
                connector
            )

        raise ValueError(
            f"Unknown driver "
            f"type: {driver_type}"
        )
