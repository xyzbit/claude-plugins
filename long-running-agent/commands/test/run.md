---
description: 运行测试
argument-hint: [frontend|backend|all]
---

# Run Tests

运行项目的测试。

## 如何执行

### 运行前端测试
```bash
cd frontend && npm test
```

### 运行后端测试
```bash
cd backend && make test
```

### 运行集成测试（端到端）
通过 playwright-mcp 运行集成测试

### 运行所有测试
```bash
cd frontend && npm test &
cd backend && make test
wait
```

## 覆盖率

### 后端测试覆盖率
```bash
cd backend && make test-coverage
```

## 提示

- 前端使用 Jest + React Testing Library
- 后端使用 Go 内置 testing 包
- 建议在提交前运行所有测试
