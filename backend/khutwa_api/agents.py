"""Read, write and temporarily clone the agent prompt files in runtime/.agents/agents/.

Only the prompt body is editable; the frontmatter (tool and plugin restrictions) is always kept from
the original file so a prompt edit can never re-enable tools.
"""
import time
import uuid
from pathlib import Path

from . import config

AGENTS_DIR = config.RUNTIME_DIR / ".agents" / "agents"
HISTORY_DIR = config.RUNTIME_DIR / "agent-history"
TUNABLE = {"risk": "khutwa-risk", "reflect": "khutwa-reflect", "suggest": "khutwa-suggest"}


def _split(path: Path) -> tuple[str, str]:
    text = path.read_text(encoding="utf-8")
    _, front, body = text.split("---", 2)
    return f"---{front}---\n", body.strip() + "\n"


def read_prompt(task: str) -> str:
    return _split(AGENTS_DIR / f"{TUNABLE[task]}.md")[1]


def write_prompt(task: str, body: str) -> None:
    path = AGENTS_DIR / f"{TUNABLE[task]}.md"
    front, _ = _split(path)
    HISTORY_DIR.mkdir(exist_ok=True)
    (HISTORY_DIR / f"{TUNABLE[task]}-{time.strftime('%Y%m%d-%H%M%S')}.md").write_text(
        path.read_text(encoding="utf-8"), encoding="utf-8")
    path.write_text(front + body.strip() + "\n", encoding="utf-8")


class TempAgent:
    """A throwaway copy of a task's agent with a draft prompt body. Delete with .remove()."""

    def __init__(self, task: str, body: str):
        front, _ = _split(AGENTS_DIR / f"{TUNABLE[task]}.md")
        self.name = f"khutwa-tmp-{uuid.uuid4().hex[:10]}"
        front = front.replace(f"name: {TUNABLE[task]}", f"name: {self.name}", 1)
        self.path = AGENTS_DIR / f"{self.name}.md"
        self.path.write_text(front + body.strip() + "\n", encoding="utf-8")

    def remove(self) -> None:
        self.path.unlink(missing_ok=True)


def cleanup_temp(max_age_seconds: int = 60) -> None:
    """Remove throwaway agent files left behind by a crash."""
    for path in AGENTS_DIR.glob("khutwa-tmp-*.md"):
        if time.time() - path.stat().st_mtime > max_age_seconds:
            path.unlink(missing_ok=True)
