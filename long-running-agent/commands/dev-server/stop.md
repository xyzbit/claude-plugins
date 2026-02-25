---
description: 停止开发服务器
argument-hint: [frontend|backend|all]
---

# Stop Development Server

停止正在运行的开发服务器。

## 如何执行

根据参数决定停止哪个服务器：

### 停止前端开发服务器
```bash
pkill -f "next dev" || true
```

### 停止后端开发服务器
```bash
pkill -f "go run" || true
pkill -f "backend" || true
```

### 停止所有开发服务器
```bash
pkill -f "next dev" || true
pkill -f "go run" || true
pkill -f "backend" || true
```

## 提示

- 使用 `lsof -i :3000` 检查前端端口是否释放
- 使用 `lsof -i :8080` 检查后端端口是否释放
