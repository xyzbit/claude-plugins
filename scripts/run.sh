#!/usr/bin/env bash
# =============================================================================
# autonomous-agent.sh — Long-Running Autonomous Coding Agent
#
# 基于 Anthropic autonomous-coding 范式 + long-running-agent 双轨 Agent 架构。
# 使用 claude code CLI 自动循环运行 Initializer → Coding Agent。
#
# Usage:
#   ./run.sh -d <project-dir> -t "任务描述" [-m <model>] [-n <max-iters>] [-s <delay>]
#
# Examples:
#   ./run.sh -d ./my-project -t "构建一个 Todo 应用，支持增删改查"
#   ./run.sh -d ./my-project -t "构建一个 Todo 应用" -m claude-opus-4-5 -n 10
#   ./run.sh -d ./my-project   # 继续已有项目（无需再次传 -t）
# =============================================================================

set -euo pipefail

# ── 常量 ─────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_DIR="${SCRIPT_DIR}/agents"
DEFAULT_MODEL="claude-sonnet-4-5"
AUTO_CONTINUE_DELAY=3
LOG_FILE=""

# ── 颜色 ─────────────────────────────────────────────────────────────────────
RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[1;33m'
CYAN=$'\033[0;36m'; BOLD=$'\033[1m'; RESET=$'\033[0m'

log()    { echo -e "${CYAN}[agent]${RESET} $*"; }
success(){ echo -e "${GREEN}[✓]${RESET} $*"; }
warn()   { echo -e "${YELLOW}[!]${RESET} $*"; }
error()  { echo -e "${RED}[✗]${RESET} $*" >&2; }
header() { echo -e "\n${BOLD}${CYAN}$*${RESET}"; }

# ── 用法 ─────────────────────────────────────────────────────────────────────
usage() {
  cat <<EOF
${BOLD}使用方式:${RESET}
  $(basename "$0") -d <project-dir> -t "任务描述" [选项]

${BOLD}必填参数:${RESET}
  -d <dir>      项目目录（不存在时自动创建）

${BOLD}可选参数:${RESET}
  -t <task>     任务描述（新项目必填，已有项目可省略）
  -m <model>    使用的模型（默认: ${DEFAULT_MODEL}）
  -n <iters>    最大迭代次数（默认: 0 = 无限制）
  -s <secs>     迭代间隔秒数（默认: ${AUTO_CONTINUE_DELAY}）
  -h            显示此帮助

${BOLD}示例:${RESET}
  # 初始化新项目
  $(basename "$0") -d ./todo-app -t "构建 Todo 应用，支持增删改查和标签"

  # 限制 5 次迭代
  $(basename "$0") -d ./todo-app -t "构建 Todo 应用" -n 5

  # 继续已有项目
  $(basename "$0") -d ./todo-app
EOF
  exit 1
}

# ── 参数解析 ──────────────────────────────────────────────────────────────────
PROJECT_DIR=""
TASK=""
MODEL="${DEFAULT_MODEL}"
MAX_ITERATIONS=0
DELAY="${AUTO_CONTINUE_DELAY}"

while getopts "d:t:m:n:s:h" opt; do
  case $opt in
    d) PROJECT_DIR="$OPTARG" ;;
    t) TASK="$OPTARG" ;;
    m) MODEL="$OPTARG" ;;
    n) MAX_ITERATIONS="$OPTARG" ;;
    s) DELAY="$OPTARG" ;;
    h) usage ;;
    *) usage ;;
  esac
done

[[ -z "$PROJECT_DIR" ]] && { error "必须指定 -d <project-dir>"; usage; }

# ── 路径设置 ──────────────────────────────────────────────────────────────────
# 规范化路径（macOS realpath 不支持 -m，先 mkdir 再 realpath）
mkdir -p "$PROJECT_DIR"
PROJECT_DIR="$(realpath "$PROJECT_DIR")"
FEATURE_LIST="${PROJECT_DIR}/feature_list.json"
PROGRESS_FILE="${PROJECT_DIR}/claude-progress.txt"
LOG_FILE="${PROJECT_DIR}/.agent-run.log"

# ── 辅助函数 ──────────────────────────────────────────────────────────────────
is_fresh_start() {
  [[ ! -f "${FEATURE_LIST}" ]]
}

all_features_pass() {
  [[ -f "${FEATURE_LIST}" ]] && ! grep -q '"passes"[[:space:]]*:[[:space:]]*false' "${FEATURE_LIST}"
}

count_features() {
  local total=0 done=0
  if [[ -f "${FEATURE_LIST}" ]]; then
    total=$(grep -c '"passes"' "${FEATURE_LIST}" 2>/dev/null || echo 0)
    done=$(grep -c '"passes"[[:space:]]*:[[:space:]]*true' "${FEATURE_LIST}" 2>/dev/null || echo 0)
  fi
  echo "${done}/${total}"
}

print_progress() {
  local counts
  counts=$(count_features)
  log "功能进度: ${counts} 已完成"
  if [[ -f "${PROGRESS_FILE}" ]]; then
    log "最新进度摘要:"
    tail -n 10 "${PROGRESS_FILE}" | sed 's/^/  /'
  fi
}

# ── Agent 运行函数 ─────────────────────────────────────────────────────────────
run_agent() {
  local agent_type="$1"  # "initializer" 或 "coding"
  local agent_file="${AGENT_DIR}/${agent_type}.md"

  if [[ ! -f "${agent_file}" ]]; then
    error "找不到 Agent 文件: ${agent_file}"
    return 1
  fi

  local system_prompt
  system_prompt=$(cat "${agent_file}")

  # 构建用户消息
  local user_message
  if [[ "${agent_type}" == "initializer" ]]; then
    if [[ -n "${TASK}" ]]; then
      user_message="## 用户任务需求

${TASK}

---
请根据以上需求和系统提示，在 ${PROJECT_DIR} 目录中初始化项目。
确保创建 feature_list.json、init.sh 和 claude-progress.txt。"
    else
      user_message="请根据系统提示，在 ${PROJECT_DIR} 目录中初始化项目。"
    fi
  else
    user_message="请继续在 ${PROJECT_DIR} 中进行增量开发。
读取 feature_list.json 选择下一个 passes: false 的功能实现。
完成后更新 claude-progress.txt 并执行 git commit。"
  fi

  log "启动 ${agent_type} agent (模型: ${MODEL})..."
  echo "─────────────────────────────────────────────────────────────────────"

  # 运行 claude，--print 非交互模式，bypassPermissions 允许自动执行工具
  claude --print \
    --model "${MODEL}" \
    --permission-mode bypassPermissions \
    --add-dir "${PROJECT_DIR}" \
    --system-prompt "${system_prompt}" \
    "${user_message}" \
    2>&1 | tee -a "${LOG_FILE}"

  local exit_code="${PIPESTATUS[0]}"
  echo "─────────────────────────────────────────────────────────────────────"

  return "${exit_code}"
}

# ── 信号处理 ──────────────────────────────────────────────────────────────────
handle_interrupt() {
  echo ""
  warn "收到中断信号，正在优雅退出..."
  print_progress
  echo ""
  log "下次运行相同命令可继续：$(basename "$0") -d ${PROJECT_DIR}"
  exit 0
}
trap handle_interrupt INT TERM

# ── 主逻辑 ────────────────────────────────────────────────────────────────────
main() {
  # 打印启动 Banner
  header "══════════════════════════════════════════════════════"
  header "   AUTONOMOUS CODING AGENT — Long-Running Harness"
  header "══════════════════════════════════════════════════════"
  echo ""
  log "项目目录 : ${PROJECT_DIR}"
  log "模型     : ${MODEL}"
  [[ "${MAX_ITERATIONS}" -gt 0 ]] && log "最大迭代 : ${MAX_ITERATIONS}" || log "最大迭代 : 无限制"
  [[ -n "${TASK}" ]] && log "任务描述 : ${TASK}"
  echo ""

  # 创建项目目录
  mkdir -p "${PROJECT_DIR}"

  # 检查是否全新项目
  local is_first_run=true
  if ! is_fresh_start; then
    is_first_run=false
    success "检测到已有项目，将继续增量开发"
    print_progress
  else
    log "全新项目，将先运行 Initializer Agent"
    if [[ -z "${TASK}" ]]; then
      warn "新项目建议通过 -t 指定任务描述，让 Initializer 更准确地生成功能清单"
    fi
  fi

  # 初始化日志文件
  {
    echo "=== Agent Run Started: $(date) ==="
    echo "Project: ${PROJECT_DIR}"
    echo "Model: ${MODEL}"
    echo "Task: ${TASK}"
    echo ""
  } >> "${LOG_FILE}"

  # ── 主循环 ────────────────────────────────────────────────────────────────
  local iteration=0

  while true; do
    iteration=$((iteration + 1))

    # 检查最大迭代次数
    if [[ "${MAX_ITERATIONS}" -gt 0 ]] && [[ "${iteration}" -gt "${MAX_ITERATIONS}" ]]; then
      warn "已达到最大迭代次数 (${MAX_ITERATIONS})，退出"
      warn "重新运行相同命令可继续开发"
      break
    fi

    header "── 迭代 #${iteration} ──────────────────────────────────────────────────"

    # 选择 Agent 类型
    if [[ "${is_first_run}" == true ]]; then
      log "阶段: 初始化 (Initializer Agent)"
      if run_agent "initializer"; then
        success "初始化完成"
        is_first_run=false
      else
        warn "初始化遇到错误，将在 ${DELAY}s 后重试..."
        sleep "${DELAY}"
        continue
      fi
    else
      log "阶段: 增量开发 (Coding Agent)"
      if run_agent "coding"; then
        success "本次迭代完成"
      else
        warn "本次迭代遇到错误，将在 ${DELAY}s 后重试..."
        sleep "${DELAY}"
        continue
      fi
    fi

    echo ""
    print_progress
    echo ""

    # 检查是否全部完成
    if all_features_pass; then
      success "🎉 所有功能已实现！"
      break
    fi

    # 倒计时继续
    if [[ "${MAX_ITERATIONS}" -eq 0 ]] || [[ "${iteration}" -lt "${MAX_ITERATIONS}" ]]; then
      echo -n "  ${DELAY}s 后自动继续下一迭代"
      for ((i=DELAY; i>0; i--)); do
        echo -n " ${i}..."
        sleep 1
      done
      echo ""
    fi
  done

  # ── 结束摘要 ──────────────────────────────────────────────────────────────
  header "══════════════════════════════════════════════════════"
  header "   会话结束"
  header "══════════════════════════════════════════════════════"
  echo ""
  log "项目目录 : ${PROJECT_DIR}"
  log "总迭代数 : ${iteration}"
  print_progress
  echo ""
  log "运行日志 : ${LOG_FILE}"
  echo ""
  if [[ -f "${PROJECT_DIR}/init.sh" ]]; then
    log "启动项目:"
    echo "  cd ${PROJECT_DIR} && bash init.sh"
  fi
  echo ""

  {
    echo "=== Agent Run Ended: $(date) ==="
    echo "Total iterations: ${iteration}"
    echo ""
  } >> "${LOG_FILE}"
}

main
