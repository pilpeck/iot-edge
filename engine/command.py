from dataclasses import dataclass, field
from typing import Any
from uuid import uuid4


@dataclass(frozen=True)
class Command:
    device_id: str
    capability: str
    arguments: dict[str, Any] = field(default_factory=dict)
    command_id: str = field(
        default_factory=lambda: str(uuid4())
    )
