class Capability:

    NAME = "unknown"

    async def invoke(
        self,
        device,
        *args,
        **kwargs
    ):
        raise NotImplementedError()
