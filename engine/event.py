from dataclasses import dataclass, field
from datetime import datetime, timezone
from typing import Any
from uuid import uuid4


@dataclass(frozen=True)
class Event:
    event_type: str
    source: str
    data: dict[str, Any] = field(default_factory=dict)
    event_id: str = field(
        default_factory=lambda: str(uuid4())
    )
    timestamp: str = field(
        default_factory=lambda: datetime.now(
            timezone.utc
        ).isoformat()
    )
