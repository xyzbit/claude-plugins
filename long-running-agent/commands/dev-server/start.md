---
description: 启动开发服务器 (前端和后端)
argument-hint: [frontend|backend|all]
---

# Start Development Server

启动项目的开发服务器。

## 如何执行

根据参数决定启动哪个服务器：

### 启动前端开发服务器
```bash
cd frontend && npm run dev
```

### 启动后端开发服务器
```bash
cd backend && make run
```

### 启动所有开发服务器
```bash
# 启动后端
cd backend && make run &

# 启动前端
cd frontend && npm run dev
```

## 前置条件

- 前端：确保已运行 `npm install`
- 后端：确保已运行 `make install`

## 提示

- 前端默认运行在 http://localhost:3000
- 后端默认运行在 http://localhost:8080
- 首次启动可能需要安装依赖
