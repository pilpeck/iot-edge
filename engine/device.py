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

    @property
    def id(self):
        return self.definition["id"]

    @property
    def name(self):
        return self.definition["name"]

    @property
    def type(self):
        return self.definition["type"]
