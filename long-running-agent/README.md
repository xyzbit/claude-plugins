# Long-Running Agent Plugin

基于 Anthropic 论文《Effective Harnesses for Long-Running Agents》设计的双轨 Agent 系统，用于指导 AI Agent 进行自动化增量开发。

## 插件结构

```
long-running-agent/
├── .claude-plugin/
│   └── plugin.json          # 插件元数据
├── agents/
│   ├── initializer.md       # 初始化代理（使用项目模板）
│   ├── initializer-notemp.md # 初始化代理（无模板依赖）
│   └── coding.md            # 编码代理
├── skills/                  # Agent 运行时参考的技能文档
│   ├── session/
│   │   ├── status.md        # 查看会话状态
│   │   ├── complete.md      # 标记功能完成
│   │   └── commit.md        # 提交代码
│   └── test/
│       └── run.md           # 运行测试
├── commands/
│   └── requirement-develop.md  # 启动开发的入口命令
└── README.md
```

## 使用方法

### 唯一入口：启动开发

```
/requirement-develop <需求描述（新项目时提供）>
```

Agent 会自动：
1. **判断项目状态**：检查 `feature_list.json` 是否存在
2. **选择代理模式**：
   - 全新项目 → **Initializer Agent** 或 **Initializer-NoTemp Agent**：初始化完整项目结构
   - 已有项目 → **Coding Agent**：继续增量开发
3. **自动完成开发循环**：实现功能 → 验证 → 标记完成 → 提交 → 更新进度

无需手动执行任何中间命令，Agent 会在运行过程中自动参考 `skills/` 下的技能文档完成所有操作。

---

## 状态文件数据流

本插件通过以下状态文件实现跨会话的增量开发：

### 核心状态文件

| 文件 | 说明 | 生命周期 |
|------|------|----------|
| `feature_list.json` | 功能清单，记录所有待实现功能及完成状态 | 项目创建时生成，持续更新 |
| `claude-progress.txt` | 进度日志，记录当前状态和下一步计划 | 项目创建时生成，持续更新 |
| `init.sh` | 启动脚本，用于启动开发服务器 | 项目创建时生成 |
| Git 仓库 | 代码版本管理 | 项目创建时初始化 |

### 数据流图

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           项目初始化阶段                                   │
│                           (Initializer Agent)                             │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│   用户需求 ──┬──> 创建 feature_list.json  ◄────────┐                   │
│             │                                     │                    │
│             ├──> 创建 claude-progress.txt ────────┤                    │
│             │                                     │                    │
│             ├──> 创建 init.sh                     │                    │
│             │                                     │                    │
│             ├──> 初始化 Git 仓库                  │                    │
│             │                                     │                    │
│             └──> 执行初始 git commit              │                    │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                           增量开发阶段                                    │
│                           (Coding Agent)                                 │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│   会话开始 ──> 读取 feature_list.json ──> 选择最高优先级功能             │
│       │                                                           │      │
│       ├──> 读取 claude-progress.txt                               │      │
│       │                                                           │      │
│       ├──> 启动开发服务器 (source init.sh)                        │      │
│       │                                                           │      │
│       │     ┌─────────────────────────────────────────────────┐  │      │
│       │     │           功能实现与验证循环                     │  │      │
│       │     ├─────────────────────────────────────────────────┤  │      │
│       │     │                                                 │  │      │
│       │     │  1. 实现功能代码                                 │  │      │
│       │     │         │                                       │  │      │
│       │     │         ▼                                       │  │      │
│       │     │  2. 运行测试 (skills/test/run.md)               │  │      │
│       │     │         │                                       │  │      │
│       │     │         ▼                                       │  │      │
│       │     │  3. 端到端验证（如需要）                        │  │      │
│       │     │         │                                       │  │      │
│       │     │         ▼                                       │  │      │
│       │     │  4. 测试通过？ ──No──> 返回步骤1               │  │      │
│       │     │         │Yes                                     │  │      │
│       │     │         ▼                                       │  │      │
│       │     └─────────────────────────────────────────────────┘  │      │
│       │                         │                                 │      │
│       │                         ▼                                 │      │
│       │     ┌─────────────────────────────────────────────────┐  │      │
│       │     │          标记完成 (skills/session/complete.md)   │  │      │
│       │     ├─────────────────────────────────────────────────┤  │      │
│       │     │                                                 │  │      │
│       │     │  修改 feature_list.json:                        │  │      │
│       │     │    "passes": false ──> "passes": true           │  │      │
│       │     │                                                 │  │      │
│       │     │  更新 claude-progress.txt:                     │  │      │
│       │     │    追加完成记录                                  │  │      │
│       │     └─────────────────────────────────────────────────┘  │      │
│       │                         │                                 │      │
│       │                         ▼                                 │      │
│       │     ┌─────────────────────────────────────────────────┐  │      │
│       │     │          提交代码 (skills/session/commit.md)    │  │      │
│       │     ├─────────────────────────────────────────────────┤  │      │
│       │     │                                                 │  │      │
│       │     │  git add .                                      │  │      │
│       │     │  git commit -m "Implement: [功能描述]"           │  │      │
│       │     └─────────────────────────────────────────────────┘  │      │
│       │                                                           │      │
│       └──> 会话结束，等待下次启动                                 │      │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 状态文件修改详情

| 阶段 | Agent | 修改的文件 | 修改内容 |
|------|-------|------------|----------|
| 初始化 | Initializer Agent | `feature_list.json` | 创建功能清单（所有 passes: false） |
| 初始化 | Initializer Agent | `claude-progress.txt` | 创建初始进度日志 |
| 初始化 | Initializer Agent | `init.sh` | 创建启动脚本 |
| 初始化 | Initializer Agent | Git | 执行初始提交 |
| 增量开发 | Coding Agent | 读取 `feature_list.json` | 选择待实现功能 |
| 增量开发 | Coding Agent | 读取 `claude-progress.txt` | 了解当前状态 |
| 增量开发 | Coding Agent | `feature_list.json` | 修改 passes: false → true |
| 增量开发 | Coding Agent | `claude-progress.txt` | 追加完成记录 |
| 增量开发 | Coding Agent | Git | 提交代码更改 |

### feature_list.json 结构

```json
{
  "features": [
    {
      "category": "functional",
      "description": "功能描述",
      "steps": ["步骤1", "步骤2", "步骤3"],
      "passes": false
    }
  ]
}
```

### claude-progress.txt 示例

```
# 项目: MyApp
# 描述: 一个任务管理应用

## 当前状态
- 已完成: 3/10 功能
- 当前: 实现用户登录功能

## 进度记录
[2024-01-15 10:30:00] Completed: Create project structure
[2024-01-15 11:45:00] Completed: Implement user registration
[2024-01-15 14:20:00] Completed: Add unit tests

## 下一步计划
实现用户登录功能
```

---

## Agents

### Initializer Agent

负责全新项目的初始化（使用项目模板）：
- 克隆项目模板仓库
- 根据需求创建完整的功能清单（`feature_list.json`）
- 生成前后端项目结构
- 编写启动脚本（`init.sh`）和进度日志（`claude-progress.txt`）
- 初始化 Git 仓库并执行初始提交

### Initializer-NoTemp Agent

负责全新项目的初始化（无模板依赖）：
- 根据需求创建完整的功能清单（`feature_list.json`）
- 从零创建项目结构
- 编写启动脚本（`init.sh`）和进度日志（`claude-progress.txt`）
- 初始化 Git 仓库并执行初始提交

### Coding Agent

负责已有项目的增量开发：
- 每次会话只实现一个最高优先级功能
- 实现完成后自动运行测试验证
- 验证通过后标记完成并提交代码
- 更新进度日志供下次会话使用

---

## Skills（Agent 内部参考）

这些技能文档由 Agent 在运行过程中自动参考，用户无需直接调用：

| Skill | 用途 | 修改的文件 |
|-------|------|----------|
| `skills/session/status.md` | 读取当前项目状态和进度 | 无（只读） |
| `skills/session/complete.md` | 将功能标记为已完成 | `feature_list.json`, `claude-progress.txt` |
| `skills/session/commit.md` | 提交代码更改 | Git |
| `skills/test/run.md` | 运行前端/后端/集成测试 | 无（只读） |

---

## 核心设计原则

1. **增量开发**：每次只实现一个功能，保持稳定可验证
2. **验证驱动**：必须真实验证通过才能标记完成
3. **Git 提交**：每次完成功能后自动提交，保持清晰历史
4. **进度跟踪**：写入 progress 文件，支持跨会话连续工作

---

## 文件约定

| 文件 | 说明 |
|------|------|
| `feature_list.json` | 功能清单，记录所有待实现功能及完成状态 |
| `claude-progress.txt` | 进度日志，记录当前状态和下一步计划 |
| `init.sh` | 启动脚本，用于启动开发服务器 |
