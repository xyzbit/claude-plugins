---
name: content:write
description: 执行完整的内容创作工作流：数据收集 → 撰写 → 评审 → 发布
argument-hint: <topic> [platforms:wx,xhs] [skip-review:true/false] [workspace:path]
allowed-tools:
  - Read
  - Write
  - Bash
---

# Content Creation Workflow Command

你现在需要执行完整的内容创作工作流，从热点收集到多平台发布。

## 输入参数

从用户输入中解析以下参数：

**必填参数**:
- `topic`: 创作主题或关键词（用户输入的主要文本）

**可选参数**（格式：key:value）:
- `platforms`: 发布平台，可选值 wx（公众号）、xhs（小红书）、feishu（飞书），多个用逗号分隔，默认：wx,xhs
- `skip-review`: 跳过评审环节，可选值 true/false，默认：false
- `workspace`: 自定义工作空间路径，默认：article/{YYYY-MM-DD-HH-MM}

**示例输入**:
```
/content-create:write "AI手机热点分析"
/content-create:write "DeepSeek V3评测" platforms:wx
/content-create:write "AI编程工具" platforms:wx,xhs skip-review:true
```

## 执行步骤

### Step 0: 初始化

1. **解析参数**
   - 提取 topic 和可选参数
   - 验证参数有效性

2. **读取配置**
   - 读取 `.claude/content-create.local.md` 配置文件, 获取后续步骤需要用到的变量
   - 如果配置文件不存在，提示用户创建：
     ```
     配置文件不存在，请先创建配置文件：
     mkdir -p .claude
     cp ~/.claude/plugins/content-create/templates/content-create.local.md .claude/
     ```
   - 解析 YAML frontmatter，获取：
     - rss_sources: RSS 源列表
     - time_range: 时间范围
     - paths: 路径配置
     - platforms: 平台配置

3. **验证配置**
   检查配置完整性：
   - 如果开启了公众号，则需要配置微信公众号的 app_id 和 app_secret
   - 如果开启了小红书，则需要配置小红书的 app_id 和 app_secret
   - 如果开启了飞书，则需要配置飞书的 app_id 和 app_secret，chat_id
   检测到配置不完整，提示用户："配置不完整，请先配置配置文件"
   
3. **生成工作空间**
   - 获取当前时间，格式：YYYY-MM-DD-HH-MM
   - 创建工作空间目录：`{workspace_root}/{YYYY-MM-DD-HH-MM}/`
   - 示例：`article/2025-12-08-16-30/`

4. **变量替换**
   - 将配置中的 `{work-space}` 替换为实际工作空间路径
   - 生成文件路径：
     - hot_topic_data_path: `{workspace}/hot_topic_data.md`
     - wx_article_path: `{workspace}/wx_article.md`
     - xhs_article_path: `{workspace}/xhs_article.md`
     - review_report_path: `{workspace}/review_report.md`

### Step 1: 数据收集

**调用 collector agent**，传递以下参数：

```
请收集关于"{{topic}}"的热点信息。

参数：
- rss_sources: {{rss_sources}}
- hot_topic_data_path: {{hot_topic_data_path}}
- time_range: {{time_range}}

请生成热点数据文件，包含：
1. 核心热点事件（一句话概括）
2. 关键信息点（5-10条）
3. 舆论风向（正向/负向/争议）
4. 参考素材链接
```

**检查输出**：
- 确认 `hot_topic_data.md` 文件已生成
- 验证内容是否充实（至少500字）
- 如果失败，报告错误并终止

### Step 2: 公众号文章撰写

如果 {{platforms.wx.enabled}} 为 false，则跳过此步骤，进入 Step 3

**调用 writer-wx agent**，传递以下参数：

```
请基于热点信息编写高质量公众号文章。

参数：
- task: 编写关于"{{topic}}"的公众号文章
- style_references_dir: {{style_references_dir}}
- reference_path: {{hot_topic_data_path}}
- output_path: {{wx_article_path}}
- feedback: ""

要求：
1. 分析风格参考文章（如果存在）
2. 基于热点数据创作原创内容
3. 生成封面图和配图（使用 minimax-mcp）
4. 输出格式良好的 Markdown 文章
```

**检查输出**：
- 确认 `wx_article.md` 文件已生成
- 验证文章长度合理（建议 1500-3000 字）
- 确认包含图片（至少封面图）

### Step 3: 质量评审
如果过 {{skip-review}} 为 true，则跳过此步骤，进入 Step 4

**进入评审循环（最大迭代次数：2次）**:

**Loop Start:**

1. **调用 reviewer agent**，传递以下参数：

```
请评审以下公众号文章。

参数：
- draft_article_path: {{wx_article_path}}

请提供：
1. 评分（0-100）
2. 风险提示
3. 模拟用户评论
4. 修改建议（如需要）
5. 最终结论（PASS / REJECT）
```

2. **分支判断**：
   - **IF 结论 == PASS**:
     - 跳出循环，进入 Step 4
   - **IF 结论 == REJECT**:
     - 判断是否达到最大循环次数（2次）
     - **IF 未达上限**:
       - 提取评审建议
       - 再次调用 writer-wx agent，传递 feedback 参数
       - 继续循环
     - **IF 已达上限**:
       - 提示用户："已达最大优化次数，将使用当前版本发布。"
       - 跳出循环，进入 Step 4

### Step 4: 发布公众号

如果 {{platforms.wx.auto_publish}} 为 false，则跳过此步骤，进入 Step 5

> 参考 skills/platform-publishing 发布公众号
**调用 wenyan-mcp 的 `publish_article` 工具**：
   - 读取 `wx_article.md` 内容
   - 使用 `phycat` 主题发布
   - 如果报错主题找不到，调用 `list_themes` 工具随机选择一个主题

### Step 5: 小红书文章撰写(如果 platforms 包含 xhs 且 enabled 为 true)

**调用 writer-xhs agent**，传递以下参数：

```
请创作一篇小红书风格的文章。

参数：
- task: 创作一篇小红书风格的文章
- style_references_dir: {{style_references_dir}}
- reference_path: {{hot_topic_data_path}}
- output_path: {{xhs_article_path}}
- feedback: ""

要求：
1. 爆款标题（Emoji + 痛点/利益点 + 悬念）
2. 短句 + Emoji 排版
3. 视觉化表达
4. 限制 1000 字以内
```

**检查输出**：
- 确认 `xhs_article.md` 文件已生成
- 验证字数限制（<= 1000 字）

### Step 6: 发布小红书
如果 {{platforms.xhs.auto_publish}} 为 false，则跳过此步骤，进入 Step 7

> 参考 skills/platform-publishing 发布小红书

### Step 7: 飞书消息编写
如果 {{platforms.feishu.enabled}} 为 false，则跳过此步骤，进入 Step 8

将收集的数据进行分析、提炼、精简为飞书消息卡片内容（<=60行），markdown格式。

### Step 8: 飞书消息发布
如果 {{platforms.feishu.auto_publish}} 为 false，则跳过此步骤，进入 Step 9

> 参考 skills/platform-publishing 发送飞书消息
你需要注意飞书 mcp 的参数要求，不要出现语法错误；

### Step 9: 生成工作流总结

**创建总结报告** `workflow_summary.md`：

```markdown
# 内容创作工作流总结

**创作主题**: {{topic}}
**执行时间**: {{timestamp}}
**工作空间**: {{workspace}}

## 执行步骤

✅ Step 1: 数据收集完成
✅ Step 2: 文章撰写完成
✅ Step 3: 质量评审通过（评分：{{score}}）
✅ Step 4: 公众号发布{{status}}
✅ Step 5: 小红书改写完成
✅ Step 6: 小红书发布{{status}}

## 生成的文件

- 热点数据: {{hot_topic_data_path}}
- 公众号文章: {{wx_article_path}}
- 小红书文章: {{xhs_article_path}}
- 评审报告: {{review_report_path}}

## 发布状态

- 公众号: {{wx_publish_status}}
- 小红书: {{xhs_publish_status}}

## 下一步建议

1. 查看生成的文章，确认质量
2. 如需修改，可以直接编辑 Markdown 文件
3. 如未自动发布，请手动发布到各平台
4. 保存本次工作流输出作为未来参考
```

**显示给用户**：
- 工作流完成提示
- 总结报告路径
- 关键文件列表
- 下一步操作建议

## 错误处理

在每个步骤中，如果遇到错误：

1. **记录错误信息**到总结报告
2. **提示用户**具体错误原因
3. **提供解决建议**
4. **根据严重程度决定是否继续**：
   - 数据收集失败 → 终止流程
   - 文章撰写失败 → 终止流程
   - 评审失败 → 跳过评审，继续发布
   - 发布失败 → 记录错误，继续其他平台

## 注意事项

1. **配置验证**: 开始前验证配置文件存在且格式正确
2. **路径检查**: 确保所有路径存在，不存在则创建
3. **API 密钥**: 使用环境变量，不要在日志中显示密钥
4. **用户确认**: enabled 为 false 时，不执行实际发布
5. **时间管理**: 整个流程可能需要 5-10 分钟，提示用户耐心等待
6. **增量保存**: 每个步骤完成后保存文件，避免中途失败丢失数据

## 工作流可视化

```
┌─────────────────┐
│  Step 0: 初始化  │
│  • 解析参数      │
│  • 读取配置      │
│  • 创建工作空间   │
└────────┬────────┘
         ↓
┌─────────────────┐
│ Step 1: 数据收集 │
│  collector agent │
└────────┬────────┘
         ↓
┌─────────────────┐
│ Step 2: 文章撰写 │
│  writer-wx agent │
└────────┬────────┘
         ↓
┌─────────────────┐
│ Step 3: 质量评审 │
│  reviewer agent  │
│  (循环最多2次)   │
└────────┬────────┘
         ↓
┌─────────────────┐
│ Step 4: 发布公众号│
│  wenyan-mcp      │
└────────┬────────┘
         ↓
┌─────────────────┐
│Step 5: 小红书改写│
│ writer-xhs agent │
└────────┬────────┘
         ↓
┌─────────────────┐
│Step 6: 发布小红书│
│   playwright     │
└────────┬────────┘
         ↓
┌─────────────────┐
│ Step 7: 生成总结 │
│  workflow_summary│
└─────────────────┘
```

现在，请严格按照上述流程执行内容创作工作流！
