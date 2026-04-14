> 项目基于 https://github.com/jarrodwatts/claude-hud 扩展

# Claude HUD

Claude Code 实时状态栏插件 — 上下文用量、工具活动、子代理追踪、Todo 进度、Dev Engine 需求看板，一目了然。

[![License](https://img.shields.io/github/license/jarrodwatts/claude-hud?v=2)](LICENSE)

![Claude HUD in action](claude-hud-preview-5-2.png)

## 安装

在 Claude Code 中执行以下命令：

**第 1 步：添加 marketplace**
```
/plugin marketplace add xyzbit/claude-plugins
```

**第 2 步：安装插件**

<details>
<summary><strong>⚠️ Linux 用户请先看这里</strong></summary>

Linux 上 `/tmp` 通常是独立文件系统（tmpfs），会导致安装失败：
```
EXDEV: cross-device link not permitted
```

**解决方法**：安装前设置 TMPDIR：
```bash
mkdir -p ~/.cache/tmp && TMPDIR=~/.cache/tmp claude
```

然后在该会话中运行安装命令。这是 [Claude Code 平台限制](https://github.com/anthropics/claude-code/issues/14799)。

</details>

```
/plugin install claude-hud
```

**第 3 步：配置状态栏**
```
/claude-hud:setup
```

完成！HUD 立即显示，无需重启。

---

## 功能概览

| 显示内容 | 价值 |
|----------|------|
| **项目路径** | 快速确认当前项目（可配置 1-3 级目录） |
| **上下文健康度** | 精确了解上下文窗口占用，避免溢出 |
| **工具活动** | 实时观察 Claude 的文件读取、编辑、搜索操作 |
| **子代理追踪** | 查看正在运行的 subagent 及其任务 |
| **Todo 进度** | 实时追踪任务完成度 |
| **Dev Engine 看板** | 显示当前需求、功能进度（与 dev-enegine 插件联动） |
| **订阅用量** | Pro/Max/Team 用户的速率限额消耗（5h/7d） |
| **输出速度** | 显示 token 输出速率 `out: X tok/s` |

## 显示效果

### 默认（2 行）
```
[Opus | Max] │ my-project git:(main*)
Context █████░░░░░ 45% │ Usage ██░░░░░░░░ 25% (1h 30m / 5h)
```
- **第 1 行** — 模型、订阅计划（或 `Bedrock`）、项目路径、Git 分支
- **第 2 行** — 上下文条形图（绿→黄→红）和用量限额

### 可选行（通过 `/claude-hud:configure` 启用）
```
◐ Edit: auth.ts | ✓ Read ×3 | ✓ Grep ×2        ← 工具活动
◐ explore [haiku]: Finding auth code (2m 15s)    ← 子代理状态
▸ Fix authentication bug (2/5)                   ← Todo 进度
⚙ 用户登录模块 [developing] 3/8 ▸ 实现JWT验证   ← Dev Engine
```

---

## 相对上游的扩展功能

本版本在上游 [jarrodwatts/claude-hud](https://github.com/jarrodwatts/claude-hud) 基础上增加了：

| 功能 | 说明 |
|------|------|
| **Dev Engine 集成** | 读取 `.dev-enegine/` 目录数据，在状态栏显示当前需求名称、状态、功能进度和最新日志 |
| **Extra Command** | 支持 `--extra-cmd` 参数执行自定义命令，将 JSON 输出的 `label` 字段追加到状态栏 |
| **会话名显示** | 显示 `/rename` 设置的会话名称 |
| **剩余上下文模式** | `contextValue: "remaining"` 显示剩余上下文百分比 |

---

## 工作原理

Claude HUD 使用 Claude Code 原生 **statusline API** — 无需额外窗口、无需 tmux，任何终端都能运行。

```
Claude Code → stdin JSON → claude-hud → stdout → 终端显示
           ↘ transcript JSONL（工具、代理、Todo）
```

**核心特性：**
- 原生 token 数据（非估算）
- 解析 transcript 获取工具/代理活动
- 约 300ms 更新间隔

---

## 配置

随时自定义 HUD：

```
/claude-hud:configure
```

引导式问卷，无需手动编辑：

- **首次配置**：选择预设（Full/Essential/Minimal），然后微调各项
- **随时修改**：开关各项元素、调整 Git 显示风格、切换布局
- **保存前预览**：确认效果后再应用

### 预设

| 预设 | 显示内容 |
|------|----------|
| **Full** | 全部启用 — 工具、代理、Todo、Git、用量、时长 |
| **Essential** | 活动行 + Git 状态，信息精简 |
| **Minimal** | 仅核心 — 模型名 + 上下文条 |

### 手动配置

直接编辑配置文件 `~/.claude/plugins/claude-hud/config.json`。

### 配置选项

| 选项 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `lineLayout` | string | `expanded` | 布局：`expanded`（多行）或 `compact`（单行） |
| `pathLevels` | 1-3 | 1 | 项目路径显示的目录层级数 |
| `gitStatus.enabled` | boolean | true | 显示 Git 分支 |
| `gitStatus.showDirty` | boolean | true | 有未提交更改时显示 `*` |
| `gitStatus.showAheadBehind` | boolean | false | 显示 `↑N ↓N`（领先/落后远程） |
| `gitStatus.showFileStats` | boolean | false | 显示文件变更统计 `!M +A ✘D ?U` |
| `display.showModel` | boolean | true | 显示模型名 `[Opus]` |
| `display.showContextBar` | boolean | true | 显示上下文条形图 `████░░░░░░` |
| `display.contextValue` | string | `percent` | 上下文格式：`percent`、`tokens`、`remaining` |
| `display.showConfigCounts` | boolean | false | 显示 CLAUDE.md、rules、MCPs、hooks 计数 |
| `display.showDuration` | boolean | false | 显示会话时长 `⏱️ 5m` |
| `display.showSpeed` | boolean | false | 显示输出速度 `out: 42.1 tok/s` |
| `display.showUsage` | boolean | true | 显示用量限额（仅 Pro/Max/Team） |
| `display.usageBarEnabled` | boolean | true | 用量显示为条形图 |
| `display.sevenDayThreshold` | 0-100 | 80 | 7 天用量 >= 阈值时显示（0 = 始终显示） |
| `display.showTokenBreakdown` | boolean | true | 高上下文（85%+）时显示 token 详情 |
| `display.showTools` | boolean | false | 显示工具活动行 |
| `display.showAgents` | boolean | false | 显示代理活动行 |
| `display.showTodos` | boolean | false | 显示 Todo 进度行 |

### 订阅用量（Pro/Max/Team）

用量显示默认启用。它在第 2 行的上下文条旁显示速率限额消耗。

7 天百分比在超过 `display.sevenDayThreshold`（默认 80%）时显示：

```
Context █████░░░░░ 45% │ Usage ██░░░░░░░░ 25% (1h 30m / 5h) | ██████████ 85% (2d / 7d)
```

禁用方法：将 `display.showUsage` 设为 `false`。

**要求：**
- Claude Pro、Max 或 Team 订阅（API 用户不可用）
- Claude Code 自动创建的 OAuth 凭据

**排查：** 如果用量不显示：
- 确认使用 Pro/Max/Team 账户登录（非 API key）
- 检查 `display.showUsage` 是否为 `false`
- API 用户无用量显示（按量付费，无速率限额）
- AWS Bedrock 模型显示 `Bedrock`，隐藏用量限额

### 配置示例

```json
{
  "lineLayout": "expanded",
  "pathLevels": 2,
  "gitStatus": {
    "enabled": true,
    "showDirty": true,
    "showAheadBehind": true,
    "showFileStats": true
  },
  "display": {
    "showTools": true,
    "showAgents": true,
    "showTodos": true,
    "showConfigCounts": true,
    "showDuration": true
  }
}
```

### 路径显示示例

**1 级（默认）：** `[Opus] │ my-project git:(main)`

**2 级：** `[Opus] │ apps/my-project git:(main)`

**3 级：** `[Opus] │ dev/apps/my-project git:(main)`

**脏标记：** `[Opus] │ my-project git:(main*)`

**领先/落后：** `[Opus] │ my-project git:(main ↑2 ↓1)`

**文件统计：** `[Opus] │ my-project git:(main* !3 +1 ?2)`
- `!` = 已修改, `+` = 已添加/暂存, `✘` = 已删除, `?` = 未追踪
- 计数为 0 时省略

### 排查

**配置不生效？**
- 检查 JSON 语法错误：无效 JSON 会静默回退到默认值
- 确保值有效：`pathLevels` 须为 1、2 或 3；`lineLayout` 须为 `expanded` 或 `compact`
- 删除配置后运行 `/claude-hud:configure` 重新生成

**Git 状态缺失？**
- 确认在 Git 仓库中
- 检查 `gitStatus.enabled` 是否为 `false`

**工具/代理/Todo 行缺失？**
- 默认隐藏 — 在配置中启用 `showTools`、`showAgents`、`showTodos`
- 仅在有活动时显示

---

## 环境要求

- Claude Code v1.0.80+
- Node.js 18+ 或 Bun

---

## 开发

```bash
cd claude-hud
npm ci && npm run build
npm test
```

调试模式：`DEBUG=claude-hud` 或 `DEBUG=*`

详见 [CONTRIBUTING.md](CONTRIBUTING.md)。

---

## License

MIT — 详见 [LICENSE](LICENSE)
