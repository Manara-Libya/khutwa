#!/usr/bin/env bash
# One-command check of the Khutwa API.
#   ./scripts/smoke-test.sh                 # tests http://127.0.0.1:8787 (starts a temporary local server if none is running)
#   ./scripts/smoke-test.sh https://x.trycloudflare.com   # tests the public URL
set -uo pipefail
cd "$(dirname "$0")/.."
URL="${1:-http://127.0.0.1:8787}"
KEY="$(grep '^KHUTWA_API_KEY=' .env 2>/dev/null | cut -d= -f2-)"
[ -n "$KEY" ] || { echo "No KHUTWA_API_KEY in backend/.env"; exit 1; }

STARTED=""
if ! curl -fs "$URL/health" >/dev/null 2>&1; then
  if [[ "$URL" == http://127.0.0.1:* ]]; then
    echo "Starting a temporary local server (warming up ~10 s)..."
    uv sync -q
    # Run the venv's python directly so $! is the server itself; stopping it shuts down its agy workers.
    .venv/bin/python -m uvicorn khutwa_api.main:app --host 127.0.0.1 --port "${URL##*:}" --no-access-log --log-level warning &
    STARTED=$!
    trap 'kill $STARTED 2>/dev/null' EXIT
    until curl -fs "$URL/health" >/dev/null 2>&1; do sleep 1; done
    sleep 8
  else
    echo "FAIL  $URL is not reachable"; exit 1
  fi
else
  echo "Using the server already running at $URL"
fi

PASS=0; FAIL=0
check() {  # name, condition-result
  if [ "$2" = "yes" ]; then echo "PASS  $1"; PASS=$((PASS+1)); else echo "FAIL  $1"; FAIL=$((FAIL+1)); fi
}
post() {  # path, json
  curl -s -m 60 "$URL$1" -H "Authorization: Bearer $KEY" -H "Content-Type: application/json" -d "$2"
}
field() { python3 -c "import sys,json; d=json.load(sys.stdin); print($1)" 2>/dev/null; }

check "health" "$(curl -s "$URL/health" | field '"yes" if d["status"]=="ok" else "no"')"

code=$(curl -s -o /dev/null -w "%{http_code}" "$URL/v1/analyze" -H "Authorization: Bearer wrong" \
  -H "Content-Type: application/json" -d '{"text":"hi"}')
check "wrong key rejected (401)" "$([ "$code" = 401 ] && echo yes || echo no)"

start=$(date +%s.%N)
r=$(post /v1/analyze '{"text":"rani ta3bana barsha min el imti7anat w el 7osh kollah mashakel"}')
t=$(python3 -c "print(f'{$(date +%s.%N)-$start:.1f}s')")
check "normal message -> reflection + suggestions ($t)" \
  "$(echo "$r" | field '"yes" if not d["urgent"] and d["reflection"] and d["suggestions"] else "no"')"
echo "      $(echo "$r" | field 'd.get("reflection") or d')" | cut -c1-160

start=$(date +%s.%N)
r=$(post /v1/analyze '{"text":"sa3at n7ess ennou mafish fayda min 7ayati"}')
t=$(python3 -c "print(f'{$(date +%s.%N)-$start:.1f}s')")
check "risky message -> urgent, no AI text ($t)" \
  "$(echo "$r" | field '"yes" if d["urgent"] and d["reflection"] is None else "no"')"

r=$(post /v1/chat/completions '{"model":"gemini-3.8-flash-low","messages":[{"role":"user","content":"salam"}]}')
check "OpenAI-compatible chat" "$(echo "$r" | field '"yes" if d["choices"][0]["message"]["content"] else "no"')"

echo; echo "$PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
