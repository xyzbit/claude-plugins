# Skill: 提交代码

Agent 在每次完成功能并验证通过后，执行以下步骤提交代码。

## 执行步骤

### 1. 检查更改状态

```bash
git status
git diff --stat
```

### 2. 添加所有更改

```bash
git add .
```

### 3. 提交

```bash
git commit -m "Implement: [功能描述]"
```

## 提交信息规范

- 格式：`Implement: [功能描述]`
- 描述做了什么，而不是怎么做
- 示例：`git commit -m "Implement: Add user login feature"`

## 约束

- 提交前确保代码可以正常运行
- 必须先运行测试（参考 `skills/test/run.md`）
- 必须先标记功能完成（参考 `skills/session/complete.md`）
- 每次只提交一个完整功能的更改
