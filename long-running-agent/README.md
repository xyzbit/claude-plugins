# Long-Running Agent Plugin

基于 Anthropic 论文《Effective Harnesses for Long-Running Agents》设计的双轨 Agent 系统，用于指导 AI Agent 进行增量开发。

## 插件结构

```
long-running-agent/
├── .claude-plugin/
│   └── plugin.json          # 插件元数据
├── agents/
│   ├── initializer.md       # 初始化代理
│   └── coding.md           # 编码代理
├── skills/
│   └── start-session/
│       └── SKILL.md        # 启动会话技能
├── commands/
│   ├── dev-server/
│   │   ├── start.md        # 启动开发服务器
│   │   └── stop.md         # 停止开发服务器
│   ├── build/
│   │   ├── frontend.md     # 构建前端
│   │   └── backend.md      # 构建后端
│   ├── test/
│   │   └── run.md          # 运行测试
│   └── session/
│       ├── status.md       # 查看会话状态
│       ├── commit.md       # 提交代码
│       └── complete.md     # 标记功能完成
├── backend/                 # Go 后端模板
├── frontend/               # Next.js 前端模板
├── harness/               # 核心脚本
└── README.md
```

## 功能

### Agents

1. **Initializer Agent** (`/initializer`)
   - 负责项目初始设置
   - 创建功能清单 (feature_list.json)
   - 编写启动脚本 (init.sh)
   - 初始化 Git 仓库

2. **Coding Agent** (`/coding`)
   - 负责增量开发
   - 一次只实现一个功能
   - 验证功能后提交代码
   - 更新进度日志

### Skills

1. **start-session** (`/start-session`)
   - 启动 Long-Running Agent 会话
   - 自动判断项目状态（初始化/增量开发）
   - 引导正确的代理工作流程

### Commands

#### 开发服务器
- `/dev-server:start` - 启动开发服务器 (frontend/backend/all)
- `/dev-server:stop` - 停止开发服务器

#### 构建
- `/build:frontend` - 构建前端项目
- `/build:backend` - 构建后端项目

#### 测试
- `/test:run` - 运行测试 (frontend/backend/all)

#### 会话管理
- `/session:status` - 查看当前进度和待办功能
- `/session:commit` - 提交代码更改
- `/session:complete` - 标记功能为已完成

## 使用方法

### 启动会话

```
/start-session
```

### 开发流程

1. **查看状态**
   ```
   /session:status
   ```

2. **启动开发服务器**
   ```
   /dev-server:start all
   ```

3. **开发功能**

4. **运行测试**
   ```
   /test:run all
   ```

5. **标记完成**
   ```
   /session:complete <功能描述>
   ```

6. **提交代码**
   ```
   /session:commit <提交信息>
   ```

## 核心设计原则

1. **增量开发**: 每次只实现一个功能
2. **保持代码干净**: 无重大 bug、代码有序
3. **Git 提交**: 每次完成功能后提交
4. **进度跟踪**: 写入 progress 文件供下一会话参考

## 文件约定

- `feature_list.json` - 功能清单，记录所有待实现功能
- `claude-progress.txt` - 进度日志，记录当前状态和下一步计划
- `init.sh` - 启动脚本，用于启动开发服务器
