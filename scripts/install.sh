#!/usr/bin/env bash
set -euo pipefail

REPO_RAW="${REPO_RAW:-https://raw.githubusercontent.com/kt-aicoding/claudecode-codex-switch/main}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"

mkdir -p "$INSTALL_DIR"

install_file() {
  local name="$1"
  local url="$REPO_RAW/bin/$name"
  local target="$INSTALL_DIR/$name"
  curl -fsSL "$url" -o "$target"
  chmod +x "$target"
  echo "installed: $target"
}

install_file ccuse
install_file codexuse

echo ""
echo "Claude Code switcher:"
echo "  ccuse --help"
echo ""
echo "Codex switcher:"
echo "  codexuse --help"
echo ""
echo "Make sure $INSTALL_DIR is in PATH."
