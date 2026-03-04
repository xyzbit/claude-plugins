#!/usr/bin/env node
/**
 * Long-Running Agent HUD
 * statusLine 脚本：读取项目进度文件，输出状态栏信息
 *
 * 输出格式（2行）：
 * Line 1: Context 使用情况 | Token Usage
 * Line 2: 当前需求 → 当前 Feature | 进度 X/N
 *
 * Claude Code 通过环境变量传入上下文信息：
 * CLAUDE_CONTEXT_WINDOW_CURRENT / CLAUDE_CONTEXT_WINDOW_TOKENS_USED_CURRENT
 * CLAUDE_COST_USD / CLAUDE_COST_SESSION_TOTAL_USD
 */

const fs = require("fs");
const path = require("path");

// ── 读取环境变量（Claude Code 注入）──────────────────────────────────────
const ctxUsed = parseInt(process.env.CLAUDE_CONTEXT_WINDOW_TOKENS_USED_CURRENT || "0");
const ctxTotal = parseInt(process.env.CLAUDE_CONTEXT_WINDOW_CURRENT || "0");
const sessionCost = parseFloat(process.env.CLAUDE_COST_USD || process.env.CLAUDE_COST_SESSION_TOTAL_USD || "0");
const cwd = process.env.CLAUDE_CWD || process.cwd();

// ── 工具函数 ─────────────────────────────────────────────────────────────
function readJSON(filePath) {
  try {
    const raw = fs.readFileSync(filePath, "utf8");
    return JSON.parse(raw);
  } catch {
    return null;
  }
}

function readLastLines(filePath, n = 5) {
  try {
    const raw = fs.readFileSync(filePath, "utf8");
    const lines = raw.trim().split("\n").filter(Boolean);
    return lines.slice(-n);
  } catch {
    return [];
  }
}

function fmt(n, total) {
  if (!total) return "?";
  const pct = Math.round((n / total) * 100);
  const bars = Math.round(pct / 10);
  const filled = "█".repeat(bars);
  const empty = "░".repeat(10 - bars);
  return `${filled}${empty} ${pct}%`;
}

function fmtK(n) {
  if (!n) return "0";
  return n >= 1000 ? `${(n / 1000).toFixed(1)}k` : String(n);
}

// ── 读取项目数据 ──────────────────────────────────────────────────────────
const manifestPath = path.join(cwd, ".dev-enegine/requirements/manifest.json");
const manifest = readJSON(manifestPath);

let currentReqId = null;
let currentReqName = "—";
let currentReqStatus = null;

if (manifest && manifest.requirements) {
  // 找出状态为 developing 的需求，否则最后一个 planning
  const reqs = manifest.requirements;
  const developing = reqs.find((r) => r.status === "developing");
  const planning = reqs.find((r) => r.status === "planning");
  const target = developing || planning || reqs[reqs.length - 1];
  if (target) {
    currentReqId = target.id;
    currentReqName = target.name || target.description || target.id;
    currentReqStatus = target.status;
    if (currentReqName.length > 20) currentReqName = currentReqName.slice(0, 19) + "…";
  }
}

// ── 读取 feature 清单 ─────────────────────────────────────────────────────
let featureTotal = 0;
let featureDone = 0;
let currentFeatureName = "—";

if (currentReqId) {
  const featurePath = path.join(cwd, `.dev-enegine/requirements/${currentReqId}/feature_list.json`);
  const featureList = readJSON(featurePath);
  if (featureList && Array.isArray(featureList.features)) {
    const features = featureList.features;
    featureTotal = features.length;
    featureDone = features.filter((f) => f.passes === true).length;
    // 当前正在开发的 feature：第一个未完成且未阻塞的
    const inProgress = features.find((f) => !f.passes && !f.blocked);
    if (inProgress) {
      currentFeatureName = inProgress.name || inProgress.id;
      if (currentFeatureName.length > 24) currentFeatureName = currentFeatureName.slice(0, 23) + "…";
    } else if (featureDone === featureTotal && featureTotal > 0) {
      currentFeatureName = "✓ 全部完成";
    }
  }
}

// ── 读取最新进度日志（最后一条）────────────────────────────────────────────
const progressLogPath = path.join(cwd, ".dev-enegine/claude-progress.txt");
const recentLogs = readLastLines(progressLogPath, 1);
const lastLog = recentLogs[0] ? recentLogs[0].replace(/^\[.*?\]\s*/, "") : null;

// ── 组装输出 ──────────────────────────────────────────────────────────────
const lines = [];

// Line 1: Context + Usage
const ctxBar = ctxTotal > 0 ? fmt(ctxUsed, ctxTotal) : "— no data —";
const ctxStr = ctxTotal > 0
  ? `${fmtK(ctxUsed)}/${fmtK(ctxTotal)} tokens`
  : "—";
const costStr = sessionCost > 0 ? ` | $${sessionCost.toFixed(3)}` : "";
lines.push(`Context ${ctxBar}  ${ctxStr}${costStr}`);

// Line 2: 需求 + Feature + 进度
const reqLabel = currentReqStatus ? `[${currentReqStatus}]` : "";
const progressStr = featureTotal > 0
  ? `${featureDone}/${featureTotal} features`
  : "—";
const featureStr = currentFeatureName !== "—" ? ` → ${currentFeatureName}` : "";
lines.push(`${reqLabel} ${currentReqName}${featureStr}  ${progressStr}`);

// Line 3（可选）: 最新日志摘要
if (lastLog) {
  const short = lastLog.length > 60 ? lastLog.slice(0, 59) + "…" : lastLog;
  lines.push(`↳ ${short}`);
}

process.stdout.write(lines.join("\n") + "\n");
