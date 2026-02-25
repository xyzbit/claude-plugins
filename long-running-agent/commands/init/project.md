---
description: 初始化新项目（复制模板）
argument-hint: <project-name>
allowed-tools: Bash,Read,Write,Glob
---

# Initialize Project

使用 Long-Running Agent 模板初始化新项目。

## 如何执行

### 1. 创建项目目录
首先创建项目目录（如果需要）：
```bash
mkdir -p $ARGUMENTS && cd $ARGUMENTS
```

### 2. 复制模板文件

从插件目录复制模板到当前项目：

```bash
# 复制 backend 模板
cp -r ${CLAUDE_PLUGIN_ROOT}/../long-running-agent/backend ./

# 复制 frontend 模板
cp -r ${CLAUDE_PLUGIN_ROOT}/../long-running-agent/frontend ./

# 复制 harness 脚本
mkdir -p harness
cp ${CLAUDE_PLUGIN_ROOT}/../long-running-agent/harness/*.md harness/
cp ${CLAUDE_PLUGIN_ROOT}/../long-running-agent/harness/session.sh harness/
```

### 3. 初始化 Git
```bash
git init
git add .
git commit -m "Initial commit: Long-Running Agent project structure"
```

### 4. 创建工作空间
```bash
mkdir -p workspace
```

## 输出

项目结构：
```
project/
├── backend/           # Go 后端模板
├── frontend/          # Next.js 前端模板
├── harness/          # Agent 指令
├── workspace/       # 功能清单和进度文件
└── .git/
```

## 提示

- 插件根目录可通过 `${CLAUDE_PLUGIN_ROOT}` 获取
- 复制后需要根据具体需求修改配置
- 参考 `harness/initializer.md` 创建功能清单
