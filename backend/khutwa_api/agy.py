"""Model access through the Antigravity CLI (agy).

Each Worker is one pre-started `agy` process in stream-json mode, running a minimal custom agent
(runtime/.agents/agents/*.md) inside an otherwise empty, sandboxed workspace. A worker serves exactly
one request and is then killed, so no user's text ever stays in context for the next user.
Pools keep workers warm so the ~3 s startup is never on the request path.
"""
import json
import os
import queue
import signal
import subprocess
import sys
import threading
import time
from collections.abc import Iterator
from concurrent.futures import ThreadPoolExecutor

from pydantic import BaseModel, ValidationError

from . import config


class AgyUnavailable(Exception):
    """Timed out, at the process limit, or the model returned nothing usable."""


_process_slots = threading.BoundedSemaphore(config.MAX_PROCESSES)

# All agy processes are started from this one long-lived thread. On Linux each child asks the kernel to
# kill it when its parent goes away (PR_SET_PDEATHSIG). That signal fires when the *thread* that forked the
# child exits, so forking from short-lived threads would kill workers early; a persistent thread avoids it.
_spawner = ThreadPoolExecutor(max_workers=1, thread_name_prefix="agy-spawner")


def _die_with_parent() -> None:
    if sys.platform.startswith("linux"):
        import ctypes
        ctypes.CDLL("libc.so.6", use_errno=True).prctl(1, signal.SIGKILL)  # 1 = PR_SET_PDEATHSIG


def reap_orphans() -> int:
    """Kill agy workers left by a crashed server: same runtime folder, and their server is gone.
    Workers of another live server (any parent running uvicorn or python) are never touched."""
    if not sys.platform.startswith("linux"):
        return 0
    killed = 0
    for pid in filter(str.isdigit, os.listdir("/proc")):
        try:
            cmd = open(f"/proc/{pid}/cmdline", "rb").read().split(b"\0")
            if not cmd or not cmd[0].endswith(b"agy") or b"--agent" not in cmd:
                continue
            if os.readlink(f"/proc/{pid}/cwd") != str(config.RUNTIME_DIR):
                continue
            ppid = open(f"/proc/{pid}/stat").read().rsplit(")", 1)[1].split()[1]
            parent = open(f"/proc/{ppid}/cmdline", "rb").read() if ppid != "1" else b""
            if b"uvicorn" in parent or b"python" in parent:
                continue  # belongs to a running server
            os.kill(int(pid), signal.SIGKILL)
            killed += 1
        except (OSError, IndexError):
            continue
    return killed


def fence(text: str) -> str:
    """Wrap user text so the agent treats it as data (the agents' prompts refer to these markers)."""
    clean = text.replace("<<<", "").replace(">>>", "")
    return f"<<<\n{clean}\n>>>"


class Worker:
    def __init__(self, agent: str, model: str):
        if not _process_slots.acquire(timeout=config.TIMEOUT_SECONDS):
            raise AgyUnavailable("process limit reached")
        self._released = False
        try:
            self.proc = _spawner.submit(
                subprocess.Popen,
                [config.AGY_BIN, "--agent", agent, "--input-format", "stream-json",
                 "--output-format", "stream-json", "--model", model, "--sandbox",
                 "--disable-slash-commands", "-p="],
                cwd=config.RUNTIME_DIR, stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                stderr=subprocess.DEVNULL, text=True, bufsize=1, preexec_fn=_die_with_parent).result()
            assert self.proc.stdin and self.proc.stdout
            for line in self.proc.stdout:
                if '"event":"init"' in line:
                    break
        except Exception:
            self.close()
            raise

    def close(self) -> None:
        if getattr(self, "proc", None) and self.proc.poll() is None:
            self.proc.kill()
        if not self._released:
            self._released = True
            _process_slots.release()

    def stream(self, content: str, timeout: float) -> Iterator[tuple[str, bool]]:
        """Send one message and yield (text_delta, step_done) for the agent's answer steps."""
        lines: queue.Queue[str | None] = queue.Queue()

        def reader() -> None:
            assert self.proc.stdin and self.proc.stdout
            try:
                self.proc.stdin.write(json.dumps({"event": "user", "message": {"content": content}}) + "\n")
                self.proc.stdin.flush()
                for line in self.proc.stdout:
                    if '"agent_response"' in line or '"event":"result"' in line:
                        lines.put(line)
            except (OSError, ValueError):
                pass
            finally:
                lines.put(None)

        threading.Thread(target=reader, daemon=True).start()
        deadline = time.monotonic() + timeout
        try:
            while True:
                remaining = deadline - time.monotonic()
                if remaining <= 0:
                    raise AgyUnavailable("timeout")
                try:
                    line = lines.get(timeout=remaining)
                except queue.Empty:
                    raise AgyUnavailable("timeout") from None
                if line is None:
                    return
                event = json.loads(line)
                if event.get("event") == "result":
                    return
                step = event["step_update"]
                yield step.get("text_delta", ""), step.get("state") == "DONE"
        finally:
            self.close()

    def ask_json(self, content: str, schema: type[BaseModel], timeout: float) -> BaseModel | None:
        """Return the first answer step that parses and validates against `schema`."""
        buf = ""
        for delta, done in self.stream(content, timeout):
            buf += delta
            if done and "{" in buf:
                try:
                    return schema.model_validate_json(buf[buf.index("{"): buf.rindex("}") + 1])
                except (ValidationError, ValueError):
                    buf = ""
        return None


class Pool:
    """Keeps `size` warm workers for one (agent, model); size 0 means spawn on demand."""

    def __init__(self, agent: str, model: str, size: int):
        self.agent, self.model, self.size = agent, model, size
        self.ready: queue.Queue[Worker] = queue.Queue()
        self.closed = False
        self._starting = 0  # spawns in flight
        self._lock = threading.Lock()
        self._top_up()

    def _top_up(self) -> None:
        """Start workers until ready + starting reaches `size`, never more. Extra warm workers would sit
        idle holding process slots, and requests would then time out waiting for a slot."""
        with self._lock:
            missing = 0 if self.closed else self.size - self.ready.qsize() - self._starting
            self._starting += max(missing, 0)
        for _ in range(missing):
            threading.Thread(target=self._spawn, daemon=True).start()

    def _spawn(self) -> None:
        try:
            worker = Worker(self.agent, self.model)
        except AgyUnavailable:
            worker = None
        with self._lock:
            self._starting -= 1
            keep = worker is not None and not self.closed
            if keep:
                self.ready.put(worker)
        if worker is not None and not keep:
            worker.close()

    def acquire(self) -> Worker:
        try:
            worker = self.ready.get_nowait()
        except queue.Empty:
            worker = None
        self._top_up()
        return worker or Worker(self.agent, self.model)

    def close(self) -> None:
        self.closed = True
        while not self.ready.empty():
            self.ready.get_nowait().close()


# task -> (agent, models in preference order)
TASKS = {
    "risk": ("khutwa-risk", [config.FAST_MODEL, config.QUALITY_MODEL]),
    "reflect": ("khutwa-reflect", [config.QUALITY_MODEL, config.FAST_MODEL]),
    "suggest": ("khutwa-suggest", [config.QUALITY_MODEL, config.FAST_MODEL]),
    "chat": ("khutwa-chat", [config.QUALITY_MODEL, config.FAST_MODEL]),
    "remember": ("khutwa-remember", [config.QUALITY_MODEL, config.FAST_MODEL]),
}


class AgyRouter:
    """Routes each task to its preferred model and falls back to the other on errors or timeouts."""

    def __init__(self, pool_size: int = config.POOL_SIZE):
        from .agents import cleanup_temp
        reap_orphans()
        cleanup_temp()
        self.pools: dict[tuple[str, str], Pool] = {}
        for task, (agent, models) in TASKS.items():
            for i, model in enumerate(models):
                # chat and remember are not on the user's critical path: one warm worker each
                warm = pool_size if i == 0 and task not in ("chat", "remember") else (1 if i == 0 else 0)
                self.pools[(task, model)] = Pool(agent, model, warm)

    def json_task(self, task: str, text: str, schema: type[BaseModel]) -> tuple[BaseModel | None, str | None]:
        for attempt, model in enumerate(TASKS[task][1]):
            timeout = config.PRIMARY_TIMEOUT_SECONDS if attempt == 0 else config.TIMEOUT_SECONDS
            try:
                result = self.pools[(task, model)].acquire().ask_json(fence(text), schema, timeout)
            except AgyUnavailable:
                result = None
            if result is not None:
                return result, model
        return None, None

    def chat_stream(self, prompt: str, model: str) -> Iterator[str]:
        """Yield text deltas of the first complete answer step."""
        for delta, done in self.pools[("chat", model)].acquire().stream(prompt, config.TIMEOUT_SECONDS):
            if delta:
                yield delta
            if done:
                return

    def try_once(self, task: str, text: str, model: str, prompt: str | None = None) -> str:
        """Developer tool: run one message and return the raw answer text. With `prompt`, a throwaway
        agent with that body is used (cold start, ~3 s extra); otherwise the live agent."""
        from .agents import TempAgent
        temp = TempAgent(task, prompt) if prompt else None
        try:
            worker = Worker(temp.name, model) if temp else self.pools[(task, model)].acquire()
        finally:
            if temp:
                temp.remove()  # the agent is loaded at startup, so the file can go now
        raw = ""
        for delta, done in worker.stream(fence(text), config.TIMEOUT_SECONDS):
            raw += delta
            if done and raw.strip():
                break
        worker.close()
        return raw.strip()

    def reload(self, task: str) -> None:
        """Replace a task's warm workers so they pick up an edited agent file."""
        agent, models = TASKS[task]
        for model in models:
            old = self.pools[(task, model)]
            self.pools[(task, model)] = Pool(agent, model, old.size)
            old.close()

    def status(self) -> dict[str, int]:
        return {f"{task}/{model}": pool.ready.qsize() for (task, model), pool in self.pools.items()}

    def close(self) -> None:
        for pool in self.pools.values():
            pool.close()
