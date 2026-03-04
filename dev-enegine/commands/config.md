---
description: 查看或修改 Long-Running Agent 配置项。
argument-hint: [配置项=值] 或留空查看当前配置
allowed-tools: Bash,Read,Write
---

# Config

管理 Long-Running Agent 的项目级配置。配置文件位于 `.dev-enegine/.lra-config.json`。

## 执行流程

### 无参数：查看当前配置

```bash
cat .dev-enegine/.lra-config.json
```

以表格形式向用户展示当前所有配置项及其含义：

| 配置项 | 当前值 | 可选值 | 说明 |
|--------|--------|--------|------|
| `control_level` | - | `high` / `medium` / `low` | 人工控制等级。high=Plan后确认+每个Feature后确认；medium=Plan后确认；low=全自动 |
| `max_test_retry` | - | 正整数 | 单个 feature 最大重试次数 |
| `auto_commit` | - | `true` / `false` | Feature 验证通过后是否自动 git commit |
| `parallel_features` | - | `true` / `false` | 是否并行开发 DAG 中无依赖的 features |
| `template_repo` | - | git URL | 项目模板仓库地址 |

### 有参数：修改配置

用户可以通过以下方式修改：

```
/config control_level=high
/config max_test_retry=3
/config parallel_features=true
```

修改步骤：

1. 读取当前配置
   ```bash
   cat .dev-enegine/.lra-config.json
   ```

2. 验证参数合法性：
   - `control_level`：必须是 `high`、`medium`、`low` 之一
   - `auto_commit`：必须是 `true` 或 `false`
   - `parallel_features`：必须是 `true` 或 `false`
   - `template_repo`：必须是有效的 git URL

3. 更新配置文件中对应字段

4. 向用户确认修改结果

## 默认配置

如果 `.dev-enegine/.lra-config.json` 不存在，创建默认配置：

```json
{
  "control_level": "low",
  "auto_commit": true,
  "parallel_features": false,
  "template_repo": "git@github.com:xyzbit/ai-coding-layout.git"
}
```

## 注意事项

- 配置修改立即生效，下次执行 `/requirement-dev` 时会使用新配置
- `/requirement-dev` 的 `--level` 参数会临时覆盖 `control_level`，但不会修改配置文件
