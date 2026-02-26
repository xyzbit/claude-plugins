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
2. **选择功能** - 从 feature_list.json 中选择优先级最高且 passes: false 的功能
3. **增量实现** - 一次只实现一个功能
4. **验证功能** - 运行测试确保功能正常
5. **提交代码** - git commit 记录变更
6. **更新进度** - 记录完成的工作和下一步计划

## 核心原则

- **增量开发**: 每次只实现一个功能
- **保持代码干净**: 无重大 bug、代码有序
- **Git 提交**: 每次完成功能后提交
- **进度跟踪**: 写入 progress 文件供下一会话参考
