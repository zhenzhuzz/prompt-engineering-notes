# KNOW 知识提取文档编写指南

**文档类型**: Knowledge Extraction Document (KNOW)
**版本**: 1.2.0
**创建日期**: 2025-12-08
**最后更新**: 2025-12-10
**适用场景**: 公司介绍、博客摘要、视频报告、竞品战略分析、技术文章提炼


---

## 📋 文档说明

本指南用于规范从外部来源（公司官网、博客文章、视频内容、技术报告）提取知识时的文档结构和内容要求。

**KNOW 文档的核心目的**：
- **知识转化**：将原始内容转化为可迁移、可分享的结构化知识
- **洞见提炼**：提取独特观点、具体案例、可操作建议
- **快速传递**：让读者在 10-15 分钟内掌握核心价值

**核心原则**：
- ✅ **洞见优先** - 提炼独特观点，而非简单复述
- ✅ **具体案例** - 用真实数据和例子支撑观点
- ✅ **可操作性** - 每个章节都应包含可迁移的行动建议
- ✅ **结构清晰** - 使用 ASCII 图表、表格、对比增强理解
- ✅ **多层受众** - 为不同角色（工程师/管理者/创始人）提供针对性建议

---

## 📑 目录

- [1. 文档类型与适用场景](#1-文档类型与适用场景)
- [2. 文档结构规范](#2-文档结构规范)
- [3. 核心内容要素](#3-核心内容要素)
- [4. 写作风格与技巧](#4-写作风格与技巧)
- [5. 质量检查清单](#5-质量检查清单)

---

## 1. 文档类型与适用场景

### 1.1 四种文档类型

| 类型 | 命名规范 | 适用场景 | 目标长度 |
|------|----------|----------|----------|
| **公司深度研究** | `{company}-company-deep-dive.md` | 公司介绍、商业模式分析 | 400-600 行 |
| **博客/文章摘要** | `{source}-{topic}-summary.md` | 技术博客、行业文章 | 300-500 行 |
| **视频报告** | `{source}-{topic}-report.md` | YouTube 视频、演讲、播客 | 300-500 行 |
| **竞品战略报告** | `{product}-competitive-strategy-report.md` | 竞品分析、市场定位、破局策略 | 500-900 行 |

### 1.2 文档命名示例

```
公司研究：
- palantir-company-deep-dive.md
- stripe-company-deep-dive.md
- openai-company-deep-dive.md

博客摘要：
- parahelp-prompt-design-summary.md
- anthropic-claude-techniques-summary.md
- vercel-ai-sdk-summary.md

视频报告：
- yc-state-of-the-art-prompting-report.md
- lex-fridman-sam-altman-report.md
- nvidia-gtc-keynote-report.md

竞品战略报告：
- yoach-competitive-strategy-report.md
- mechcode-competitive-strategy-report.md
- [product]-competitive-strategy-report.md
```

---

## 2. 文档结构规范

### 2.1 文档头部元信息（必填）

```markdown
# [标题：描述性标题，非原标题直译]

> **Source**: [来源类型和名称]
> **Author/Speaker**: [作者或演讲者]
> **Date**: [发布日期]
> **Core Metric/Theme**: [核心指标或主题]

---
```

**按文档类型的元信息**：

**公司深度研究**：
```markdown
> **Founded**: [成立时间和地点]
> **Founders**: [创始人]
> **CEO**: [现任 CEO 及背景]
> **Revenue**: [营收数据]
> **Market Cap**: [市值]
> **Core Philosophy**: [核心理念，一句话]
```

**博客/文章摘要**：
```markdown
> **Source**: [博客名称] ([发布日期])
> **Authors**: [作者及职位]
> **Company/Org**: [所属公司]
> **Clients/Users**: [客户或用户，如适用]
> **Core Metric**: [核心成功指标]
```

**视频报告**：
```markdown
> **Source**: [频道名称] Video
> **Speaker(s)**: [演讲者]
> **Featured Company**: [主要介绍的公司]
> **Duration**: [视频时长]
> **Core Theme**: [核心主题]
```

**竞品战略报告**：
```markdown
**文档版本**: v1.0.0
**文档类型**: KNOW 文档
**创建日期**: [日期]
**目标读者**: [创始团队、产品团队、投资人]

> **Product**: [产品名称]
> **Target Market**: [目标市场]
> **Direct Competitors**: [直接竞品，3-5 个]
> **Market Size**: [市场规模]
> **Core Insight**: [核心洞见，一句话]
```

### 2.2 核心章节结构

**必备章节**（所有类型）：

```markdown
## The Essence (核心精华)
[用一个 ASCII 图表/框架图/概念图，将整篇文档最重要的 3-5 个核心概念
可视化呈现。这是读者即使只看这一张图也能带走的核心价值。]

## Executive Summary / Why This Matters
[一段话总结核心洞见，突出"反直觉"或"独特"的观点]

## [主题章节 1-N]
[按主题组织的核心内容，每个章节包含：定义、案例、图表、可操作建议]

## Key Takeaways
[按角色分类的行动建议]

## Sources / References
[引用来源链接]
```

#### The Essence 章节设计指南

**目的**：用一张图让读者在 30 秒内抓住文档精华。

**设计原则**：
- 提炼 3-5 个最核心的概念/洞见/方法
- 用 ASCII 图表可视化概念间关系
- 每个概念用一句话解释其价值
- 可以是：核心公式、决策框架、概念地图、价值链

**示例模板**：

```
┌─────────────────────────────────────────────────────────────────┐
│                     THE ESSENCE (核心精华)                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   [核心概念 1]          [核心概念 2]          [核心概念 3]        │
│   ┌───────────┐        ┌───────────┐        ┌───────────┐      │
│   │  概念名称  │   ──▶  │  概念名称  │   ──▶  │  概念名称  │      │
│   └───────────┘        └───────────┘        └───────────┘      │
│   一句话价值说明        一句话价值说明        一句话价值说明       │
│                                                                 │
│   ─────────────────────────────────────────────────────────     │
│                                                                 │
│   💡 核心洞见: [用一句话总结最反直觉/最有价值的发现]              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**按文档类型的推荐章节**：

**公司深度研究**：
```markdown
## Why [Company] Matters
## Core Products/Platforms
## Business Model & Go-to-Market
## Technical Architecture / Secret Sauce
## Real-World Examples (with metrics)
## Leadership Philosophy
## Actionable Insights for [Your Field]
## Competitive Moats
## Key Metrics
## Key Takeaways
## Sources
```

**博客/文章摘要**：
```markdown
## The Core Insight
## Key Concepts (with definitions)
## Real Production Examples (annotated)
## Patterns & Anti-Patterns
## Transferable Rules
## Key Takeaways
## Glossary (if technical)
```

**视频报告**：
```markdown
## Executive Summary
## [Topic Sections by Timestamp]
## Key Takeaways
## Quick Reference: Timestamps
```

**竞品战略报告**：
```markdown
## The Essence (核心精华)
[三个核心洞见的 ASCII 可视化框图 + 关键数据速览表]

## 执行摘要
[反直觉洞见（引用块）+ Why This Matters（表格）+ 核心结论（3 条）]

## 目录

## 第一部分：[市场背景/案例研究]
[历史案例分析（如 Coach's Eye 兴衰史）或市场现状分析]

## 第二部分：竞品深度解析
### 市场规模与机会
### 竞品分层 (Tier 1/2/3)
### [竞品名] - [定位]（首要威胁）
[ASCII 界面图 + 深度分析 + 优劣势]
### [竞品名] - [定位]（次要威胁）
### 威胁评估矩阵

## 第三部分：[产品名] 破局战略
### Before/After 对比
### 核心差异化能力矩阵
### 破局策略与护城河
### 行动路线图

## 可迁移规则
[5 条普适规律，每条包含：模式 + 为什么有效 + 如何应用]

## Key Takeaways
[按角色分类：工程师 / 管理者 / 创始人]

## 术语表 (Glossary)
## 信息来源 (Sources)
```

---

## 3. 核心内容要素

### 3.1 必须包含的六大要素

#### 要素 #1: 独特洞见（Unique Insights）

**定义**：原始内容中"反直觉"或"不常见"的观点，是读者愿意分享的核心原因。

**识别方法**：
- 作者明确说"大多数人不知道..."或"常见误解是..."
- 与行业常规做法相反的建议
- 基于实战经验的独特发现

**呈现方式**：
```markdown
### The Uncomfortable Truth About [Topic]

> "Most of the time spent on X is actually NOT spent on Y."

**Key Insight**: [一句话总结]
```

**示例**：
```markdown
> "Most of the time spent optimizing prompts is actually NOT spent
> on writing the prompts."

**Key Insight**: If you're spending most of your time writing prompts,
you're doing it wrong. The leverage is in evaluation systems.
```

---

#### 要素 #2: 具体案例与数据（Concrete Examples）

**定义**：用真实公司、真实数据、真实结果支撑观点。

**必须包含**：
- 公司/产品名称（非匿名）
- 具体数字（金额、百分比、时间）
- 前后对比（Before vs After）

**呈现方式**：使用表格展示多个案例

```markdown
| Company | Use Case | Result |
|---------|----------|--------|
| **BP** | Oil & gas operations | **$1B saved** |
| **Global Bank** | Transaction monitoring | **60% faster, 90% lower cost** |
```

**示例**：
```markdown
### Real-World Results

| Company | Use Case | Result |
|---------|----------|--------|
| **BP** | Oil & gas operations optimization | **$1B saved** |
| **Fortune 100 CPG** | 7 ERP systems → digital twin in 5 days | **$100M projected savings Year 1** |
| **CAZ Investments** | Lead processing | **100x more leads, 90% less processing time** |
```

---

#### 要素 #3: ASCII 架构图（Visual Diagrams）

**定义**：用 ASCII 字符绘制架构图、流程图、对比图，帮助理解复杂概念。

**使用场景**：
- 系统架构
- 工作流程
- 概念对比
- 层级关系

**标准模板**：

**架构图**：
```
┌─────────────────────────────────────────────────────────────────┐
│                    [ARCHITECTURE NAME]                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   [Input/Source]                                                │
│        │                                                        │
│        ▼                                                        │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │              [LAYER/COMPONENT 1]                        │   │
│   │   • Point 1                                             │   │
│   │   • Point 2                                             │   │
│   └─────────────────────────────────────────────────────────┘   │
│        │                                                        │
│        ▼                                                        │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │              [LAYER/COMPONENT 2]                        │   │
│   └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**对比图**：
```
┌─────────────────────────────────────────────────────────────────┐
│              [CONCEPT A] vs [CONCEPT B]                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   [CONCEPT A]:                                                  │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │   [Description]                                         │   │
│   │   ❌ Problem 1                                          │   │
│   │   ❌ Problem 2                                          │   │
│   └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│   [CONCEPT B]:                                                  │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │   [Description]                                         │   │
│   │   ✅ Benefit 1                                          │   │
│   │   ✅ Benefit 2                                          │   │
│   └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**树形结构**：
```
Decision Flow:
├── Condition A?
│   ├── Yes → Action 1
│   └── No → Check Condition B
│       ├── B1 → Action 2
│       ├── B2 → Action 3
│       └── B3 → Action 4
```

---

#### 要素 #4: Before/After 对比（Transformations）

**定义**：展示"旧方法 vs 新方法"或"错误做法 vs 正确做法"的对比。

**呈现方式**：

**代码/文本对比**：
```markdown
### Before (Verbose - 89 tokens)
```
[旧的/错误的做法]
```

### After (Optimized - 47 tokens)
```
[新的/正确的做法]
```

### Why It Works
1. [原因 1]
2. [原因 2]
```

**表格对比**：
```markdown
| Aspect | Traditional Approach | New Approach |
|--------|---------------------|--------------|
| **Speed** | 18 months | 5 days |
| **Cost** | $1M+ | $50K |
| **Accuracy** | 60% | 95% |
```

**DO/DON'T 对比**：
```markdown
| ❌ Don't | ✅ Do |
|----------|-------|
| Send surveys | Sit with users for a week |
| Ask "What do you need?" | Watch what they actually do |
```

---

#### 要素 #5: 可迁移规则（Transferable Rules）

**定义**：可以直接应用到读者自己工作中的具体规则或模式。

**呈现方式**：

```markdown
## Transferable Rules

### Rule 1: [Rule Name]

**The Pattern**:
```
[具体的模式或模板]
```

**Why it works**: [解释原因]

**How to apply**: [如何应用到自己的工作]
```

**示例**：
```markdown
### Rule 1: Specify Thinking Order

**The Pattern**:
```xml
<instruction>
To handle this request, follow these steps IN ORDER:
1) First, identify the user's primary intent
2) Then, check which policy applies
3) Next, verify you have all required information
4) Finally, take the appropriate action
</instruction>
```

**Why it works**: Models are autoregressive. Specifying order ensures
correct dependency chain.

**How to apply**: Any time you need multi-step reasoning, explicitly
number the steps in the prompt.
```

---

#### 要素 #6: 多层受众建议（Role-Based Takeaways）

**定义**：为不同角色（工程师、管理者、创始人）提供针对性的行动建议。

**标准格式**：

```markdown
## Key Takeaways

### For Individual Engineers
1. **[动词开头的建议 1]**
2. **[动词开头的建议 2]**
3. **[动词开头的建议 3]**

### For Teams / Managers
1. **[动词开头的建议 1]**
2. **[动词开头的建议 2]**

### For Founders / Leaders
1. **[动词开头的建议 1]**
2. **[动词开头的建议 2]**
```

**示例**：
```markdown
## Key Takeaways

### For Individual Engineers
1. **Build evals first**, prompts second
2. **Use structured formats** (XML/JSON) to activate code-reasoning
3. **Shadow real users** before writing prompts

### For Teams
1. **Parameterize prompts** to avoid consulting-model trap
2. **Treat eval corpus as core IP** — competitors can copy prompts, not evals

### For Founders
1. **Forward deployed mindset** creates defensible insights
2. **Current AI ≈ 1995 coding** — massive opportunity for those who go deep
```

---

### 3.2 可选内容要素

| 要素 | 适用场景 | 示例 |
|------|----------|------|
| **术语表 (Glossary)** | 技术文章、有专有术语 | 英文/中文/定义 三列表格 |
| **时间戳参考 (Timestamps)** | 视频报告 | 时间/主题 两列表格 |
| **竞争壁垒 (Competitive Moats)** | 公司研究 | 壁垒/描述 两列表格 |
| **关键指标 (Key Metrics)** | 公司研究 | 指标/数值 两列表格 |
| **领导者哲学 (Leadership Philosophy)** | 公司研究 | 引用 + 解释 |
| **待探索话题 (Topics to Explore)** | 博客摘要 | 作者提及的后续话题 |

---

### 3.3 竞品战略报告专属要素

> **适用场景**：撰写产品竞争战略报告时，使用以下专属要素来构建完整的竞品分析和破局策略。

#### 要素 A: 竞品分层表格

**目的**：将竞品按威胁程度分层，帮助团队聚焦关键对手。

**标准格式**：
```markdown
### Tier 1: 直接竞品（核心威胁）

| 竞品 | 核心技术 | 融资情况 | 定价 | 威胁等级 |
|------|----------|----------|------|----------|
| **[竞品A]** | [技术描述] | $[金额] (轮次) | $[价格]/月 | ⚠️ 高 |
| **[竞品B]** | [技术描述] | 开源 | 免费 | ⚠️ 高 |

### Tier 2: 邻接玩家（间接竞争）

| 竞品 | 核心技术 | 目标用户 | 商业模式 |
|------|----------|----------|----------|
| **[竞品C]** | [技术描述] | [用户群] | 订阅 |

### Tier 3: 潜在进入者
[学术研究、大公司内部项目等]
```

---

#### 要素 B: 竞品 ASCII 界面图

**目的**：用 ASCII 图可视化竞品核心界面，直观展示功能差异。

**标准模板**：
```
┌─────────────────────────────────────────────────────────────────────────┐
│                       [竞品名] 核心界面                                  │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                      [界面主区域描述]                            │   │
│  │  ┌─────────────────────┐    ┌─────────────────────────────┐     │   │
│  │  │    [功能区 A]        │    │      [功能区 B]              │     │   │
│  │  │    [具体内容]        │    │      [具体内容]              │     │   │
│  │  └─────────────────────┘    └─────────────────────────────┘     │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  核心功能:                        技术限制:                             │
│  • [功能 1]                       • [限制 1]                            │
│  • [功能 2]                       • [限制 2]                            │
│                                                                         │
│  关键洞察: [一句话总结该竞品的核心价值和局限]                           │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

#### 要素 C: 威胁评估矩阵

**目的**：系统性评估每个竞品的威胁程度和应对策略。

**标准模板**：
```
┌─────────────────────────────────────────────────────────────────────────┐
│                      威胁评估与应对策略                                   │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  竞品            威胁     核心威胁点              [产品名] 应对          │
│  ─────────────────────────────────────────────────────────────────────  │
│  [竞品A]        ⚠️高    [资金/技术/用户优势]    [差异化策略]            │
│                                                  [具体行动]              │
│                                                                         │
│  [竞品B]        ⚠️高    [网络效应/生态优势]     [另辟蹊径策略]          │
│                                                  [具体行动]              │
│                                                                         │
│  [竞品C]        🔵中    [细分市场威胁]          [学习+差异化]            │
│                                                  [具体行动]              │
│                                                                         │
│  [竞品D]        🟢低    [免费替代威胁]          [强调独特价值]          │
│                                                  [具体行动]              │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

**威胁等级图例**：
- ⚠️ 高：直接竞争、资金充裕、技术领先
- 🔵 中：间接竞争、不同细分、可学习借鉴
- 🟢 低：不同赛道、可忽略或监控

---

#### 要素 D: 差异化能力矩阵

**目的**：对比自身与竞品的功能差异，识别独有优势。

**标准格式**：
```markdown
| 功能维度 | 竞品A | 竞品B | 竞品C | **[产品名]** |
|----------|-------|-------|-------|--------------|
| [能力 1] | ✅    | ❌    | ❌    | ✅           |
| [能力 2] | ❌    | ✅    | ❌    | ✅           |
| [能力 3] | ❌    | ❌    | ❌    | ✅ (独有)    |
| [能力 4] | ✅    | ✅    | ✅    | ✅           |
```

---

#### 要素 E: 护城河层级图

**目的**：可视化产品的多层防御壁垒。

**标准模板**：
```
┌─────────────────────────────────────────────────────────────────┐
│ L4 [最外层]: [工作流/生态整合]                                   │
├─────────────────────────────────────────────────────────────────┤
│ L3 [第三层]: [社区/网络效应]                                     │
├─────────────────────────────────────────────────────────────────┤
│ L2 [第二层]: [内容/数据资产]                                     │
├─────────────────────────────────────────────────────────────────┤
│ L1 [核心层]: [技术/格式标准]                                     │
└─────────────────────────────────────────────────────────────────┘
```

**示例**：
```
四层护城河:
┌─────────────────────────────────────────────────────────────────┐
│ L4 工作流: CI/CD + Python API 深度集成                          │
├─────────────────────────────────────────────────────────────────┤
│ L3 社区: 开源核心 + 社区贡献标准件库                             │
├─────────────────────────────────────────────────────────────────┤
│ L2 AI: 逆向工程数据飞轮 → 模型持续改进                           │
├─────────────────────────────────────────────────────────────────┤
│ L1 格式: .mech 成为程序员机械设计交换标准                        │
└─────────────────────────────────────────────────────────────────┘
```

---

#### 要素 F: 行动路线图

**目的**：将战略分解为可执行的阶段性任务。

**标准模板**：
```
┌─────────────────────────────────────────────────────────────────────────┐
│                    [产品名] [年份] 路线图                                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Phase 1: [阶段名] (Q1)              Phase 2: [阶段名] (Q2)             │
│  ─────────────────────────────────   ─────────────────────────────      │
│  🔲 [任务 1]                         🔲 [任务 1]                         │
│  🔲 [任务 2]                         🔲 [任务 2]                         │
│  🔲 [任务 3]                         🔲 [任务 3]                         │
│  目标: [阶段目标]                    目标: [阶段目标]                    │
│                                                                         │
│  Phase 3: [阶段名] (Q3)              Phase 4: [阶段名] (Q4)             │
│  ─────────────────────────────────   ─────────────────────────────      │
│  🔲 [任务 1]                         🔲 [任务 1]                         │
│  🔲 [任务 2]                         🔲 [任务 2]                         │
│  目标: [阶段目标]                    目标: [阶段目标]                    │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

#### 要素 G: 可迁移规则格式

**目的**：将竞争战略中的洞见提炼为可复用的普适规则。

**标准格式**：
```markdown
### 规则 #N: [规则名称]

**模式**：
```
❌ 错误模式: [常见错误做法]
✅ 正确模式: [推荐做法]
```

**为什么有效**：[解释原因，引用案例]

**如何应用**：[给读者的具体建议]
```

**示例**：
```markdown
### 规则 #1: 诊断不等于解决

**模式**：
```
❌ 错误模式: 诊断 → "你的问题是X" → (结束)
✅ 正确模式: 诊断 → 原因解释 → 解决方案 → 执行跟踪
```

**为什么有效**：用户付费不是为了知道问题，而是为了解决问题。
Coach's Eye 只做了诊断，OnForm 依赖教练做解决，只有 Yoach 提供了完整闭环。

**如何应用**：设计产品时问自己——"用户看完分析报告后，下一步做什么？"
如果答案是"自己想办法"，那你的产品还没完成。
```

---

## 4. 写作风格与技巧

### 4.1 核心写作原则

#### 原则 #1: 洞见密度优先

**要求**：
- ✅ 每个段落都应包含新信息或新观点
- ✅ 删除所有"空话"（如"众所周知"、"值得注意的是"）
- ✅ 如果一句话删掉后不影响理解，就删掉它
- ❌ 避免重复原文的铺垫和过渡

**测试方法**：
> 如果读者跳过这一段，会错过什么关键信息？
> 如果答案是"没什么"，删掉这段。

---

#### 原则 #2: 具体胜过抽象

**要求**：
- ✅ 用具体数字代替模糊描述（"$1B saved" vs "significant savings"）
- ✅ 用公司名称代替泛指（"BP" vs "a major oil company"）
- ✅ 用代码/模板代替描述（实际 XML 结构 vs "使用结构化格式"）
- ❌ 避免空洞的形容词（"innovative"、"cutting-edge"、"powerful"）

**对比**：
```
❌ BAD: "The company achieved significant improvements in efficiency."
✅ GOOD: "BP saved $1B through optimized oil & gas operations."

❌ BAD: "Use structured formats for better results."
✅ GOOD:
```xml
<refund_policy>
  <rule condition="days <= 30">APPROVE</rule>
  <rule condition="days > 30 AND valid_reason">ESCALATE</rule>
</refund_policy>
```
```

---

#### 原则 #3: 视觉结构化

**要求**：
- ✅ 每 3-5 段使用一个视觉元素（表格、图表、代码块）
- ✅ 复杂概念用 ASCII 图表解释
- ✅ 对比内容用表格呈现
- ✅ 列表超过 5 项时考虑转为表格
- ❌ 避免连续超过 10 行的纯文字段落

---

#### 原则 #4: 引用原文精华

**要求**：
- ✅ 保留原作者的精彩表述（用引用块 `>` 标记）
- ✅ 引用后添加解释或应用建议
- ✅ 选择"反直觉"或"memorable"的句子

**格式**：
```markdown
> "We don't just sell software. We sit with users, map messy data
> into a usable ontology, and build production software that keeps
> working when our engineers go home."

**Why this matters**: This explains Palantir's core differentiation —
they're not a product company, they're a transformation company.
```

---

#### 原则 #5: 中英混排规范

**核心原则**：中文为主体语言，英文用于保留核心概念的准确性。

**何时使用中文**：
- ✅ 章节标题和子标题
- ✅ 深度分析和解释性段落
- ✅ 长难句的翻译和阐述
- ✅ Key Takeaways 的行动建议描述

**何时保留英文**：
- ✅ ASCII 图表内的标签和说明
- ✅ 核心术语首次出现时（附中文翻译）
- ✅ XML/代码示例
- ✅ 原文引用（精华句子）
- ✅ 表格中的关键概念名称

**格式示例**：

```markdown
## 章节标题使用中文

### 分析 #1: 核心概念的中文解释

这里是中文的深度分析段落。当提到 **Chain-of-Thought (思维链)** 时，
首次出现附上中文翻译，之后可以简称为 CoT。

> "This is an important quote in English that captures the essence."

**深层洞见**：这句话揭示了...（中文解释）

| 英文术语 | 中文翻译 | 说明 |
|----------|----------|------|
| Affirmative Rules | 肯定规则 | 中文说明 |
```

**ASCII 图表规范**：

```
┌─────────────────────────────────────────────────────────────────┐
│                    DIAGRAM TITLE IN ENGLISH                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   Step 1: English label                                         │
│   说明：中文解释可以放在英文标签下方                               │
│                                                                 │
│   Key Insight: 核心洞见用中文，因为这是给读者的重要信息             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**理由**：
1. **中文主体**：便于快速阅读和理解复杂分析
2. **英文保留**：保持核心概念的准确性，避免翻译失真
3. **ASCII 英文**：确保图表在不同字体下对齐正常

---

### 4.2 特定内容类型的技巧

#### 提取技术概念

1. **先给定义**：用一句话解释概念
2. **再举例子**：用具体场景说明
3. **最后给规则**：可直接复用的模板

```markdown
### The "Model RAM" Concept

**Definition**: Model RAM = The number of conditional paths a model
can reliably track in a single prompt.

**Example**:
```
Simple Flow (2 paths - Any model handles this):
├── Within 30 days → Approve
└── After 30 days → Deny

Complex Flow (8+ paths - Exceeds small model RAM):
├── Within 30 days
│   ├── Full refund → Approve
│   └── Partial refund → Calculate
└── After 30 days
    ├── Defective → Escalate
    └── Changed mind → Deny
```

**Practical Limits**:
| Model | Reliable Paths |
|-------|----------------|
| GPT-3.5 / Haiku | 3-4 |
| GPT-4 / Sonnet | 6-8 |
| o1 / o3 / Opus | 10-15+ |
```

---

#### 提取商业模式

1. **用架构图展示产品线**
2. **用表格展示客户案例**
3. **用对比图展示差异化**

```markdown
## The Three Platforms

### 1. Gotham (Defense)
**Target**: Intelligence agencies, military
**Core Use**: Counter-terrorism, battlefield awareness

[ASCII 架构图]

**Real-World Examples**:
| Client | Use Case | Result |
|--------|----------|--------|
| CIA/FBI | Counter-terrorism | 30% faster case resolution |
```

---

#### 提取领导者观点

1. **背景信息**：教育、非典型经历
2. **核心信念**：3-5 个要点
3. **原话引用**：每个信念配一个引用

```markdown
## Alex Karp's Philosophy

### Unusual Background
- **Education**: Philosophy PhD (not CS or MBA)
- **Style**: Speeches reference historical collapse and civilizational risk

### Core Beliefs

**1. Technology Must Serve Democracy**
> "Karp's belief that technological dominance must serve democratic values
> has become a blueprint for how the West can maintain strength without
> losing its soul."

**2. Product Over Sales**
> "Palantir's ethos was clear: prioritize engineering and product
> excellence over traditional sales tactics."
```

---

## 5. 质量检查清单

### 5.1 内容完整性检查

```
✔ 包含 Executive Summary / Why This Matters
✔ 每个核心概念都有：定义 + 案例 + 图表
✔ 包含至少 3 个具体数字/案例
✔ 包含至少 2 个 ASCII 图表
✔ 包含至少 1 个 Before/After 对比
✔ 包含 Role-Based Key Takeaways
✔ 包含 Sources 引用
```

### 5.2 洞见密度检查

```
✔ 每个章节都有"独特观点"或"反直觉洞见"
✔ 删除了所有"空话"和重复内容
✔ 引用的原话是"精华"而非"铺垫"
✔ 每个建议都是具体可行的（动词开头）
```

### 5.3 视觉结构检查

```
✔ 没有连续超过 10 行的纯文字
✔ 复杂概念用 ASCII 图表解释
✔ 对比内容用表格呈现
✔ 代码/模板有语法高亮
✔ 引用块用于原作者精彩表述
```

### 5.4 可迁移性检查

```
✔ 读者可以直接复制模板使用
✔ 每个规则都解释了"为什么有效"
✔ 不同角色都有针对性建议
✔ 技术概念有非技术人员也能理解的解释
```

### 5.5 竞品战略报告专属检查

```
✔ 包含至少 3 个竞品的深度分析
✔ 包含竞品分层表格（Tier 1/2/3）
✔ 包含威胁评估矩阵（高/中/低 + 应对策略）
✔ 包含差异化能力对比表（✅/❌ 矩阵）
✔ 包含护城河分析（多层结构）
✔ 包含行动路线图（按阶段/季度）
✔ 每个主要竞品有 ASCII 界面图或架构图
✔ 包含 5 条可迁移规则
✔ 包含 Before/After 场景对比
```

---

## 附录：快速参考

### A. 文档类型速查

| 场景 | 文档类型 | 命名格式 |
|------|----------|----------|
| 研究一家公司 | Company Deep Dive | `{company}-company-deep-dive.md` |
| 总结技术博客 | Blog Summary | `{source}-{topic}-summary.md` |
| 记录视频内容 | Video Report | `{source}-{topic}-report.md` |
| 制定竞争策略 | Competitive Strategy Report | `{product}-competitive-strategy-report.md` |

### B. 六大必备要素速查

1. **独特洞见** — 反直觉的核心观点
2. **具体案例** — 公司名 + 数字 + 结果
3. **ASCII 图表** — 架构图、流程图、对比图
4. **Before/After** — 旧方法 vs 新方法
5. **可迁移规则** — 可直接复用的模板
6. **多层受众建议** — 工程师/管理者/创始人

### C. ASCII 图表符号速查

```
Box drawing:
┌ ┐ └ ┘ ─ │ ├ ┤ ┬ ┴ ┼

Arrows:
→ ← ↑ ↓ ▶ ◀ ▲ ▼ ──▶

Symbols:
✅ ❌ ⚠️ • ├── └──
```

---

**下一步**:
- 📚 使用本指南提取知识文档
- 🎯 确保包含六大必备要素
- 📊 每 3-5 段添加视觉元素
- 🔄 检查洞见密度和可迁移性

---

## 📜 版本历史

| 版本 | 日期 | 变更内容 |
|------|------|----------|
| v1.0.0 | 2025-12-08 | 初始版本，定义四种文档类型和六大必备要素 |
| v1.1.0 | 2025-12-10 | 新增竞品战略报告专属要素（A-G）、质量检查清单、附录快速参考 |
| v1.2.0 | 2025-12-10 | 新增版本历史章节、语言风格指南（中英混排规范） |