# Knowledge Asset OS

本仓库的 `vault/` 目录不是“笔记集合”，而是一套 **Knowledge Asset OS（知识资产操作系统）**：把外部信息与个人经验加工成可复用、可审计、可授权的数字资产。系统的目标是让你的知识像代码与财务账本一样：可追溯（traceable）、可复核（verifiable）、可回滚（rollbackable），并且能持续产生复利。

语言与格式遵循 `vault/STYLE.md`：正文中文为主；专业术语首次出现采用 `English（中文解释）`；ASCII 图标签用英文保证对齐；原文引用保留原语言；术语多译时固定一种并登记。

---

## Scope

本系统覆盖三类知识资产：第一类是你历史沉淀的专业知识与方法论（例如工程建模、研究技巧、写作与协作流程）；第二类是你持续摄入的前沿材料（博客、论文、访谈、产品手册、工具教程）；第三类是你在实践中形成的可迁移规则（transferable rules，可迁移规则）与技能化工位（skills，技能工位）设计。

本系统不试图在 Phase 1–2 解决“把所有旧文档一次性迁移进来”的大工程；也不试图绑定某个 SaaS（Notion、NotebookLM 等）作为事实源。系统优先保证：你对资产的主权、证据链、审计与授权能力可持续扩展。

---

## Core Principles

第一原则是 **Sovereignty（主权）**：`vault/` 的开放格式文件（Markdown/YAML/原始附件）是唯一事实源（single source of truth，唯一事实源）。任何外部工具只能作为 UI 与加速器，不能成为唯一存储，否则资产所有权与可迁移性会被工具锁定。具体硬规则见 `vault/CONTRACT.md`。

第二原则是 **Evidence-first（证据优先）**：任何结论必须能指回证据；没有证据的内容只能停留在 `draft`，不得进入 `validated`。在资产层面，Claim（主张）与 Evidence（证据）必须成对存在；“看起来合理”不是审计标准，“可复核引用”才是。

第三原则是 **Non-repudiation（不可抵赖）**：变更必须可追溯。工程实现上以 Git 历史作为可审计的变更链；未来可扩展签名提交（signed commit）、发布签名 tag、以及不可变归档（append-only / WORM）等更强存证机制。

第四原则是 **Least privilege（最小授权）** 与 **Separation of duties（职责分离）**：即使仓库 public，也要在元数据中声明敏感级别（`public/internal/private`），并且把“编辑”“审核”“发布”“归档”的职责边界写进制度，避免协作时出现未经授权的关键变更。

第五原则是 **Accounting（会计化管理）**：知识资产要能盘点与对账。每个资产有稳定 ID、状态（`draft/validated/deprecated`）、最后验证时间与置信度；系统可生成 ledger（账本）去回答“新增了什么、废弃了什么、哪些资产过期、哪些资产被复用”。

---

## Architecture

整个 OS 以“可审计流水线”组织，分四层：摄入与存证、提炼与检验、权威存储、发布与授权。你可以把它想成一条智能制造产线：原料先入库并留存证据，再加工成标准件（cards），再组装成成品（know），最后按权限发布不同版本。

```text
                 +--------------------+
                 |  External Sources  |
                 |  web/video/pdf/... |
                 +----------+---------+
                            |
                            v
+-------------------+   +-------------------+   +-------------------+   +-------------------+
| Ingest & Evidence |-->| Refine to Cards   |-->| Synthesize to Know |-->| Publish & Access  |
| (evidence/)       |   | (cards/)          |   | (know/)            |   | (publish/)        |
+-------------------+   +-------------------+   +-------------------+   +-------------------+
        |                         |                      |                       |
        v                         v                      v                       v
+-------------------+   +-------------------+   +-------------------+   +-------------------+
| Metadata + Hash   |   | Claim-Evidence    |   | Human-readable    |   | Redaction/Scopes  |
| (SCHEMA/STYLE)    |   | + QA (tools/)     |   | reports           |   | + Audit logs      |
+-------------------+   +-------------------+   +-------------------+   +-------------------+
```

系统的“硬控制点”是 `vault/tools/validate_vault.py`：它是最小的质量门槛（quality gate）。未来你可以把它接入 CI（例如 GitHub Actions），把制度变成机器强制执行的契约。

* * *

Object Model (Evidence / Card / Know)
-------------------------------------

Evidence（证据）是“原料与存证对象”，放在 `vault/evidence/`。它必须有对应的元数据 YAML（`EVI-*.yml`），记录来源、采集时间、许可、hash 等信息。Evidence 的原则是 append-only（只追加，不覆盖），因为覆盖会破坏审计链。

Card（卡片）是“原子化资产”，放在 `vault/cards/`。一个 card 表达一个可检验的 Claim（主张），并且必须绑定至少一个 evidence_refs（证据引用）。card 的价值不在于写得长，而在于：它能被跨文档复用、能被验证、能被废弃。card 的元数据字段与正文要求见 `vault/SCHEMA.md`。

Know（知识文档）是“面向阅读的综合报告”，放在 `vault/know/`。Know 的核心约束是：它只能引用现有 card（通过 card id），不能在 know 里偷偷新增未经证据绑定的新 claim。换句话说，Know 是“组装与叙事层”，Card 才是“资产层”。

* * *

Minimal Workflow
----------------

最小工作流是四步闭环：Evidence → Cards → Know → Validate → Commit。你不需要一次做很多；每次摄入只要完成“1 个 evidence + 2 个 cards”，系统就会持续积累复利。

第一步，摄入新材料时先创建 Evidence（证据对象）与元数据（含来源与 hash/时间戳）。第二步，从 Evidence 中抽取 1–3 个可检验的 Claim，每个 Claim 做成一个 Card，并绑定 evidence_refs。第三步，当你需要输出文章/汇报/复盘时，再把多个 Cards 组装成 Know 文档，并只用 card id 做引用。第四步，每次提交前运行 `python vault/tools/validate_vault.py`，把“制度”落实为可执行检查。

* * *

Tooling Roles (Git/Markdown, Claude Code, Notion, NotebookLM)
-------------------------------------------------------------

Git/Markdown 是系统底座，承担主权、版本历史与可迁移性；它是资产的“金库与账本”。Claude Code（agentic coding，具备代理式执行能力的编码助手）承担重复劳动的工位：建文件、填模板、生成初稿、跑校验、生成 ledger 草稿，但它不拥有“最终事实”，最终事实仍在仓库可审计文件里。

Notion 的合理角色是“权限化索引与工作台”：用于浏览、过滤、仪表盘与协作分发，但不作为唯一事实源；与之相关的自动写入必须遵守 `vault/CONTRACT.md` 的主权规则。NotebookLM 的合理角色是“快速理解与结构化衍生品生成器”：适合把多来源材料变成对话、表格、幻灯片等衍生品；这些衍生品应作为 derivatives 回流为 Evidence 或 publish 输出，而不是替代证据本体。

* * *

Glossary (terms and fixed Chinese translations)
-----------------------------------------------

术语多译会导致资产不可维护，因此固定译法并在 `vault/STYLE.md` 术语表登记。此处列出 OS 核心术语（与 STYLE 保持一致或补充）：

| English term | 中文固定译法 | Notes |
| --- | --- | --- |
| Knowledge Asset OS | 知识资产操作系统 | 指整个可审计知识工厂 |
| Evidence | 证据 | 原料与存证对象 |
| Claim | 主张 | 可检验结论，不是摘要 |
| Card | 卡片 | 原子化 claim–evidence 资产 |
| Know doc | 知识文档 | 只组装 cards 的阅读视图 |
| Evidence-first | 证据优先 | 无证据不可 validated |
| Sovereignty | 主权 | 开放格式 + 你控制存储 |
| Non-repudiation | 不可抵赖 | 变更历史可追溯 |
| Least privilege | 最小授权 | 只给必须权限 |
| Accounting / Ledger | 会计化管理 / 账本 | 资产盘点与对账 |

* * *

Non-goals (Phase 1-2 boundaries)
--------------------------------

Phase 1–2 不做全量迁移：不把现有 `_knowledge/` 等目录一次性拆成 cards，也不追求立刻把历史内容全部证据化。Phase 1–2 不做复杂权限系统：仓库保持 public，但通过 `sensitivity` 字段与未来的发布/脱敏策略预留扩展点。Phase 1–2 不引入重型依赖：校验工具保持无外部依赖，优先稳定与可审计。

当你能稳定地把每天的新材料变成 Evidence+Cards，并且每周能产出 1–2 篇 Know 文档时，再进入后续阶段：SOP、治理模型、skills 蓝图、CI 与 ledger 自动化。
