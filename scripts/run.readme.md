
### autonomous 全自动脚本

`run.sh` 依赖已在 Claude Code 中安装的 `long-running-agent` 插件，
每次迭代通过 `claude code` CLI 调用 `long-running-agent:start-session` skill 进行自动开发。

```bash
# 初始化新项目
./run.sh -d ./my-app -t "构建 Todo 应用，支持增删改查和标签分类"

# 限制最大迭代次数
./run.sh -d ./my-app -t "构建 Todo 应用" -n 5

# 继续已有项目
./run.sh -d ./my-app

# 查看帮助
./run.sh -h
```

**参数说明：**
| 参数 | 说明 | 默认值 |
|------|------|--------|
| `-d <dir>` | 项目目录（必填） | — |
| `-t <task>` | 任务描述（新项目建议填写） | — |
| `-m <model>` | 使用的模型 | `claude-sonnet-4-5` |
| `-n <iters>` | 最大迭代次数（0 = 无限制） | `0` |
| `-s <secs>` | 迭代间隔秒数 | `3` |

**运行流程：**
```
run.sh 启动
  │
  └─ 循环迭代 → claude --print 调用 long-running-agent:start-session skill
                 skill 内部自动判断：全新项目 → 初始化 / 已有项目 → 增量开发
                 直到所有功能 passes:true 或达到最大迭代次数
```

> 脚本使用 `--permission-mode bypassPermissions` 让 claude 自主执行工具，
> 适合在受信任的沙盒环境中运行。按 `Ctrl+C` 可优雅退出，下次运行自动续接。

---
