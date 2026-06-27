#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

export CODEX_HOME="$TMP/codex"
export CONFIG_FILE="$CODEX_HOME/config.toml"
export CAPTURE_FILE="$TMP/capture.out"
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

mkdir -p "$TMP/bin"
cat > "$TMP/bin/codex" <<'SH'
#!/usr/bin/env bash
{
  printf 'codex args:'
  printf ' [%s]' "$@"
  printf '\n'
  printf 'HTTP_PROXY=%s\n' "${HTTP_PROXY:-}"
} > "$CAPTURE_FILE"
SH
chmod +x "$TMP/bin/codex"
PATH="$TMP/bin:$PATH" "$ROOT/bin/codexuse" vpn on http://127.0.0.1:7890 "localhost,127.0.0.1" >/tmp/codexuse-smoke.out
PATH="$TMP/bin:$PATH" "$ROOT/bin/codexuse" session gpt-5.5 high medium -- --search >/tmp/codexuse-smoke.out
grep -Fq 'codex args: [--model] [gpt-5.5]' "$CAPTURE_FILE"
grep -q 'model_reasoning_effort' "$CAPTURE_FILE"
grep -q 'HTTP_PROXY=http://127.0.0.1:7890' "$CAPTURE_FILE"
PATH="$TMP/bin:$PATH" "$ROOT/bin/codexuse" run fast -- --search >/tmp/codexuse-smoke.out
grep -Fq 'codex args: [--profile] [fast] [--search]' "$CAPTURE_FILE"

cat > "$TMP/bin/claude" <<'SH'
#!/usr/bin/env bash
{
  printf 'claude args:'
  printf ' [%s]' "$@"
  printf '\n'
  printf 'ANTHROPIC_BASE_URL=%s\n' "${ANTHROPIC_BASE_URL:-}"
  printf 'HTTP_PROXY=%s\n' "${HTTP_PROXY:-}"
} > "$CAPTURE_FILE"
SH
chmod +x "$TMP/bin/claude"

export CLAUDE_DIR="$TMP/claude"
export PROFILE_DIR="$CLAUDE_DIR/profiles"
export SETTINGS_FILE="$CLAUDE_DIR/settings.json"
mkdir -p "$PROFILE_DIR"
cat > "$PROFILE_DIR/ark.json" <<'JSON'
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "test-token",
    "ANTHROPIC_BASE_URL": "https://ark.cn-beijing.volces.com/api/coding",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "doubao-seed-2-0-code-preview-260215"
  }
}
JSON

"$ROOT/bin/ccuse" vpn ark on http://127.0.0.1:7890 "localhost,127.0.0.1" >/tmp/ccuse-smoke.out
grep -q 'HTTP_PROXY' "$PROFILE_DIR/ark.json"
PATH="$TMP/bin:$PATH" "$ROOT/bin/ccuse" session ark -- --model doubao-seed-2-0-code-preview-260215 -p hello >/tmp/ccuse-smoke.out
grep -Fq 'claude args: [--model] [doubao-seed-2-0-code-preview-260215] [-p] [hello]' "$CAPTURE_FILE"
grep -q 'ANTHROPIC_BASE_URL=https://ark.cn-beijing.volces.com/api/coding' "$CAPTURE_FILE"
grep -q 'HTTP_PROXY=http://127.0.0.1:7890' "$CAPTURE_FILE"
test ! -f "$SETTINGS_FILE"

bash -n "$ROOT/bin/ccuse" "$ROOT/bin/codexuse" "$ROOT/scripts/install.sh"

rm -f /tmp/codexuse-smoke.out /tmp/ccuse-smoke.out
echo "smoke tests passed"
