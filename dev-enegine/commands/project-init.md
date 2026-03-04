---
description: 初始化新项目，拉取模板并跑通 demo。仅在首次创建项目时使用。
argument-hint: <项目名称> [--no-template]
allowed-tools: Bash,Read,Write,Grep,TodoWrite
---

# Project Init

初始化一个新项目。此命令仅需执行一次，用于搭建项目骨架、创建配置文件和需求管理目录。

## 执行流程

### 第一步：解析参数

从用户输入中提取：
- **项目名称**（必须）
- **是否使用模板**（可选，用户说"不用模板"或传 `--no-template` 时为否，默认为是）

### 第二步：检查项目是否已存在

```bash
ls <项目名称>/.dev-enegine/.lra-config.json 2>/dev/null && echo "PROJECT_EXISTS" || echo "NEW_PROJECT"
```

如果项目已存在，提示用户并终止。

### 第三步：调用 Initializer Agent

将项目名称和模板选项传递给 **Initializer Agent** 子代理。

Initializer Agent 将初始化项目骨架并完成首次提交。

## 注意事项

- 此命令仅用于首次初始化，不要用于需求开发
- 初始化完成后，使用 `/requirement-dev` 进行需求开发
