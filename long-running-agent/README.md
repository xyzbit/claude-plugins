# Long-Running Agent Plugin

基于 Anthropic 论文《Effective Harnesses for Long-Running Agents》设计的双轨 Agent 系统，用于指导 AI Agent 进行自动化增量开发。

## 插件结构

```
long-running-agent/
├── .claude-plugin/
│   └── plugin.json          # 插件元数据
├── agents/
│   ├── initializer.md       # 初始化代理
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
├── templates/               # 项目模板
│   ├── backend/             # Go 后端模板
│   └── frontend/            # Next.js 前端模板
└── README.md
```

## 使用方法

### 唯一入口：启动开发

```
/requirement-develop <需求描述（新项目时提供）>
```

Agent 会自动：
1. **判断项目状态**：检查 `workspace/feature_list.json` 是否存在
2. **选择代理模式**：
   - 全新项目 → **Initializer Agent**：初始化完整项目结构
   - 已有项目 → **Coding Agent**：继续增量开发
3. **自动完成开发循环**：实现功能 → 验证 → 标记完成 → 提交 → 更新进度

无需手动执行任何中间命令，Agent 会在运行过程中自动参考 `skills/` 下的技能文档完成所有操作。

## Agents

### Initializer Agent

负责全新项目的初始化：
- 根据需求创建完整的功能清单（`feature_list.json`）
- 生成前后端项目结构（基于模板）
- 编写启动脚本（`init.sh`）和进度日志（`claude-progress.txt`）
- 初始化 Git 仓库

### Coding Agent

负责已有项目的增量开发：
- 每次会话只实现一个最高优先级功能
- 实现完成后自动运行测试验证
- 验证通过后标记完成并提交代码
- 更新进度日志供下次会话使用

## Skills（Agent 内部参考）

这些技能文档由 Agent 在运行过程中自动参考，用户无需直接调用：

| Skill | 用途 |
|-------|------|
| `skills/session/status.md` | 读取当前项目状态和进度 |
| `skills/session/complete.md` | 将功能标记为已完成 |
| `skills/session/commit.md` | 提交代码更改 |
| `skills/test/run.md` | 运行前端/后端/集成测试 |

## 核心设计原则

1. **增量开发**：每次只实现一个功能，保持稳定可验证
2. **验证驱动**：必须真实验证通过才能标记完成
3. **Git 提交**：每次完成功能后自动提交，保持清晰历史
4. **进度跟踪**：写入 progress 文件，支持跨会话连续工作

## 文件约定

| 文件 | 说明 |
|------|------|
| `workspace/feature_list.json` | 功能清单，记录所有待实现功能及完成状态 |
| `workspace/claude-progress.txt` | 进度日志，记录当前状态和下一步计划 |
| `workspace/init.sh` | 启动脚本，用于启动开发服务器 |
