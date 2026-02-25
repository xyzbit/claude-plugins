---
description: 提交当前更改
argument-hint: <commit-message>
allowed-tools: Bash,Grep,Read
---

# Commit Changes

提交当前的代码更改。

## 如何执行

### 1. 检查更改状态
首先查看有哪些文件被修改：
```bash
git status
git diff --stat
```

### 2. 添加更改
```bash
git add .
```

### 3. 提交更改
```bash
git commit -m "Implement: [功能描述]"
```

## 提交规范

- 使用清晰的提交信息
- 格式：`Implement: [功能描述]`
- 例如：`git commit -m "Implement: Add user login feature"`

## 提示

- 提交前确保代码可以正常运行
- 建议先运行测试：`/test:run`
- 提交信息应该描述做了什么，而不是怎么做
