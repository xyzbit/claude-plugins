# Skill: 标记功能完成

Agent 在功能**真正验证通过**后，执行以下步骤将功能标记为已完成。

## 前提条件

- 功能代码已实现
- 相关测试已通过（参考 `skills/test/run.md`）
- 端到端验证已完成（如需要）

## 执行步骤

### 1. 确认要标记的功能

```bash
cat feature_list.json
```

找到对应功能的条目，确认描述匹配。

### 2. 将 passes 改为 true

```bash
# 使用 jq 标记第一个未完成功能为已完成
jq '.features |= map(if .passes == false then first |= . + {"passes": true} else . end)' feature_list.json > temp.json && mv temp.json feature_list.json
```

或者直接编辑 `feature_list.json`，将对应功能的 `"passes": false` 改为 `"passes": true`。

### 3. 更新进度日志

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Completed: [功能描述]" >> claude-progress.txt
```

## 约束

- **禁止修改 feature_list.json 中 passes 字段以外的任何内容**
- 只有功能真正通过验证后才能标记为完成，不得提前标记
- 标记完成后，随即执行提交（参考 `skills/session/commit.md`）
