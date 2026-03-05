# Claude Code Plugins 精选集

> 收集日常工作中最常用、好用的 Claude Code Plugins，覆盖多个领域：编码、测试、内容创作、分发、分析...

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Plugin-purple.svg)](https://code.claude.com)

## 📚 Plugins 列表

### 🚀 开发效率类

#### [DevEngine](dev-enegine/) - 自动化开发引擎
**基于 Anthropic 论文《Effective Harnesses for Long-Running Agents》设计的多 Agent 协作系统**

- 🔄 需求规划 → 编码 → 测试全流程自动化
- 📋 智能需求拆解，生成技术方案和 Feature 清单
- ⚡ 支持 DAG 依赖分析和并行开发
- 🎛️ 三级人工控制（high/medium/low）灵活可控
- 🔗 原生 Hooks 实现自动副作用处理

**适用场景**：
- 复杂项目增量开发
- 多 Feature 并行协作
- 长期项目需求管理

**[📖 查看详细文档](dev-enegine/README.md)**

---

#### [Claude HUD](claude-hud/) - 实时状态栏
**终端里的实时监控面板**

- 📊 Context 使用量实时可视化
- 🤖 Subagent 活动状态追踪
- 🔧 工具调用历史展示
- ✅ Todo 进度实时显示
- 📈 Usage 配额消耗监控

**适用场景**：
- 长时间运行的任务
- 多 Agent 协作开发
- Context 配额管理

**[📖 查看详细文档](claude-hud/README.md)**

---

#### [Architect Collaboration](architect-collaboration/) - 架构师协作
**四阶段结构化协作工作流**

- 📝 需求分析 - 协作需求收集与评估
- 🏗️ 技术设计 - 架构方案与 TDD 支持
- 📋 任务拆解 - 粒度任务创建与依赖管理
- 💻 功能开发 - 实施指导与质量把控

**适用场景**：
- 复杂系统设计
- 团队协作开发
- 技术方案评审

**[📖 查看详细文档](architect-collaboration/README.md)**

---

#### [Long-Running Agent](long-running-agent/) - 长时任务 Agent
**基于 Anthropic 论文设计的双轨 Agent 系统**

- 🎯 单一入口自动判断项目状态
- 🔄 初始化 Agent / 编码 Agent 自动切换
- ✅ 验证驱动：测试通过才标记完成
- 📝 自动 commit 保持清晰历史

**适用场景**：
- 一次性 Demo 或原型快速开发
- 单一需求完整实现
- 简单项目增量迭代

**[📖 查看详细文档](long-running-agent/README.md)**

---

### 🎨 内容创作类

#### [Content Creator](content-create/) - AI 内容助手
**一站式内容创作与发布解决方案**

- 🔍 自动收集热点信息（RSS + 搜索）
- ✍️ 多平台内容创作（微信、小红书、飞书）
- 🎯 智能风格模仿，保持个人 IP 特色
- 📊 质量评审打分，多轮迭代优化
- 🚀 一键发布到多个平台

**适用场景**：
- 自媒体日常运营
- 企业内容营销
- 个人品牌打造
- 热点资讯发布

**[📖 查看详细文档](content-create/README.md)**

---

## 🚀 快速开始

使用插件市场安装
进入 Claude Code 命令行，执行以下命令：
```bash
/plugins marketplace add https://github.com/xyzbit/claude-plugins.git
```
按需安装
```bash
/plugins install dev-enegine
/plugins install claude-hud
/plugins install long-running-agent
/plugins install content-create
```

### 使用

每个 Plugin 都有独立的 README 文档，请查看对应目录获取详细使用说明。

在 Claude Code 中加载所需的 Plugin


## 🤝 贡献

欢迎贡献新的 Plugin 或改进现有 Plugin！

推荐安装：[Plugin Dev](https://github.com/anthropics/claude-code/tree/main/plugins/plugin-dev) 插件，用于快速开发和调试 Plugin。

### 贡献指南

1. Fork 本仓库
2. 创建新的 Plugin 目录
3. 遵循 [Claude Code Plugin 规范](https://code.claude.com/docs/en/plugins)
4. 提交 Pull Request

### Plugin 开发规范

- 每个 Plugin 独立目录
- 必须包含 `manifest.json` 和 `README.md`
- Skills 采用 Markdown 格式
- 提供完整的使用示例
- 添加必要的配置说明

## 📝 许可证

本项目采用 MIT 许可证，详见 [LICENSE](LICENSE) 文件。

## 🙏 致谢

- [Claude Code](https://code.claude.com) - 强大的 AI 编程助手
- 所有贡献者和使用者

---

**⭐️ 如果觉得有用，请给个 Star！**
