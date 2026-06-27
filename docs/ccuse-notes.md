# ccuse 实现说明

`ccuse` 是一个无依赖 Bash 脚本，用于切换 Claude Code 的 provider profile。

## 文件布局

默认路径：

```text
CLAUDE_DIR=~/.claude
PROFILE_DIR=$CLAUDE_DIR/profiles
SETTINGS_FILE=$CLAUDE_DIR/settings.json
```

profile 是普通 JSON 文件：

```text
~/.claude/profiles/claude.json
~/.claude/profiles/ark.json
~/.claude/profiles/glm.json
~/.claude/profiles/kimi.json
```

## 切换机制

运行：

```bash
ccuse glm
```

执行流程：

1. 查找 `~/.claude/profiles/glm.json`
2. 如果当前 `~/.claude/settings.json` 存在，先备份成 `settings.json.bak`
3. 复制 profile 文件覆盖当前 `settings.json`
4. 输出当前切换结果

这是有意设计成“整份 settings 切换”，因为 Claude Code 的第三方兼容 provider 通常需要同时切换 base URL、token、默认模型环境变量和 traffic flags。

## 内置模板

`ccuse init-*` 会生成 profile 模板：

| 命令 | profile | 说明 |
| --- | --- | --- |
| `ccuse init-claude` | `claude.json` | 保存当前原生 Claude 配置 |
| `ccuse init-ark` | `ark.json` | Volcengine Ark Coding Plan |
| `ccuse init-glm` | `glm.json` | Zhipu GLM Anthropic 兼容接口 |
| `ccuse init-kimi` | `kimi.json` | Moonshot Kimi Coding 兼容接口 |

模板里只写占位 API key。用户需要在本机替换：

```json
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "YOUR_API_KEY",
    "ANTHROPIC_BASE_URL": "https://example.com/api/anthropic"
  }
}
```

## 常用命令

```bash
ccuse list
ccuse show
ccuse edit glm
ccuse remove glm
```

## 与 codexuse 的差异

`ccuse` 复制整份 JSON，因为 provider 切换是一组强绑定配置。

`codexuse` 修改 TOML 顶层模型字段或运行 `codex --profile`，因为 Codex 的模型切换可以更窄地处理，避免覆盖 MCP、sandbox、history 和 project trust list。

