---
description: 需求开发主流程。传入需求描述，自动完成规划→编码→测试的全流程。
argument-hint: <需求描述> [--level high|medium|low] [--parallel_features true|false]
allowed-tools: Bash,Read,Write,Grep,TodoWrite
---

# Requirement Dev

需求开发主编排命令。根据需求状态自动选择 Plan → Code → Test 流程，支持人工控制等级。

## 执行流程

### 第一步：加载配置

```bash
cat .dev-enegine/.lra-config.json
```

读取默认配置。如果用户通过 `--level` 传入了控制等级，则覆盖配置中的 `control_level`。

配置项说明：
- `control_level`：人工控制等级（high/medium/low）
- `max_test_retry`：单个 feature 最大重试次数
- `parallel_features`：是否并行开发无依赖的 features, 注意 false 一定不要并发启动 subagent

### 第二步：判断需求状态

```bash
cat .dev-enegine/requirements/manifest.json
```

读取需求索引，判断当前需求是否已存在：
- 将用户输入的需求描述与 manifest 中已有需求做语义匹配
- 如果匹配到已有需求，检查其 `status` 字段
- 如果未匹配到，视为新需求

### 第三步：状态分流

读取 manifest 中当前需求的 `status`，按下表执行对应操作：

| 状态 | 说明 | 操作 |
|------|------|------|
| 不存在 | 未匹配到已有需求 | 创建需求目录，向 manifest.json 添加条目 `{ "dir": "<目录名>", "name": "<需求简称>", "status": "planning" }`，进入规划 |
| `planning` | 规划未完成 | 调用 `Planner Agent`，用户确认后状态改为 `developing`，进入`开发循环` |
| `developing` | 规划已完成 | 直接进入`开发循环` |
| `completed` | 全部完成 | 展示完成摘要，询问是否继续新需求 |
| `blocked` | 存在阻塞 feature | 展示阻塞原因，询问用户：恢复 / 跳过 / 终止 |

### 第四步：开发循环

#### 获取下一个|批待开发 feature
读取需求目录下的 `feature_list.json`，按 DAG 拓扑排序执行, 获取下一个|批待开发 feature。

获取规则如下：
```
规则：
1. passes == false 且 blocked != true
2. depends_on 中所有 feature 的 passes == true
3. 如果 parallel_features == false，一次只取一个
4. 如果 parallel_features == true，取所有满足条件的（当前版本暂不实现并行调用，只标记可并行的 features）
```

#### 调用 Coder Agent 开发
调用 `Coder Agent`，传入 feature 对象、需求目录路径及上一轮失败摘要（如有）。

**根据结果处理**：

| 结果 | 操作 |
|------|------|
| PASS，`control_level != high` | 直接继续下一个 feature |
| PASS，`control_level == high` | 向用户展示 feature 详情，确认后标记 `passes = true`，继续 |
| FAIL，`失败次数 < max_test_retry` | 携带失败摘要重试 Coder Agent |
| FAIL，`失败次数 >= max_test_retry` | 标记 `blocked = true`，跳过，若后续所有 feature 均依赖此项则整体置为 `blocked` |

**结束条件**：所有 feature `passes == true` → manifest 置 `completed`；存在 blocked → manifest 置 `blocked`。未结束则回到`获取下一个|批待开发 feature` 继续开发

### 第五步：收尾
1. 记录
```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Requirement completed: <需求名>" >> .dev-enegine/claude-progress.txt
```
2. 报告
向用户报告最终结果：
- 完成的 feature 数量
- 阻塞的 feature 数量（如有）
- Git 提交记录摘要

## 注意事项

- 主会话负责编排，不直接编写代码
- 人工确认点由 `control_level` 配置决定
- 尽量保持主会话干净

