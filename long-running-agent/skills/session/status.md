# Skill: 查看会话状态

Agent 在每次会话开始时，以及需要了解当前进度时，应执行以下操作。

## 读取进度日志

```bash
cat claude-progress.txt
```

## 查看功能列表

```bash
cat feature_list.json
```

## 筛选待办功能

```bash
cat feature_list.json | grep -A2 '"passes": false'
```

## 查看 Git 历史

```bash
git log --oneline -10
```

## 查看未提交更改

```bash
git status
```

## 输出信息说明

- **进度日志**：了解上一次 Agent 做了什么、当前状态和下一步计划
- **待完成功能**：确定本次会话要实现哪个功能
- **已完成数量**：掌握整体进展
- **Git 历史**：确认提交记录是否正常
- **未提交更改**：检查是否有遗留的未提交代码
