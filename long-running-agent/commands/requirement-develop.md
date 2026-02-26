---
description: 启动 Long-Running Agent 开发模式，根据需求进行自动化开发
argument-hint: <需求描述（可选，新项目时提供）>
allowed-tools: Bash,Read,Write,Grep,TodoWrite
---

# Requirement Develop

启动 Long-Running Agent 开发模式。这是一个基于 Anthropic 论文《Effective Harnesses for Long-Running Agents》设计的自动化开发模式。

Agent 将自动判断当前状态并选择合适的工作流程。

## 执行流程

### 第一步：判断项目状态

检查当前目录是否存在 `feature_list.json`：

```bash
ls feature_list.json 2>/dev/null && echo "EXISTS" || echo "NEW_PROJECT"
```

### 第二步：选择代理模式

#### 全新项目（feature_list.json 不存在）

使用 **Initializer Agent** 子代理进行初始化项目。

#### 已有项目（feature_list.json 存在）

使用 **Coding Agent** 子代理进行增量开发。

## 注意事项
- 所有状态管理、提交、测试均由 Agent 自动完成，无需用户手动执行
- 如需中途查看进度，可以直接询问 Agent 当前状态
