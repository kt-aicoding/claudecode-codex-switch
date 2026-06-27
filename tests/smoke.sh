#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

export CODEX_HOME="$TMP/codex"
export CONFIG_FILE="$CODEX_HOME/config.toml"
mkdir -p "$CODEX_HOME"
cat > "$CONFIG_FILE" <<'TOML'
model = "old-model"

[mcp_servers.context7]
command = "npx"
args = ["-y", "@upstash/context7-mcp"]
TOML

"$ROOT/bin/codexuse" set gpt-5.5 high medium >/tmp/codexuse-smoke.out
grep -q 'model = "gpt-5.5"' "$CONFIG_FILE"
grep -q 'model_reasoning_effort = "high"' "$CONFIG_FILE"
grep -q 'model_verbosity = "medium"' "$CONFIG_FILE"
grep -q '\[mcp_servers.context7\]' "$CONFIG_FILE"
grep -q 'args = \["-y", "@upstash/context7-mcp"\]' "$CONFIG_FILE"

"$ROOT/bin/codexuse" init fast gpt-5.5 medium low >/tmp/codexuse-smoke.out
grep -q 'model_reasoning_effort = "medium"' "$CODEX_HOME/fast.config.toml"

"$ROOT/bin/codexuse" use fast >/tmp/codexuse-smoke.out
grep -q 'model_reasoning_effort = "medium"' "$CONFIG_FILE"
grep -q '\[mcp_servers.context7\]' "$CONFIG_FILE"

"$ROOT/bin/codexuse" list >/tmp/codexuse-smoke.out
grep -q 'fast' /tmp/codexuse-smoke.out

bash -n "$ROOT/bin/ccuse" "$ROOT/bin/codexuse" "$ROOT/scripts/install.sh"

rm -f /tmp/codexuse-smoke.out
echo "smoke tests passed"
