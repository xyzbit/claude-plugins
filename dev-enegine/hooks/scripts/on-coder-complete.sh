#!/bin/bash
# =============================================================================
# SubagentStop hook for Coder Agent
# =============================================================================
# 触发时机：Coder Agent (subagent) 结束时，由 Claude 自动调用
# 输入（stdin）：JSON，包含 .cwd 和 .last_assistant_message
# 输出（stdout）：JSON hookSpecificOutput，供主会话读取上下文
#
# 功能：
#   1. 从 Coder 输出中匹配 FEATURE_ID / TEST_RESULT / FAILURE_SUMMARY
#   2. PASS + control_level != high → 自动标记 feature_list.json passes=true
#   3. PASS + control_level == high → 输出上下文，由主会话确认后再更新
#   4. FAIL → 记录失败日志，输出 FAILURE_SUMMARY 供主会话触发重试
#
# Coder Agent 输出格式（见 agents/coder.md）：
#   FEATURE_ID: F001
#   TEST_RESULT: PASS
#   FAILURE_SUMMARY: <可选，仅 FAIL 时>
#
# 依赖：jq, grep, bash >= 4
# =============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# 1. 读取 stdin 并提取基础字段
# ---------------------------------------------------------------------------
INPUT_FILE=$(mktemp)
cat > "$INPUT_FILE"
trap 'rm -f "$INPUT_FILE"' EXIT

CWD=$(jq -r '.cwd' < "$INPUT_FILE")
LAST_MSG=$(jq -r '.last_assistant_message // ""' < "$INPUT_FILE")

if [ -z "$LAST_MSG" ] || [ "$LAST_MSG" = "null" ]; then
  exit 0
fi

# ---------------------------------------------------------------------------
# 2. 从消息中匹配关键字段（纯文本 KEY: VALUE 格式）
# ---------------------------------------------------------------------------

FEATURE_ID=$(echo "$LAST_MSG"  | awk -F': ' '/^FEATURE_ID:/{v=$2} END{print v}' | tr -d '[:space:]')
TEST_RESULT=$(echo "$LAST_MSG" | awk -F': ' '/^TEST_RESULT:/{v=$2} END{print v}' | tr -d '[:space:]')

if [ -z "$TEST_RESULT" ] || [ -z "$FEATURE_ID" ]; then
  exit 0
fi

# ---------------------------------------------------------------------------
# 3. 定位项目状态文件
# ---------------------------------------------------------------------------

# manifest.json 跟踪所有需求及其状态
MANIFEST="$CWD/.dev-enegine/requirements/manifest.json"
if [ ! -f "$MANIFEST" ]; then
  exit 0
fi

# 找到当前正在开发（status == "developing"）的需求目录
REQ_DIR=$(jq -r '[.requirements[] | select(.status == "developing")] | last | .dir // empty' "$MANIFEST")
if [ -z "$REQ_DIR" ]; then
  exit 0
fi

FULL_REQ_DIR="$CWD/.dev-enegine/requirements/$REQ_DIR"
FEATURE_LIST="$FULL_REQ_DIR/feature_list.json"   # 功能列表（passes 字段在此更新）
PROGRESS_LOG="$FULL_REQ_DIR/progress.log"         # 进度日志（追加写入）

# 读取控制级别（low/high），决定是否自动确认通过
CONFIG="$CWD/.dev-enegine/.lra-config.json"
CONTROL_LEVEL=$(jq -r '.control_level // "low"' "$CONFIG" 2>/dev/null || echo "low")

# 从 feature_list.json 取出功能描述（用于日志可读性）
DESCRIPTION=""
if [ -f "$FEATURE_LIST" ]; then
  DESCRIPTION=$(jq -r --arg fid "$FEATURE_ID" \
    '.features[] | select(.id == $fid) | .description // ""' "$FEATURE_LIST")
fi

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# ---------------------------------------------------------------------------
# 4. 按测试结果分支处理
# ---------------------------------------------------------------------------

if [ "$TEST_RESULT" = "PASS" ]; then

  # --- 4a. control_level=high：不自动更新，交由主会话让用户确认 ---
  if [ "$CONTROL_LEVEL" = "high" ]; then
    echo "[$TIMESTAMP] TEST PASSED (awaiting user confirmation): $FEATURE_ID - $DESCRIPTION" >> "$PROGRESS_LOG"

    jq -n --arg fid "$FEATURE_ID" --arg desc "$DESCRIPTION" '{
      hookSpecificOutput: {
        hookEventName: "SubagentStop",
        additionalContext: (
          "Feature " + $fid + " (" + $desc + ") 测试通过。" +
          "control_level=high：请将结果展示给用户，等待用户确认后再继续执行：" +
          "1) 更新 feature_list.json 中该功能的 passes=true；" +
          "2) 继续开发下一个功能。"
        )
      }
    }'
    exit 0
  fi

  # --- 4b. control_level!=high：自动标记通过，写日志，通知主会话继续 ---
  if [ -f "$FEATURE_LIST" ]; then
    # 原子更新：先写临时文件再替换，避免写入中断导致 JSON 损坏
    jq --arg fid "$FEATURE_ID" \
      '(.features[] | select(.id == $fid)).passes = true' \
      "$FEATURE_LIST" > "${FEATURE_LIST}.tmp" \
      && mv "${FEATURE_LIST}.tmp" "$FEATURE_LIST"
  fi

  # 写入需求级进度日志
  echo "[$TIMESTAMP] COMPLETED: $FEATURE_ID - $DESCRIPTION" >> "$PROGRESS_LOG"

  jq -n --arg fid "$FEATURE_ID" --arg desc "$DESCRIPTION" '{
    hookSpecificOutput: {
      hookEventName: "SubagentStop",
      additionalContext: (
        "Feature " + $fid + " (" + $desc + ") 测试通过，已自动标记 passes=true 并写入进度日志。" +
        "请继续下一个未完成的功能。"
      )
    }
  }'

else
  # --- 4c. 测试失败：记录失败原因，通知主会话触发重试 ---
  FAILURE_SUMMARY=$(echo "$LAST_MSG" | awk -F': ' '/^FAILURE_SUMMARY:/{v=substr($0, index($0,":")+2)} END{print v}')
  [ -z "$FAILURE_SUMMARY" ] && FAILURE_SUMMARY="No detailed summary provided"

  echo "[$TIMESTAMP] FAILED: $FEATURE_ID - $FAILURE_SUMMARY" >> "$PROGRESS_LOG"

  jq -n --arg fid "$FEATURE_ID" --arg summary "$FAILURE_SUMMARY" '{
    hookSpecificOutput: {
      hookEventName: "SubagentStop",
      additionalContext: (
        "Feature " + $fid + " 测试失败。失败摘要：" + $summary + "。" +
        "请递增重试计数器：若未达 max_test_retry，携带此 FAILURE_SUMMARY 重新调用 Coder Agent 修复；" +
        "若已达上限，将该功能标记为 blocked 并通知用户。"
      )
    }
  }'

fi

exit 0
