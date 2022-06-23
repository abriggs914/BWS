import dataclasses
from dataclasses import dataclass
from typing import Dict


@dataclass
class Form:

    id: int
    name: str
    record_source: str = None
    events: Dict[str, list] = dataclasses.field(default_factory=dict)

    def add_event(self, callback, action):
        self.events[callback].append(action)
