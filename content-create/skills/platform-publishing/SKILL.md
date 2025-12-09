---
description: 使用此技能当用户询问"如何发布到公众号"、"小红书发布流程"、"多平台发布配置"、"平台内容规范"时。提供各平台发布指南、API 配置、故障排查等完整信息。
---

# Platform Publishing Skill

这是 content-create 插件的多平台发布指导。掌握此技能可以帮助你顺利将内容发布到微信公众号、小红书、飞书等平台。

## 支持的平台

### 1. 微信公众号 (wenyan-mcp)

**特点**:
- 深度长文为主（1500-3000 字）
- 专业、有深度的内容
- 重视排版和图文搭配
- 强互动（留言、讨论）

**技术方案**: 使用 wenyan-mcp（微信公众号 MCP 服务器）

**发布方式**: API 自动发布

### 2. 小红书 (playwright)

**特点**:
- 短文为主（<= 1000 字）
- 轻松、视觉化风格
- 爆款标题 + Emoji 排版
- 重视图片和互动

**技术方案**: 使用 playwright（浏览器自动化）

**发布方式**: 自动化发布到草稿箱，手动确认

### 3. 飞书 (lark-mcp)

**特点**:
- 中短文（800-1500 字）
- 简洁、实用的内容
- 工作场景为主
- 快速传阅

**技术方案**: 使用 lark-mcp（飞书 MCP 服务器）

**发布方式**: API 自动发布

## 发布流程

### 微信公众号发布

**前置准备**:

1. **获取 API 凭证**
   - 登录微信公众平台：https://mp.weixin.qq.com/
   - 开发 > 基本配置
   - 获取 AppID 和 AppSecret

2. **配置环境变量**
   ```bash
   export WECHAT_APP_ID="your-app-id"
   export WECHAT_APP_SECRET="your-app-secret"
   ```

3. **配置 MCP 服务器**（已内置在插件中）
   ```json
   {
     "wenyan-mcp": {
       "command": "npx",
       "args": ["-y", "@iflow-mcp/wenyan-mcp@0.1.0"],
       "env": {
         "WECHAT_APP_ID": "${WECHAT_APP_ID}",
         "WECHAT_APP_SECRET": "${WECHAT_APP_SECRET}"
       }
     }
   }
   ```

**发布操作**:

**方式 1: 通过工作流自动发布**
```
/content-create:write "主题" platforms:wx
```

**方式 2: 手动调用 MCP 工具**
1. 列出可用主题：
   ```
   调用 wenyan-mcp 的 list_themes 工具
   ```

2. 发布文章：
   ```
   调用 wenyan-mcp 的 publish_article 工具
   参数：
     - title: 文章标题
     - content: 文章内容（Markdown）
     - theme: 主题名称（如 phycat）
   ```

**输出**:
- 成功：返回文章 URL
- 失败：返回错误信息

**常见问题**:

**问题 1: 主题不存在**
```
错误：Theme 'phycat' not found
```
解决：
1. 调用 `list_themes` 查看可用主题
2. 选择其中一个主题使用
3. 或不指定主题，使用默认主题

**问题 2: API 凭证错误**
```
错误：Invalid AppID or AppSecret
```
解决：
1. 检查环境变量是否正确配置
2. 确认 AppID 和 AppSecret 有效
3. 重新获取凭证

**问题 3: 发布频率限制**
```
错误：API rate limit exceeded
```
解决：
1. 微信公众号有发布频率限制
2. 等待一段时间后重试
3. 考虑手动发布

### 小红书发布

**前置准备**:

1. **安装 Playwright**（已内置在插件中）
   ```json
   {
     "playwright": {
       "command": "npx",
       "args": ["@playwright/mcp@latest"]
     }
   }
   ```

2. **登录小红书账号**（首次使用）
   - 浏览器会自动打开
   - 扫码或输入密码登录
   - 登录状态会保存

**发布操作**:

**方式 1: 通过工作流自动发布**
```
/content-create:write "主题" platforms:xhs
```

**方式 2: 手动调用 Playwright**

发布流程：
1. 导航到 小红书创作服务平台`https://creator.xiaohongshu.com/publish/publish?source=official&from=menu&target=article`
2. 点击“写长文” tab。
3. 点击“新的创作” button。
4. 等待页面渲染完成后，输入标题"{YYYY-MM-DD} 今日AI热点速览"，粘贴文章内容。
5. 点击底部“一键排版” button
6. 等待页面渲染完成后，在右侧选择模版"清晰明朗"
7. 等待页面渲染完成后，点击底部“下一步” button。
6. 等待页面渲染完成后, 在标题下的正文输入框中填入"每日AI热点速览，定时同步，请查收～ #AI"并加入一些内容相关的标签（通过#{tag}格式）。
7. 点击“添加合集” 下拉框，选择 “AI每日热点资讯” 合集。
8. 点击底部“发布” button。
9. 等待页面展示发布完成。

**输出**:
- 提示：文章已保存到草稿箱
- 需要用户手动确认并发布

**常见问题**:

**问题 1: 浏览器自动化失败**
```
错误：Playwright navigation timeout
```
解决：
1. 检查网络连接
2. 确认小红书网站可访问
3. 增加 timeout 时间

**问题 2: 登录状态失效**
```
错误：需要重新登录
```
解决：
1. 手动登录小红书账号
2. 保持登录状态
3. 重新运行发布流程

**问题 3: 字数超限**
```
警告：字数超过 1000 字
```
解决：
1. 小红书长文限制 1000 字
2. 修改文章，压缩内容
3. 或分段发布

### 飞书发布

**前置准备**:

1. **获取 API 凭证**
   - 访问飞书开放平台：https://open.feishu.cn/
   - 创建企业自建应用
   - 获取 App ID 和 App Secret

2. **配置环境变量**
   ```bash
   export LARK_APP_ID="your-app-id"
   export LARK_APP_SECRET="your-app-secret"
   ```

3. **配置 MCP 服务器**（已内置在插件中）
   ```json
   {
     "lark-mcp": {
       "command": "npx",
       "args": [
         "-y",
         "@larksuiteoapi/lark-mcp",
         "mcp",
         "-a",
         "${LARK_APP_ID}",
         "-s",
         "${LARK_APP_SECRET}",
         "--oauth"
       ]
     }
   }
   ```

**发布操作**:

**方式 1: 通过工作流自动发布**
```
/content-create:write "主题" platforms:feishu
```

**方式 2: 手动调用 MCP 工具**
使用 `lark-mcp` 的 `im.v1.message.create` tool 发送飞书消息。
参数备注：
  - msg_type: "interactive" 交互卡片消息
  - chat_id: ${chat_id} 飞书群ID
  - content: 将文章内容替换到 ${feishu_msg_card_template_path} 模板文件中的 ${content} 变量；请确保json格式正确，不要出现语法错误；

## API 配置

### 获取 API 密钥

**1. Minimax API（图片/视频生成）**

访问：https://www.minimaxi.com/

步骤：
1. 注册并登录
2. 进入控制台
3. 创建 API Key
4. 复制 API Key

配置：
```bash
export MINIMAX_API_KEY="your-api-key"
export MINIMAX_API_HOST="https://api.minimaxi.com"
```

**2. 微信公众号**

访问：https://mp.weixin.qq.com/

步骤：
1. 登录公众号后台
2. 开发 > 基本配置
3. 获取 AppID
4. 获取 AppSecret（需要管理员权限）

配置：
```bash
export WECHAT_APP_ID="wx1234567890"
export WECHAT_APP_SECRET="abcdef1234567890"
```

**3. 飞书**

访问：https://open.feishu.cn/

步骤：
1. 创建企业自建应用
2. 获取 App ID
3. 获取 App Secret
4. 配置应用权限

配置：
```bash
export LARK_APP_ID="cli_abc123"
export LARK_APP_SECRET="xyz789"
```

### 配置验证

验证环境变量是否正确配置：

```bash
# 检查环境变量
echo $MINIMAX_API_KEY
echo $WECHAT_APP_ID
echo $LARK_APP_ID

# 验证插件配置
/content-create:config
```

应该看到：
```
• Minimax API Key: sk_12***34
• 微信 App ID: wx12***90
• 飞书 App ID: cli_***23
```

## 平台内容规范

### 微信公众号

**内容规范**:
- ✅ 原创内容，禁止抄袭
- ✅ 符合社会主义核心价值观
- ✅ 不涉及政治、色情、暴力等敏感内容
- ✅ 不包含违禁词（最、第一、唯一等）

**格式规范**:
- 标题：64 字以内
- 正文：不限字数（建议 1500-3000 字）
- 图片：支持 JPG、PNG，单张 < 10MB
- 封面：建议 900x500px

**排版建议**:
- 段落间距：适当留白
- 字体：默认字体即可
- 颜色：黑色为主，重点可用深灰
- Emoji：适度使用

### 小红书

**内容规范**:
- ✅ 真实分享，禁止虚假宣传
- ✅ 积极向上，传播正能量
- ✅ 不涉及敏感话题
- ✅ 不过度营销

**格式规范**:
- 标题：20 字以内
- 正文：1000 字以内（长文限制）
- 图片：建议 3:4 或 4:3 比例
- 封面：首图即封面

**排版建议**:
- 短句：每句 10-20 字
- 分段：2-3 行一段
- Emoji：大量使用，增强视觉效果
- 符号：使用 ✅/❌/⭐️ 等

**爆款特征**:
- 标题党：`🔥必看！xxx`
- 情绪化：`😭终于找到了！`
- 互动结尾：`评论区聊聊～`

### 飞书

**内容规范**:
- ✅ 工作相关内容
- ✅ 简洁实用
- ✅ 便于传阅
- ✅ 符合企业文化

**格式规范**:
- 标题：简洁明了
- 正文：800-1500 字
- 结构：清晰分段
- 链接：支持内外链

**排版建议**:
- 简洁：避免过度装饰
- 清晰：使用标题层级
- 实用：重点突出
- 专业：正式商务风格

## 故障排查

### 常见发布错误

**错误 1: MCP 服务器未启动**

```
错误：MCP server 'wenyan-mcp' not found
```

解决：
1. 检查 `.mcp.json` 配置
2. 确认 MCP 服务器已安装
3. 重启 Claude Code

**错误 2: API 凭证无效**

```
错误：Authentication failed
```

解决：
1. 检查环境变量配置
2. 确认 API 密钥有效期
3. 重新获取凭证

**错误 3: 网络连接失败**

```
错误：Network timeout
```

解决：
1. 检查网络连接
2. 确认目标平台可访问
3. 使用代理（如需要）

**错误 4: 内容不符合规范**

```
错误：Content violates platform policy
```

解决：
1. 检查违禁词
2. 确认内容合规性
3. 修改后重新发布

**错误 5: 发布频率限制**

```
错误：Rate limit exceeded
```

解决：
1. 等待一段时间后重试
2. 查看平台限制规则
3. 考虑手动发布

### 日志查看

**查看详细日志**:
```bash
# 查看 Claude Code 日志
claude --debug

# 查看 MCP 服务器日志
# 日志位置：~/.claude/logs/
```

**常见日志信息**:
- `[wenyan-mcp] Connected`: MCP 服务器连接成功
- `[wenyan-mcp] Publishing article...`: 正在发布文章
- `[wenyan-mcp] Published successfully`: 发布成功
- `[wenyan-mcp] Error: ...`: 发布失败，查看错误信息

## 最佳实践

### 1. 发布前检查清单

- [ ] 文章已评审通过（评分 >= 85）
- [ ] 图片已准备好（封面 + 配图）
- [ ] API 凭证已配置且有效
- [ ] 内容符合平台规范
- [ ] 标题吸引人且不违规
- [ ] 排版清晰美观

### 2. 分平台优化

**公众号**:
- 深度内容，有价值
- 排版精美，图文并茂
- 引导留言讨论

**小红书**:
- 轻量内容，易传播
- 视觉化排版，Emoji 多
- 引导点赞收藏

**飞书**:
- 实用内容，便于工作
- 简洁排版，突出重点
- 便于快速传阅

### 3. 发布时机选择

**最佳发布时间**:
- 公众号：晚上 7-9 点（下班高峰）
- 小红书：中午 12-1 点、晚上 8-10 点
- 飞书：工作日上午 9-11 点

**避免时间**:
- 凌晨（用户睡眠时间）
- 工作时间（公众号、小红书）
- 周末（飞书）

### 4. 多平台联动

**发布顺序**:
1. 公众号（首发，深度内容）
2. 小红书（改写，轻量传播）
3. 飞书（提取，工作分享）

**内容复用**:
- 公众号 → 小红书：压缩字数，增加 Emoji
- 公众号 → 飞书：提取核心，突出实用性
- 小红书 → 公众号：扩展深度，增加论据

### 5. 自动化与手动的平衡

**建议 enabled 设置**:
```yaml
platforms:
  wx:
    enabled: true  # 是否编写公众号文章
    auto_publish: false  # 是否自动发布到公众号草稿箱
  xhs:
    enabled: true  # 是否编写小红书文章
    auto_publish: false  # 是否自动发布到小红书
  feishu:
    enabled: true  # 是否编写飞书消息
    auto_publish: false  # 是否自动发布到飞书群
```

**原因**:
- 发布前可以最后检查
- 避免误发或格式问题
- 可以调整发布时间
- 可以添加额外内容（如标签）

**何时可以自动发布**:
- 工作流稳定可靠
- 对内容质量有信心
- 发布频率较高
- 有回滚机制

## 参考资源

详细的参考文档请查看：
- `references/feishu-card.md` - 飞书消息卡片json 结构参考文档

现在你已经掌握了多平台发布的完整流程！开始发布高质量内容吧。
