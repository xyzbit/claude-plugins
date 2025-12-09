---
# RSS 源配置
rss_sources:
  - name: "AI产品洞察日报"
    url: "https://justlovemaki.github.io/CloudFlare-AI-Insight-Daily/rss.xml"
  - name: "AI产品创业者-刘小排"
    url: "https://wechat2rss.bestblogs.dev/feed/484d4199ae6c0b72ea01e7e0597a1f74933dfb62.xml"
  - name: "AI产品创业者-数字生命卡兹克"
    url: "https://wechat2rss.bestblogs.dev/feed/ff621c3e98d6ae6fceb3397e57441ffc6ea3c17f.xml"

# 时间范围配置
time_range: "7天"
# 是否跳过评审环节
skip-review: false

# 路径配置
paths:
  workspace_root: "article"
  style_references: "article/style_references"

# 平台配置
platforms:
  wx:
    enabled: true # 是否编写公众号文章
    auto_publish: false # 是否自动发布到公众号草稿箱
  xhs:
    enabled: true # 是否编写小红书文章
    auto_publish: false # 是否自动发布到小红书
  feishu:
    enabled: true # 是否编写飞书消息内容
    auto_publish: false # 是否自动发布到飞书群
    chat_id: "${chat_id}"
    feishu_msg_card_template_path: "${feishu_msg_card_template_path}"

# API 密钥（使用环境变量引用 或 直接修改 mcp.json）
api_keys:
  minimax_api_key: "${MINIMAX_API_KEY}"
  minimax_api_host: "${MINIMAX_API_HOST}"
  wechat_app_id: "${WECHAT_APP_ID}"
  wechat_app_secret: "${WECHAT_APP_SECRET}"
  lark_app_id: "${LARK_APP_ID}"
  lark_app_secret: "${LARK_APP_SECRET}"
---

# Content-Create 插件配置说明

这是 content-create 插件的配置文件。将此文件复制到您的项目目录：

```bash
mkdir -p .claude
cp ~/.claude/plugins/content-create/templates/content-create.local.md .claude/
```

## RSS 源配置

添加或删除 RSS 源，用于热点数据收集。

**格式**:
```yaml
rss_sources:
  - name: "源名称"
    url: "RSS地址"
```

**推荐 RSS 源**:
- AI 产品相关：AI 产品洞察、创业者博客
- 科技资讯：36氪、极客公园、TechCrunch
- 行业垂直：根据您的内容领域选择

## 时间范围

设置热点数据的时间范围，控制收集多久内的文章。

**可选值**: "24小时"、"48小时"、"7天"、"30天"

## 路径配置

- `workspace_root`: 工作空间根目录，所有生成的文章都会保存在这里
- `style_references`: 风格参考文章目录，放置您希望模仿的文章

**目录结构示例**:
```
article/
├── style_references/
│   ├── article/           # 放置2-3篇您的风格参考文章
│   └── report/            # 报告风格参考（可选）
└── 2025-12-08-16-30/      # 自动生成的工作空间
```

## 平台配置

控制各平台的启用状态和发布行为。

- `enabled`: 是否启用该平台, 启用后会自动发布到平台
- `auto_publish`: 是否自动发布, 开启后会自动发布到平台

飞书配置：
- `chat_id`: 飞书群聊 ID， 如果未配置，则不会发送飞书消息
- `feishu_msg_card_template_path`: 飞书消息卡片模板文件路径，如果未配置，则根据实际内容生成模板进行发送飞书消息

## API 密钥配置

通过环境变量配置 API 密钥，不要在此文件中硬编码！

**设置环境变量**:

```bash
# 添加到 ~/.bashrc 或 ~/.zshrc
export MINIMAX_API_KEY="your-minimax-api-key"
export MINIMAX_API_HOST="https://api.minimaxi.com"
export WECHAT_APP_ID="your-wechat-app-id"
export WECHAT_APP_SECRET="your-wechat-app-secret"
export LARK_APP_ID="your-lark-app-id"
export LARK_APP_SECRET="your-lark-app-secret"
```

**获取 API 密钥**:

1. **Minimax** (图片/视频生成):
   - 访问 https://www.minimaxi.com/
   - 注册并获取 API Key

2. **微信公众号**:
   - 访问 https://mp.weixin.qq.com/
   - 开发 > 基本配置 > 获取 AppID 和 AppSecret

3. **飞书**:
   - 访问 https://open.feishu.cn/
   - 创建企业自建应用，获取 App ID 和 App Secret

## 安全提示

- ✅ 使用环境变量存储敏感信息
- ✅ 将 `.claude/*.local.md` 添加到 .gitignore
- ❌ 不要在配置文件中硬编码密钥
- ❌ 不要将包含密钥的配置文件提交到 git

## 验证配置

配置完成后，运行以下命令验证：

```bash
/content-create:config
```

应该能看到您的配置信息（敏感信息会被隐藏）。
