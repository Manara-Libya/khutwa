# Khutwa API

A secured HTTP API for Khutwa's AI tasks: risk check, reflection, and support suggestions with draft messages. Models are reached through the Antigravity CLI (`agy`) on the host machine, so no paid API key is needed.

- **OpenAPI 3.1:** interactive docs at `/docs`, spec at `/openapi.json` (also committed as [`openapi.json`](openapi.json))
- **OpenAI-compatible:** `GET /v1/models` and `POST /v1/chat/completions` (with `stream: true`), so any OpenAI SDK or tool can call it

## Run

Requires `agy` installed and signed in, plus [uv](https://docs.astral.sh/uv/).

```sh
cd backend
cp .env.example .env        # then set KHUTWA_API_KEY (the server refuses to start without one)
uv sync
uv run uvicorn khutwa_api.main:app --host 127.0.0.1 --port 8787 --no-access-log
```

To reach it from phones on the same Wi-Fi, use `--host 0.0.0.0`. Only do this on a network you trust, and keep the key secret.

### Public URL (Cloudflare quick tunnel)

```sh
./scripts/serve-public.sh
```

This starts the API on `127.0.0.1` and publishes it through a free Cloudflare quick tunnel. It prints a public `https://….trycloudflare.com` URL. Nothing is opened on your router, and the API key, rate limit and the other protections still apply. The URL changes on every run, and the laptop must stay on. Behind the tunnel, rate limits use Cloudflare's `CF-Connecting-IP` header, which is trusted only for loopback connections.

If a browser frontend calls the API, set `KHUTWA_CORS_ORIGINS` in `.env` to its origin (for example `http://localhost:5173`).

## Endpoints

All `/v1` endpoints need `Authorization: Bearer <key>` or `X-API-Key: <key>`.

| Method | Path | What it does |
|---|---|---|
| GET | `/health` | Liveness and warm-worker counts (no auth) |
| POST | `/v1/analyze` | **Main call.** Runs risk, reflection and suggestions in parallel. Any risk other than `none` returns `urgent: true` with no AI text. |
| POST | `/v1/risk` | Risk check only |
| POST | `/v1/reflect` | Reflection in Libyan Arabic (no diagnosis) |
| POST | `/v1/suggest` | 2–3 support types from the fixed list, each with a "why" and a draft message |
| GET | `/v1/models` | Models, in OpenAI format |
| POST | `/v1/chat/completions` | OpenAI-format chat, for development. User-facing screens should use `/v1/analyze`. |

```sh
curl -s http://127.0.0.1:8787/v1/analyze \
  -H "Authorization: Bearer $KHUTWA_API_KEY" -H "Content-Type: application/json" \
  -d '{"text":"rani ta3bana barsha min el imti7anat"}'
```

Send **redacted text only**. Redaction happens on the phone before any request.

## Prompt tuner (for the AI lead)

`tools/khutwa-tune.py` is a terminal app for tuning prompts against the live server. You edit a prompt, run it on test messages, and see each output, whether it's valid, any guardrail hits and the time taken. When you're happy, save it live.

**Install (one line, like Claude Code). The running server hosts the installer:**

```powershell
irm https://<current-url>/install.ps1 | iex          # Windows
```
```sh
curl -fsSL https://<current-url>/install.sh | sh     # macOS / Linux
```

Then run `khutwa-tune`. On first launch it asks for the API key and the **developer key** (`KHUTWA_DEV_KEY` in `.env`; give it only to the AI lead).

**It survives URL changes.** `serve-public.sh` publishes each new tunnel URL to a secret gist (`KHUTWA_URL_GIST` in `.env`, created automatically with `gh`). When the server is unreachable, the tuner reads the latest URL from that gist and keeps retrying for up to 3 minutes, then carries on. Drafts are saved to `~/.khutwa-tune-drafts.json`, so nothing is lost.

| Key | Action |
|---|---|
| Ctrl+R / Ctrl+E | Run the selected message / all messages with the current draft |
| Ctrl+F | Run the full `/v1/analyze` flow on the selected message |
| Ctrl+S | Save the draft as the live prompt (backed up in `runtime/agent-history/`) |
| Ctrl+N / Ctrl+D | Add / delete a test message (saved in `~/.khutwa-tune-messages.json`) |
| F2 | Arabic shaping (on by default on Windows; turn it on if Arabic looks broken) |

A draft is run in a throwaway copy of the agent, so it doesn't affect the team until it's saved. The prompt files keep their tool restrictions; only the prompt text is editable. The developer endpoints (`/v1/dev/*`) need both the API key and `X-Dev-Key`, and they're disabled if `KHUTWA_DEV_KEY` is unset.

## Security

- **API key:** required, compared in constant time; the server won't start with a key shorter than 32 characters
- **Network:** binds to `127.0.0.1` by default; CORS is off unless `KHUTWA_CORS_ORIGINS` is set
- **Limits:** per-client rate limit (`KHUTWA_RATE_LIMIT_PER_MINUTE`), body-size cap, input length validation
- **No logging:** request text is never logged or stored (run uvicorn with `--no-access-log`)
- **Hardened responses:** `nosniff`, `no-store` and `no-referrer` headers on every response
- **Model isolation:** each `agy` worker runs a minimal agent (only the `finish` tool, no skills, plugins, rules or MCP servers) with `--sandbox` in the empty `runtime/` folder. Each worker serves one request and is then killed, so no user's text stays in context.
- **Prompt injection:** user text is fenced as data, and the agents are told never to follow instructions inside it
- **Output guardrails:** diagnosis, medication and confidentiality terms are replaced with approved fallback text (`khutwa_api/guardrails.py`)
- **Fail-safe risk:** if the risk check fails or times out, the response is urgent
- **Process cap:** `KHUTWA_MAX_PROCESSES` limits concurrent `agy` processes (each uses about 300 MB)
- **No leftover processes:** on Linux, workers are killed by the kernel the moment their server exits, even after a crash or `kill -9` (`PR_SET_PDEATHSIG`). On startup the server also removes `agy` workers whose server is gone, and stale temporary prompt files. Workers belonging to another running server are never touched.

## How it works

- `runtime/.agents/agents/` holds the minimal agents: `khutwa-risk`, `khutwa-reflect`, `khutwa-suggest`, `khutwa-chat`
- Warm pools of pre-started `agy` processes (`--input-format stream-json`) keep the ~3 s startup off the request path
- Risk runs on GPT-OSS 120B (fastest); text tasks run on Gemini Flash (best Libyan Arabic). Each falls back to the other model on errors or timeouts.
- `runtime/risk_keywords.txt` is checked before any model call. The language and testing lead owns it.

Measured with the warm pool: the full analyze call usually takes 3–5 s (Gemini can spike past 10 s), and risky messages return `urgent` in about 2 s.

## Test

```sh
uv run pytest -q                    # unit tests (fake model, no agy calls)
KHUTWA_LIVE=1 uv run pytest -s -k live   # end-to-end with the real agy CLI
```

## Limits

- It runs on one laptop and uses that account's Antigravity quota. The laptop must stay on and reachable during the demo.
- The free route sends redacted text to Google's models; state this in the pitch.
- The guardrail term list and fallback text need review by the language and testing lead.
