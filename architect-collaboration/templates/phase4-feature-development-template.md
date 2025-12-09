# Feature Development Guide

## 项目信息
- **项目名称**: [项目名称]
- **创建日期**: [YYYY-MM-DD]
- **版本**: v1.0
- **负责人**: [姓名]

## 开发工作流

### 阶段4执行流程

#### 1. 任务维护
1. 详细阅读 `技术文档.md` 和 `开发任务.md`
2. 明确任务目标、功能需求和技术要求
3. 每完成一个子任务，立即更新 `开发任务.md` 中的对应任务状态

#### 2. 开发执行
1. 按照 `开发任务.md` 逐步进行代码实现
2. 每完成一个任务后，简要说明完成情况和主要改动点
3. 确保代码符合项目架构和设计模式
4. 编写单元测试，满足 80% 以上的代码覆盖率

## TDD开发流程

### Step 1: 编写测试 (Red)
```typescript
// 测试用例示例
describe('[功能名称]', () => {
  describe('[方法/场景]', () => {
    it('[测试场景描述]', async () => {
      // Given - 准备测试数据
      const input = createTestInput();

      // When - 执行被测试的代码
      const result = await functionUnderTest(input);

      // Then - 验证结果
      expect(result.success).toBe(true);
      expect(result.data).toBeDefined();
    });
  });
});
```

### Step 2: 编写代码 (Green)
```typescript
// 实现最小代码使测试通过
export async function functionUnderTest(input: InputType): Promise<Result> {
  // 最小实现
  return {
    success: true,
    data: processInput(input)
  };
}
```

### Step 3: 重构 (Refactor)
```typescript
// 改进代码质量，保持测试通过
export async function functionUnderTest(input: InputType): Promise<Result> {
  try {
    validateInput(input);
    const processedData = processInput(input);
    return {
      success: true,
      data: processedData
    };
  } catch (error) {
    logger.error('Processing failed', error);
    return {
      success: false,
      error: error.message
    };
  }
}
```

## 代码质量标准

### SOLID原则

#### 单一职责原则 (SRP)
```typescript
// ✅ Good
class UserValidator {
  validate(user: User): ValidationResult {
    // 只负责验证用户
  }
}

class UserRepository {
  save(user: User): void {
    // 只负责保存用户
  }
}

// ❌ Bad
class UserService {
  validate(user: User): ValidationResult { }
  save(user: User): void { }
  sendEmail(user: User): void { }
}
```

#### 开放封闭原则 (OCP)
```typescript
// ✅ Good
interface PaymentMethod {
  process(amount: number): Promise<PaymentResult>;
}

class CreditCardPayment implements PaymentMethod {
  async process(amount: number): Promise<PaymentResult> {
    // 信用卡支付逻辑
  }
}

class PayPalPayment implements PaymentMethod {
  async process(amount: number): Promise<PaymentResult> {
    // PayPal支付逻辑
  }
}
```

#### 里氏替换原则 (LSP)
```typescript
// ✅ Good
abstract class Shape {
  abstract area(): number;
}

class Rectangle extends Shape {
  constructor(private width: number, private height: number) {
    super();
  }

  area(): number {
    return this.width * this.height;
  }
}

class Square extends Shape {
  constructor(private side: number) {
    super();
  }

  area(): number {
    return this.side * this.side;
  }
}
```

### 错误处理

```typescript
// ✅ Good - 具体错误类型
try {
  const result = await paymentGateway.charge(amount, paymentMethod);
  return { success: true, data: result };
} catch (error) {
  if (error instanceof InsufficientFundsError) {
    return { success: false, error: 'INSUFFICIENT_FUNDS' };
  }
  if (error instanceof PaymentDeclinedError) {
    return { success: false, error: 'PAYMENT_DECLINED' };
  }
  logger.error('Payment processing failed', error);
  return { success: false, error: 'PAYMENT_FAILED' };
}

// ❌ Bad - 通用错误处理
try {
  return await paymentGateway.charge(amount, paymentMethod);
} catch (error) {
  return { success: false, error: 'ERROR' };
}
```

## 测试要求

### 测试覆盖率: ≥ 80%

#### 单元测试模板
```typescript
import { describe, it, expect, beforeEach } from '@jest/globals';
import { ClassUnderTest } from '../src/ClassUnderTest';

describe('ClassUnderTest', () => {
  let instance: ClassUnderTest;

  beforeEach(() => {
    instance = new ClassUnderTest();
  });

  describe('methodName', () => {
    it('should handle happy path', () => {
      // Given
      const input = createValidInput();

      // When
      const result = instance.methodName(input);

      // Then
      expect(result.success).toBe(true);
      expect(result.data).toEqual(expectedData);
    });

    it('should handle edge case', () => {
      // Given
      const input = createEdgeCaseInput();

      // When
      const result = instance.methodName(input);

      // Then
      expect(result.success).toBe(false);
      expect(result.error).toBe('EDGE_CASE_ERROR');
    });
  });
});
```

#### 集成测试模板
```typescript
describe('Payment Integration', () => {
  it('should complete full payment flow', async () => {
    // Given
    const order = await createTestOrder();
    const paymentMethod = await createTestPaymentMethod();

    // When
    const result = await paymentService.process(order, paymentMethod);

    // Then
    expect(result.success).toBe(true);

    // Verify order status updated
    const updatedOrder = await orderRepository.findById(order.id);
    expect(updatedOrder.status).toBe('PAID');

    // Verify payment recorded
    const payment = await paymentRepository.findByOrderId(order.id);
    expect(payment.status).toBe('COMPLETED');
  });
});
```

## 进度跟踪

### 任务状态更新

更新开发任务.md中的任务状态：

```markdown
[ ] 任务1: 用户认证模块
  - **描述**: 实现账号密码登录功能
  - **进度**: 50%
  - **当前状态**: 进行中
  - **子任务**:
    - [x] 设计API接口
    - [x] 实现用户验证逻辑
    - [ ] 集成JWT token生成
    - [ ] 编写单元测试
    - [ ] 编写集成测试
  - **预计完成**: 2024-01-15
  - **完成时间**: [实际完成时间]
  - **代码审查**: [审查人] - [日期]
```

### 每日进度模板

```markdown
## [YYYY-MM-DD] 进度更新

### 完成
- ✅ [任务/子任务1]
- ✅ [任务/子任务2]

### 进行中
- 🔄 [任务] (X% 完成)
  - 已完成: [具体完成内容]
  - 待完成: [剩余工作]
  - 预计完成: [日期]

### 阻塞
- ⛔ [任务]: [阻塞原因]
  - 解决方案: [方案]
  - 责任人: [姓名]
  - 预计解决: [日期]

### 明日计划
- [ ] [计划任务1]
- [ ] [计划任务2]

### 风险/问题
- [风险/问题描述] - [应对措施]
```

## 代码审查检查清单

### 提交前自检
- [ ] 代码符合项目规范
- [ ] 所有测试通过
- [ ] 测试覆盖率 ≥ 80%
- [ ] 无注释掉的代码
- [ ] 无 console.log 语句
- [ ] 错误处理已实现
- [ ] 文档已更新
- [ ] 自检已完成

### 审查要点
- [ ] **功能性**: 代码实现是否正确
- [ ] **可读性**: 代码是否清晰易懂
- [ ] **性能**: 是否有性能问题
- [ ] **安全性**: 是否有安全漏洞
- [ ] **测试**: 测试是否充分
- [ ] **文档**: 文档是否完整

### 审查反馈模板

```markdown
## 代码审查结果 - [PR/提交]

### 通过 ✅
- [区域]: [正面反馈]

### 需要修改 ⚠️
- [区域]: [问题描述]
  - 建议: [改进建议]
  - 影响: [未修复的影响]

### 严重问题 ❌
- [区域]: [严重问题]
  - 必须修复: [原因]
  - 建议: [解决方案]

**审查人**: [姓名]
**审查日期**: [日期]
```

## 最佳实践

### 1. 提交信息规范
```bash
# 好的提交信息
feat(auth): add JWT token generation
fix(api): resolve timeout issue in payment endpoint
test(user): add unit tests for user validation
docs(readme): update installation instructions

# 格式
type(scope): description

# 类型
feat: 新功能
fix: 修复bug
test: 测试相关
docs: 文档相关
refactor: 重构
style: 代码格式
chore: 构建/工具相关
```

### 2. 分支管理
```bash
# 分支命名规范
feature/user-authentication
bugfix/payment-timeout
hotfix/security-vulnerability
release/v1.0.0

# 工作流程
git checkout -b feature/new-feature
# 开发...
git add .
git commit -m "feat: add new feature"
git push origin feature/new-feature
# 创建Pull Request
```

### 3. 持续集成
```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install dependencies
        run: npm install
      - name: Run tests
        run: npm test
      - name: Check coverage
        run: npm run coverage
      - name: Run linting
        run: npm run lint
```

## 完成标准

### 功能完成标准
- [ ] 所有验收标准达到要求
- [ ] 单元测试通过
- [ ] 集成测试通过
- [ ] E2E测试通过（如适用）

### 质量完成标准
- [ ] 测试覆盖率 ≥ 80%
- [ ] 代码审查通过
- [ ] 无严重代码异味
- [ ] 性能测试通过
- [ ] 安全扫描通过

### 文档完成标准
- [ ] API文档完整
- [ ] 代码注释清晰
- [ ] README更新
- [ ] 变更日志记录

### 交付完成标准
- [ ] 代码合并到主分支
- [ ] 部署到测试环境
- [ ] QA验收通过
- [ ] 监控配置完成
- [ ] 任务状态更新为完成

## 常见问题解决

### 测试失败
```bash
# 查看详细错误
npm test -- --verbose

# 运行特定测试
npm test -- --testNamePattern="test name"

# 查看覆盖率报告
npm run coverage
```

### 调试技巧
```typescript
// 使用debugger
function processPayment(payment: Payment) {
  debugger; // 在浏览器中会停在此处

  // 使用console.table查看复杂对象
  console.table(payment.items);

  // 使用console.group组织日志
  console.group('Payment Processing');
  console.log('Amount:', payment.amount);
  console.log('Method:', payment.method);
  console.groupEnd();
}
```

### 性能优化
```typescript
// 使用缓存
const cache = new Map();

function getExpensiveData(id: string): Data {
  if (cache.has(id)) {
    return cache.get(id);
  }

  const data = computeExpensiveData(id);
  cache.set(id, data);
  return data;
}

// 使用防抖
function debounce<T extends (...args: any[]) => any>(
  func: T,
  wait: number
): (...args: Parameters<T>) => void {
  let timeout: NodeJS.Timeout;

  return (...args: Parameters<T>) => {
    clearTimeout(timeout);
    timeout = setTimeout(() => func(...args), wait);
  };
}
```

## 资源链接

- [项目Wiki](链接)
- [API文档](链接)
- [编码规范](链接)
- [测试指南](链接)
- [部署文档](链接)

**最后更新**: [YYYY-MM-DD HH:mm:ss]
