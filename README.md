# Claude Code Plugins 精选集

> 收集日常工作中最常用、好用的 Claude Code Plugins，覆盖多个领域：编码、测试、内容创作、分发、分析...

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Plugin-purple.svg)](https://code.claude.com)

## 📚 Plugins 列表

### 🎨 内容创作类

#### [Content Creator](content-creator/) - AI 内容助手
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

**[📖 查看详细文档](content-creator/README.md)**

---

## 🚀 快速开始

使用插件市场安装
进入 Claude Code 命令行，执行以下命令：
```bash
/plugins marketplace add https://github.com/xyzbit/claude-plugins.git

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
