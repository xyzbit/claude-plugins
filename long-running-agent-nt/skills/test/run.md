# Skill: 运行测试

Agent 在完成功能实现后、标记完成前，必须运行测试进行验证。

## 运行前端测试

```bash
cd frontend && npm test
```

## 运行后端测试

```bash
cd backend && make test
```

## 运行集成测试（端到端）

通过浏览器操作进行真实的端到端验证，确认功能在真实环境中正常工作。

## 运行所有测试

```bash
cd frontend && npm test &
cd backend && make test
wait
```

## 查看后端测试覆盖率

```bash
cd backend && make test-coverage
```

## 测试框架说明

- **前端**：Jest + React Testing Library
- **后端**：Go 内置 testing 包
- **集成测试**：浏览器自动化（playwright 等）

## 约束

- 提交代码前必须运行测试
- 所有测试通过后才能标记功能完成（参考 `skills/session/complete.md`）
- 测试失败时不得强行提交，必须先修复
