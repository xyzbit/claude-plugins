---
name: "Requirements Analysis Skill"
description: "Interactive guidance for Phase 1 of the Senior Architect Collaboration workflow - Requirements gathering, analysis, and validation"
triggers:
  - "analyze requirements"
  - "clarify scope"
  - "feasibility check"
  - "gather requirements"
  - "business requirements"
  - "user story analysis"
---

# Requirements Analysis Skill

This skill guides senior architects and development teams through **Phase 1: Requirements Analysis** of the collaborative workflow. It ensures comprehensive requirement gathering, structured analysis, and validation before proceeding to technical design.

## When to Use

Use this skill when:
- Starting a new project or feature development
- Encountering ambiguous or unclear requirements
- Need to validate existing requirements
- Performing feasibility assessment
- Preparing for technical design phase

## How to Use

Invoke the skill by describing your requirements situation. The skill will:
1. **Ask clarifying questions** about business goals, constraints, and success metrics
2. **Guide requirement breakdown** into manageable components
3. **Assess feasibility** against current architecture and constraints
4. **Validate completeness** against quality criteria
5. **Generate requirements document** with standardized structure

## Key Questions Asked

The skill will prompt you to provide:

### Business Context
- What is the business goal or problem being solved?
- Who are the primary users/stakeholders?
- What is the expected business impact?
- Any budget or timeline constraints?

### Functional Requirements
- What are the core features needed?
- What are the user workflows?
- Any specific integration requirements?
- What are the data requirements?

### Non-Functional Requirements
- Performance requirements (response time, throughput)?
- Security requirements (authentication, encryption)?
- Scalability needs?
- Availability requirements?

### Constraints & Dependencies
- Technology constraints?
- Regulatory/compliance requirements?
- External dependencies?
- Team skill constraints?

## Outputs Generated

The skill creates a structured **Requirements Document** with:

```markdown
## 1. 需求基础

### 1.1 需求详情
- 核心需求描述
- 业务背景
- 目标用户

### 1.2 成功指标
- 可量化的成功标准
- 业务指标 (转化率, 用户增长, etc.)
- 技术指标 (响应时间, 可用性, etc.)

### 1.3 约束条件
- 技术约束
- 业务约束
- 资源约束
- 时间约束

## 2. 功能需求

### 2.1 核心功能
- 必需要素
- 用户工作流
- 业务规则

### 2.2 辅助功能
- 优化体验
- 运维支持

### 2.3 扩展功能
- 未来规划
- 可选特性

## 3. 非功能需求

### 3.1 性能要求
- 响应时间
- 并发处理
- 数据处理量

### 3.2 安全要求
- 认证授权
- 数据加密
- 合规要求

### 3.3 可用性要求
- 系统可用性 (99.9%)
- 容错能力
- 恢复时间

## 4. 可行性评估

### 4.1 技术可行性
- 现有架构支持度
- 技术难点分析
- 风险评估

### 4.2 业务可行性
- 业务价值评估
- ROI分析
- 风险与回报

### 4.3 资源评估
- 人力资源需求
- 技术资源需求
- 时间估算

## 5. 下一步行动

### 5.1 待确认事项
- 关键决策点
- 需要澄清的问题
- 风险应对策略

### 5.2 验收标准
- 功能验收标准
- 质量验收标准
- 业务验收标准
```

## Quality Criteria

Requirements are validated against:

- ✅ **Completeness** - All necessary aspects covered
- ✅ **Clarity** - Unambiguous and understandable
- ✅ **Consistency** - No contradictions
- ✅ **Testability** - Can be verified/validated
- ✅ **Traceability** - Links to business goals
- ✅ **Priority** - Ranked by importance

## Validation Checklist

Before proceeding to Phase 2 (Technical Design), ensure:

- [ ] Business goals clearly defined and quantified
- [ ] Success metrics established and measurable
- [ ] All stakeholders identified and aligned
- [ ] Constraints documented and understood
- [ ] Feasibility confirmed with risk assessment
- [ ] Requirements reviewed and approved by stakeholders

## Best Practices

1. **Quantify everything** - Convert vague statements to measurable criteria
   - ❌ "Fast response" → ✅ "API response < 200ms"
   - ❌ "User-friendly" → ✅ "Task completion in < 3 clicks"

2. **Identify dependencies early** - Map external systems and integrations

3. **Validate with stakeholders** - Ensure alignment before proceeding

4. **Document assumptions** - Make implicit assumptions explicit

5. **Plan for change** - Build flexibility for requirement evolution

## Examples

### Example 1: E-commerce Platform
```
"Analyze requirements for a new payment gateway integration"

The skill will guide you through:
- Payment methods to support
- Security requirements (PCI compliance)
- Performance needs (transaction latency)
- Integration complexity
- Risk assessment
```

### Example 2: Mobile App Feature
```
"Analyze requirements for adding offline mode to our mobile app"

The skill will explore:
- Sync strategy and conflicts
- Data storage requirements
- Network handling
- User experience in offline/online transitions
- Performance impact
```

## Risk Communication

This skill proactively identifies and communicates:

- **Technical Risks**: Architecture mismatches, technology limitations
- **Business Risks**: Market timing, competitive landscape, regulatory changes
- **Resource Risks**: Team capacity, skill gaps, budget constraints
- **Schedule Risks**: Unrealistic timelines, dependency delays

## Integration with Other Phases

This skill provides input to:
- **Phase 2 (Technical Design)**: Requirements inform architecture decisions
- **Phase 3 (Task Breakdown)**: Requirements become task categories
- **Phase 4 (Feature Development)**: Requirements guide acceptance criteria

## Tips for Success

1. **Be specific** - The more details you provide, the better the analysis
2. **Think edge cases** - Consider failure modes and error handling
3. **Involve stakeholders** - Get input from business and technical teams
4. **Challenge assumptions** - Question every requirement
5. **Plan validation** - How will you know if requirements are met?

## Next Steps

After completing requirements analysis:
1. Review generated requirements document
2. Validate with stakeholders
3. Proceed to **Phase 2: Technical Design**
4. Use Technical Design Skill for solution architecture

---

**Remember**: Good requirements are the foundation of successful software projects. Invest time in this phase to save effort later.
