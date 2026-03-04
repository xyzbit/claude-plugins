---
description: 为 long-running-agent 配置自定义状态栏 HUD，显示 Context、Usage、当前需求、当前 Feature 和开发进度
allowed-tools: Bash, Read, Write
---

# Long-Running Agent HUD Setup

将 long-running-agent 的进度 HUD 注入到 Claude Code 状态栏（statusLine）。

仅使用 `node`（纯 JS，不依赖 bun/TypeScript）。

## Step 1: 定位脚本路径

找到本插件的 hud 脚本最新版本的绝对路径：

```bash
ls -td ~/.claude/plugins/cache/long-running-agent/long-running-agent/*/ 2>/dev/null | head -1
```

如果输出为空，说明插件未通过 marketplace 安装。提示用户重新安装插件。

记录找到的目录为 `{PLUGIN_DIR}`，脚本路径为 `{PLUGIN_DIR}/hud/dist/index.js`。

## Step 2: 确认 node 可用

```bash
command -v node 2>/dev/null
```

如果为空，停止并提示用户安装 Node.js（https://nodejs.org）。

记录 node 绝对路径为 `{NODE_PATH}`。

## Step 3: 验证脚本可执行

```bash
node "{PLUGIN_DIR}/hud/dist/index.js"
```

应输出 2~3 行文本。如果报错，检查路径是否正确。

## Step 4: 生成 statusLine command

命令格式（固定路径，稳定可靠）：

```
"{NODE_PATH}" "{PLUGIN_DIR}/hud/dist/index.js"
```

## Step 5: 写入 ~/.claude/settings.json

读取现有 settings.json，合并以下配置（保留其他字段）：

```json
{
  "statusLine": {
    "type": "command",
    "command": "{GENERATED_COMMAND}"
  }
}
```

settings 文件路径：`~/.claude/settings.json`

如果文件不存在，创建它。如果已有 `statusLine` 配置，覆盖它。

## Step 6: 验证

告知用户：
- 状态栏将在 Claude Code 输入框下方显示
- **第 1 行**：Context 用量进度条 + Token 数量 + 当前会话费用
- **第 2 行**：当前需求状态 + 需求名 → 当前 Feature + Feature 进度 (X/N)
- **第 3 行**（有进度日志时）：最新操作摘要

> HUD 读取项目中的以下文件：
> - `.dev-enegine/requirements/manifest.json`（当前需求）
> - `.dev-enegine/requirements/<需求ID>/feature_list.json`（feature 进度）
> - `.dev-enegine/claude-progress.txt`（最新日志）
>
> 这些文件由 `/requirement-dev` 命令自动维护，无需手动管理。

**重启 Claude Code 使配置生效。**
