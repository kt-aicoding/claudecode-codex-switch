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
```

`ccuse` profiles live under `~/.claude/profiles/`. It backs up `~/.claude/settings.json` before switching.

## Codex

Use `codexuse`:

```bash
codexuse set gpt-5.5 high
codexuse init-fast
codexuse init-deep
codexuse run fast
codexuse use deep
```

Codex official switching patterns:

- `codex --model <model>` for a one-off launch
- `/model` inside a Codex session
- `model = "..."` in `~/.codex/config.toml` for default
- `codex --profile <name>` with `~/.codex/<name>.config.toml` for profile-based launch

Prefer `codexuse set` for persistent default changes and `codexuse run <profile>` for per-session profile changes.

