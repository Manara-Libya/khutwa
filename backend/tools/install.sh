#!/bin/sh
# Khutwa prompt tuner installer (macOS / Linux).  Usage:  curl -fsSL {BASE_URL}/install.sh | sh
set -e
BASE="{BASE_URL}"
DIR="$HOME/.khutwa"; BIN="$HOME/.local/bin"
mkdir -p "$DIR" "$BIN"
echo; echo "  Installing the Khutwa prompt tuner"
if ! command -v uv >/dev/null 2>&1; then
  echo "  - installing uv (Python runner)..."
  curl -LsSf https://astral.sh/uv/install.sh | sh >/dev/null 2>&1
  export PATH="$BIN:$PATH"
fi
echo "  - downloading the tuner..."
curl -fsSL "$BASE/tools/khutwa-tune.py" -o "$DIR/khutwa-tune.py"
printf '#!/bin/sh\nexec uv run --quiet --script "$HOME/.khutwa/khutwa-tune.py" "$@"\n' > "$BIN/khutwa-tune"
chmod +x "$BIN/khutwa-tune"
echo "  - preparing dependencies (first time only)..."
uv run --quiet --script "$DIR/khutwa-tune.py" --set-url "$BASE" --set-discovery "{DISCOVERY_URL}"
uv run --quiet --script "$DIR/khutwa-tune.py" --check >/dev/null
echo; echo "  Done! Run:  khutwa-tune"
case ":$PATH:" in *":$BIN:"*) ;; *) echo "  (Add $BIN to your PATH, or open a new terminal.)";; esac
echo
