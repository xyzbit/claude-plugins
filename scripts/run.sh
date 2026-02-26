#!/usr/bin/env bash
# =============================================================================
# run.sh — Long-Running Agent 循环运行脚本
#
# 依赖：已在 Claude Code 中安装 long-running-agent 插件
# 每次迭代调用 claude 并使用 long-running-agent:start-session skill
#
# Usage:
#   ./run.sh -d <project-dir> [-t "任务描述"][-n <max-iters>] [-s <delay>]
#
# Examples:
#   ./run.sh -d ./my-project -t "构建一个 Todo 应用，支持增删改查"
#   ./run.sh -d ./my-project -n 5
# =============================================================================

set -euo pipefail

# ── 常量 ─────────────────────────────────────────────────────────────────────
DEFAULT_DELAY=3

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
  $(basename "$0") -d <project-dir> [选项]

${BOLD}必填参数:${RESET}
  -d <dir>      项目目录（不存在时自动创建）

${BOLD}必填参数:${RESET}
  -t <task>     任务描述

  -n <iters>    最大迭代次数（默认: 0 = 无限制）
  -s <secs>     迭代间隔秒数（默认: ${DEFAULT_DELAY}）
  -h            显示此帮助

${BOLD}示例:${RESET}
  $(basename "$0") -d ./todo-app -t "构建 Todo 应用，支持增删改查和标签"
  $(basename "$0") -d ./todo-app -n 5
  $(basename "$0") -d ./todo-app   # 继续已有项目
EOF
  exit 1
}

# ── 参数解析 ──────────────────────────────────────────────────────────────────
PROJECT_DIR=""
TASK=""
MAX_ITERATIONS=0
DELAY="${DEFAULT_DELAY}"

while getopts "d:t:m:n:s:h" opt; do
  case $opt in
    d) PROJECT_DIR="$OPTARG" ;;
    t) TASK="$OPTARG" ;;
    n) MAX_ITERATIONS="$OPTARG" ;;
    s) DELAY="$OPTARG" ;;
    h) usage ;;
    *) usage ;;
  esac
done

[[ -z "$PROJECT_DIR" ]] && { error "必须指定 -d <project-dir>"; usage; }
[[ -z "$TASK" ]] && { error "必须指定 -t <task>"; usage; }

# ── 路径设置 ──────────────────────────────────────────────────────────────────
mkdir -p "$PROJECT_DIR"
PROJECT_DIR="$(realpath "$PROJECT_DIR")"
cd "${PROJECT_DIR}"

# ── 信号处理 ──────────────────────────────────────────────────────────────────
handle_interrupt() {
  echo ""
  warn "收到中断信号，退出。"
  warn "重新运行相同命令可继续：$(basename "$0") -d ${PROJECT_DIR}"
  exit 0
}
trap handle_interrupt INT TERM

# ── 主逻辑 ────────────────────────────────────────────────────────────────────
main() {
  header "══════════════════════════════════════════════════════"
  header "   Long-Running Agent"
  header "══════════════════════════════════════════════════════"
  echo ""
  log "项目目录 : ${PROJECT_DIR}"
  [[ "${MAX_ITERATIONS}" -gt 0 ]] && log "最大迭代 : ${MAX_ITERATIONS}" || log "最大迭代 : 无限制"
  [[ -n "${TASK}" ]] && log "任务描述 : ${TASK}"
  echo ""

  local iteration=0

  while true; do
    iteration=$((iteration + 1))

    if [[ "${MAX_ITERATIONS}" -gt 0 ]] && [[ "${iteration}" -gt "${MAX_ITERATIONS}" ]]; then
      warn "已达到最大迭代次数 (${MAX_ITERATIONS})，退出"
      break
    fi

    header "── 迭代 #${iteration} ──────────────────────────────────────────────────"

    # 构建用户消息
    local user_message="${TASK}"

    echo "─────────────────────────────────────────────────────────────────────"

    local log_file="${PROJECT_DIR}/.agent.log"
    echo "${user_message}" | claude --print --verbose \
      --permission-mode bypassPermissions 2>&1 | tee -a "${log_file}"
    # PIPESTATUS[0] 是 claude 的退出码，tee 不影响判断
    [[ "${PIPESTATUS[0]}" -ne 0 ]] && warn "本次迭代遇到错误，继续下一轮..."

    echo "─────────────────────────────────────────────────────────────────────"
    success "迭代 #${iteration} 完成"
    echo ""

    # 检查是否所有功能完成
    local feature_list="${PROJECT_DIR}/feature_list.json"
    if [[ -f "${feature_list}" ]] && ! grep -q '"passes"[[:space:]]*:[[:space:]]*false' "${feature_list}"; then
      success "所有功能已实现，退出"
      break
    fi

    # 下次迭代前等待
    if [[ "${MAX_ITERATIONS}" -eq 0 ]] || [[ "${iteration}" -lt "${MAX_ITERATIONS}" ]]; then
      echo -n "  ${DELAY}s 后自动继续"
      for ((i=DELAY; i>0; i--)); do
        echo -n " ${i}..."
        sleep 1
      done
      echo ""
    fi
  done

  header "══════════════════════════════════════════════════════"
  log "会话结束，共迭代 ${iteration} 次"
  log "项目目录: ${PROJECT_DIR}"
  header "══════════════════════════════════════════════════════"
}

main
