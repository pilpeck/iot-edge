from dataclasses import dataclass
from typing import Any


@dataclass(frozen=True)
class CommandResult:
    command_id: str
    device_id: str
    capability: str
    success: bool
    result: Any = None
    error: str | None = None
