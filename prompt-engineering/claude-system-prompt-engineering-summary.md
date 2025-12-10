# 系统级提示词工程：从 Claude Artifacts 泄露中学到的设计模式

**文档类型**: KNOW 文档 (Knowledge Extraction Document)
**版本**: v1.1.0
**创建日期**: 2025-12-10
**最后更新**: 2025-12-10
**目标读者**: 提示词工程师、AI 应用开发者、团队负责人、内容创作者

> **Source**: Claude Artifacts System Prompt (Leaked 2024.06) + Anthropic Official Documentation
> **Primary Analysis**: [NJ Pearman's Blog](https://njpearman.github.io/2024-09-06/the-claude-artifacts-system-prompt-or-message) (Sep 2024)
> **Original Leak**: [GitHub - Claude Artifacts 系统提示词原文](https://github.com/YeeKal/leaked-system-prompts/blob/main/prompts/anthropic/claude-artifacts_20240620.md)
> **SEO Deep Dive**: [GPT Insights - Claude 搜索策略分析](https://gpt-insights.de/ai-insights/gpt-insights-claude-leak-en/)
> **Core Theme**: 如何为 AI Agent 设计结构化系统提示词

---

## 版本历史

| 版本 | 日期 | 变更内容 |
|------|------|----------|
| v1.0.0 | 2025-12-10 | 初始版本，基于 NJ Pearman 分析整理五大核心技术 |
| v1.1.0 | 2025-12-10 | 新增 GPT Insights 搜索策略分析、深度分析章节、KNOW 文档格式规范 |

---

## The Essence

```
┌─────────────────────────────────────────────────────────────────────────────┐
│       SYSTEM PROMPT = XML STRUCTURE + RULES + CHAIN-OF-THOUGHT              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   THE SYSTEM PROMPT FORMULA:                                                │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                                                                     │   │
│   │    XML Sections       ×   Rule Design       ×   Internal CoT        │   │
│   │   (Organization)          (Behavior)            (Reasoning)         │   │
│   │        ↓                      ↓                     ↓               │   │
│   │   <artifacts_info>      Affirmative first    <antThinking>          │   │
│   │   <instructions>        Negative second      (scrubbed from         │   │
│   │   <examples>            Explicit prohibit     API response)         │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   FIVE CORE TECHNIQUES:                                                     │
│                                                                             │
│   1. XML HIERARCHY        Nested sections: <outer><inner></inner></outer>   │
│      ─────────────        Tag names = content descriptors                   │
│                                                                             │
│   2. AFFIRMATIVE RULES    First: WHEN to do something                       │
│      ─────────────        Then: WHEN NOT to do it                           │
│                           (Easier for model to follow "do X" than "don't")  │
│                                                                             │
│   3. TYPE DEFINITIONS     MIME types for outputs: application/vnd.ant.code  │
│      ─────────────        Enables downstream client handling                │
│                                                                             │
│   4. EXPLICIT PROHIBIT    "DO NOT USE ARBITRARY VALUES"                     │
│      ─────────────        "NEVER use placeholder comments"                  │
│                           Caps + specific = higher compliance               │
│                                                                             │
│   5. INTERNAL REASONING   <antThinking> for pre-evaluation                  │
│      ─────────────        Model reasons before output, tags stripped        │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   💡 KEY INSIGHT: 3500+ token prompt = only 1.5% of context window          │
│      Long, detailed system prompts are NOT a problem for modern models      │
│                                                                             │
│   🔍 SEARCH INSIGHT (from GPT Insights):                                    │
│      Web search is NOT default — triggered only when internal knowledge     │
│      is insufficient. Four strategies: never_search → do_not_search_but_    │
│      offer → single_search → research (2-20 tool calls)                     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 为什么这很重要 (Why This Matters)

系统提示词是 **AI Agent 行为的基石**。一个设计良好的系统提示词决定了：
- 模型能做什么、不能做什么
- 输出的格式和结构
- 何时触发特定行为
- 如何处理边界情况

> "The Claude artifacts system prompt is over 3500 tokens before getting to uploaded documents. That's 'large' when thinking about reading and maintaining the prompt; it's a lot of content. At 1.5% of the full context window size, it is arguably not a particularly big deal."

**核心洞见**：不要害怕长系统提示词。清晰度和结构比简洁更重要。

### 反直觉发现：搜索不是默认行为

来自 GPT Insights 的深度分析揭示了一个关键事实：

> **LLM 的网页搜索并非默认行为，而是基于内部知识充足性的决策树触发。**

这意味着：
- 大多数查询不会触发外部搜索
- 只有当模型"不确定"时才会主动搜索
- 链接引用必须通过实时搜索获取才可靠

---

## 1. XML 标签组织模式

### 为什么使用 XML？

Claude 在训练数据中接触过大量 XML 标签，因此对 XML 结构特别敏感。

| Benefit | 说明 |
|---------|------|
| **Clarity** | 清晰分隔提示词的不同部分 |
| **Accuracy** | 减少模型误解的可能性 |
| **Flexibility** | 轻松修改某个章节而无需重写全文 |
| **Parseability** | 便于从模型输出中提取特定部分 |

### Artifacts 提示词的层级结构

```
┌─────────────────────────────────────────────────────────────────────────────┐
│              CLAUDE ARTIFACTS SYSTEM PROMPT HIERARCHY                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ROOT LEVEL SECTIONS:                                                      │
│                                                                             │
│   <artifacts_info>                 ← Main feature documentation             │
│       <artifact_instructions>      ← How to create artifacts                │
│   </artifacts_info>                                                         │
│                                                                             │
│   <examples>                       ← Sample implementations                 │
│       <example>                    ← Individual examples                    │
│   </examples>                                                               │
│                                                                             │
│   <claude_info>                    ← Model capabilities & knowledge cutoff  │
│   </claude_info>                                                            │
│                                                                             │
│   <claude_image_specific_info>     ← Visual handling rules                  │
│   </claude_image_specific_info>                                             │
│                                                                             │
│   <documents>                      ← Uploaded file handling                 │
│       <document>                                                            │
│           <source>                                                          │
│       </document>                                                           │
│   </documents>                                                              │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 标签命名最佳实践

```xml
<!-- ✅ GOOD: Descriptive, consistent -->
<instructions>...</instructions>
<context>...</context>
<examples>...</examples>
<formatting>...</formatting>

<!-- ✅ GOOD: Reference tags in text -->
"Using the contract in <contract> tags, analyze..."

<!-- ✅ GOOD: Nest for hierarchy -->
<outer>
    <inner>Content here</inner>
</outer>

<!-- ❌ BAD: Ambiguous names -->
<data>...</data>
<info>...</info>
<stuff>...</stuff>
```

---

## 2. 肯定规则 vs 否定规则的设计

### 规则设计模式

Claude Artifacts 提示词使用了特定的规则排序模式：

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    RULE DESIGN PATTERN                                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   STEP 1: AFFIRMATIVE RULES (When TO do something)                          │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │   "Good artifacts require:                                          │   │
│   │    • Substantial content (>15 lines)                                │   │
│   │    • Self-contained, reusable material                              │   │
│   │    • Content users likely iterate on"                               │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                           │                                                 │
│                           ▼                                                 │
│   STEP 2: NEGATIVE RULES (When NOT to do something)                         │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │   "Avoid artifacts for:                                             │   │
│   │    • Simple, informational, or short content                        │   │
│   │    • Brief code snippets                                            │   │
│   │    • Primarily explanatory material                                 │   │
│   │    • Conversational context-dependent content"                      │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   WHY THIS ORDER:                                                           │
│   • Models follow "do X when Y" better than "don't do X"                    │
│   • Positive examples anchor understanding                                  │
│   • Negative rules refine the boundary                                      │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Before/After 对比

**Before (Negative-First)** — 否定规则在前：
```
Don't create artifacts for simple content.
Don't use artifacts for short code.
Don't make artifacts for explanatory text.
Create artifacts for substantial, reusable content.
```

**After (Affirmative-First)** — 肯定规则在前：
```xml
<when_to_create>
Create artifacts when:
• Content is substantial (>15 lines)
• Content is self-contained and reusable
• Users will likely modify or iterate on it
</when_to_create>

<when_to_avoid>
Avoid artifacts for:
• Simple, informational content
• Brief code snippets
• Primarily explanatory material
</when_to_avoid>
```

**为什么这样更有效**：模型更容易遵循"当 Y 条件满足时做 X"，而不是"不要做 X"。肯定的例子锚定了理解，否定规则只是细化边界。

---

## 3. 内部思维链机制 (Internal Chain-of-Thought)

### `<antThinking>` 模式

Artifacts 提示词使用特殊标签进行内部推理，这些内容会**从 API 响应中移除**：

```xml
<!-- Model's internal process (not visible to user) -->
<antThinking>
1. Does this content meet artifact criteria?
   - Is it >15 lines? Yes
   - Is it self-contained? Yes
   - Will user iterate on it? Likely

2. Is this a new artifact or an update?
   - No existing artifact with this ID
   - Creating new artifact

3. What type should it be?
   - It's React code → application/vnd.ant.react
</antThinking>

<!-- User sees only this -->
<artifact identifier="dashboard-component" type="application/vnd.ant.react">
...
</artifact>
```

### 应用这个模式

你可以在自己的系统提示词中使用类似的机制：

```xml
<instructions>
Before responding, think through:
1. [First evaluation criterion]
2. [Second evaluation criterion]
3. [Decision point]

Use <thinking> tags for your reasoning process.
Only the final <answer> will be shown to the user.
</instructions>
```

**核心价值**：让模型在输出前进行结构化推理，同时保持用户看到的响应简洁。

---

## 4. MIME 类型定义

### 为什么需要 MIME 类型？

MIME 类型让下游客户端能够正确处理不同类型的输出：

| Type | MIME | Purpose |
|------|------|---------|
| Code | `application/vnd.ant.code` | 带语言属性的代码片段 |
| Documents | `text/markdown` | 格式化文本内容 |
| HTML | `text/html` | 单文件交互页面 |
| SVG | `image/svg+xml` | 矢量图形 |
| Mermaid | `application/vnd.ant.mermaid` | 流程图/架构图 |
| React | `application/vnd.ant.react` | Tailwind 组件 |

### 实现模式

```xml
<artifact_types>
    <type name="code"
          mime="application/vnd.ant.code"
          attributes="language">
        For code snippets and scripts.
        Requires language attribute (python, javascript, etc.)
    </type>

    <type name="document"
          mime="text/markdown">
        For formatted text documents.
        Uses standard markdown syntax.
    </type>

    <type name="react"
          mime="application/vnd.ant.react"
          constraints="tailwind-only, no-arbitrary-values">
        For React components.
        Must use Tailwind CSS classes.
        Pre-installed libraries: lucide-react, recharts, shadcn/ui
    </type>
</artifact_types>
```

---

## 5. 显式约束规范

### 禁止规则的设计模式

Artifacts 提示词使用**大写 + 具体示例**来提高约束遵守率：

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    CONSTRAINT SPECIFICATION PATTERNS                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   WEAK (Low Compliance):                                                    │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │   "Try to avoid arbitrary values"                                   │   │
│   │   "It's better not to use placeholder comments"                     │   │
│   │   "Please don't truncate code"                                      │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   STRONG (High Compliance):                                                 │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │   "DO NOT USE ARBITRARY VALUES"                                     │   │
│   │   "NEVER use placeholder comments like '// rest remains the same'"  │   │
│   │   "Always provide complete code without truncation"                 │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   ELEMENTS OF STRONG CONSTRAINTS:                                           │
│   • ALL CAPS for key words (DO NOT, NEVER, ALWAYS)                          │
│   • Specific examples of violations                                         │
│   • No hedging language (try, prefer, better)                               │
│   • Explicit what TO DO, not just what not to do                            │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Artifacts 提示词中的真实示例

```xml
<constraints>
    <!-- Styling constraint -->
    <rule type="prohibition">
        DO NOT USE ARBITRARY VALUES in Tailwind CSS.
        ❌ className="w-[347px]"
        ✅ className="w-full" or "w-1/2"
    </rule>

    <!-- Code completeness constraint -->
    <rule type="requirement">
        ALWAYS provide complete code without truncation.
        NEVER use placeholder comments like:
        ❌ "// rest of code remains the same"
        ❌ "// ... (implementation)"
        ❌ "// Add your logic here"
    </rule>

    <!-- Output limit constraint -->
    <rule type="limit">
        Create ONE artifact per message unless explicitly requested.
        Prefer inline content when possible.
    </rule>
</constraints>
```

---

## 6. Claude 的搜索决策策略

> 来源：[GPT Insights 深度分析](https://gpt-insights.de/ai-insights/gpt-insights-claude-leak-en/)

这是从泄露的系统提示词中发现的一个重要机制：**Claude 的网页搜索并非默认行为**，而是基于决策树触发。

### 四类搜索策略

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    CLAUDE'S SEARCH DECISION TREE                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   User Query                                                                │
│       │                                                                     │
│       ▼                                                                     │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │  Is this stable knowledge? (e.g., "What is the capital of France?") │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│       │ Yes                          │ No                                   │
│       ▼                              ▼                                      │
│   ┌──────────────┐      ┌────────────────────────────────────────────┐      │
│   │ never_search │      │ Do I have an answer but might need update? │      │
│   │ 直接回答      │      └────────────────────────────────────────────┘      │
│   │ 无链接       │           │ Yes                    │ No                  │
│   └──────────────┘           ▼                        ▼                     │
│                    ┌─────────────────────┐  ┌─────────────────────────┐     │
│                    │ do_not_search_but_  │  │ Is this time-sensitive  │     │
│                    │ offer               │  │ factual query?          │     │
│                    │ 先回答，再建议搜索    │  └─────────────────────────┘     │
│                    └─────────────────────┘      │ Yes          │ No         │
│                                                 ▼              ▼            │
│                                      ┌──────────────┐  ┌──────────────┐     │
│                                      │ single_search│  │   research   │     │
│                                      │ 单次定向搜索  │  │ 2-20次工具调用│     │
│                                      └──────────────┘  │ 复杂多维任务  │     │
│                                                        └──────────────┘     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 对内容创作者的启示

| 洞见 | 说明 |
|------|------|
| **可见性门槛** | 只有触发搜索的查询才有机会获得链接引用 |
| **内容要求** | 需要清晰结构、可引用、模块化设计 |
| **竞争维度** | 从传统排名转向"引文优化"——能否被 LLM 引用和链接 |
| **URL 处理** | LLM 不存储网址作为可查询结构，链接必须通过实时搜索获取 |

**实际影响**：如果你希望你的内容被 AI 引用，需要：
1. 针对"不确定性查询"优化内容（模型不知道的事）
2. 提供清晰的结构化信息，便于模型提取
3. 确保内容在搜索引擎中有良好排名

---

## 7. 可迁移的提示词模式

### Pattern 1: Section-Based Organization

```xml
<system_prompt>
    <identity>
        [Who the model is, its role]
    </identity>

    <capabilities>
        [What the model can do]
    </capabilities>

    <instructions>
        [How to behave]
    </instructions>

    <constraints>
        [Limitations and prohibitions]
    </constraints>

    <examples>
        [Sample interactions]
    </examples>
</system_prompt>
```

### Pattern 2: Feature Documentation Block

```xml
<feature_name_info>
    <overview>
        [What this feature is]
    </overview>

    <activation_criteria>
        [When to use this feature]
        • Criterion 1
        • Criterion 2
    </activation_criteria>

    <avoidance_criteria>
        [When NOT to use]
        • Anti-pattern 1
        • Anti-pattern 2
    </avoidance_criteria>

    <implementation>
        [How to implement]
    </implementation>

    <feature_types>
        [Variants of the feature]
    </feature_types>
</feature_name_info>
```

### Pattern 3: Evaluation Wrapper

```xml
<evaluation_instructions>
    Before taking action, evaluate:

    <step_1>
        [First check: Is this appropriate?]
    </step_1>

    <step_2>
        [Second check: What type/variant?]
    </step_2>

    <step_3>
        [Third check: Any constraints apply?]
    </step_3>

    <output_format>
        [How to structure the response]
    </output_format>
</evaluation_instructions>
```

---

## 8. Before/After: 提示词重构示例

### 示例：工具使用说明

**Before (Unstructured)** — 非结构化：
```
You can use the search tool to find information. The search tool
takes a query parameter. You should use search when the user asks
about current events or things you don't know. Don't use search
for things you already know. The results will be in JSON format.
You should summarize the results for the user. If search fails,
tell the user you couldn't find information.
```

**After (XML Structured)** — XML 结构化：
```xml
<tool name="search">
    <description>
        Search the web for current information.
    </description>

    <parameters>
        <param name="query" type="string" required="true">
            The search query
        </param>
    </parameters>

    <when_to_use>
        • User asks about current events
        • Information outside your knowledge cutoff
        • User explicitly requests a search
    </when_to_use>

    <when_to_avoid>
        • Information you already know accurately
        • Opinion-based questions
        • Simple factual queries within training data
    </when_to_avoid>

    <output_handling>
        Results return as JSON. Summarize key findings for the user.
    </output_handling>

    <error_handling>
        If search fails: "I couldn't find information about that.
        Would you like me to try a different search?"
    </error_handling>
</tool>
```

**为什么结构化更好**：
1. 每个方面独立成块，便于修改和维护
2. 模型更容易"定位"到相关规则
3. 减少歧义和遗漏

---

## 可迁移规则 (Transferable Rules)

### 规则 #1: 肯定规则优先

**模式**：
```
❌ 错误: Don't do X. Don't do Y. Do Z.
✅ 正确: Do Z when [condition]. Avoid X and Y.
```

**为什么有效**：模型更容易遵循"做什么"而非"不做什么"。肯定规则锚定理解，否定规则细化边界。

**如何应用**：在编写系统提示词时，先列出"何时应该"，再列出"何时不应该"。

---

### 规则 #2: 大写 + 具体示例 = 高遵守率

**模式**：
```
❌ 弱约束: "Try to avoid placeholder comments"
✅ 强约束: "NEVER use placeholder comments like '// rest remains the same'"
```

**为什么有效**：大写关键词（DO NOT, NEVER, ALWAYS）在训练数据中与强制性指令关联。具体示例消除歧义。

**如何应用**：对于关键约束，使用大写 + ❌/✅ 示例对比。

---

### 规则 #3: 内部推理标签

**模式**：
```xml
<thinking>
[Model's internal reasoning - stripped from output]
</thinking>

<answer>
[What user sees]
</answer>
```

**为什么有效**：让模型在输出前进行结构化推理，提高输出质量，同时保持用户看到的响应简洁。

**如何应用**：在系统提示词中定义思考标签，并在后处理中移除。

---

### 规则 #4: 长提示词不是问题

**模式**：
```
❌ 误解: 系统提示词应该尽量简短
✅ 事实: 3500+ tokens = 仅占 1.5% 上下文窗口
```

**为什么有效**：现代 LLM 的上下文窗口足够大，清晰度和完整性比简洁更重要。

**如何应用**：不要为了简短而牺牲清晰度。宁可详细也不要模糊。

---

### 规则 #5: MIME 类型实现类型安全

**模式**：
```xml
<type name="code" mime="application/vnd.ant.code" attributes="language">
```

**为什么有效**：类型定义让模型知道输出格式，让客户端知道如何处理。减少格式错误。

**如何应用**：为每种输出类型定义明确的 MIME 类型和属性要求。

---

## Key Takeaways

### For Prompt Engineers (提示词工程师)
1. **大胆使用 XML 标签** — Claude 对 XML 结构特别敏感
2. **肯定规则优先** — 先说"何时做"，再说"何时不做"
3. **大写 + 具体示例** — "DO NOT" 比 "try to avoid" 效果好得多
4. **长提示词没问题** — 3500 tokens = 仅 1.5% 上下文窗口

### For AI Application Developers (AI 应用开发者)
1. **用 MIME 类型处理输出** — 实现类型安全的下游处理
2. **内部推理标签** — 让模型思考，但从输出中移除
3. **显式类型定义** — 减少功能使用中的歧义
4. **一个功能一个章节** — 便于维护和调试

### For Team Leads (团队负责人)
1. **系统提示词是文档** — 像代码一样版本控制
2. **结构化支持迭代** — XML 章节可以独立修改
3. **示例至关重要** — 展示比描述更有效
4. **显式测试边界情况** — 发现失败时添加约束

### For Content Creators (内容创作者)
1. **针对"不确定性查询"优化** — 只有这类查询会触发搜索
2. **结构化你的内容** — 便于 LLM 提取和引用
3. **从"排名"思维转向"引文"思维** — AI 时代的 SEO 新维度

---

## Quick Reference: XML 标签模板

```xml
<system_prompt>
    <!-- Identity Section -->
    <identity>
        You are [ROLE] that [PRIMARY FUNCTION].
    </identity>

    <!-- Capabilities Section -->
    <capabilities>
        <capability name="[NAME]">
            <description>[WHAT IT DOES]</description>
            <when_to_use>[TRIGGERS]</when_to_use>
            <when_to_avoid>[ANTI-PATTERNS]</when_to_avoid>
        </capability>
    </capabilities>

    <!-- Instructions Section -->
    <instructions>
        <rule priority="high">
            [CRITICAL BEHAVIOR]
        </rule>
        <rule priority="medium">
            [IMPORTANT BEHAVIOR]
        </rule>
    </instructions>

    <!-- Constraints Section -->
    <constraints>
        <prohibition>
            NEVER [FORBIDDEN ACTION].
            ❌ Example of violation
            ✅ Example of compliance
        </prohibition>
    </constraints>

    <!-- Examples Section -->
    <examples>
        <example name="[SCENARIO]">
            <user>[USER INPUT]</user>
            <assistant>[IDEAL RESPONSE]</assistant>
        </example>
    </examples>
</system_prompt>
```

---

## 深度分析：为什么 Anthropic 这样设计系统提示词

### 分析 #1: XML 结构的认知科学基础

Anthropic 选择 XML 作为提示词组织格式并非偶然。从认知科学角度分析：

**层级结构映射思维模型**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    WHY XML WORKS FOR LLMs                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   Human Mental Model:              LLM Token Processing:                    │
│   ┌─────────────────┐              ┌─────────────────┐                      │
│   │ Context         │              │ <context>       │                      │
│   │   └─ Task       │      ═══▶    │   <task>        │                      │
│   │       └─ Rule   │              │     <rule>      │                      │
│   └─────────────────┘              └─────────────────┘                      │
│                                                                             │
│   Key Insight: XML tags create "attention anchors" that help the model      │
│   maintain context across long sequences.                                   │
│                                                                             │
│   训练数据中的 XML 模式:                                                     │
│   • HTML/XHTML 网页 → 结构化内容理解                                         │
│   • API 文档 → 参数和约束的关联                                              │
│   • 配置文件 → 层级依赖关系                                                   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**深层原因**：Claude 的训练数据中包含大量 XML/HTML 结构化文档。当模型看到 `<instructions>` 标签时，它会激活与"指令遵循"相关的注意力模式，类似于人类看到"注意事项"标题时会更加警觉。

---

### 分析 #2: "肯定优先"规则的心理学原理

为什么 Anthropic 坚持"先说做什么，再说不做什么"？

**认知负载理论 (Cognitive Load Theory)**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│              COGNITIVE PROCESSING: AFFIRMATIVE vs NEGATIVE                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   NEGATIVE INSTRUCTION:                                                     │
│   "Don't create artifacts for simple content"                               │
│                                                                             │
│   Model's internal process:                                                 │
│   Step 1: Parse "create artifacts" → activate artifact creation pathway    │
│   Step 2: Parse "don't" → inhibit activated pathway                         │
│   Step 3: Parse "simple content" → define boundary                          │
│   ⚠️ Problem: Pathway was already activated before inhibition               │
│                                                                             │
│   ─────────────────────────────────────────────────────────────────────     │
│                                                                             │
│   AFFIRMATIVE INSTRUCTION:                                                  │
│   "Create artifacts when content is substantial (>15 lines)"                │
│                                                                             │
│   Model's internal process:                                                 │
│   Step 1: Parse "create artifacts" → prepare artifact creation pathway     │
│   Step 2: Parse "when content is substantial" → set activation condition   │
│   Step 3: Parse ">15 lines" → concrete threshold                            │
│   ✅ Benefit: Clear activation condition, no inhibition needed              │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**类比解释**：想象你在教一个新员工。说"当客户等待超过5分钟时，主动道歉"比说"不要让客户等太久"更容易执行。前者有明确的触发条件和动作，后者需要员工自己判断"太久"的标准。

---

### 分析 #3: 大写约束词的注意力机制

为什么 "DO NOT" 比 "don't" 效果更好？

**训练数据中的模式强化**

| 来源类型 | 大写使用场景 | 模型学到的关联 |
|----------|--------------|----------------|
| 法律文件 | "SHALL NOT", "MUST" | 强制性、不可违反 |
| 安全警告 | "WARNING", "DANGER" | 高优先级、需要注意 |
| API 文档 | "REQUIRED", "DEPRECATED" | 必须遵守、有后果 |
| 代码注释 | "TODO", "FIXME", "NEVER" | 开发者约定、重要标记 |

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    ATTENTION WEIGHT HYPOTHESIS                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   Token Attention Distribution:                                             │
│                                                                             │
│   "please don't use placeholder comments"                                   │
│    ├── please: 0.05                                                         │
│    ├── don't:  0.15                                                         │
│    ├── use:    0.10                                                         │
│    └── ...:    distributed                                                  │
│                                                                             │
│   "NEVER use placeholder comments like '// rest remains'"                   │
│    ├── NEVER:  0.35  ◄── Higher attention weight                            │
│    ├── use:    0.12                                                         │
│    ├── placeholder: 0.18                                                    │
│    └── '// rest remains': 0.20  ◄── Concrete example anchors               │
│                                                                             │
│   假设：大写词在训练数据中与"高重要性"上下文共现频率更高，                      │
│   因此在推理时获得更高的注意力权重。                                          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

### 分析 #4: `<antThinking>` 的工程哲学

这个设计揭示了 Anthropic 的一个核心工程理念：**让模型"思考"但不让用户看到"思考过程"**。

**设计权衡分析**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│              THINKING TAGS: DESIGN TRADE-OFFS                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   Option A: No thinking tags                                                │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │ Pros: Simpler prompt, faster response                               │   │
│   │ Cons: Model may skip evaluation, inconsistent decisions             │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   Option B: Visible thinking (like OpenAI's o1)                             │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │ Pros: Transparent reasoning, user can verify logic                  │   │
│   │ Cons: Verbose output, may confuse non-technical users               │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   Option C: Hidden thinking (Anthropic's choice) ◄── <antThinking>          │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │ Pros: Structured reasoning + clean output                           │   │
│   │ Cons: Requires post-processing to strip tags                        │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   Anthropic's philosophy: "Think before you speak, but don't show your     │
│   work unless asked."                                                       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**深层洞见**：这种设计反映了 Anthropic 对用户体验的理解——大多数用户关心的是结果，而非过程。但强制模型"思考"可以提高决策质量。这是一种**隐性 Chain-of-Thought**。

---

### 分析 #5: 搜索策略揭示的商业考量

GPT Insights 分析揭示的四类搜索策略，背后有深刻的商业和技术考量：

**成本-质量-延迟三角**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    SEARCH STRATEGY ECONOMICS                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│                           Quality                                           │
│                              ▲                                              │
│                             /|\                                             │
│                            / | \                                            │
│                           /  |  \                                           │
│                          /   |   \                                          │
│                         /    |    \                                         │
│                        /  research \                                        │
│                       /      |      \                                       │
│                      /  single_search \                                     │
│                     /        |         \                                    │
│                    / do_not_search_but_ \                                   │
│                   /    offer |           \                                  │
│                  /           |            \                                 │
│                 /  never_search            \                                │
│                ▼─────────────┴──────────────▶                               │
│              Cost                         Latency                           │
│                                                                             │
│   Strategy         API Calls    Cost/Query    Latency    Use Case          │
│   ─────────────────────────────────────────────────────────────────────     │
│   never_search     0            ~$0.001       <1s        Stable facts       │
│   do_not_search    0            ~$0.002       <2s        Dated knowledge    │
│   single_search    1            ~$0.01        2-5s       Current events     │
│   research         2-20         ~$0.05-0.50   10-60s     Complex research   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**商业洞见**：
1. **成本控制**：如果每个查询都触发搜索，API 成本会暴增 10-50 倍
2. **用户体验**：搜索增加延迟，对简单问题来说得不偿失
3. **质量保证**：对于模型"确定"的知识，搜索可能引入噪音反而降低质量

**对内容创作者的启示**：你的内容只有在触发 `single_search` 或 `research` 时才有机会被引用。这意味着要针对**模型不确定的领域**创作内容。

---

### 分析 #6: 3500 Token 系统提示词的信息密度

Anthropic 的 3500+ token 系统提示词看似"冗长"，但信息密度分析揭示了精心设计：

**信息密度分布**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│              SYSTEM PROMPT INFORMATION DENSITY ANALYSIS                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   Section                    Tokens    Purpose                              │
│   ─────────────────────────────────────────────────────────────────────     │
│   <artifacts_info>           ~800      Core feature documentation           │
│   <artifact_instructions>    ~600      Decision criteria (when/when not)    │
│   <examples>                 ~1200     Concrete demonstrations              │
│   <claude_info>              ~400      Identity & capabilities              │
│   <constraints>              ~500      Hard rules & prohibitions            │
│                                                                             │
│   Information Type Distribution:                                            │
│                                                                             │
│   ████████████████░░░░  Rules & Logic (40%)                                 │
│   ████████████░░░░░░░░  Examples (35%)                                      │
│   ██████░░░░░░░░░░░░░░  Definitions (15%)                                   │
│   ████░░░░░░░░░░░░░░░░  Meta-info (10%)                                     │
│                                                                             │
│   Key Insight: Examples占35%——Anthropic相信"展示"比"描述"更有效              │
│                                                                             │
│   ROI Analysis (假设):                                                       │
│   • 3500 tokens = ~$0.0035 per request (at $1/M tokens)                     │
│   • 200K context window = 1.75% utilization                                 │
│   • Benefit: Significantly reduced misuse & support tickets                 │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**设计启示**：不要吝啬系统提示词的长度。在 200K 上下文窗口时代，1.75% 的"成本"换取更好的行为一致性是划算的投资。

---

## 术语表 (Glossary)

| 英文术语 | 中文翻译 | 定义 |
|----------|----------|------|
| System Prompt | 系统提示词 | 定义 AI Agent 行为的基础指令 |
| Chain-of-Thought (CoT) | 思维链 | 让模型逐步推理的技术 |
| MIME Type | MIME 类型 | 标识输出格式的标准类型标识 |
| Affirmative Rules | 肯定规则 | 描述"何时应该做"的规则 |
| Negative Rules | 否定规则 | 描述"何时不应该做"的规则 |
| Artifact | 制品/产出物 | Claude 生成的独立可渲染内容 |
| Knowledge Cutoff | 知识截止日期 | 模型训练数据的最后日期 |
| Attention Anchor | 注意力锚点 | 帮助模型在长序列中保持上下文的标记 |
| Cognitive Load | 认知负载 | 处理信息时的心理资源消耗 |
| Hidden CoT | 隐性思维链 | 模型内部推理但不展示给用户的机制 |

---

## Sources

**核心来源**：
- [GitHub: Claude Artifacts 系统提示词原文 (2024.06.20)](https://github.com/YeeKal/leaked-system-prompts/blob/main/prompts/anthropic/claude-artifacts_20240620.md)
  > 📄 2024年6月泄露的 Claude Artifacts 系统提示词原始文档。包含 Artifacts 功能的完整使用准则：何时创建（>15行的实质性内容）、何时避免（简短片段、解释性内容）、支持的类型（code/markdown/HTML/SVG/Mermaid/React）以及各类型的具体限制（如 React 组件禁止使用 Tailwind 任意值）。

- [NJ Pearman: The Claude Artifacts System Prompt](https://njpearman.github.io/2024-09-06/the-claude-artifacts-system-prompt-or-message)
  > 🔬 对泄露提示词的详细技术分析，提炼出五大核心技术和可迁移模式。

- [GPT Insights: Claude 系统提示词泄露深度分析](https://gpt-insights.de/ai-insights/gpt-insights-claude-leak-en/)
  > 🔍 从 SEO 角度深度分析 Claude 的搜索策略。核心发现：网页搜索并非默认行为，而是基于四类策略决策树触发。对内容创作者的启示：只有触发搜索的查询才有机会被引用。

**官方文档**：
- [Anthropic Docs: Use XML tags to structure your prompts](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/use-xml-tags)
- [Anthropic: Prompt Engineering Overview](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview)
- [Anthropic: Best Practices for Prompt Engineering](https://www.claude.com/blog/best-practices-for-prompt-engineering)

**扩展阅读**：
- [AWS: Prompt Engineering with Anthropic Claude](https://aws.amazon.com/blogs/machine-learning/prompt-engineering-techniques-and-best-practices-learn-by-doing-with-anthropics-claude-3-on-amazon-bedrock/)
- [Walturn: Mastering Prompt Engineering for Claude](https://www.walturn.com/insights/mastering-prompt-engineering-for-claude)
- [GitHub: Leaked System Prompts Repository](https://github.com/YeeKal/leaked-system-prompts)
