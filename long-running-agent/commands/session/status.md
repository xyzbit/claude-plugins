---
description: 查看当前会话状态和进度
---

# Session Status

查看当前项目的开发进度和状态。

## 如何执行

### 查看进度日志
```bash
cat claude-progress.txt
```

### 查看功能列表
```bash
cat feature_list.json
```

### 查看待办功能
```bash
cat feature_list.json | grep -A2 '"passes": false'
```

### 查看 Git 历史
```bash
git log --oneline -10
```

### 查看 Git 状态
```bash
git status
```

## 输出信息

- 当前进度日志
- 待完成的功能列表
- 已完成的功能数量
- Git 提交历史
- 未提交的更改

## 提示

- 每次会话开始时都应该查看状态
- 确保了解当前的项目进度再开始编码
