---
description: 标记功能为已完成
argument-hint: <feature-description>
allowed-tools: Read,Write,Bash
---

# Mark Feature Complete

将功能标记为已完成。

## 如何执行

### 1. 查看待办功能
首先查看当前有哪些待完成的功能：
```bash
cat feature_list.json
```

### 2. 标记功能完成

找到要标记的功能，将 `passes` 字段从 `false` 改为 `true`：

```bash
# 使用 jq 标记第一个待办功能完成
jq '.features |= map(if .passes == false then .passes = true else . end)' feature_list.json > temp.json && mv temp.json feature_list.json
```

或者手动编辑 `feature_list.json`，找到对应的功能，将其 `passes` 改为 `true`。

### 3. 更新进度日志

在 `claude-progress.txt` 中添加完成记录：

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Completed: [功能描述]" >> claude-progress.txt
```

## 约束

- **禁止修改 feature_list.json 的 passes 字段以外的内容**
- 只有在功能真正验证通过后才能标记为完成

## 提示

- 使用 `/session:status` 查看当前功能列表
- 确保功能已经过测试验证
- 提交更改：`/session:commit "Complete: [功能描述]"`
