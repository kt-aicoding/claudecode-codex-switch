---
name: claudecode-codex-switch
description: Install and use ccuse/codexuse to switch Claude Code provider profiles and Codex CLI models or profiles. Use when the user asks about Claude Code model/provider switching, ccuse, Codex model switching, codex profiles, or reusable AI coding switcher setup.
---

# claudecode-codex-switch

Use this skill when the user wants to install, explain, or troubleshoot Claude Code and Codex CLI model switching.

## Install

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/kt-aicoding/claudecode-codex-switch/main/scripts/install.sh)"
```

This installs:

- `ccuse` to switch Claude Code provider profiles by replacing `~/.claude/settings.json`
- `codexuse` to switch Codex model settings in `~/.codex/config.toml` and manage `~/.codex/*.config.toml` profiles

## Claude Code

Use `ccuse`:

```bash
ccuse init-claude
ccuse init-ark
ccuse init-glm
ccuse init-kimi

ccuse ark
ccuse glm
ccuse kimi
ccuse claude

ccuse global glm
ccuse session glm -- --model glm-5.2
ccuse session ark --proxy http://127.0.0.1:7890
ccuse vpn glm on http://127.0.0.1:7890 "localhost,127.0.0.1"
ccuse models
```

`ccuse` profiles live under `~/.claude/profiles/`. It backs up `~/.claude/settings.json` before switching.

Use `ccuse global <profile>` for persistent switching and `ccuse session <profile>` for one session without writing `settings.json`.

## Codex

Use `codexuse`:

```bash
codexuse set gpt-5.5 high
codexuse global gpt-5.5 high
codexuse session gpt-5.5 xhigh medium -- --search
codexuse init-fast
codexuse init-deep
codexuse run fast
codexuse use deep
codexuse vpn on http://127.0.0.1:7890 "localhost,127.0.0.1"
codexuse models
```

Codex official switching patterns:

- `codex --model <model>` for a one-off launch
- `/model` inside a Codex session
- `model = "..."` in `~/.codex/config.toml` for default
- `codex --profile <name>` with `~/.codex/<name>.config.toml` for profile-based launch

Prefer `codexuse set` for persistent default changes and `codexuse run <profile>` for per-session profile changes.

VPN/proxy support uses `HTTP_PROXY`, `HTTPS_PROXY`, `ALL_PROXY`, and `NO_PROXY`. Use command-level `--proxy` for one session, or `vpn on/off/show` for persisted `codexuse` proxy behavior.
