
### autonomous 全自动脚本

`run.sh` 是一个可直接运行的 shell 脚本，参考 [Anthropic autonomous-coding](https://github.com/anthropics/claude-quickstarts/tree/main/autonomous-coding) 范式，
结合本插件的双轨 Agent 架构，通过 `claude code` CLI 实现全自动循环开发。

```bash
# 初始化新项目（自动创建目录，运行 Initializer → Coding 循环）
./run.sh -d ./my-app -t "构建 Todo 应用，支持增删改查和标签分类"

# 指定模型和最大迭代次数
./run.sh -d ./my-app -t "构建 Todo 应用" -m claude-opus-4-5 -n 10

# 继续已有项目（自动跳过初始化）
./run.sh -d ./my-app

# 查看帮助
./run.sh -h
```

**参数说明：**
| 参数 | 说明 | 默认值 |
|------|------|--------|
| `-d <dir>` | 项目目录（必填） | — |
| `-t <task>` | 任务描述（新项目必填） | — |
| `-m <model>` | 使用的模型 | `claude-sonnet-4-5` |
| `-n <iters>` | 最大迭代次数（0 = 无限制） | `0` |
| `-s <secs>` | 迭代间隔秒数 | `3` |

**运行流程：**
```
run.sh 启动
  │
  ├─ 全新项目？ → Initializer Agent（读取 initializer.md）
  │               创建 feature_list.json / init.sh / claude-progress.txt / git init
  │
  └─ 循环迭代 → Coding Agent（读取 coding.md）
                 选一个 passes:false 的功能 → 实现 → 验证 → git commit → 更新进度
                 直到所有功能 passes:true 或达到最大迭代次数
```

> 脚本使用 `--permission-mode bypassPermissions` 让 claude 自主执行工具，
> 适合在受信任的沙盒环境中运行。按 `Ctrl+C` 可优雅退出，下次运行自动续接。

---