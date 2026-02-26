---
name: "Long-Running Develop Skill"
description: "介绍了 Long-Running Agent 运行流程和核心原则, Agent 需要通过遵循这些原则来完成开发任务"
triggers:
  - "run long task"
  - "start long task"
  - "long running develop"
  - "long running task"
---

# Long-Running Agent 开发指南

你正在启动一个 Long-Running Agent 开发模式。这是一个基于 Anthropic 论文《Effective Harnesses for Long-Running Agents》设计的开发模式。

## 核心逻辑

根据当前项目状态，选择合适的代理：

### 如果是全新项目（首次初始化）
> 通过 workspace/feature_list.json 等文件判断是否是全新项目

1. 切换到工作目录 (workspace/ 或当前目录)
2. 使用 **Initializer Agent** 开始初始化项目

### 如果是已有项目（增量开发）
使用 **Coding Agent** 进行增量开发

## 工作流程

1. **读取状态** - 了解当前项目进度
2. **判断是否是全新项目** - 通过 workspace/feature_list.json 等文件判断是否是全新项目
   - 如果是全新项目，则使用 **Initializer Agent** 开始初始化项目
   - 如果不是全新项目，则使用 **Coding Agent** 进行增量开发
