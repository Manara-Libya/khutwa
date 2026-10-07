#!/usr/bin/env bash
# Start the Khutwa API on localhost and publish it through a Cloudflare quick tunnel.
# Prints a public https URL. The URL changes on every run. Ctrl+C stops both.
set -euo pipefail
cd "$(dirname "$0")/.."
PORT="${PORT:-8787}"
CLOUDFLARED="${CLOUDFLARED:-$(command -v cloudflared || echo "$HOME/.local/bin/cloudflared")}"

grep -q '^KHUTWA_API_KEY=.\{32,\}' .env 2>/dev/null || { echo "Set KHUTWA_API_KEY (32+ chars) in backend/.env first"; exit 1; }
[ -x "$CLOUDFLARED" ] || { echo "cloudflared not found"; exit 1; }

# The quick-tunnel URL changes on every run. Publish it to a secret gist so the tuner (and anyone with the
# gist link) can always find the current one. Needs the GitHub CLI signed in; skipped otherwise.
GIST="$(grep '^KHUTWA_URL_GIST=' .env | cut -d= -f2- || true)"
if [ -z "$GIST" ] && command -v gh >/dev/null && gh auth status >/dev/null 2>&1; then
  TMPD="$(mktemp -d)"; echo '{"url": ""}' > "$TMPD/khutwa-url.json"
  GIST="$(gh gist create "$TMPD/khutwa-url.json" -d "Khutwa API current URL" 2>/dev/null | grep -oE '[0-9a-f]{20,}$' || true)"
  rm -rf "$TMPD"
  [ -n "$GIST" ] && echo "KHUTWA_URL_GIST=$GIST" >> .env && echo "Created URL gist $GIST"
fi

uv run uvicorn khutwa_api.main:app --host 127.0.0.1 --port "$PORT" --no-access-log --log-level warning &
API_PID=$!
LOG="$(mktemp)"
"$CLOUDFLARED" tunnel --no-autoupdate --url "http://127.0.0.1:$PORT" >"$LOG" 2>&1 &
TUNNEL_PID=$!
trap 'kill $API_PID $TUNNEL_PID 2>/dev/null; rm -f "$LOG"; echo; echo "Stopped."' EXIT INT TERM

until curl -fs "http://127.0.0.1:$PORT/health" >/dev/null; do sleep 1; done
until URL=$(grep -oE 'https://[a-z0-9-]+\.trycloudflare\.com' "$LOG" | head -1) && [ -n "$URL" ]; do sleep 1; done

if [ -n "$GIST" ]; then
  TMPD="$(mktemp -d)"
  printf '{"url": "%s", "updated": "%s"}\n' "$URL" "$(date -u +%FT%TZ)" > "$TMPD/khutwa-url.json"
  gh gist edit "$GIST" --filename khutwa-url.json "$TMPD/khutwa-url.json" >/dev/null 2>&1 \
    && echo "Published the URL; installed tuners will reconnect automatically." \
    || echo "Warning: could not update the URL gist."
  rm -rf "$TMPD"
fi

cat <<MSG

  Khutwa API is public at:  $URL
  Interactive docs:         $URL/docs   (click Authorize, paste the API key)
  Tuner install (Windows):  irm $URL/install.ps1 | iex
  Tuner install (Mac/Linux): curl -fsSL $URL/install.sh | sh
  Health check:             $URL/health

  Share the URL with the team; send the API key privately (it is in backend/.env).
  Keep this terminal open. Ctrl+C stops the API and the tunnel.

MSG
wait $API_PID
