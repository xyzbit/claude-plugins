---
description: 构建后端项目
---

# Build Backend

构建后端 Go 项目。

## 如何执行

### 构建后端服务
```bash
cd backend && make build
```

## 输出

- 构建产物输出到 `backend/bin/`

## 前置条件

- 确保已运行 `make install` 安装依赖
- 确保 Go 版本 >= 1.22

## 提示

- 使用 `make clean` 清理构建产物
- 使用 `make generate` 生成代码 (proto, wire)
