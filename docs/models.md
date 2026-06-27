# 模型清单与示例

调研日期：2026-06-27

模型 ID 会随 provider 发布节奏变化。本页保存的是常用示例和当前工具内置模板，不承诺每个账号都可用。自动化脚本里使用前，先以对应 provider 控制台和官方文档为准。

## Claude Code 原生

Claude Code CLI 当前支持用 alias 或完整模型名启动会话：

```bash
claude --model sonnet
claude --model opus
claude --model fable
```

常见 alias / 示例：

| 模型 | 用法 |
| --- | --- |
| `opus` | 最新 Opus-class alias |
| `sonnet` | 最新 Sonnet-class alias |
| `fable` | 最新 Fable-class alias |
| `claude-opus-4-6` | 完整模型名示例 |
| `claude-sonnet-4-6` | 完整模型名示例 |
| `claude-fable-5` | Claude Code help 中展示的完整模型名示例 |

通过 `ccuse` 会话级 profile 切换时，也可以传模型：

```bash
ccuse session claude -- --model sonnet
```

## Volcengine Ark Coding Plan

当前模板使用：

```text
doubao-seed-2-0-code-preview-260215
```

生成 profile：

```bash
ccuse init-ark
ccuse global ark
ccuse session ark
```

## Zhipu GLM

当前模板使用：

| 模型 | 用途 |
| --- | --- |
| `glm-5` | 默认 Opus / Sonnet 映射 |
| `glm-4.7` | 高智能模型示例 |
| `glm-4.7-FlashX` | Haiku / 轻量模型映射 |

示例：

```bash
ccuse init-glm
ccuse session glm -- --model glm-5
```

## Moonshot Kimi

当前模板使用：

```text
kimi-k2.5
```

示例：

```bash
ccuse init-kimi
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
| `gpt-5.5` | 当前 README 与配置文档示例里的推荐默认 |
| `gpt-5.4` | GPT-5 family 兼容示例 |
| `o3` | Codex CLI config override 示例中出现的模型 ID |

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

