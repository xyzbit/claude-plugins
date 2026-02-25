---
description: 构建前端项目
argument-hint: [development|production]
---

# Build Frontend

构建前端项目。

## 如何执行

### 开发构建
```bash
cd frontend && npm run build
```

### 生产构建
```bash
cd frontend && npm run build
```

## 输出

- 构建产物输出到 `frontend/.next/`
- 生产构建会优化代码体积

## 提示

- 首次构建前确保已运行 `npm install`
- 使用 `npm run lint` 检查代码风格
- 使用 `npm run type-check` 检查类型
