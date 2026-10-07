"""Settings from environment variables, with an optional backend/.env file (git-ignored)."""
import os
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def _load_env_file(path: Path) -> None:
    if not path.exists():
        return
    for raw in path.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        os.environ.setdefault(key.strip(), value.strip().strip("'\""))


_load_env_file(ROOT / ".env")


def _int(name: str, default: int) -> int:
    return int(os.environ.get(name, default))


API_KEY = os.environ.get("KHUTWA_API_KEY", "")
DEV_KEY = os.environ.get("KHUTWA_DEV_KEY", "")
URL_GIST = os.environ.get("KHUTWA_URL_GIST", "")  # secret gist holding the current public URL (set by serve-public.sh)  # enables /v1/dev/* (prompt tuning); give it only to the AI lead
MIN_KEY_LENGTH = 32

FAST_MODEL = os.environ.get("KHUTWA_FAST_MODEL", "gpt-oss-120b-medium")
QUALITY_MODEL = os.environ.get("KHUTWA_QUALITY_MODEL", "gemini-3.8-flash-low")
AGY_BIN = os.environ.get("KHUTWA_AGY_BIN", "agy")
RUNTIME_DIR = ROOT / "runtime"

TIMEOUT_SECONDS = float(os.environ.get("KHUTWA_TIMEOUT", "15"))
POOL_SIZE = _int("KHUTWA_POOL_SIZE", 2)  # warm workers per primary (task, model)
MAX_PROCESSES = _int("KHUTWA_MAX_PROCESSES", 10)  # each agy process uses ~300 MB

MAX_TEXT_CHARS = _int("KHUTWA_MAX_TEXT_CHARS", 2000)
MAX_BODY_BYTES = _int("KHUTWA_MAX_BODY_BYTES", 64_000)
RATE_LIMIT_PER_MINUTE = _int("KHUTWA_RATE_LIMIT_PER_MINUTE", 60)
CORS_ORIGINS = [o.strip() for o in os.environ.get("KHUTWA_CORS_ORIGINS", "").split(",") if o.strip()]
DOCS_ENABLED = os.environ.get("KHUTWA_DOCS", "1") == "1"
