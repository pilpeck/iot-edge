import json
import sys
from pathlib import Path


DEVICE_FOLDER = Path("devices")


def register(
    name,
    address
):

    output = {

        "id":
            name.lower()
                .replace(
                    " ",
                    "-"
                ),

        "name":
            name,

        "connector":
        {
            "type":
                "bluetooth",

            "address":
                address
        },

        "driver":
        {
            "type":
                "unknown"
        },

        "capabilities":
        []
    }

    filename = (
        DEVICE_FOLDER
        /
        f"{output['id']}.json"
    )

    with open(
        filename,
        "w"
    ) as f:

        json.dump(
            output,
            f,
            indent=2
        )

    print(
        f"Created "
        f"{filename}"
    )


if len(sys.argv) != 3:

    print(
        "Usage:"
    )

    print(
        "register_device.py "
        "<name> "
        "<address>"
    )

    exit(1)

register(
    sys.argv[1],
    sys.argv[2]
)
