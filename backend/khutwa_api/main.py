"""Khutwa API: secured, OpenAPI-documented endpoints over the Antigravity CLI.

Run:  uv run uvicorn khutwa_api.main:app --host 127.0.0.1 --port 8787 --no-access-log
Docs: http://127.0.0.1:8787/docs   Spec: /openapi.json
"""
import hmac
import json
import threading
import time
import uuid
from collections import defaultdict, deque
from concurrent.futures import ThreadPoolExecutor
from contextlib import asynccontextmanager

from fastapi import Depends, FastAPI, Header, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse, PlainTextResponse, StreamingResponse
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from . import a2ui, agents, config, guardrails
from .agy import TASKS, AgyRouter, AgyUnavailable
from .schemas import (AnalyzeIn, AnalyzeOut, SupportOut, ChatCompletionRequest, DevPrompt, DevTryIn, DevTryOut, ReflectModelOut, ReflectOut,
                      RememberIn, RememberModelOut, RememberOut, RiskModelOut, RiskOut, SuggestModelOut, SuggestOut, TextIn)


class UTF8JSONResponse(JSONResponse):
    """Declare UTF-8 explicitly; Windows PowerShell 5.1 otherwise decodes Arabic as Latin-1."""
    media_type = "application/json; charset=utf-8"

_executor = ThreadPoolExecutor(max_workers=16)
_risk_keywords = guardrails.load_risk_keywords(config.RUNTIME_DIR / guardrails.RISK_KEYWORDS_FILE)


@asynccontextmanager
async def lifespan(app: FastAPI):
    if len(config.API_KEY) < config.MIN_KEY_LENGTH:
        raise RuntimeError(f"Set KHUTWA_API_KEY (at least {config.MIN_KEY_LENGTH} characters) in backend/.env")
    if getattr(app.state, "agy", None) is None:  # tests inject a fake router
        app.state.agy = AgyRouter()
    yield
    app.state.agy.close()


app = FastAPI(
    title="Khutwa API",
    version="0.1.0",
    summary="Private first step toward a real person: risk check, reflection and support suggestions.",
    description=(
        "All `/v1` endpoints require an API key (`Authorization: Bearer <key>` or `X-API-Key`).\n\n"
        "Send **redacted text only**; redaction happens on the device. Treat any `risk` other than `none` "
        "as urgent and show the fixed urgent-help screen. The service never stores or logs request text."),
    lifespan=lifespan,
    default_response_class=UTF8JSONResponse,
    docs_url="/docs" if config.DOCS_ENABLED else None,
    redoc_url=None,
    openapi_url="/openapi.json" if config.DOCS_ENABLED else None,
)

if config.CORS_ORIGINS:
    app.add_middleware(CORSMiddleware, allow_origins=config.CORS_ORIGINS, allow_methods=["GET", "POST"],
                       allow_headers=["Authorization", "Content-Type", "X-API-Key"])


@app.middleware("http")
async def security_headers(request: Request, call_next):
    if int(request.headers.get("content-length") or 0) > config.MAX_BODY_BYTES:
        return JSONResponse({"detail": "Request body too large"}, status_code=413)
    response = await call_next(request)
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["Cache-Control"] = "no-store"
    response.headers["Referrer-Policy"] = "no-referrer"
    return response


# --- auth and rate limiting ---
_bearer = HTTPBearer(auto_error=False, description="The API key from backend/.env")
_hits: dict[str, deque] = defaultdict(deque)
_hits_lock = threading.Lock()


def client_id(request: Request) -> str:
    """The caller's IP. Behind the local Cloudflare tunnel every request comes from loopback, so only
    then trust Cloudflare's CF-Connecting-IP header (a direct caller can't spoof it that way)."""
    peer = request.client.host if request.client else "unknown"
    if peer in ("127.0.0.1", "::1") and request.headers.get("cf-connecting-ip"):
        return request.headers["cf-connecting-ip"]
    return peer


def require_api_key(request: Request,
                    creds: HTTPAuthorizationCredentials | None = Depends(_bearer),
                    x_api_key: str | None = Header(default=None, alias="X-API-Key")) -> None:
    supplied = creds.credentials if creds else (x_api_key or "")
    if not hmac.compare_digest(supplied.encode(), config.API_KEY.encode()):
        raise HTTPException(status_code=401, detail="Invalid or missing API key",
                            headers={"WWW-Authenticate": "Bearer"})
    client = client_id(request)
    now = time.monotonic()
    with _hits_lock:
        window = _hits[client]
        while window and now - window[0] > 60:
            window.popleft()
        if len(window) >= config.RATE_LIMIT_PER_MINUTE:
            raise HTTPException(status_code=429, detail="Rate limit exceeded", headers={"Retry-After": "60"})
        window.append(now)


def router(request: Request) -> AgyRouter:
    return request.app.state.agy


Auth = [Depends(require_api_key)]


# --- task helpers ---
def _risk(agy: AgyRouter, text: str) -> str:
    if guardrails.keyword_risk(text, _risk_keywords):
        return "high"
    result, _ = agy.json_task("risk", text, RiskModelOut)
    return result.risk if result else "unknown"  # fail-safe: unknown counts as urgent


def _reflect(agy: AgyRouter, text: str) -> ReflectOut:
    result, _ = agy.json_task("reflect", text, ReflectModelOut)
    if result is None or guardrails.violates(result.reflection):
        return ReflectOut(reflection=guardrails.FALLBACK_REFLECTION, fallback=True)
    return ReflectOut(reflection=result.reflection, fallback=False)


def _suggest(agy: AgyRouter, text: str) -> SuggestOut | None:
    result, _ = agy.json_task("suggest", text, SuggestModelOut)
    if result is None:
        return None
    safe = [s for s in result.suggestions if not (guardrails.violates(s.why) or guardrails.violates(s.draft))]
    return SuggestOut(situation=result.situation, suggestions=safe, fallback=False) if safe else None


# --- tuner installer (public: these files contain no secrets) ---
TOOLS_DIR = config.ROOT / "tools"


def _base_url(request: Request) -> str:
    proto = request.headers.get("x-forwarded-proto", request.url.scheme)
    return f"{proto}://{request.headers.get('host', request.url.netloc)}"


def _installer(name: str, request: Request) -> str:
    discovery = f"https://api.github.com/gists/{config.URL_GIST}" if config.URL_GIST else ""
    text = (TOOLS_DIR / name).read_text(encoding="utf-8")
    return text.replace("{BASE_URL}", _base_url(request)).replace("{DISCOVERY_URL}", discovery)


@app.get("/install.ps1", response_class=PlainTextResponse, include_in_schema=False)
def install_ps1(request: Request) -> str:
    return _installer("install.ps1", request)


@app.get("/install.sh", response_class=PlainTextResponse, include_in_schema=False)
def install_sh(request: Request) -> str:
    return _installer("install.sh", request)


@app.get("/tools/khutwa-tune.py", response_class=PlainTextResponse, include_in_schema=False)
def tuner_script() -> str:
    return (TOOLS_DIR / "khutwa-tune.py").read_text(encoding="utf-8")


# --- Khutwa endpoints ---
@app.get("/health", tags=["service"], summary="Liveness and warm-worker counts (no auth)")
def health(request: Request) -> dict:
    return {"status": "ok", "warm_workers": router(request).status()}


@app.post("/v1/analyze", response_model=AnalyzeOut, dependencies=Auth, tags=["khutwa"],
          summary="Risk check, reflection and support suggestions in one call",
          description="Runs all three in parallel. If the risk check returns anything but `none`, "
                      "returns `urgent: true` with no AI text.")
def analyze(body: AnalyzeIn, request: Request) -> AnalyzeOut:
    start = time.perf_counter()
    agy = router(request)
    convo = conversation_text(body.text, body.history or [], body.memory)
    ready = support_ready(body.text, body.history)
    risk_f = _executor.submit(_risk, agy, body.text)  # every message is checked on its own
    reflect_f = _executor.submit(_reflect, agy, convo)
    suggest_f = _executor.submit(_suggest, agy, convo) if ready and not body.defer_support else None
    risk = risk_f.result()
    elapsed = lambda: int((time.perf_counter() - start) * 1000)  # noqa: E731
    if risk != "none":
        return AnalyzeOut(urgent=True, risk=risk, elapsed_ms=elapsed())
    reflection = reflect_f.result()
    suggestions = suggest_f.result() if suggest_f else None
    return AnalyzeOut(urgent=False, risk=risk, reflection=reflection.reflection,
                      situation=suggestions.situation if suggestions else [],
                      suggestions=suggestions.suggestions if suggestions else [],
                      fallback=reflection.fallback or (ready and suggestions is None),
                      support_ready=ready,
                      a2ui=a2ui.support_surface(suggestions.suggestions, f"support-{uuid.uuid4().hex[:8]}") if suggestions else [],
                      elapsed_ms=elapsed())


@app.post("/v1/support", response_model=SupportOut, dependencies=Auth, tags=["khutwa"],
          summary="Support options for the conversation so far, with their A2UI surface",
          description="Used after /v1/analyze with defer_support=true, so the reply is not held back by the options.")
def support(body: AnalyzeIn, request: Request) -> SupportOut:
    suggestions = _suggest(router(request), conversation_text(body.text, body.history or [], body.memory))
    if suggestions is None:
        return SupportOut(fallback=True)
    return SupportOut(situation=suggestions.situation, suggestions=suggestions.suggestions, fallback=False,
                      a2ui=a2ui.support_surface(suggestions.suggestions, f"support-{uuid.uuid4().hex[:8]}"))


# Phrases that ask who to turn to; then support options come straight away.
HELP_REQUESTS = ("مع مني نحكي", "مع منو نحكي", "مع من نحكي", "نحكي مع مني", "نحكي مع منو", "نحكي مع من",
                 "منو نكلم", "مني نكلم", "شن ندير", "شنو ندير", "دبرني", "نبي نحكي مع حد",
                 "m3a men nahki", "m3a mni nahki", "chen ndir", "chnou ndir", "who should i talk", "who can i talk")


def support_ready(text: str, history: list | None) -> bool:
    """Listen first: no support options until the user's SUGGEST_AFTER-th message, unless they ask who to talk to.
    Without `history` (old clients) options come every time, as before."""
    if history is None:
        return True
    low = text.lower()
    user_messages = 1 + sum(t.role == "user" for t in history)
    return user_messages >= config.SUGGEST_AFTER or any(p in low for p in HELP_REQUESTS)


def conversation_text(text: str, history: list, memory: str | None = None) -> str:
    """The new message with the notes from earlier chats and the earlier turns, in the plain format the agents' prompts describe."""
    memory = (memory or "").strip()
    if not history and not memory:
        return text
    lines = [f"memory: {memory}"] if memory else []
    lines += [f"earlier {'user' if t.role == 'user' else 'khutwa'}: {t.text}" for t in history]
    return "\n".join(lines + [f"new: {text}"])


@app.post("/v1/remember", response_model=RememberOut, dependencies=Auth, tags=["khutwa"],
          summary="Update the short notes Khutwa keeps across chats (only for users who turned on saved chats)",
          description="Takes the redacted conversation and the current notes and returns the updated notes. "
                      "The phone stores them; the server keeps nothing. Never records anything about risk or danger.")
def remember(body: RememberIn, request: Request) -> RememberOut:
    lines = [f"memory: {body.memory.strip()}"] if body.memory and body.memory.strip() else []
    lines += [f"{'user' if t.role == 'user' else 'khutwa'}: {t.text}" for t in body.history]
    result, _ = router(request).json_task("remember", "\n".join(lines), RememberModelOut)
    if result is None or guardrails.violates(result.memory):
        return RememberOut(memory=None, fallback=True)
    return RememberOut(memory=result.memory.strip(), fallback=False)


@app.post("/v1/risk", response_model=RiskOut, dependencies=Auth, tags=["khutwa"], summary="Risk check only")
def risk(body: TextIn, request: Request) -> RiskOut:
    level = _risk(router(request), body.text)
    return RiskOut(risk=level, urgent=level != "none")


@app.post("/v1/reflect", response_model=ReflectOut, dependencies=Auth, tags=["khutwa"],
          summary="Non-diagnostic reflection in Libyan Arabic")
def reflect(body: TextIn, request: Request) -> ReflectOut:
    return _reflect(router(request), body.text)


@app.post("/v1/suggest", response_model=SuggestOut, dependencies=Auth, tags=["khutwa"],
          summary="2-3 support types from the fixed list, each with a reason and a draft message")
def suggest(body: TextIn, request: Request) -> SuggestOut:
    result = _suggest(router(request), body.text)
    if result is None:
        raise HTTPException(status_code=503, detail="Suggestions unavailable; show the generic support options")
    return result


# --- OpenAI-compatible endpoints (development use; user-facing screens should use /v1/analyze) ---
@app.get("/v1/models", dependencies=Auth, tags=["openai-compatible"], summary="List models (OpenAI format)")
def list_models() -> dict:
    return {"object": "list", "data": [{"id": m, "object": "model", "created": 0, "owned_by": "khutwa"}
                                       for m in (config.QUALITY_MODEL, config.FAST_MODEL)]}


@app.post("/v1/chat/completions", dependencies=Auth, tags=["openai-compatible"],
          summary="Chat completions (OpenAI format, supports stream=true)",
          description="Runs the `khutwa-chat` agent, whose safety rules override the conversation. "
                      "`temperature` and `max_tokens` are accepted but ignored.")
def chat_completions(body: ChatCompletionRequest, request: Request):
    if body.model not in (config.QUALITY_MODEL, config.FAST_MODEL):
        raise HTTPException(status_code=400, detail="Unknown model; use GET /v1/models")
    prompt = "\n\n".join(f"[{m.role}]\n{m.content}" for m in body.messages)
    agy = router(request)
    cid, created = f"chatcmpl-{uuid.uuid4().hex}", int(time.time())

    def chunk(delta: dict, finish: str | None = None) -> str:
        return "data: " + json.dumps({"id": cid, "object": "chat.completion.chunk", "created": created,
                                      "model": body.model, "choices": [{"index": 0, "delta": delta,
                                                                       "finish_reason": finish}]},
                                     ensure_ascii=False) + "\n\n"

    if body.stream:
        def events():
            yield chunk({"role": "assistant"})
            try:
                for delta in agy.chat_stream(prompt, body.model):
                    yield chunk({"content": delta})
            except AgyUnavailable:
                yield chunk({"content": guardrails.FALLBACK_REFLECTION})
            yield chunk({}, "stop")
            yield "data: [DONE]\n\n"
        return StreamingResponse(events(), media_type="text/event-stream")

    try:
        text = "".join(agy.chat_stream(prompt, body.model))
    except AgyUnavailable:
        raise HTTPException(status_code=503, detail="Model unavailable, try again") from None
    if not text or guardrails.violates(text):
        text = guardrails.FALLBACK_REFLECTION
    return {"id": cid, "object": "chat.completion", "created": created, "model": body.model,
            "choices": [{"index": 0, "message": {"role": "assistant", "content": text}, "finish_reason": "stop"}],
            "usage": {"prompt_tokens": 0, "completion_tokens": 0, "total_tokens": 0}}


# --- developer tools: prompt tuning (needs the API key AND X-Dev-Key; disabled when KHUTWA_DEV_KEY is unset) ---
DEV_SCHEMAS = {"risk": RiskModelOut, "reflect": ReflectModelOut, "suggest": SuggestModelOut}


def require_dev_key(x_dev_key: str | None = Header(default=None, alias="X-Dev-Key")) -> None:
    if not config.DEV_KEY:
        raise HTTPException(status_code=404, detail="Developer tools are disabled")
    if not hmac.compare_digest((x_dev_key or "").encode(), config.DEV_KEY.encode()):
        raise HTTPException(status_code=403, detail="Invalid developer key")


DevAuth = [Depends(require_api_key), Depends(require_dev_key)]


@app.get("/v1/dev/prompts", dependencies=DevAuth, tags=["developer"], summary="Live prompt bodies and models")
def dev_prompts() -> dict:
    return {task: {"prompt": agents.read_prompt(task), "models": TASKS[task][1]} for task in agents.TUNABLE}


@app.post("/v1/dev/try", response_model=DevTryOut, dependencies=DevAuth, tags=["developer"],
          summary="Run one message with a draft (or the live) prompt and show the raw output")
def dev_try(body: DevTryIn, request: Request) -> DevTryOut:
    model = body.model or TASKS[body.task][1][0]
    if model not in TASKS[body.task][1]:
        raise HTTPException(status_code=400, detail=f"Model must be one of {TASKS[body.task][1]}")
    start = time.perf_counter()
    try:
        text = conversation_text(body.text, body.history or []) if body.task != "risk" else body.text
        raw = router(request).try_once(body.task, text, model, body.prompt)
    except AgyUnavailable as e:
        raise HTTPException(status_code=504, detail=f"Model unavailable: {e}") from None
    parsed, valid = None, False
    if "{" in raw:
        try:
            parsed = json.loads(raw[raw.index("{"): raw.rindex("}") + 1])
            DEV_SCHEMAS[body.task].model_validate(parsed)
            valid = True
        except ValueError:
            pass
    return DevTryOut(raw=raw, parsed=parsed, valid=valid, guardrail=guardrails.violates(raw), model=model,
                     elapsed_ms=int((time.perf_counter() - start) * 1000))


@app.put("/v1/dev/prompts/{task}", dependencies=DevAuth, tags=["developer"],
         summary="Save a prompt as live (previous version is backed up) and refresh its workers")
def dev_save_prompt(task: str, body: DevPrompt, request: Request) -> dict:
    if task not in agents.TUNABLE:
        raise HTTPException(status_code=404, detail="Unknown task")
    agents.write_prompt(task, body.prompt)
    router(request).reload(task)
    return {"saved": task}
