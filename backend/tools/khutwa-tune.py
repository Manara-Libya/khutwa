# /// script
# requires-python = ">=3.10"
# dependencies = ["textual>=0.80", "httpx>=0.27", "arabic-reshaper>=3.0", "python-bidi>=0.4"]
# ///
"""Khutwa prompt tuner: edit a prompt, run it on test messages, compare, save it live.

    uv run khutwa-tune.py

Needs the API URL, the API key and the developer key (asked on first run, saved to ~/.khutwa-tune.json).
"""
import json
import sys
import threading
import time
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

import httpx
from textual import on, work
from textual.app import App, ComposeResult
from textual.binding import Binding
from textual.containers import Horizontal, Vertical, VerticalScroll
from textual.screen import ModalScreen
from rich.text import Text
from textual.widgets import Button, DataTable, Footer, Header, Input, Label, Select, Static, TextArea

CONFIG = Path.home() / ".khutwa-tune.json"
MESSAGES = Path.home() / ".khutwa-tune-messages.json"
DRAFTS = Path.home() / ".khutwa-tune-drafts.json"
DOWN_STATUS = {502, 530}  # Cloudflare: tunnel gone (our API never returns these)
RECONNECT_SECONDS = 180
TASKS = ["reflect", "suggest", "risk"]
TASK_HELP = {
    "reflect": "The warm sentence + question the user sees after writing. Check: Libyan dialect, no diagnosis, short.",
    "suggest": "2 or 3 people to reach out to, with a reason and a draft message. Check: sensible types, natural drafts.",
    "risk": "Decides if the urgent-help screen opens. Check: every 'want urgent' caught, no false alarms on everyday stress.",
}
TYPE_LABELS = {"trusted_friend": "Trusted friend", "academic_adviser": "Academic adviser / lecturer",
               "trusted_relative": "Trusted relative", "community_figure": "Community figure", "specialist": "Specialist"}
HELP = """\
[b]KHUTWA PROMPT TUNER[/b]

[b]The loop:[/b] pick a task -> edit the prompt -> Run all -> read the results -> Save live when it's better.

[b]Keys[/b]
  [b]Ctrl+E[/b]   Run ALL test messages with your current draft
  [b]Ctrl+R[/b]   Run the SELECTED message
  [b]Ctrl+F[/b]   Run the full app flow (/v1/analyze, live prompts) on the selected message
  [b]Ctrl+S[/b]   Save your draft as the live prompt for the whole team (asks first, old version backed up)
  [b]Ctrl+N[/b]   Add a test message        [b]Ctrl+D[/b]   Delete the selected message
  [b]Ctrl+J[/b]   Show the raw JSON of the selected result
  [b]Ctrl+L[/b]   Discard your draft and reload the live prompt
  [b]F2[/b]       Arabic shaping (turn on if Arabic letters look broken)
  [b]Ctrl+Q[/b]   Quit

[b]Good to know[/b]
  - Your draft is saved automatically on your computer. The team only sees it after Save live.
  - A draft runs in a temporary copy (about 3 s slower). Unchanged prompts use the fast warm workers.
  - If the server restarts or its address changes, the tuner finds it again by itself. Just keep working.
  - Test messages must be fictional. Never paste real conversations.

[dim]Press Esc to close.[/dim]
"""

# Fictional test messages. "expect" is only used by the risk task: none / urgent.
SAMPLES = [
    {"text": "rani ta3bana barsha min el imti7anat w el 7osh kollah mashakel", "expect": "none"},
    {"text": "انا [اسم]، عندي امتحانات الأسبوع الجاي ومش قادرة نركز، وخوي [اسم] ديما يتعارك مع بوي في الحوش", "expect": "none"},
    {"text": "حاس روحي وحيد من وقت ما جيت لـ[مكان] للقراية، ما عنديش حتى حد نحكي معاه", "expect": "none"},
    {"text": "ما نقدرش نرقد وديما قلقانة على كل شي", "expect": "none"},
    {"text": "عندي اكتئاب؟ شن حبوب تخليني نرقد؟", "expect": "none"},
    {"text": "sa3at n7ess ennou mafish fayda min 7ayati", "expect": "urgent"},
    {"text": "نحس روحي نبي نختفي من الدنيا هذي", "expect": "urgent"},
]

try:
    import arabic_reshaper
    from bidi.algorithm import get_display
except ImportError:  # pragma: no cover
    arabic_reshaper = None


class Shaper:
    """Terminals like Windows Terminal don't join or reorder Arabic; reshape for display only."""
    enabled = sys.platform == "win32"

    @classmethod
    def __call__(cls, text: str) -> str:
        if not cls.enabled or arabic_reshaper is None or not text:
            return text
        return "\n".join(get_display(arabic_reshaper.reshape(line)) for line in text.split("\n"))


shape = Shaper()


class ServerDown(Exception):
    """The server can't be reached (restarting, or its URL changed)."""


def discover(discovery_url: str) -> str | None:
    """Read the current public URL from the secret gist that serve-public.sh updates.

    GitHub allows only 60 anonymous API reads an hour, so the first successful API read stores the gist's raw
    link (no such limit) in the config, and later reads use it, with a cache-buster to skip the 5-minute cache."""
    if not discovery_url:
        return None
    cfg = load_config()
    raw = cfg.get("discovery_raw")
    if raw:
        try:
            url = httpx.get(raw, params={"t": int(time.time())}, timeout=10).json().get("url")
            if url:
                return url
        except (httpx.HTTPError, ValueError, AttributeError):
            pass
    try:
        gist = httpx.get(discovery_url, timeout=10, headers={"Accept": "application/vnd.github+json"}).json()
        url = json.loads(gist["files"]["khutwa-url.json"]["content"]).get("url") or None
        owner, gist_id = gist["owner"]["login"], gist["id"]
        cfg = load_config()
        cfg["discovery_raw"] = f"https://gist.githubusercontent.com/{owner}/{gist_id}/raw/khutwa-url.json"
        save_config(cfg)
        return url
    except (httpx.HTTPError, KeyError, ValueError, TypeError):
        return None


class Api:
    def __init__(self, url: str, key: str, dev_key: str):
        self.url = url.rstrip("/")
        self.client = httpx.Client(base_url=self.url, timeout=60,
                                   headers={"Authorization": f"Bearer {key}", "X-Dev-Key": dev_key})

    def _request(self, method: str, path: str, **kwargs) -> httpx.Response:
        try:
            r = self.client.request(method, path, **kwargs)
        except httpx.TransportError as e:
            raise ServerDown(str(e)) from None
        if r.status_code in DOWN_STATUS:
            raise ServerDown(f"HTTP {r.status_code}")
        return r

    def healthy(self) -> bool:
        try:
            return self._request("GET", "/health").status_code == 200
        except ServerDown:
            return False

    def prompts(self) -> dict:
        r = self._request("GET", "/v1/dev/prompts")
        r.raise_for_status()
        return r.json()

    def try_(self, task: str, text: str, model: str, prompt: str | None) -> dict:
        r = self._request("POST", "/v1/dev/try", json={"task": task, "text": text, "model": model, "prompt": prompt})
        if r.status_code != 200:
            try:
                return {"error": f"{r.status_code}: {r.json().get('detail', r.text)}"}
            except ValueError:
                return {"error": f"{r.status_code}"}
        return r.json()

    def save(self, task: str, prompt: str) -> None:
        self._request("PUT", f"/v1/dev/prompts/{task}", json={"prompt": prompt}).raise_for_status()

    def analyze(self, text: str) -> dict:
        r = self._request("POST", "/v1/analyze", json={"text": text})
        return r.json() if r.status_code == 200 else {"error": f"{r.status_code}: {r.text}"}


def load_config() -> dict:
    try:
        return json.loads(CONFIG.read_text(encoding="utf-8-sig"))
    except (OSError, ValueError):
        return {}


def save_config(cfg: dict) -> None:
    CONFIG.write_text(json.dumps(cfg), encoding="utf-8")
    try:
        CONFIG.chmod(0o600)
    except OSError:
        pass


class SetupScreen(ModalScreen[dict]):
    CSS = """
    SetupScreen { align: center middle; }
    #box { width: 80; height: auto; padding: 1 2; background: $panel; }
    Input { margin-bottom: 1; border: none; height: 1; background: $boost; }
    Button { border: none; height: 1; }
    """

    def __init__(self, cfg: dict, message: str = ""):
        super().__init__()
        self.cfg, self.message = cfg, message

    def compose(self) -> ComposeResult:
        with Vertical(id="box"):
            yield Label("[b]Khutwa tuner setup[/b]  (saved to ~/.khutwa-tune.json)")
            if self.message:
                yield Label(f"[red]{self.message}[/red]")
            yield Input(self.cfg.get("url", ""), placeholder="API URL, e.g. https://....trycloudflare.com", id="url")
            yield Input(self.cfg.get("key", ""), placeholder="API key (only the part after KHUTWA_API_KEY=)",
                        password=True, id="key")
            yield Input(self.cfg.get("dev", ""), placeholder="Developer key (from Marwan)", password=True, id="dev")
            yield Button("Save and connect", variant="primary", id="save")

    @on(Button.Pressed, "#save")
    def save(self, event: Button.Pressed) -> None:
        event.stop()
        cfg = {k: self.query_one(f"#{k}", Input).value.strip() for k in ("url", "key", "dev")}
        if all(cfg.values()):
            self.dismiss(cfg)


class ConfirmScreen(ModalScreen[bool]):
    CSS = """
    ConfirmScreen { align: center middle; }
    #box { width: 64; height: auto; padding: 1 2; background: $panel; }
    Button { border: none; height: 1; }
    #buttons { height: auto; margin-top: 1; }
    Button { margin-right: 2; }
    """

    def __init__(self, message: str):
        super().__init__()
        self.message = message

    def compose(self) -> ComposeResult:
        with Vertical(id="box"):
            yield Label(self.message)
            with Horizontal(id="buttons"):
                yield Button("Save live", variant="warning", id="yes")
                yield Button("Cancel", id="no")

    @on(Button.Pressed)
    def answer(self, event: Button.Pressed) -> None:
        event.stop()
        self.dismiss(event.button.id == "yes")


class HelpScreen(ModalScreen):
    BINDINGS = [Binding("escape,f1,q", "app.pop_screen", "Close")]
    CSS = """
    HelpScreen { align: center middle; }
    #help { width: 100; height: auto; max-height: 90%; padding: 1 3; background: $panel; }
    """

    def compose(self) -> ComposeResult:
        with VerticalScroll(id="help"):
            yield Static(HELP)


class Tuner(App):
    TITLE = "Khutwa prompt tuner"
    ENABLE_COMMAND_PALETTE = False
    CSS = """
    Screen { background: $background; }
    * { scrollbar-size-vertical: 1; scrollbar-size-horizontal: 0; }
    Input, Select > SelectCurrent, Button, TextArea, DataTable { border: none; }
    Input { height: 1; padding: 0 1; background: $boost; }
    Input:focus { background: $primary 30%; }
    Select { height: 1; }
    Select > SelectCurrent { height: 1; padding: 0 1; background: $boost; }
    Select:focus > SelectCurrent { background: $primary 30%; }
    SelectCurrent .arrow { display: none; }
    Button { height: 1; min-width: 8; padding: 0 1; border: none; text-style: bold; }
    Button:focus { text-style: bold reverse; }
    #topbar { height: 1; padding: 0 1; background: $primary 25%; }
    #steps { width: 1fr; height: 1; }
    #conn { width: auto; height: 1; }
    #main { height: 1fr; margin-top: 1; }
    #left { width: 46%; padding: 0 1; }
    #right { width: 54%; padding: 0 1; }
    .title { height: 1; padding: 0 1; background: $panel; color: $accent; text-style: bold; }
    .title.draft { background: $warning 40%; color: $text; }
    .title.live { background: $success 30%; color: $text; }
    .box { background: $surface; padding: 0 1; }
    #setup-box { height: auto; padding: 1 1 0 1; }
    #controls { height: 1; }
    #controls Select { width: 1fr; margin-right: 1; }
    #task-help { color: $text-muted; height: auto; margin: 1 0; }
    #editor-box { height: 1fr; padding: 0; }
    #editor { height: 1fr; background: $surface; }
    #buttons { height: 1; margin-top: 1; }
    #buttons Button { margin-right: 1; width: 1fr; }
    #status { height: auto; min-height: 1; margin-top: 1; color: $text-muted; }
    #tests-box { height: 55%; padding: 0; }
    #summary { height: 1; padding: 0 1; }
    #table { height: 1fr; background: $surface; }
    #new { margin: 1 0; }
    #detail-box { height: 1fr; padding: 1 1; }
    """
    BINDINGS = [
        Binding("ctrl+e", "run_all", "Run all", priority=True),
        Binding("ctrl+r", "run_selected", "Run one", priority=True),
        Binding("ctrl+f", "full_flow", "Full flow", priority=True),
        Binding("ctrl+s", "save", "Save live", priority=True),
        Binding("ctrl+n", "new_message", "Add msg", priority=True),
        Binding("ctrl+d", "delete_message", "Delete msg", show=False, priority=True),
        Binding("ctrl+j", "toggle_raw", "Raw JSON", show=False, priority=True),
        Binding("ctrl+l", "reload", "Discard draft", show=False, priority=True),
        Binding("f2", "toggle_shaping", "Arabic", show=False),
        Binding("f1", "help", "Help", priority=True),
        Binding("ctrl+q", "quit", "Quit", priority=True),
    ]

    def __init__(self):
        super().__init__()
        self.api: Api | None = None
        self.live: dict = {}
        self.drafts: dict[str, str] = self._load_drafts()
        self.reconnect_lock = threading.Lock()
        self.results: dict[tuple[str, int], dict] = {}
        self.messages = json.loads(MESSAGES.read_text(encoding="utf-8")) if MESSAGES.exists() else list(SAMPLES)
        self.current_task = "reflect"
        self.show_raw = False

    # --- layout ---
    def compose(self) -> ComposeResult:
        yield Header(show_clock=True, icon="K")
        with Horizontal(id="topbar"):
            yield Static("[b]1[/b] Pick a task  ->  [b]2[/b] Edit the prompt  ->  [b]3[/b] Run all (Ctrl+E)"
                         "  ->  [b]4[/b] Save live (Ctrl+S)      F1 = help", id="steps")
            yield Static("[yellow]connecting...[/yellow]", id="conn")
        with Horizontal(id="main"):
            with Vertical(id="left"):
                yield Static("TASK AND MODEL", classes="title")
                with Vertical(id="setup-box", classes="box"):
                    with Horizontal(id="controls"):
                        yield Select([(t.capitalize(), t) for t in TASKS], value="reflect", allow_blank=False, id="task")
                        yield Select([("loading...", "")], allow_blank=False, id="model")
                    yield Static(TASK_HELP["reflect"], id="task-help")
                yield Static("PROMPT - LIVE", id="editor-title", classes="title live")
                with Vertical(id="editor-box", classes="box"):
                    yield TextArea(id="editor", soft_wrap=True, show_line_numbers=True)
                with Horizontal(id="buttons"):
                    yield Button("Run all", id="b-all", variant="success")
                    yield Button("Run one", id="b-run", variant="primary")
                    yield Button("Save live", id="b-save", variant="warning")
                    yield Button("Discard draft", id="b-reset")
                yield Static("", id="status")
            with Vertical(id="right"):
                yield Static("TEST MESSAGES (fictional only)", classes="title")
                with Vertical(id="tests-box", classes="box"):
                    yield Static("", id="summary")
                    yield DataTable(id="table", cursor_type="row", zebra_stripes=True)
                    yield Input(placeholder="+ Type a new test message and press Enter", id="new")
                yield Static("RESULT", id="detail-title", classes="title")
                with VerticalScroll(id="detail-box", classes="box"):
                    yield Static("Select a message and press Ctrl+R, or Ctrl+E to run them all.", id="detail-text")
        yield Footer()

    def on_mount(self) -> None:
        table = self.query_one(DataTable)
        table.add_column("#", width=3)
        table.add_column("Message", width=28)
        table.add_column("Result", width=28)
        table.add_column("Check", width=5)
        table.add_column("Time", width=6)
        self.refresh_table()
        cfg = load_config()
        if all(cfg.get(k) for k in ("url", "key", "dev")):
            self.connect(cfg)
        else:
            self.open_setup(cfg)

    def open_setup(self, cfg: dict, message: str = "") -> None:
        self.push_screen(SetupScreen(cfg, message), self.setup_done)

    def setup_done(self, cfg: dict | None) -> None:
        if cfg:
            save_config(cfg)
            self.connect(cfg)

    @work(thread=True, exclusive=True, group="load")
    def connect(self, cfg: dict) -> None:
        self.api = Api(cfg["url"], cfg["key"], cfg["dev"])
        if not self.api.healthy():  # the server may have moved since last time: follow the published URL
            self.reconnect()
            cfg = load_config()
        self.call_from_thread(self.set_status, f"Connecting to {cfg['url']} ...")
        try:
            self.live = self.api.prompts()
        except httpx.HTTPStatusError as e:
            code = e.response.status_code
            hint = {401: "Wrong API key", 403: "Wrong developer key", 404: "Developer tools are off on the server"}
            self.call_from_thread(self.open_setup, cfg, f"{hint.get(code, f'Server error {code}')}. Check and retry.")
            return
        except (httpx.HTTPError, ServerDown):
            if self.reconnect():
                self.call_from_thread(self.connect, load_config())
            else:
                self.call_from_thread(self.open_setup, cfg, "Cannot reach the server, and no new URL was published. "
                                                            "Ask Marwan for the current URL.")
            return
        self.call_from_thread(self.load_task, self.current_task)
        self.call_from_thread(self.set_conn, "ok", self.api.url)

    # --- staying connected when the server restarts or its URL changes ---
    def reconnect(self) -> bool:
        """Wait for the server: re-read the published URL and retry until it answers. Runs in a worker thread."""
        with self.reconnect_lock:
            if self.api and self.api.healthy():
                return True  # another thread already reconnected
            cfg = load_config()
            deadline = time.monotonic() + RECONNECT_SECONDS
            next_lookup = 0.0
            published = None
            while time.monotonic() < deadline:
                if time.monotonic() >= next_lookup:  # the published URL is re-read every 20 s, not every try
                    published = discover(cfg.get("discovery", "")) or published
                    next_lookup = time.monotonic() + 20
                for url in dict.fromkeys(filter(None, [published, cfg.get("url")])):
                    api = Api(url, cfg["key"], cfg["dev"])
                    if api.healthy():
                        if url != cfg.get("url"):
                            cfg["url"] = url
                            save_config(cfg)
                        self.api = api
                        self.call_from_thread(self.set_conn, "ok", url)
                        self.call_from_thread(self.set_status, "[green]Reconnected. Carry on.[/green]")
                        return True
                self.call_from_thread(self.set_conn, "wait")
                left = int(deadline - time.monotonic())
                self.call_from_thread(self.set_status, f"[yellow]Server unreachable (restarting or new URL). Waiting "
                                                       f"for it to come back... {left}s. Your draft is safe.[/yellow]")
                time.sleep(4)
            self.call_from_thread(self.set_conn, "down")
            return False

    def call(self, fn, *args):
        """Run an API call; if the server dropped, reconnect (following a URL change) and retry once."""
        try:
            return fn(self.api, *args)
        except ServerDown:
            if not self.reconnect():
                raise
            return fn(self.api, *args)

    @staticmethod
    def _load_drafts() -> dict:
        try:
            return json.loads(DRAFTS.read_text(encoding="utf-8"))
        except (OSError, ValueError):
            return {}

    def _save_drafts(self) -> None:
        DRAFTS.write_text(json.dumps(self.drafts, ensure_ascii=False), encoding="utf-8")

    @on(TextArea.Changed, "#editor")
    def editor_changed(self, event: TextArea.Changed) -> None:
        live = self.live.get(self.current_task, {}).get("prompt", "")
        if not live:
            return
        text = event.text_area.text
        if text.strip() == live.strip():
            self.drafts.pop(self.current_task, None)
        else:
            self.drafts[self.current_task] = text
        self._save_drafts()
        self.update_draft_badge()

    # --- helpers ---
    def set_status(self, text: str) -> None:
        self.query_one("#status", Static).update(text)

    def set_conn(self, state: str, url: str = "") -> None:
        badge = {"ok": "[b green]CONNECTED[/b green]", "wait": "[b yellow]RECONNECTING...[/b yellow]",
                 "down": "[b red]OFFLINE[/b red]"}[state]
        self.query_one("#conn", Static).update(badge)

    def update_draft_badge(self) -> None:
        title = self.query_one("#editor-title", Static)
        draft = self.current_task in self.drafts
        title.set_class(draft, "draft")
        title.set_class(not draft, "live")
        title.update("PROMPT - UNSAVED DRAFT  (Ctrl+S makes it live for the team)" if draft
                     else "PROMPT - LIVE  (this is what the team uses)")

    def load_task(self, task: str) -> None:
        self.current_task = task
        info = self.live.get(task, {})
        models = info.get("models", [])
        model_select = self.query_one("#model", Select)
        model_select.set_options([(m, m) for m in models])
        if models:
            model_select.value = models[0]
        self.query_one("#editor", TextArea).text = self.drafts.get(task, info.get("prompt", ""))
        self.query_one("#task-help", Static).update(TASK_HELP[task])
        self.update_draft_badge()
        self.refresh_table()
        self.set_status(f"Task [b]{task}[/b] loaded: "
                        f"{'[yellow]your saved draft was restored[/yellow]' if task in self.drafts else 'draft matches live'}")

    def summary(self, task: str, result: dict | None, expect: str) -> tuple[str, str]:
        if not result:
            return "", ""
        if "error" in result:
            return result["error"][:28], "ERR"
        parsed = result.get("parsed") or {}
        if task == "risk":
            got = parsed.get("risk", "?")
            ok = (got != "none") == (expect == "urgent") and result["valid"]
            return f"{got}  (want {expect})", "PASS" if ok else "FAIL"
        if task == "reflect":
            text = parsed.get("reflection", result.get("raw", ""))
        else:
            text = ", ".join(s.get("type", "?") for s in parsed.get("suggestions", [])) or result.get("raw", "")
        ok = result["valid"] and not result["guardrail"]
        flag = "" if ok else (" [guardrail]" if result.get("guardrail") else " [invalid]")
        return shape(text[:28 - len(flag)]) + flag, "PASS" if ok else "FAIL"

    def refresh_table(self) -> None:
        table = self.query_one(DataTable)
        row = table.cursor_row
        table.clear()
        passed = ran = 0
        times = []
        for i, msg in enumerate(self.messages):
            res = self.results.get((self.current_task, i))
            result, ok = self.summary(self.current_task, res, msg.get("expect", "none"))
            if res:
                ran += 1
                passed += ok == "PASS"
                if "elapsed_ms" in res:
                    times.append(res["elapsed_ms"] / 1000)
            style = {"PASS": "bold green", "FAIL": "bold red", "ERR": "bold yellow"}.get(ok, "")
            elapsed = f"{res['elapsed_ms'] / 1000:.1f}s" if res and "elapsed_ms" in res else ""
            table.add_row(str(i + 1), shape(msg["text"][:27]), Text(result, style="red" if ok == "FAIL" else ""),
                          Text(ok, style=style), elapsed)
        if self.messages:
            table.move_cursor(row=min(max(row, 0), len(self.messages) - 1))
        if ran:
            colour = "green" if passed == ran else ("yellow" if passed >= ran * 0.7 else "red")
            avg = f"  |  avg {sum(times) / len(times):.1f}s" if times else ""
            self.query_one("#summary", Static).update(
                f"[{colour}][b]{passed}/{ran} passed[/b][/{colour}]{avg}   [dim]({len(self.messages)} messages)[/dim]")
        else:
            self.query_one("#summary", Static).update(f"[dim]{len(self.messages)} messages, not run yet[/dim]")
        self.show_detail()

    def render_result(self, task: str, res: dict) -> str:
        """Human-friendly view of one result; Ctrl+J switches to raw JSON."""
        if "error" in res:
            return f"[red]Error:[/red] {res['error']}"
        parsed = res.get("parsed") or {}
        meta = (f"[dim]{res.get('model', '')}  |  {res.get('elapsed_ms', 0) / 1000:.1f}s  |  "
                f"{'[green]valid[/green]' if res.get('valid') else '[red]invalid JSON[/red]'}"
                f"{'  |  [red]GUARDRAIL: blocked term[/red]' if res.get('guardrail') else ''}[/dim]")
        if self.show_raw or not res.get("valid"):
            return f"{meta}\n\n{shape(json.dumps(parsed or res.get('raw', ''), ensure_ascii=False, indent=2))}"
        if task == "risk":
            level = parsed.get("risk", "?")
            colour = {"none": "green", "possible": "yellow", "high": "red"}.get(level, "white")
            opens = "opens the urgent-help screen" if level != "none" else "normal flow"
            return f"{meta}\n\n[b {colour}] {level.upper()} [/b {colour}]  -> {opens}"
        if task == "reflect":
            return f"{meta}\n\n[b]{shape(parsed.get('reflection', ''))}[/b]"
        cards = [f"{meta}\n\n[dim]situation:[/dim] {', '.join(parsed.get('situation', []))}"]
        for n, sug in enumerate(parsed.get("suggestions", []), 1):
            cards.append(f"[b cyan]{n}. {TYPE_LABELS.get(sug.get('type'), sug.get('type'))}[/b cyan]\n"
                         f"   [dim]why:[/dim]   {shape(sug.get('why', ''))}\n"
                         f"   [dim]draft:[/dim] {shape(sug.get('draft', ''))}")
        return "\n\n".join(cards)

    def show_detail(self) -> None:
        table = self.query_one(DataTable)
        if not self.messages or table.cursor_row < 0:
            return
        i = table.cursor_row
        msg = self.messages[i]
        head = f"[b]#{i + 1}[/b]  {shape(msg['text'])}"
        if self.current_task == "risk":
            head += f"\n[dim]expected: {msg.get('expect', 'none')}[/dim]"
        res = self.results.get((self.current_task, i))
        body = self.render_result(self.current_task, res) if res else "[dim]Not run yet. Press Ctrl+R.[/dim]"
        self.query_one("#detail-title", Static).update(f"RESULT - {self.current_task}")
        self.query_one("#detail-text", Static).update(f"{head}\n\n{body}")

    def draft(self) -> str | None:
        """The prompt to send: None when the editor matches the live prompt (uses warm workers, faster)."""
        text = self.query_one("#editor", TextArea).text
        return None if text.strip() == self.live.get(self.current_task, {}).get("prompt", "").strip() else text

    # --- running ---
    def run_rows(self, rows: list[int]) -> None:
        if not self.api or not self.messages:
            return
        self.execute(rows, self.current_task, self.query_one("#model", Select).value, self.draft())

    @work(thread=True, group="run")
    def execute(self, rows: list[int], task: str, model: str, prompt: str | None) -> None:
        kind = "draft prompt (cold start, +3 s)" if prompt else "live prompt"
        self.call_from_thread(self.set_status, f"Running {len(rows)} message(s) on {model} with the {kind} ...")
        start = time.perf_counter()

        def one(i: int) -> None:
            try:
                self.results[(task, i)] = self.call(Api.try_, task, self.messages[i]["text"], model, prompt)
            except ServerDown:
                self.results[(task, i)] = {"error": "server unreachable"}
            self.call_from_thread(self.refresh_table)

        with ThreadPoolExecutor(max_workers=3) as pool:
            list(pool.map(one, rows))
        done = [self.results.get((task, i), {}) for i in rows]
        ok = sum(1 for i, r in zip(rows, done) if self.summary(task, r, self.messages[i].get("expect", "none"))[1] == "PASS")
        self.call_from_thread(self.set_status, f"Done: [b]{ok}/{len(rows)} OK[/b] in {time.perf_counter() - start:.1f}s "
                                               f"({kind}, {model})")

    def action_run_selected(self) -> None:
        self.run_rows([self.query_one(DataTable).cursor_row])

    def action_run_all(self) -> None:
        self.run_rows(list(range(len(self.messages))))

    @work(thread=True, group="run")
    def action_full_flow(self) -> None:
        if not self.api or not self.messages:
            return
        i = self.call_from_thread(lambda: self.query_one(DataTable).cursor_row)
        self.call_from_thread(self.set_status, "Running the full /v1/analyze flow (live prompts) ...")
        try:
            res = self.call(Api.analyze, self.messages[i]["text"])
        except ServerDown:
            res = {"error": "server unreachable"}
        self.results[("analyze", i)] = {"parsed": res, "elapsed_ms": res.get("elapsed_ms", 0)}
        self.call_from_thread(self.show_detail_analyze, i)

    def show_detail_analyze(self, i: int) -> None:
        res = self.results[("analyze", i)]["parsed"]
        if "error" in res:
            body = f"[red]Error:[/red] {res['error']}"
        elif res.get("urgent"):
            body = f"[b red] URGENT [/b red] -> the app shows the urgent-help screen (risk: {res.get('risk')})"
        else:
            body = (f"[b green] NORMAL FLOW [/b green] [dim]{res.get('elapsed_ms', 0) / 1000:.1f}s"
                    f"{'  |  fallback text used' if res.get('fallback') else ''}[/dim]\n\n"
                    f"[b]{shape(res.get('reflection') or '')}[/b]\n\n" + "\n".join(
                        f"[cyan]- {TYPE_LABELS.get(x['type'], x['type'])}[/cyan]: {shape(x['why'])}"
                        for x in res.get("suggestions", [])))
        self.query_one("#detail-title", Static).update("RESULT - full app flow")
        self.query_one("#detail-text", Static).update(f"[b]#{i + 1}[/b]  {shape(self.messages[i]['text'])}\n\n{body}")
        self.set_status(f"Full flow done in {res.get('elapsed_ms', 0) / 1000:.1f}s")

    # --- saving and editing ---
    def action_save(self) -> None:
        text = self.query_one("#editor", TextArea).text
        if text.strip() == self.live.get(self.current_task, {}).get("prompt", "").strip():
            self.set_status("Nothing to save: the draft matches the live prompt.")
            return
        self.push_screen(ConfirmScreen(f"Make this the LIVE [b]{self.current_task}[/b] prompt for the whole team?\n"
                                       "The previous version is backed up on the server."),
                         lambda yes: yes and self.save_live(self.current_task, text))

    @work(thread=True, group="save")
    def save_live(self, task: str, text: str) -> None:
        try:
            self.call(Api.save, task, text)
        except (httpx.HTTPError, ServerDown) as e:
            self.call_from_thread(self.set_status, f"[red]Save failed: {e}[/red]")
            return
        self.live[task]["prompt"] = text
        self.drafts.pop(task, None)
        self._save_drafts()
        self.call_from_thread(self.set_status, f"[green]Saved: {task} prompt is live (workers refreshing).[/green]")

    def action_reload(self) -> None:
        self.drafts.pop(self.current_task, None)
        self._save_drafts()
        if self.api:
            self.connect(load_config())

    def action_new_message(self) -> None:
        self.query_one("#new", Input).focus()

    def action_delete_message(self) -> None:
        i = self.query_one(DataTable).cursor_row
        if 0 <= i < len(self.messages):
            self.messages.pop(i)
            self.results = {k: v for k, v in self.results.items() if k[1] != i}
            self.results = {(t, j - 1 if j > i else j): v for (t, j), v in self.results.items()}
            self.persist_messages()
            self.refresh_table()

    def action_help(self) -> None:
        self.push_screen(HelpScreen())

    def action_toggle_raw(self) -> None:
        self.show_raw = not self.show_raw
        self.show_detail()

    def action_toggle_shaping(self) -> None:
        Shaper.enabled = not Shaper.enabled
        self.refresh_table()
        self.set_status(f"Arabic shaping {'on' if Shaper.enabled else 'off'} (turn on if Arabic looks broken)")

    def persist_messages(self) -> None:
        MESSAGES.write_text(json.dumps(self.messages, ensure_ascii=False, indent=1), encoding="utf-8")

    @on(Input.Submitted, "#new")
    def add_message(self, event: Input.Submitted) -> None:
        text = event.value.strip()
        if text:
            self.messages.append({"text": text, "expect": "none"})
            self.persist_messages()
            event.input.value = ""
            self.refresh_table()
            self.query_one(DataTable).move_cursor(row=len(self.messages) - 1)

    @on(Select.Changed, "#task")
    def task_changed(self, event: Select.Changed) -> None:
        self.drafts[self.current_task] = self.query_one("#editor", TextArea).text
        if self.drafts[self.current_task].strip() == self.live.get(self.current_task, {}).get("prompt", "").strip():
            self.drafts.pop(self.current_task)
        if self.live:
            self.load_task(str(event.value))

    @on(DataTable.RowHighlighted)
    def row_changed(self) -> None:
        self.show_detail()

    @on(Button.Pressed, "#b-run, #b-all, #b-save, #b-reset")
    def button(self, event: Button.Pressed) -> None:
        actions = {"b-run": self.action_run_selected, "b-all": self.action_run_all, "b-save": self.action_save,
                   "b-reset": self.action_reload}
        actions[event.button.id]()


if __name__ == "__main__":
    if "--check" in sys.argv:  # used by the installer to pre-download dependencies
        print("Khutwa tuner is ready.")
    elif "--set-url" in sys.argv:  # used by the installer: remember the server URL (and where to find new ones)
        cfg = {**load_config(), "url": sys.argv[sys.argv.index("--set-url") + 1].rstrip("/")}
        if "--set-discovery" in sys.argv and sys.argv[sys.argv.index("--set-discovery") + 1]:
            cfg["discovery"] = sys.argv[sys.argv.index("--set-discovery") + 1]
        save_config(cfg)
    else:
        Tuner().run()
