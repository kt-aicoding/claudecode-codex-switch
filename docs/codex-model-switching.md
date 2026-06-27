# Codex CLI 模型切换调研

调研日期：2026-06-27

## 结论

Codex CLI 当前有四种常用模型切换方式：

1. 临时启动参数：`codex --model <model>`
2. 交互会话内命令：`/model`
3. 持久默认配置：`~/.codex/config.toml` 顶层 `model = "..."`
4. Profile 文件：`$CODEX_HOME/<name>.config.toml`，启动时 `codex --profile <name>`

本仓库的 `codexuse` 同时支持两类工作流：

- `codexuse global gpt-5.5 high`：修改 `~/.codex/config.toml`，适合持久切换默认模型。
- `codexuse session gpt-5.5 high`：运行单次会话，不改 `config.toml`。
- `codexuse run fast`：运行 `codex --profile fast`，适合每次启动选择一套 profile。

## 配置文件位置

OpenAI Codex 文档说明，用户级默认配置在：

```text
~/.codex/config.toml
```

项目级配置可以放在 repo 内：

```text
.codex/config.toml
```

项目级配置只有在该项目被 Codex trust 后才会加载。

## 默认模型

默认模型写在 `config.toml` 顶层：

```toml
model = "gpt-5.5"
```

如果要同时切换 reasoning effort：

```toml
model = "gpt-5.5"
model_reasoning_effort = "high"
```

如果要同时切换输出风格：

```toml
model = "gpt-5.5"
model_reasoning_effort = "xhigh"
model_verbosity = "medium"
```

`codexuse set` 只更新这些模型相关顶层字段，不覆盖用户已有的 MCP、sandbox、history、project trust list 等配置。

等价命令：

```bash
codexuse global gpt-5.5 xhigh medium
codexuse set gpt-5.5 xhigh medium
codexuse gpt-5.5 xhigh medium
```

## 会话级切换

会话级切换不会修改 `~/.codex/config.toml`：

```bash
codexuse session gpt-5.5 high
codexuse session gpt-5.5 xhigh medium -- --search
```

如果目标是一个存在的 profile：

```bash
codexuse session fast -- --search
```

等价于：

```bash
codex --profile fast --search
```

## Profile

Codex profile 文件位于：

```text
$CODEX_HOME/<profile-name>.config.toml
```

默认情况下 `$CODEX_HOME` 是：

```text
~/.codex
```

示例：

```toml
# ~/.codex/fast.config.toml
model = "gpt-5.5"
model_reasoning_effort = "medium"
model_verbosity = "low"
```

启动时使用：

```bash
codex --profile fast
```

`codexuse run fast` 只是这个官方启动方式的短命令封装。

## VPN / proxy

Codex CLI 进程会读取常见 proxy 环境变量。`codexuse` 支持两种方式：

只给当前会话使用：

```bash
codexuse session gpt-5.5 high --proxy http://127.0.0.1:7890
codexuse run fast --proxy http://127.0.0.1:7890 -- --search
```

持久保存给 `codexuse run/session` 自动使用：

```bash
codexuse vpn on http://127.0.0.1:7890 "localhost,127.0.0.1"
codexuse vpn show
codexuse vpn off
```

保存位置：

```text
~/.codex/vpn.env
```

写入的环境变量：

```text
HTTP_PROXY
HTTPS_PROXY
ALL_PROXY
http_proxy
https_proxy
all_proxy
NO_PROXY
no_proxy
```

注意：`codexuse vpn on` 只影响通过 `codexuse run/session` 启动的进程。如果你直接运行 `codex`，仍需要在 shell 里手动 `export HTTP_PROXY=...`。

## 为什么不直接复制整份 config.toml

`ccuse` 切换 Claude Code 时复制整份 `settings.json`，因为 Claude Code provider 切换通常需要整套环境变量：

- `ANTHROPIC_AUTH_TOKEN`
- `ANTHROPIC_BASE_URL`
- `ANTHROPIC_DEFAULT_*_MODEL`
- provider-specific timeout / traffic flags

Codex 的模型切换不需要替换整份配置。`~/.codex/config.toml` 往往还包含：

- MCP servers
- plugins
- sandbox settings
- history
- shell environment policy
- project trust list

所以 `codexuse` 采用更窄的策略：只更新模型相关顶层字段，或使用官方 `--profile` 在启动时选 profile。

## 资料来源

- OpenAI Developers Codex CLI: https://developers.openai.com/codex/cli
- OpenAI Developers Codex basic config: https://developers.openai.com/codex/config-basic
- OpenAI Developers Codex config reference: https://developers.openai.com/codex/config-reference
- OpenAI Codex repository config docs entry: https://github.com/openai/codex/blob/main/docs/config.md
