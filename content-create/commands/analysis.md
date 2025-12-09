---
name: content:analysis
description: 分析内容创作数据并生成可视化报告
argument-hint: <data-path> [analysis-type:performance|trend|comparison] [output-path:path]
allowed-tools:
  - Read
  - Write
  - Bash
---

# Content Analysis Command

你现在需要调用 data-analyst agent 对内容创作相关数据进行分析和可视化。

## 输入参数

从用户输入中解析以下参数：

**必填参数**:
- `data-path`: 数据文件路径（用户输入的主要文本），支持格式：CSV、Excel、JSON

**可选参数**（格式：key:value）:
- `analysis-type`: 分析类型，可选值：
  - `performance`: 性能分析（点赞数、阅读量、互动率等）
  - `trend`: 趋势分析（时间序列变化）
  - `comparison`: 对比分析（不同平台、不同主题）
  - 默认：根据数据自动判断
- `output-path`: 报告输出路径，默认：`{data-path-dir}/analysis_report.md`

**示例输入**:
```
/content-create:analysis article/2025-12-08/metrics.csv
/content-create:analysis data/wx_stats.json analysis-type:trend
/content-create:analysis article/stats.xlsx analysis-type:comparison output-path:reports/compare.md
```

## 执行步骤

### Step 1: 参数验证

1. **解析参数**
   - 提取 data-path 和可选参数
   - 验证 data-path 文件存在
   - 验证文件格式（CSV/Excel/JSON）

2. **检查数据可用性**
   - 尝试读取文件
   - 检查文件大小（不为空）
   - 验证数据格式正确

3. **如果文件不存在或无法读取**：
   ```
   错误：数据文件不存在或无法访问
   文件路径：{{data-path}}

   请确认：
   1. 文件路径是否正确
   2. 文件是否存在
   3. 文件格式是否支持（CSV、Excel、JSON）
   ```
   - 终止执行

### Step 2: 确定分析目标

**如果用户未指定 analysis-type**：
- 询问用户分析目标：
  ```
  请指定分析目标（或让我根据数据自动判断）：

  1. 性能分析 (performance): 评估内容表现（点赞、阅读、互动）
  2. 趋势分析 (trend): 观察指标随时间变化
  3. 对比分析 (comparison): 比较不同维度的差异

  您可以回复数字或关键词，或直接说"自动判断"。
  ```

**如果用户指定了 analysis-type**：
- 使用指定的分析类型

**如果用户选择"自动判断"**：
- 快速扫描数据，根据列名和数据特征推断分析类型

### Step 3: 调用 data-analyst agent

**传递以下完整信息给 data-analyst agent**：

```
请分析以下数据文件并生成专业的分析报告。

## 数据文件
文件路径：{{data-path}}
文件格式：{{format}}
数据行数：{{rows}}（如果已知）

## 分析目标
分析类型：{{analysis-type}}

具体要求：
{{根据 analysis-type 生成具体要求}}

## 输出要求

1. **数据质量评估**
   - 数据完整性检查
   - 异常值检测
   - 缺失值分析

2. **生成可视化图表**（最少 3-5 个图表）
   根据分析类型生成相应图表：

   • performance（性能分析）：
     - 各指标表现柱状图
     - 互动率分布图
     - 热门内容 Top 10
     - 表现最差内容 Bottom 5

   • trend（趋势分析）：
     - 时间序列折线图
     - 移动平均线
     - 趋势预测
     - 周期性分析

   • comparison（对比分析）：
     - 分组对比柱状图
     - 箱线图（分布对比）
     - 散点图（相关性）
     - 热力图（多维对比）

3. **统计分析**
   - 描述性统计（均值、中位数、标准差）
   - 关键洞察（Top 3）
   - 异常点分析

4. **可操作建议**
   - 基于数据的改进建议（3-5条）
   - 关注要点
   - 下一步行动

## 输出格式

请生成 Markdown 格式的分析报告，包含：
- 嵌入的图表（PNG 格式）
- 清晰的章节结构
- 数据表格（关键数据）
- 可执行的建议

输出路径：{{output-path}}
```

### Step 4: 等待 agent 完成

**data-analyst agent 工作流程**：
1. 读取数据文件
2. 数据清洗和预处理
3. 执行统计分析
4. 生成可视化图表（使用 Python: matplotlib、seaborn）
5. 编写分析报告
6. 保存报告和图表

**预计时间**: 2-5 分钟，取决于数据量

**提示用户**：
```
正在分析数据，请稍候...
• 读取数据文件
• 执行统计分析
• 生成可视化图表
• 编写分析报告

预计需要 2-5 分钟，请耐心等待。
```

### Step 5: 验证输出

1. **检查报告文件**
   - 确认 `{{output-path}}` 文件已生成
   - 验证文件不为空
   - 检查是否包含图表

2. **检查图表文件**
   - 确认图表 PNG 文件已生成
   - 验证图表数量（至少 3 个）

3. **如果输出不完整**：
   - 提示用户缺少的部分
   - 建议重新运行或手动补充

### Step 6: 展示结果

**向用户报告**：

```
✅ 数据分析完成！

## 分析总结
• 数据文件：{{data-path}}
• 数据行数：{{rows}}
• 分析类型：{{analysis-type}}
• 生成图表：{{chart-count}} 个

## 关键发现（Top 3）
1. {{insight-1}}
2. {{insight-2}}
3. {{insight-3}}

## 查看完整报告
报告路径：{{output-path}}
图表目录：{{charts-dir}}

## 下一步建议
{{recommendations}}
```

## 不同分析类型的具体要求

### Performance（性能分析）

**适用场景**: 评估内容表现，找出优秀和待改进的内容

**分析维度**:
- 阅读量、点赞数、评论数、分享数
- 互动率 = (点赞 + 评论 + 分享) / 阅读量
- 平均停留时间
- 转化率（如有）

**关键图表**:
1. 各指标表现柱状图
2. 互动率分布直方图
3. Top 10 热门内容
4. Bottom 5 待改进内容
5. 指标相关性热力图

**输出建议**:
- 高性能内容的共同特征
- 低性能内容的改进方向
- 最佳发布时间和频率

### Trend（趋势分析）

**适用场景**: 观察指标随时间的变化，发现规律和预测趋势

**分析维度**:
- 时间序列数据（日/周/月）
- 增长率
- 周期性（周末效应、节假日效应）
- 趋势预测

**关键图表**:
1. 时间序列折线图（多指标）
2. 移动平均线（7日/30日）
3. 增长率变化图
4. 周期性分析（热力图）
5. 趋势预测图

**输出建议**:
- 上升/下降趋势的原因分析
- 周期性规律的利用
- 未来趋势预测

### Comparison（对比分析）

**适用场景**: 比较不同维度（平台、主题、时间段）的差异

**分析维度**:
- 不同平台对比（公众号 vs 小红书）
- 不同主题对比（AI vs 产品 vs 技术）
- 不同时间段对比（本月 vs 上月）
- 不同作者对比（如多人团队）

**关键图表**:
1. 分组对比柱状图
2. 箱线图（分布对比）
3. 散点图（相关性）
4. 雷达图（多维对比）
5. 热力图（交叉对比）

**输出建议**:
- 各维度的优劣势
- 最佳实践总结
- 资源分配建议

## 错误处理

### 数据文件问题

**问题**: 文件不存在或无法读取
**解决**:
```
错误：无法访问数据文件
文件：{{data-path}}

请检查：
1. 文件路径是否正确
2. 文件是否存在
3. 是否有读取权限
```

**问题**: 文件格式不支持
**解决**:
```
错误：不支持的文件格式
文件：{{data-path}}

支持的格式：
• CSV (.csv)
• Excel (.xlsx, .xls)
• JSON (.json)

请转换文件格式后重试。
```

**问题**: 数据为空或格式错误
**解决**:
```
错误：数据文件为空或格式错误
文件：{{data-path}}

请确认：
1. 文件不为空
2. 数据格式正确
3. 包含必要的列名和数据
```

### Agent 执行问题

**问题**: data-analyst agent 拒绝执行
**解决**:
- agent 会明确说明拒绝原因（如数据质量不足）
- 提示用户根据 agent 的错误信息修复数据

**问题**: 图表生成失败
**解决**:
- 报告仍会生成，但不包含图表
- 提示用户："部分图表生成失败，请检查数据完整性"

### 输出问题

**问题**: 报告文件未生成
**解决**:
- 检查 agent 执行日志
- 确认输出路径有写入权限
- 建议重新运行

## 注意事项

1. **数据隐私**: 不要在日志中显示敏感数据
2. **大文件处理**: 如果数据文件 > 10MB，警告用户可能需要更长时间
3. **Python 依赖**: 确保 agent 能访问 Python 和必要的库
4. **图表保存**: 图表应保存在报告同目录下的 `charts/` 子目录
5. **Markdown 链接**: 报告中的图表使用相对路径链接

## 使用示例

### 示例 1: 性能分析

```
/content-create:analysis article/2025-12-stats.csv
```

**输出**:
- 报告：`article/2025-12-stats_analysis.md`
- 图表：`article/charts/performance_*.png`

### 示例 2: 趋势分析

```
/content-create:analysis data/monthly_metrics.json analysis-type:trend
```

**输出**:
- 报告：`data/monthly_metrics_analysis.md`
- 图表：`data/charts/trend_*.png`

### 示例 3: 对比分析

```
/content-create:analysis stats/platform_comparison.xlsx analysis-type:comparison output-path:reports/platform_report.md
```

**输出**:
- 报告：`reports/platform_report.md`
- 图表：`reports/charts/comparison_*.png`

现在，请执行数据分析任务！
