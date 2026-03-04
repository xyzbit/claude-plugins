# Long-Running Agent Hooks

本文档说明 Long-Running Agent 的生命周期 hooks 配置和手动测试流程。

## 架构概览

```
Planner Agent → Coder Agent (实现 + 验证)
                     │
                     └─ SubagentStop hook (on-coder-complete.sh)
                              │
                              ├─ PASS → 更新 feature_list.json passes=true
                              └─ FAIL → 记录日志，通知主会话重试

主会话结束
     │
     └─ Stop hook (check-completion.sh)
              │
              └─ 有未完成功能 → block，阻止主会话退出
```

## Hook 配置

`hooks/hooks.json`：

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/check-completion.sh",
            "timeout": 10,
            "statusMessage": "Checking feature completion status..."
          }
        ]
      }
    ],
    "SubagentStop": [
      {
        "matcher": "coder",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/on-coder-complete.sh",
            "timeout": 30,
            "statusMessage": "Processing coder test results..."
          }
        ]
      }
    ]
  }
}
```

### Stop Hook（`check-completion.sh`）

- **触发时机**：主会话即将结束时
- **作用**：检查当前开发需求中是否还有未完成（`passes=false`）且未阻塞的功能；若有则返回 `decision: block` 阻止退出

### SubagentStop Hook（`on-coder-complete.sh`）

- **触发时机**：`matcher: "coder"` 的 subagent 结束时
- **作用**：解析 Coder 输出的 JSON 结果，自动更新 `feature_list.json`，写进度日志

## Coder Agent 输出格式

Coder Agent 完成后**必须**在消息末尾输出纯文本格式的结果：

```
FEATURE_ID: F001
TEST_RESULT: PASS
```

测试失败时：

```
FEATURE_ID: F001
TEST_RESULT: FAIL
FAILURE_SUMMARY: login API returns 401 when using valid credentials
```

---

## 本地测试案例

> 前置条件：项目已通过 `/project-init` 和 `/requirement-dev` 初始化，存在 `.dev-enegine/` 目录结构。

### 准备测试目录结构

#### 方式一：一键执行脚本（推荐）

```bash
# 使用默认路径
./hooks/scripts/init-test-env.sh

# 或指定自定义项目路径
./hooks/scripts/init-test-env.sh /path/to/your/project
```

#### 方式二：手动执行

```bash
#!/bin/bash
# =============================================================================
# 初始化测试环境脚本
# =============================================================================
# 用途：一键创建测试所需的目录结构和配置文件
# 用法：./init-test-env.sh [项目根目录路径]
#
# 示例：
#   ./init-test-env.sh /Users/staff/code/ai/test-long-run/test-hook
#   或使用默认路径：./init-test-env.sh
# =============================================================================

set -e

# 默认项目根目录（如果未提供参数）
DEFAULT_PROJECT_ROOT="/Users/staff/code/ai/test-long-run/test-hook"

# 使用传入的参数，或使用默认值
PROJECT_ROOT="${1:-$DEFAULT_PROJECT_ROOT}"

echo "正在初始化测试环境..."
echo "项目根目录: $PROJECT_ROOT"
echo ""

# 创建目录结构
mkdir -p "$PROJECT_ROOT/.dev-enegine/requirements/req-001"

# manifest.json：标记 req-001 为 developing 状态
cat > "$PROJECT_ROOT/.dev-enegine/requirements/manifest.json" <<'EOF'
{
  "requirements": [
    { "dir": "req-001", "status": "developing" }
  ]
}
EOF
echo "✓ 已创建 manifest.json"

# feature_list.json：两个功能，F001 待完成，F002 已完成
cat > "$PROJECT_ROOT/.dev-enegine/requirements/req-001/feature_list.json" <<'EOF'
{
  "features": [
    { "id": "F001", "description": "用户登录 API", "passes": false, "blocked": false },
    { "id": "F002", "description": "用户注册 API", "passes": true,  "blocked": false }
  ]
}
EOF
echo "✓ 已创建 feature_list.json"

# lra-config.json：control_level=low（自动确认）
cat > "$PROJECT_ROOT/.dev-enegine/.lra-config.json" <<'EOF'
{ "control_level": "low" }
EOF
echo "✓ 已创建 .lra-config.json"

# 创建进度日志文件
touch "$PROJECT_ROOT/.dev-enegine/requirements/req-001/progress.log"
echo "✓ 已创建 progress.log"

echo ""
echo "✅ 测试环境初始化完成！"
echo ""
echo "创建的文件："
echo "  - $PROJECT_ROOT/.dev-enegine/requirements/manifest.json"
echo "  - $PROJECT_ROOT/.dev-enegine/requirements/req-001/feature_list.json"
echo "  - $PROJECT_ROOT/.dev-enegine/.lra-config.json"
echo "  - $PROJECT_ROOT/.dev-enegine/requirements/req-001/progress.log"

```

---

### 案例 1：测试通过，自动标记完成（control_level=low）

模拟 Coder Agent 输出 PASS，验证 `on-coder-complete.sh` 自动将 F001 的 `passes` 更新为 `true`。

```bash
PLUGIN_ROOT=/Users/staff/code/ai/claude-plugins/dev-enegine

MSGFILE=$(mktemp)
cat > "$MSGFILE" <<'MSGEOF'
功能已实现并通过验证。

FEATURE_ID: F001
TEST_RESULT: PASS
MSGEOF

jq -n --arg cwd "$PROJECT_ROOT" --rawfile msg "$MSGFILE" \
  '{cwd: $cwd, last_assistant_message: $msg}' \
  | bash "$PLUGIN_ROOT/hooks/scripts/on-coder-complete.sh"
rm "$MSGFILE"
```

**预期输出（stdout）：**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "SubagentStop",
    "additionalContext": "Feature F001 (用户登录 API) 测试通过，已自动标记 passes=true 并写入进度日志。请执行 /compact 释放上下文，然后继续下一个未完成的功能。"
  }
}
```

**验证状态文件：**

```bash
# F001 的 passes 应变为 true
jq '.features[] | select(.id=="F001")' \
  "$PROJECT_ROOT/.dev-enegine/requirements/req-001/feature_list.json"

# progress.log 应有 COMPLETED 记录
cat "$PROJECT_ROOT/.dev-enegine/requirements/req-001/progress.log"
```

---

### 案例 2：测试失败，输出重试上下文

```bash
PLUGIN_ROOT=/Users/staff/code/ai/claude-plugins/dev-enegine

MSGFILE=$(mktemp)
cat > "$MSGFILE" <<'MSGEOF'
功能验证失败。

FEATURE_ID: F001
TEST_RESULT: FAIL
FAILURE_SUMMARY: POST /login returns 500 due to missing DB connection
MSGEOF

jq -n --arg cwd "$PROJECT_ROOT" --rawfile msg "$MSGFILE" \
  '{cwd: $cwd, last_assistant_message: $msg}' \
  | bash "$PLUGIN_ROOT/hooks/scripts/on-coder-complete.sh"
rm "$MSGFILE"
```

**预期输出（stdout）：**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "SubagentStop",
    "additionalContext": "Feature F001 测试失败。失败摘要：POST /login returns 500 due to missing DB connection。请递增重试计数器：若未达 max_test_retry，携带此 FAILURE_SUMMARY 重新调用 Coder Agent 修复；若已达上限，将该功能标记为 blocked 并通知用户。"
  }
}
```

**验证：**

```bash
# F001 passes 应仍为 false（未改变）
jq '.features[] | select(.id=="F001")' \
  "$PROJECT_ROOT/.dev-enegine/requirements/req-001/feature_list.json"

# progress.log 应有 FAILED 记录
cat "$PROJECT_ROOT/.dev-enegine/requirements/req-001/progress.log"
```

---

### 案例 3：control_level=high，等待用户确认

```bash
# 切换为 high 模式
echo '{ "control_level": "high" }' \
  > "$PROJECT_ROOT/.dev-enegine/.lra-config.json"

PLUGIN_ROOT=/Users/staff/code/ai/claude-plugins/dev-enegine

MSGFILE=$(mktemp)
cat > "$MSGFILE" <<'MSGEOF'
功能已实现并通过验证。

FEATURE_ID: F001
TEST_RESULT: PASS
MSGEOF

jq -n --arg cwd "$PROJECT_ROOT" --rawfile msg "$MSGFILE" \
  '{cwd: $cwd, last_assistant_message: $msg}' \
  | bash "$PLUGIN_ROOT/hooks/scripts/on-coder-complete.sh"
rm "$MSGFILE"
```

**预期：** 输出要求用户确认的 `additionalContext`，`feature_list.json` 中 `passes` **不会**自动变更。

---

### 案例 4：消息中无 JSON 块，hook 静默退出

```bash
PLUGIN_ROOT=/Users/staff/code/ai/claude-plugins/dev-enegine

jq -n --arg cwd "$PROJECT_ROOT" --arg msg "正在分析需求，尚未完成实现。" \
  '{cwd: $cwd, last_assistant_message: $msg}' \
  | bash "$PLUGIN_ROOT/hooks/scripts/on-coder-complete.sh"
echo "exit code: $?"
```

**预期：** 无任何输出，exit code 为 `0`（hook 静默跳过，不干扰正常会话）。

---

### 案例 5：Stop hook — 有未完成功能时阻止退出

```bash
# 确保 F001 仍为未完成状态（passes=false）
PLUGIN_ROOT=/Users/staff/code/ai/claude-plugins/dev-enegine

jq -n \
  --arg cwd "$PROJECT_ROOT" \
  '{cwd: $cwd, stop_hook_active: false}' \
  | bash "$PLUGIN_ROOT/hooks/scripts/check-completion.sh"
```

**预期输出：**

```json
{
  "decision": "block",
  "reason": "Requirement \"req-001\" still has 1/2 incomplete features (0 blocked). Continue developing the next available feature, or explicitly tell the user why you need to stop."
}
```

将 F001 标记完成后再测试，应无输出（exit 0，不阻止退出）：

```bash
jq '(.features[] | select(.id=="F001")).passes = true' \
  "$PROJECT_ROOT/.dev-enegine/requirements/req-001/feature_list.json" \
  > /tmp/fl.json && mv /tmp/fl.json \
  "$PROJECT_ROOT/.dev-enegine/requirements/req-001/feature_list.json"

jq -n \
  --arg cwd "$PROJECT_ROOT" \
  '{cwd: $cwd, stop_hook_active: false}' \
  | bash "$PLUGIN_ROOT/hooks/scripts/check-completion.sh"
echo "exit code: $?"
```

---

