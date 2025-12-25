# Playbook: Learning Intake（学习摄入）→ 概念卡片 → 最小学习路径

本 Playbook 用于"我看到了很多名词，但我缺最小概念模型"的高频场景。我们统一用 `type: tech_blog` 来组织这类学习资产，把它当作 tech primer（技术入门简报）：即使最初证据只是你自己的名词清单，也先落地为可审计 Evidence，再提炼为可迁移 Cards。证据来源形态用 `source_type: note` 标注，后续若补充 web search，再把外部 sources 追加进 evidence（或新建 evidence）。

适用规范：字段与结构遵循 `vault/SCHEMA.md`；日常流程遵循 `vault/SOP.md`；语言与术语遵循 `vault/STYLE.md`。

```text
Term list / curiosity
        |
        v
Evidence (type=tech_blog, source_type=note)
        |
        v
Cards: Concept / Boundary / Next-step
        |
        v
(Optional) web search -> add sources -> refine cards
        |
        v
(When needed) Know doc assembled from cards
```

When to use（and when NOT to）
----------------------------

适用：你只拿到"名词 + 场景上下文"，目标是快速建立词汇表、分层概念图、最小学习路径，以及决定下一步该深入哪些点。

不适用：你已经有完整原文/转录并需要逐段引用时（那更像"全文提炼"，证据引用粒度应更细）；或者你要做严肃选型/写技术方案（那需要补充外部 sources 与可复核证据）。

10-minute Workflow（per input）
-----------------------------

第一步（2 分钟）：创建 Evidence（证据笔记）。把名词清单写进去，补三件事：你的动机（为什么现在看它）、你的背景约束（你已懂什么/不懂什么）、你想回答的 3 个问题（这会直接决定 cards）。

第二步（6 分钟）：写两到三张 Cards（每天固定额度即可）。每张 card 只回答一个问题，优先产出"能指导行动"的卡：概念是什么、什么时候该学/用、边界是什么、最小学习路径是什么。

第三步（2 分钟）：触发 web search 的"开放问题清单"。把你不确定、且值得查证的点写进 card 的 `Evidence` 或 `Transferable Rule` 末尾，用 "Open questions:" 明确列出。你可以立刻查，也可以集中到晚上/周末查；查完后把 sources 追加进 evidence 元数据（append-only 方式新增 evidence 版本，或在 notes 里记录补充来源）。

Evidence template（名词清单 + 上下文触发）
-------------------------------

建议 Evidence 元数据组合（你坚持统一用 tech_blog 时就这么写）：

* `type: tech_blog`

* `source_type: note`

* `source: "term list from <where> (e.g., video description)"`

* `notes:` 写清动机、约束、问题

* `license: unknown`（因为不是复制外部大段内容）

* `sha256:` 若落地了 note 文件就算一下（可选）


Evidence 笔记正文建议结构（简短即可）：

* Context：我为什么看到了这串名词？我现在要解决什么问题？

* Term list：名词清单（可分组：runtime / data / infra / tooling）

* My constraints：我已有基础、时间预算、目标（比如"只需建立最小模型"）

* 3 Questions：我最想回答的三个问题

* Artifacts：如果有链接/截图/时间戳，写在这里（少量引用即可）


Card types（Concept / Boundary / Next-step）
------------------------------------------

建议固定三类卡片（用 tags 区分，不必新增 type）：

Concept card（概念卡）：回答 "X 是什么、解决什么问题、和相邻概念边界在哪"。Claim 应是可证伪断言，不是百科式堆砌。

Boundary card（边界卡）：回答 "X 何时不适用、常见误用是什么、失败信号是什么"。这类卡片最能防止"学了一堆名词但不会用"。

Next-step card（路径卡）：回答 "对我这种背景，最小学习路径是什么（最小可行实验/最小项目）"。路径卡优先给动作，而不是给资料链接列表。

Web search trigger list（哪些问题值得查）
--------------------------------

当你碰到以下情况，应该触发 web search 并补 sources（而不是凭感觉写结论）：

* 名词之间关系不确定（例如 Kafka vs RabbitMQ 的边界到底是什么）

* 有明显版本/实现差异（例如 MySQL vs PostgreSQL 的关键差异随版本变化）

* 有性能/一致性/容错的硬指标（需要可引用来源）

* 有"最佳实践"但你想知道适用条件（避免把经验当真理）


做法：先把问题写进 card 的 Open questions，再集中查证；查证结果作为新 evidence（或在 evidence notes 追加 sources），然后把 card 从 `draft` 提升为 `validated`。

Output: When to write a Know doc（何时组装成长文）
-----------------------------------------

当你满足任一条件才建议写 Know（知识文档）：

* 同主题累计 ≥ 10 张 cards（说明知识网络成形）

* 你要做一次对外输出（分享/讲解/写文）

* 你要做一次真实决策（技术选型/学习计划/项目设计）


Know 的底线：只引用 card id，不新增未经证据化的主张。

Example（tiny）：后端技术名词清单如何 10 分钟消化
--------------------------------

输入：视频简介里出现 Spring/Docker/Redis/MySQL/K8s/Nginx/Kafka/ES/gRPC/Jenkins…

Evidence（type=tech_blog, source_type=note）：先写 "我当前只略懂 Docker/MySQL/Git；目标是建立最小分层模型"。

Cards（2–3 张就够）：

* Concept card：后端技术栈最小分层（Runtime / Data / Infra / Delivery），每层列 2–3 个代表工具，写清"解决的根问题"。

* Boundary card：哪些名词对新手是"先不碰也不影响主线"的（例如分布式协调/服务发现），触发条件是什么。

* Next-step card：最小学习路径（先容器与数据库→再缓存与消息→再编排与可观测），并写一个最小实验（例如 Docker + MySQL + 一个简单 API + 压测观察缓存效果）。
