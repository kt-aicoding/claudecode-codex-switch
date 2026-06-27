# 模型清单与示例

更新日期：2026-06-27

模型 ID 会随 provider 发布节奏变化。本页保存当前工具模板和常用示例，不承诺每个账号都可用。自动化脚本里使用前，先以对应 provider 控制台和官方文档为准。

## 快速结论

| Provider | 当前建议 |
| --- | --- |
| Claude Code native | CLI 支持 `opus`、`sonnet`、`fable` alias；Claude API 文档列出 `claude-opus-4-8`、`claude-sonnet-4-6`、`claude-haiku-4-5` |
| Volcengine Ark Coding Plan | `ark-code-latest`、`doubao-seed-2-0-pro-260215`、`doubao-seed-2-0-code-preview-260215`、`doubao-seed-2-0-mini-260215`、`doubao-seed-2-0-lite-260215` |
| Z.AI GLM Coding Plan | 强模型 `glm-5.2`，1M 上下文写法 `glm-5.2[1m]`，日常编码 `glm-4.7`，可选 `glm-5-turbo` |
| Moonshot Kimi Code | Claude Code / coding agent 推荐稳定 ID `kimi-for-coding`；Thinking 模式走 K2.7 Code，否则走 K2.6 |
| Codex / OpenAI | Codex 文档默认示例为 `gpt-5.5`；`o3` 出现在 CLI config override 示例中 |

## Claude Code 原生

Claude Code CLI 当前支持 alias 或完整模型名：

```bash
claude --model sonnet
claude --model opus
claude --model fable
```

常见 alias / 示例：

| 模型 | 用法 |
| --- | --- |
| `opus` | Claude Code alias，指向最新 Opus-class 模型 |
| `sonnet` | Claude Code alias，指向最新 Sonnet-class 模型 |
| `fable` | Claude Code alias，指向最新 Fable-class 模型 |
| `claude-opus-4-8` | Claude API 文档列出的最新 Opus 模型 ID |
| `claude-sonnet-4-6` | Claude API 文档列出的 Sonnet 模型 ID |
| `claude-haiku-4-5` | Claude API 文档列出的 Haiku 模型 ID |
| `claude-fable-5` | Claude Code help 中展示的完整模型名示例 |

通过 `ccuse` 会话级 profile 切换时，也可以传模型：

```bash
ccuse session claude -- --model sonnet
```

## Volcengine Ark Coding Plan

常见 coding model：

| 模型 | 用途 |
| --- | --- |
| `ark-code-latest` | 代码场景滚动最新 alias，适合不想固定版本的配置 |
| `doubao-seed-2-0-pro-260215` | 高能力版本 |
| `doubao-seed-2-0-code-preview-260215` | 原模板使用的 coding preview |
| `doubao-seed-2-0-mini-260215` | 更轻量 |
| `doubao-seed-2-0-lite-260215` | 最轻量 |

当前 `ccuse init-ark` 仍使用更保守的固定 coding preview：

```text
doubao-seed-2-0-code-preview-260215
```

如果你希望 profile 自动跟随 Ark 代码模型更新，可以把 profile 里的 `ANTHROPIC_DEFAULT_*_MODEL` 改成：

```text
ark-code-latest
```

示例：

```bash
ccuse init-ark
ccuse global ark
ccuse session ark
```

## Z.AI GLM

`ccuse init-glm` 当前模板：

```json
{
  "ANTHROPIC_BASE_URL": "https://api.z.ai/api/anthropic",
  "ANTHROPIC_DEFAULT_OPUS_MODEL": "glm-5.2",
  "ANTHROPIC_DEFAULT_SONNET_MODEL": "glm-4.7",
  "ANTHROPIC_DEFAULT_HAIKU_MODEL": "glm-4.7"
}
```

常用模型：

| 模型 | 用途 |
| --- | --- |
| `glm-5.2` | 最新强代码模型，适合复杂架构、深度实现和困难 bug |
| `glm-5.2[1m]` | 1M 上下文写法，需要配合 `CLAUDE_CODE_AUTO_COMPACT_WINDOW=1000000` |
| `glm-5-turbo` | 进阶 coding 模型，适合较重任务 |
| `glm-4.7` | 日常编码、较低 quota 消耗 |

示例：

```bash
ccuse init-glm
ccuse global glm
ccuse session glm -- --model glm-5.2
```

## Moonshot Kimi

`ccuse init-kimi` 当前模板使用稳定 coding model ID：

```text
kimi-for-coding
```

Kimi Code 文档要求 Claude Code、OpenCode 等第三方 coding agent 使用 `kimi-for-coding` 统一模型 ID。当前文档说明，开启 Thinking 模式会调用最新 K2.7 Code，否则请求会路由到 K2.6。

| 模型 / 名称 | 用途 |
| --- | --- |
| `kimi-for-coding` | coding agent 稳定 ID，推荐写入 Claude Code profile |
| K2.7 Code | Kimi Code 当前最新 coding 模型；在 Claude Code 中通过 Thinking 模式触发 |
| K2.6 | 未开启 Thinking 时的路由目标 |

示例：

```bash
ccuse init-kimi
ccuse global kimi
ccuse session kimi
```

## Codex / OpenAI

Codex CLI 支持：

```bash
codex --model <model>
codex --profile <name>
```

当前示例：

| 模型 | 用途 |
| --- | --- |
| `gpt-5.5` | Codex config 文档中的默认模型示例，也是本工具默认 preset |
| `o3` | OpenAI Codex CLI 源码 / help 的 `-c model="o3"` override 示例中出现的模型 ID |

`codexuse` presets：

| preset | 模型 | effort | verbosity |
| --- | --- | --- | --- |
| `fast` | `gpt-5.5` | `medium` | `low` |
| `deep` | `gpt-5.5` | `xhigh` | `medium` |

示例：

```bash
codexuse global gpt-5.5 high
codexuse session gpt-5.5 xhigh medium -- --search
codexuse init-fast
codexuse run fast
```

## Local / OSS

Codex CLI 支持本地 provider：

```bash
codex --oss --local-provider ollama
codex --oss --local-provider lmstudio
```

本地模型 ID 由 Ollama / LM Studio 里实际安装的模型决定。

## 查看工具内置清单

```bash
ccuse models
codexuse models
```

## 资料来源

- Anthropic model overview: https://docs.anthropic.com/en/docs/about-claude/models/overview
- Claude Code CLI help: `claude --help`
- OpenAI Codex CLI: https://developers.openai.com/codex/cli
- OpenAI Codex config: https://developers.openai.com/codex/config-basic
- OpenAI Codex config override source: https://github.com/openai/codex/blob/main/codex-rs/utils/cli/src/config_override.rs
- Z.AI GLM Coding Plan / Claude Code docs: https://docs.z.ai/devpack/tool/claude
- Z.AI GLM latest model switching docs: https://docs.z.ai/devpack/latest-model
- Moonshot Kimi Code: https://www.kimi.com/code/en
- Moonshot Kimi third-party coding agent docs: https://www.kimi.com/code/docs/en/third-party-tools/other-coding-agents.html
- Volcengine Ark model list: https://www.volcengine.com/docs/82379/1330310
