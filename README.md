# claudecode-codex-switch

Claude Code 和 Codex CLI 的模型 / provider 切换工具。

这个仓库把两个场景放在一起：

- `ccuse`：切换 Claude Code 的 `~/.claude/settings.json` provider profile，例如 Anthropic、Volcengine Ark、GLM、Kimi。
- `codexuse`：切换 Codex CLI 的默认模型，管理 Codex profile，并支持 `codex --profile <name>` 的启动方式。

## 一句话安装

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/kt-aicoding/claudecode-codex-switch/main/scripts/install.sh)"
```

默认安装到 `~/.local/bin/ccuse` 和 `~/.local/bin/codexuse`。如果你的 shell 找不到命令，把下面这行加入 shell profile：

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## ccuse：Claude Code 切换

`ccuse` 通过 profile 文件切换 Claude Code 配置：

- profile 目录：`~/.claude/profiles/`
- 当前配置：`~/.claude/settings.json`
- 切换方式：备份当前 settings，再复制目标 profile 到 settings

常用命令：

```bash
ccuse init-claude
ccuse init-ark
ccuse init-glm
ccuse init-kimi

ccuse ark
ccuse glm
ccuse kimi
ccuse claude

ccuse list
ccuse show
ccuse edit glm
```

内置 provider 模板：

| 命令 | Provider | 说明 |
| --- | --- | --- |
| `ccuse claude` | Anthropic | 使用原生 Claude 配置 |
| `ccuse ark` | Volcengine Ark | Ark Coding Plan Claude 兼容接口 |
| `ccuse glm` | Zhipu GLM | GLM Anthropic 兼容接口 |
| `ccuse kimi` | Moonshot Kimi | Kimi Coding Anthropic 兼容接口 |

`ccuse` profile 中可能包含 API key，占位模板会写 `YOUR_*_API_KEY`，真实 key 只保存在用户本机，不提交到仓库。

## codexuse：Codex 切换

Codex CLI 有几种模型切换方式：

- 临时启动：`codex --model <model>`
- 会话内切换：在 Codex 交互界面使用 `/model`
- 持久默认：写入 `~/.codex/config.toml` 的顶层 `model = "..."`
- Profile 启动：写入 `$CODEX_HOME/<name>.config.toml`，运行 `codex --profile <name>`

`codexuse` 把这些做成两个常用动作：

```bash
codexuse set gpt-5.5 high
codexuse gpt-5.5 xhigh medium
```

这会更新 `~/.codex/config.toml` 的顶层配置：

```toml
model = "gpt-5.5"
model_reasoning_effort = "xhigh"
model_verbosity = "medium"
```

管理 profile：

```bash
codexuse init-fast
codexuse init-deep
codexuse init fast gpt-5.5 medium low
codexuse init deep gpt-5.5 xhigh medium
```

使用 profile：

```bash
codexuse run fast              # 等价于 codex --profile fast
codexuse run deep --ask-for-approval on-request
codexuse use deep              # 把 deep profile 的模型字段写成默认配置
codexuse deep                  # 如果 deep.config.toml 存在，也等价于 use deep
```

查看和编辑：

```bash
codexuse list
codexuse show
codexuse edit config
codexuse edit fast
codexuse remove fast
```

## 两者差异

| 工具 | 管理对象 | 切换方式 | 适合场景 |
| --- | --- | --- | --- |
| `ccuse` | Claude Code `settings.json` | 复制整个 JSON profile | 切换 Anthropic 兼容 provider、base URL、默认模型环境变量 |
| `codexuse` | Codex `config.toml` 和 profile TOML | 写入顶层模型字段，或运行 `codex --profile` | 切换 Codex 默认模型、reasoning effort、profile |

Claude Code 的 provider 切换通常需要整套环境变量，所以 `ccuse` 复制 profile 更直接。Codex 的模型切换是 TOML 配置项，`codexuse` 只更新模型相关顶层字段，避免覆盖用户的 MCP、trust list、sandbox 等配置。

## 安全边界

- 安装脚本只下载 `bin/ccuse` 和 `bin/codexuse` 到本机。
- `ccuse` / `codexuse` 写入前会备份已有配置。
- 仓库不提交 API key、OAuth token、项目 trust list 或个人路径配置。
- `codexuse use <profile>` 只合并 profile 里的模型相关顶层字段，不覆盖整份 `config.toml`。

## 本地开发

```bash
bash -n bin/ccuse bin/codexuse scripts/install.sh
bash tests/smoke.sh
```

## 调研资料

- [Codex 模型切换调研](docs/codex-model-switching.md)
- [ccuse 实现说明](docs/ccuse-notes.md)

