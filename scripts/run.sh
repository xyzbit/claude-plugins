#!/usr/bin/env bash
# =============================================================================
# run.sh — Long-Running Agent 循环运行脚本
#
# 每次迭代根据项目状态选择 Agent：
#   - 无 feature_list.json → Initializer Agent（初始化项目）
#   - 有 feature_list.json → Coding Agent（实现一个 feature 后退出）
#
# Usage:
#   ./run.sh -d <project-dir> -t "任务描述" [-n <max-iters>] [-s <delay>]
#
# Examples:
#   ./run.sh -d ./my-project -t "构建一个 Todo 应用，支持增删改查"
#   ./run.sh -d ./my-project -t "继续开发" -n 5
# =============================================================================

set -euo pipefail

# ── 常量 ─────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_DIR="${SCRIPT_DIR}/../long-running-agent/agents"
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
  $(basename "$0") -d <project-dir> -t "任务描述" [选项]

${BOLD}必填参数:${RESET}
  -d <dir>      项目目录（不存在时自动创建）
  -t <task>     任务描述

${BOLD}可选参数:${RESET}
  -n <iters>    最大迭代次数（默认: 0 = 无限制）
  -s <secs>     迭代间隔秒数（默认: ${DEFAULT_DELAY}）
  -h            显示此帮助

${BOLD}示例:${RESET}
  $(basename "$0") -d ./todo-app -t "构建 Todo 应用，支持增删改查和标签"
  $(basename "$0") -d ./todo-app -t "继续开发" -n 5
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
[[ -z "$TASK" ]]        && { error "必须指定 -t <task>"; usage; }

# ── 路径设置 ──────────────────────────────────────────────────────────────────
mkdir -p "$PROJECT_DIR"
PROJECT_DIR="$(realpath "$PROJECT_DIR")"
cd "${PROJECT_DIR}"

# ── 辅助：去除 .md 文件的 frontmatter（--- ... ---）─────────────────────────
strip_frontmatter() {
  local file="$1"
  # 如果文件以 --- 开头，跳过到第二个 --- 之后的内容
  awk 'BEGIN{fm=0} /^---/{fm++; if(fm==2){fm=-1}; next} fm==-1||fm==0{print}' "$file"
}

# ── 信号处理 ──────────────────────────────────────────────────────────────────
handle_interrupt() {
  echo ""
  warn "收到中断信号，退出。"
  warn "重新运行相同命令可继续：$(basename "$0") -d ${PROJECT_DIR} -t \"${TASK}\""
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
  log "任务描述 : ${TASK}"
  [[ "${MAX_ITERATIONS}" -gt 0 ]] && log "最大迭代 : ${MAX_ITERATIONS}" || log "最大迭代 : 无限制"
  echo ""

  local log_file="${PROJECT_DIR}/.agent.log"
  local iteration=0

  # ── 搜索 feature_list.json（含子目录）─────────────────────────────────────
  find_feature_list() {
    # 优先当前目录，再搜索一层子目录
    local f
    f=$(find "${PROJECT_DIR}" -maxdepth 2 -name "feature_list.json" 2>/dev/null | head -1)
    echo "${f}"
  }

  while true; do
    iteration=$((iteration + 1))

    if [[ "${MAX_ITERATIONS}" -gt 0 ]] && [[ "${iteration}" -gt "${MAX_ITERATIONS}" ]]; then
      warn "已达到最大迭代次数 (${MAX_ITERATIONS})，退出"
      break
    fi

    # ── 每次迭代重新查找 feature_list.json ───────────────────────────────────
    local feature_list work_dir
    feature_list="$(find_feature_list)"
    if [[ -n "${feature_list}" ]]; then
      work_dir="$(dirname "${feature_list}")"
    else
      work_dir="${PROJECT_DIR}"
    fi

    # ── 检查是否所有功能已完成 ────────────────────────────────────────────
    if [[ -n "${feature_list}" ]] && ! grep -q '"passes"[[:space:]]*:[[:space:]]*false' "${feature_list}"; then
      success "所有功能已实现，退出"
      break
    fi

    # ── 根据项目状态选择 Agent ────────────────────────────────────────────
    local agent_type system_prompt user_message

    if [[ -z "${feature_list}" ]]; then
      agent_type="Initializer"
      system_prompt="$(strip_frontmatter "${AGENT_DIR}/initializer.md")"
      user_message="${TASK}"
    else
      agent_type="Coding"
      system_prompt="$(strip_frontmatter "${AGENT_DIR}/coding.md")"
      user_message="请从 feature_list.json 中选择下一个 passes:false 的功能进行开发，完成后 git commit 并更新 claude-progress.txt，然后退出。"
      # 切换到 feature_list.json 所在目录，确保 coding agent 在正确目录工作
      if [[ "${work_dir}" != "$(pwd)" ]]; then
        log "检测到项目子目录: ${work_dir}，切换工作目录"
        cd "${work_dir}"
      fi
    fi

    header "── 迭代 #${iteration} [${agent_type} Agent] ──────────────────────────────"
    echo "─────────────────────────────────────────────────────────────────────"

    echo "${user_message}" | claude --print --verbose \
      --permission-mode bypassPermissions \
      --system-prompt "${system_prompt}" \
      2>&1 | tee -a "${log_file}"
    [[ "${PIPESTATUS[0]}" -ne 0 ]] && warn "本次迭代遇到错误，继续下一轮..."

    echo "─────────────────────────────────────────────────────────────────────"
    success "迭代 #${iteration} [${agent_type}] 完成"
    echo ""

    # ── 下次迭代前等待 ────────────────────────────────────────────────────
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
