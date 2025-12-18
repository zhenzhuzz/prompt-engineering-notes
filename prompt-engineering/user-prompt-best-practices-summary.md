# User Prompt 最佳实践：从 System Prompt 借鉴的技巧

> **Source**: 基于 Claude System Prompt Engineering 文档的用户提示词优化指南
> **Purpose**: 让 User Prompt 更高效、更清晰、更省 Token
> **Core Insight**: 系统提示词的结构化技巧同样适用于用户提示词

## 🚀 常用 Git 操作快捷跳转

| 操作 | 跳转链接 |
|------|----------|
| Git Commit + Push | [示例 6: run git commit push](#示例-6-run-git-commit-push) |
| 创建 PR | [示例 7: create pr in simplified chinese](#示例-7-create-pr-in-simplified-chinese) |
| 新建分支 + 提交 | [示例 8: create branch and commit push](#示例-8-create-branch-and-commit-push) |
| 切换并拉取分支 | [示例 9: switch to main and pull](#示例-9-switch-to-main-and-pull) |

---

## The Essence

```
┌─────────────────────────────────────────────────────────────────────────────┐
│       USER PROMPT 优化 = 结构化 + 肯定式 + 明确期望                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   FROM SYSTEM PROMPT PATTERNS:                                              │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                                                                     │   │
│   │   1. 轻量 XML 标签     用 <task> <context> <output> 组织内容        │   │
│   │   2. 肯定式表达        "请做 X" 优于 "不要做 Y"                     │   │
│   │   3. 明确输出格式      提前说明期望的结果形式                        │   │
│   │   4. 分层提供信息      背景 → 任务 → 约束 → 输出                    │   │
│   │                                                                     │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   TOKEN 节省策略：                                                          │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                                                                     │   │
│   │   ❌ 冗长: "我想问一下，能不能帮我解释一下什么是..."               │   │
│   │   ✅ 简洁: "<task>解释 X</task>"                                    │   │
│   │                                                                     │   │
│   │   ❌ 模糊: "帮我改进一下这个"                                       │   │
│   │   ✅ 明确: "<task>重构</task><output>保持接口不变</output>"         │   │
│   │                                                                     │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 旧范式 vs 新范式

### 旧范式特点（你的自然表达习惯）

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         旧范式特征分析                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   1. "根据 @file" 开头                                                      │
│      → 背景和任务混在一起                                                   │
│                                                                             │
│   2. 一长段话描述                                                           │
│      → 背景 + 任务 + 约束 + 期望 混合                                       │
│                                                                             │
│   3. 中英文混用                                                             │
│      → "Save tokens", "Internal Thinking"                                   │
│                                                                             │
│   4. 附带任务用自然语言连接                                                 │
│      → "顺便...", "另外...", "然后..."                                      │
│                                                                             │
│   5. 输出要求在末尾                                                         │
│      → "总结到 markdown 里"                                                 │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 新范式核心：标签分区

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         新范式标签体系                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   <context>      参考文件、背景信息                                         │
│   <my_thinking>  你的假设、担心、隐含意图（可选）                           │
│   <task>         核心任务，动词开头                                         │
│   <requirements> 约束条件、必须满足的要求                                   │
│   <constraints>  限制条件、不考虑的因素                                     │
│   <output>       输出格式、语言、结构                                       │
│   <also>         附带任务（替代"顺便"）                                     │
│                                                                             │
│   使用原则：                                                                │
│   • 简单问题：无需标签，直接问                                              │
│   • 中等任务：<context> + <task> + <output>                                 │
│   • 复杂任务：全套标签                                                      │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Before/After 对比

### 示例 1: 概念解释类提示词

**Before (55 tokens)**:
```
@claude-system-prompt-engineering-summary.md , 什么是artifacts？
什么是artifacts prompt？ 什么是MIME？
```

**After (38 tokens, -31%)**:
```xml
<context>参考 @claude-system-prompt-engineering-summary.md</context>

<task>解释以下概念</task>
- artifacts
- artifacts prompt
- MIME

<output>用中文，每个概念配 ASCII 图解</output>
```

**为什么更好**：
- `<context>` 明确参考来源
- `<task>` 动词开头，明确动作
- 列表形式清晰
- `<output>` 预设期望格式

---

### 示例 2: 复杂任务类提示词

**Before (约 180 tokens)**:
```
根据 @claude-system-prompt-engineering-summary.md 的建议，我以后在和你交流时
除了说明我的需求并且给你提供相应的信息我还可以做哪些养成的习惯使得和给你的
prompt更加的高效让你能理解清楚呢我说的是 user prompt能够借鉴 system prompt
的一些东西当然我并不想全部写一大堆插面 但是有一些东西应该可以借鉴 比如少量
的XML或者 tabs。

你可以就以这一次这些prompt为例作为一次user prompt的示例，然后告诉我应该如
何改进注意提到的Internal Thinking Process 还有 Outputs，并且能Save tokens
and more affirmative。总结到一个markdown文档里
```

**After (约 85 tokens, -53%)**:
```xml
<context>
参考 @claude-system-prompt-engineering-summary.md
示例: 本次对话中我的所有提示词
</context>

<task>
总结 User Prompt 最佳实践，借鉴 System Prompt 技巧
</task>

<requirements>
- 轻量级 XML/结构化（非完整 system prompt）
- 肯定式表达优先
- Token 优化策略
- Before/After 对比
</requirements>

<output>
Markdown 文档，包含:
1. 原始提示词分析
2. 改进后版本
3. 可迁移的规则
</output>
```

**为什么更好**：
| 方面 | Before | After |
|------|--------|-------|
| **结构** | 一段话，需要解析 | XML 标签分区 |
| **任务** | 埋在描述中 | `<task>` 开门见山 |
| **约束** | 散落各处 | `<requirements>` 集中 |
| **输出** | 末尾提及 | `<output>` 明确结构 |
| **Token** | ~180 | ~85 (-53%) |

---

### 示例 3: 多任务 + 附带请求

**Before (旧范式)**:
```
根据 @gemini-system-prompt.md 的系统提示词对比一下 @claude-system-prompt.md
这两个有什么差异呢？顺便帮我更新一下之前那个提示词工程的总结文档，把这个
对比加进去
```

**After (新范式)**:
```xml
<context>
@gemini-system-prompt.md
@claude-system-prompt.md
</context>

<task>对比两个系统提示词的设计差异</task>

<output>
- 结构对比表格
- 各自优势分析
- 适用场景建议
</output>

<also>更新 @claude-system-prompt-engineering-summary.md，添加对比结果</also>
```

**改进点**:
| 旧范式问题 | 新范式解决 |
|-----------|-----------|
| "顺便"连接附带任务 | `<also>` 标签明确分离 |
| 任务埋在长句中 | `<task>` 单独一行 |
| 输出格式未说明 | `<output>` 预设结构 |

---

### 示例 4: 带假设/担心的复杂任务

**Before (旧范式)**:
```
我想了解一下 NotebookLM 的功能，但我不确定你是不是有最新的信息，
因为这个产品更新很快。我主要想知道它和 ChatGPT 有什么区别，
特别是在处理文档方面。如果你不确定的话可以搜索一下。
最后总结成一个 markdown 文档，格式参考我之前的那些总结文档。
```

**After (新范式)**:
```xml
<my_thinking>
产品更新快，需要最新信息
重点关注：文档处理能力对比
</my_thinking>

<task>
1. 搜索 NotebookLM 最新功能
2. 对比 NotebookLM vs ChatGPT（文档处理）
</task>

<output>
KNOW 格式 markdown，参考 @claude-system-prompt-engineering-summary.md
</output>
```

**改进点**:
| 旧范式问题 | 新范式解决 |
|-----------|-----------|
| 担心/假设散落在描述中 | `<my_thinking>` 集中表达 |
| "如果...可以..."条件句 | 任务列表直接写搜索 |
| "参考之前的"模糊引用 | @ 精确引用模板文件 |

---

### 示例 5: 文档更新任务

**Before (旧范式)**:
```
你清楚了我 before 的 prompt 范式，目标文件是 @user-prompt-best-practices-summary.md
帮我整理一下我旧 prompt 范式和建议新范式的符合我表达习惯的 prompt 模板，
少数几个模板即可，尽量多的 tags 满足我不同的需求，更新 markdown。
还有更新 Before/After Prompt 核心差异。思考我的表达，找到更符合我的表达的
新版 prompt 模板并单个模板涵盖多种可能，修改 markdown。
```

**After (新范式)**:
```xml
<context>
1. 你已了解我的旧 prompt 范式
2. 目标文件: @user-prompt-best-practices-summary.md
</context>

<task>
1. 整理旧范式 → 新范式对照模板
2. 更新 Before/After 核心差异
</task>

<requirements>
- 少量模板，多 tags 覆盖
- 符合我的表达习惯
</requirements>

<output>直接修改 markdown</output>
```

**改进点**:
| 旧范式问题 | 新范式解决 |
|-----------|-----------|
| context 和 task 混在开头 | `<context>` 单独列出前提 |
| 多个任务用逗号连接 | `<task>` 编号列表 |
| 要求散落各处 | `<requirements>` 集中 |
| 重复说明"修改 markdown" | `<output>` 说一次 |

---

### 示例 6: run git commit push

**Before (旧范式)**:
```
run git commit push
```

**After (新范式)**:
```xml
<task>
1. git add 相关文件
2. git commit（生成提交信息）
3. git push
</task>

<requirements>
- commit title 和 description 用简体中文
- 详细汇总所有更改（便于日后回顾）
- 鼓励用详细的文字描述更改分析和总结，用详细的ASCII diagram加上各组件描述布局、逻辑、结构树、流程等, 用icon增加趣味性和美观度
</requirements>
```

**改进点**:
| 旧范式问题 | 新范式解决 |
|-----------|-----------|
| 三个动作挤在一行 | `<task>` 编号列表分步 |
| 缺少 git add 步骤 | 补全完整流程 |
| 无法知道 commit 什么 | 明确期望（生成提交信息）|


---

### 示例 7: create pr in simplified chinese

**Before (旧范式)**:
```
create pr and write title and body in details for all recent changes in simplified chinese
```

**After (新范式)**:
```xml
<task>创建新的 Pull Request</task>

<requirements>
- 标题和描述用简体中文
- 详细描述所有最近的更改
- 鼓励用详细的文字描述更改分析和总结，用详细的ASCII diagram加上各组件描述布局、逻辑、结构树、流程等, 用icon增加趣味性和美观度
</requirements>
```

**改进点**:
| 旧范式问题 | 新范式解决 |
|-----------|-----------|
| 英文指令混杂中文要求 | 统一用中文表达 |
| "in details" 位置模糊 | `<requirements>` 明确"详细描述" |
| 一句话塞太多信息 | 任务和要求分离 |

---

### 示例 8: create branch and commit push

**Before (旧范式)**:
```
create new branch (name with "some of my ideas are shown here, like today's date / xxx features"), give me the new branch name ideas first before continue
switch to this new branch, and run git add commit push
```

**After (新范式)**:
```xml
<task>
1. 创建新分支
2. 提供 3 个分支命名建议（格式: xxx/xxxxx-YYYY-MM-DD）
3. 等我确认后再继续
4. 创建并切换到新分支
5. git add → commit → push
</task>

<requirements>
- 分支名包含日期
- 先确认再执行
</requirements>

<branch-name-context>
我今天的工作是收集第四五六个维度的评分的小红书视频素材
</branch-name-context>
```

**改进点**:
| 旧范式问题 | 新范式解决 |
|-----------|-----------|
| 括号内夹杂想法说明 | `<requirements>` 明确约束 |
| "give me...first before" 冗长 | 任务列表步骤 2 简洁表达 |
| 多个动作一句话 | 编号列表分步 |

---

### 示例 9: switch to main and pull

**Before (旧范式)**:
```
git pull main and switch to main
```

**After (新范式)**:
```xml
<task>
1. git checkout main
2. git pull origin main
</task>
```

**或更简洁**:
```
切换到 main 并拉取最新代码
```

**改进点**:
| 旧范式问题 | 新范式解决 |
|-----------|-----------|
| 顺序错误（应先 checkout 再 pull）| 编号列表纠正顺序 |
| "and" 连接模糊 | 步骤明确先后 |

**注意**: 对于简单 git 操作，最简版即可，无需 XML 标签。

---

## 五个可迁移的规则

### 规则 1: 轻量 XML 标签组织

**模式**:
```xml
<context>背景/参考资料</context>
<task>要做什么</task>
<requirements>约束条件</requirements>
<output>期望输出格式</output>
```

**何时使用**:
- 任务有多个组成部分
- 需要明确输出格式
- 想减少歧义

**何时不用**:
- 简单单一问题 ("Python 如何读文件?")
- 纯对话式交流

---

### 规则 2: 肯定式优先于否定式

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    AFFIRMATIVE-FIRST PATTERN                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ❌ NEGATIVE (模型需要推断你想要什么):                                     │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │   "不要写太长"                                                      │   │
│   │   "别用复杂的术语"                                                  │   │
│   │   "不需要解释基础概念"                                              │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   ✅ AFFIRMATIVE (直接说明期望):                                            │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │   "控制在 200 字内"                                                 │   │
│   │   "用通俗语言解释"                                                  │   │
│   │   "假设读者已了解 X 基础"                                           │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   为什么有效:                                                               │
│   • 模型更容易遵循 "做 X" 而非 "别做 Y"                                     │
│   • 减少歧义（"不要太长" 是多长？）                                         │
│   • Token 更少（否定式往往需要更多解释）                                    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

### 规则 3: 明确输出期望

**Before**:
```
帮我总结一下这篇文章
```

**After**:
```xml
<task>总结这篇文章</task>
<output>
- 3 个核心观点
- 每点一句话
- 中文
</output>
```

**输出格式常用模板**:
| 需求 | 写法 |
|------|------|
| 长度限制 | `<output>200 字内</output>` |
| 格式要求 | `<output>Markdown 表格</output>` |
| 语言选择 | `<output>中英双语</output>` |
| 结构要求 | `<output>分 3 部分: 背景/分析/结论</output>` |

---

### 规则 4: @ 引用 + 简洁描述

**在 Claude Code / IDE 中**:

```
❌ 冗长:
"我想让你看一下我之前创建的那个关于系统提示词工程的文档，
就是在 prompt-engineering 文件夹下面的那个 md 文件..."

✅ 简洁:
"参考 @claude-system-prompt-engineering-summary.md，解释 X"
```

**@ 引用的优势**:
- 精确定位文件
- 自动加载上下文
- 节省描述文件位置的 token

---

### 规则 5: 分步骤任务用列表

**Before**:
```
帮我先读一下这个文件然后找出里面的主要概念接着用中文解释
最后给我画个图总结一下
```

**After**:
```xml
<task>
1. 读取 @file.md
2. 提取核心概念
3. 中文解释每个概念
4. ASCII 图总结关系
</task>
```

**为什么列表更好**:
- 模型按顺序执行
- 容易检查是否遗漏
- 可以中途暂停/继续

---

## 你的新范式模板

基于你的表达习惯，以下模板覆盖大多数场景：

### 万能模板（完整版）

```xml
<my_thinking>
[可选] 我的假设/担心/隐含意图
</my_thinking>

<context>
[可选] @file1 @file2
[可选] 前提条件/已知信息
</context>

<task>
[必填] 动词开头，核心任务
1. 步骤一
2. 步骤二
</task>

<requirements>
[可选] 必须满足的约束
- 约束 1
- 约束 2
</requirements>

<output>
[推荐] 期望格式/语言/结构
</output>

<also>
[可选] 附带任务（替代"顺便"）
</also>
```

### 简化版（日常使用）

```xml
<context>@file</context>
<task>动词 + 对象</task>
<output>格式要求</output>
```

### 最简版（单一任务）

```
解释 @file 中的 X 概念，用中文 + ASCII 图
```

---

## 使用决策树

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         何时使用什么模板？                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   问题复杂度判断：                                                          │
│                                                                             │
│   单一问题？ ──Yes──→ 最简版（无标签）                                      │
│       │                "解释 X 概念"                                        │
│       No                                                                    │
│       ↓                                                                     │
│   需要特定输出？ ──Yes──→ 简化版                                            │
│       │                   <context> + <task> + <output>                     │
│       No                                                                    │
│       ↓                                                                     │
│   有附带任务？ ──Yes──→ 加 <also>                                           │
│       │                                                                     │
│       No                                                                    │
│       ↓                                                                     │
│   容易被误解？ ──Yes──→ 加 <my_thinking>                                    │
│       │                                                                     │
│       No                                                                    │
│       ↓                                                                     │
│   有硬性约束？ ──Yes──→ 加 <requirements>/<constraints>                     │
│                                                                             │
│   最终：组合所需标签 → 万能模板                                             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Key Takeaways

### Token 节省技巧
1. **用 @ 引用替代文件描述** — 自动加载，省去位置说明
2. **列表替代长句** — 结构清晰，减少连接词
3. **XML 标签替代解释** — `<task>` 比 "我想让你..." 更短
4. **肯定式替代否定式** — "200 字内" 比 "不要太长" 更精确

### 清晰度提升技巧
1. **动词开头** — "总结/解释/实现" 而非 "帮我看看..."
2. **明确输出** — 提前告知期望格式
3. **分层信息** — context → task → requirements → output
4. **提供 thinking** — 复杂任务时说明你的假设

### 何时使用结构化
| 场景 | 建议 |
|------|------|
| 简单问答 | 直接提问，无需 XML |
| 多步骤任务 | 使用列表或 `<task>` |
| 需要特定输出 | 使用 `<output>` |
| 容易误解的任务 | 使用 `<my_thinking>` |
| 多文件参考 | 使用 `<context>` + @ 引用 |

---

### 示例 10: 复杂产品设计任务

**Before (旧范式，~320 tokens)**:
```xml
<context>
@TENNIS_FOREHAND_RUBRIC_V3.md
</context>

<task>
1. 根据Tennis Forehand Rubric V3 Markdown File设计一个Web App发布到我们的Co-host上
这个Web App可以给用户上传一段本地的影片然后循环播放 然后这个Web App的主要功能
就是对这个影片进行打分根据这个Rub Down定义的评分标准我会找不同的人去新建一份
打分的表然后需要设计一些 Meta Data 原数据给这些打分的表用来区分打分者的一些信息
比如说打分表的ID打分者的姓名还有网球的水平这些然后设计一个合理的引导打分过程
让任何一个人 并不需要是网球专业运动员都能够根据打分表以及打分系统的引导可以对
视频中的网球正手动作进行打分然后在打分结束之后生成当前打分用户的 报告 以JSON
的格式保存到本地。
</task>

<requirement>
1. 评分过程和系统的引导很重要，时刻想着是给真人用户使用的评分过程。
2. 界面美观有交互性
3. 先把这个webapp以及评分引导系统的设计，参照 @_templates/qwORG_编写指南.md
写成ORG文档，鼓励 ASCII diagram
4. make an implementation plan and do it step by step.
</requirement>

<main task>
@user-prompt-best-practices-summary.md ，评估我这一次prompt的写作效果，
并作为一个案例加到文档中。
</main task>
```

**After (新范式，~150 tokens, -53%)**:
```xml
<context>
@TENNIS_FOREHAND_RUBRIC_V3.md
@_templates/qwORG_编写指南.md
</context>

<task>
设计网球正手评分 Web App：
1. 视频上传 + 循环播放功能
2. 评分表元数据设计（ID、姓名、网球水平）
3. 引导式评分流程（面向非专业用户）
4. JSON 格式评分报告导出
</task>

<requirements>
- 界面美观、交互友好
- 评分引导对非专业人员友好
- 分步实现计划
</requirements>

<output>
ORG 文档，包含 ASCII 架构图
</output>

<also>
评估本次 prompt，加入 @user-prompt-best-practices-summary.md 作为案例
</also>
```

**改进点**:
| 旧范式问题 | 新范式解决 |
|-----------|-----------|
| `<task>` 内一大段话混合多个子任务 | 编号列表拆分 4 个明确步骤 |
| 缺少 `<output>` 标签 | 明确输出格式（ORG 文档 + ASCII 图）|
| `<main task>` 非标准标签 | 用 `<also>` 表达附带任务 |
| `<requirement>` 中英混用 | 统一中文表达 |
| 描述性语言过多 | 关键词提炼（"引导式评分流程"）|
| 所有 @ 引用散落各处 | `<context>` 集中管理 |

**评分**：⭐⭐⭐⭐☆ (4/5) — 已掌握核心结构，可进一步精简

---

## Sources

- [claude-system-prompt-engineering-summary.md](claude-system-prompt-engineering-summary.md) - System Prompt 模式参考
- [Anthropic: Use XML tags to structure prompts](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/use-xml-tags)
- [parahelp-prompt-design-summary.md](parahelp-prompt-design-summary.md) - 生产级 Prompt 技巧
