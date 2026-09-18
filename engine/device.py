from engine.capability_factory \
    import CapabilityFactory


class Device:

    def __init__(
        self,
        definition,
        connector,
        driver
    ):

        self.definition = definition
        self.connector = connector
        self.driver = driver

        self.capabilities = {}

        self.load_capabilities()

    def load_capabilities(self):

        for capability_name in \
                self.definition.get(
                    "capabilities",
                    []
                ):

            self.capabilities[
                capability_name
            ] = \
                CapabilityFactory.create(
                    capability_name
                )

    def supports(
        self,
        capability_name
    ):

        return (
            capability_name
            in self.capabilities
        )

    @property
    def id(self):
        return self.definition["id"]

    @property
    def name(self):
        return self.definition["name"]

    @property
    def type(self):
        return self.definition["type"]
