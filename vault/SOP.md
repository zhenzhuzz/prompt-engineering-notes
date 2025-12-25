# SOP: Evidence → Cards → Know

这份 SOP（Standard Operating Procedure，标准操作规程）定义了你每天如何把新材料变成可审计的知识资产：先把来源固化为 Evidence（证据），再提炼为 Card（卡片），最后按需组装成 Know（知识文档）。底层遵循统一契约（见 `vault/CONTRACT.md`、`vault/SCHEMA.md`），上层按来源类型分型（typed assets，分型资产），避免“一套模板揉全宇宙”的膨胀问题。语言与术语规范见 `vault/STYLE.md`。

---

## Daily Workflow (10–30 min)

目标不是写长文，而是每天稳定产出最小资产增量：**1 个 Evidence + 2 张 Cards**。Know 文档可以“周更”，用已有 cards 组装成高密度报告。

建议节奏：先用 5–10 分钟完成 Evidence（含元数据与可复核引用）；再用 10–20 分钟写 2 张 Cards（每张只写一个可检验 claim）；最后 1 分钟跑校验并提交。你已经有最低质量门槛：`python vault/tools/validate_vault.py` 必须 PASS。

```text
Evidence (append-only) -> Cards (claim-evidence) -> Know (assemble) -> Validate -> Commit
```

* * *

Naming & ID Rules (EVI/CARD/KNOW)
---------------------------------

ID 与文件名保持英文/数字，便于跨平台检索与脚本处理。

Evidence：

* 证据内容文件：`vault/evidence/EVI-YYYYMMDD-XXXX.<ext>`
    
* 证据元数据：`vault/evidence/EVI-YYYYMMDD-XXXX.yml`  
    两者的 `id` 必须一致，且文件不可覆盖，只能追加新版本（append-only）。
    

Card：

* 文件：`vault/cards/CARD-YYYYMMDD-XXXX.md`
    
* 每张 card 只包含一个 Claim（主张）。
    

Know：

* 文件：`vault/know/KNOW-YYYYMMDD-<slug>.md`
    
* Know 是组装视图：只能引用 card id，不得新增未经 card/evidence 支撑的主张。
    

序号 `XXXX` 从 `0001` 递增；不追求全球唯一性，只要仓库内唯一即可。

* * *

Status Lifecycle (draft / validated / deprecated)
-------------------------------------------------

`draft`：默认状态。允许不完整，但必须绑定至少一个 evidence_ref（底层要求）。

`validated`：满足“可复核 + 可复用”的状态。进入 validated 的触发条件建议是：你至少在一个真实任务/项目/实践中用过它，或你对证据链做过二次核查（例如回看原文、补齐口径/时间戳、写清适用边界 scope）。

`deprecated`：被证据推翻、适用条件消失、或被更好的 rule 替代。废弃并不等于删除；保留它是为了审计历史与避免重蹈覆辙。deprecated 必须写清“废弃原因”和“替代 card id（若有）”。

* * *

Evidence Capture Rules (append-only, timestamps, hashing)
---------------------------------------------------------

Evidence 的本质是“可审计存证”。你记录它不是为了好看，而是为了未来能回答：这条结论来自哪里？原始语境是什么？是否被断章取义？

统一底层字段遵循 `vault/SCHEMA.md`，并在 Evidence 元数据中新增一个字段（上层分型用）：

* `type`: tech_blog | interview | company_research | other
    

证据引用（evidence_refs）的建议格式（不强制，但要一致）：

* 网页/博客：`EVI-...#url:<...>#quote:<short>` 或 `#sec:<heading>` 或 `#p:<n>`（你可以自己选一种）
    
* 视频/访谈：`EVI-...#ts:12:34-13:10#speaker:<name>`
    
* PDF：`EVI-...#p:12#loc:<row/para>`
    
* 自己的笔记：`EVI-...#loc:<section>`
    

哈希（sha256）用于“内容是否被悄悄改过”的最小校验。对纯文本 note 也可以做 hash；对网页可先存为 markdown/截图/保存为文件再 hash（后续可扩展自动化）。

* * *

Card Writing Rules (claim testability, scope, confidence, evidence_refs)
------------------------------------------------------------------------

Card 是资产最小单位。写 card 时你要像写工程断言（assertion）：可检验、带边界、可追溯。

统一底层字段遵循 `vault/SCHEMA.md`，并在 card 的 YAML front matter 中新增：

* `type`: tech_blog | interview | company_research | other
    

Card 正文的三个 section 标题建议保持英文（因为工具/脚本未来可能依赖）：`Claim`、`Evidence`、`Transferable Rule`。正文内容中文为主，术语首次解释。

写作要点：Claim 要能被反驳（falsifiable，可证伪），不要写“泛泛正确的空话”；scope 写清适用条件（何时有效、对什么规模/团队/系统有效）；confidence 不是情绪，是证据强度的标记；Evidence 段落只做“证据陈述与引用”，不要在这里偷偷扩展新结论；Transferable Rule 要动作化（可执行），最好能让未来的你一眼知道怎么用。

* * *

Know Doc Assembly Rules (ONLY reference card ids; no new claims)
----------------------------------------------------------------

Know 文档是“组装与叙事层”。它可以有结构、有类比、有图表，但它的每个关键结论都必须能落到已存在的 card id 上。

因此：Know 的写作流程不是“从头总结”，而是“先选 cards 再编排”。你可以根据用途选择不同 know 类型（如技术总结、公司调研、访谈提炼），但底线一致：不引入未卡片化的主张。如果发现 know 写到一半需要新主张，正确做法是：先回到 `cards/` 创建新 card，绑定 evidence，再回到 know 引用它。

* * *

Quality Gates
-------------

底层质量门槛（机器强制）：

* `python vault/tools/validate_vault.py` PASS（字段齐全、枚举合法、每张 card 至少 1 个 evidence_ref、每个 evidence yml 合法）。
    

上层质量门槛（人类 checklist，先不自动化）：

* Claim 是否可证伪？是否过于宽泛？
    
* scope 是否明确？是否包含反例或失效条件？
    
* evidence_refs 是否足够精确到“段落/时间戳/页码”？
    
* 是否出现“从证据跳到结论”的断层（逻辑缺口）？
    
* 是否把一个 card 塞进多个 claim（应拆分）？
    

* * *

Common Failure Modes & Fixes
----------------------------

失败模式一：把 Evidence 当成“链接收藏”，没有快照、没有定位。修复：至少落地一份本地 evidence 文件（note/transcript/保存的网页文本），并在 evidence_refs 里写清定位（page/ts/section）。

失败模式二：card 写成“长篇总结”，里面混了多个结论。修复：一张 card 只保留一个 Claim，其余拆成多张 cards，并分别绑定 evidence_refs。

失败模式三：Know 写嗨了，开始新增未经证据的主张。修复：停下来先补 card，再回到 know 引用 card id。

失败模式四：type 分型失效，所有内容又回到“万能模板”。修复：每次摄入先确定 `type`，并用对应模板创建 evidence/card；如果出现新类型，新增模板而不是扩展旧模板字段。

* * *

Review & Release (optional for public repo)
-------------------------------------------

当前仓库 public，因此默认把 `sensitivity` 字段作为“自律型授权标签”。当你未来需要更严格的授权与审计，可采用“私有金库 + 公共发布镜像”的发布策略：`publish/` 输出脱敏版本；ledger 记录发布内容与变更摘要；对外只发布 publish 结果而非完整证据链。

在 Phase 3 结束前，你的最小习惯是：每次提交前跑 validator；每周挑选 1 次把若干 cards 组装成 know；每月把关键 cards 从 draft 提升到 validated 或标记 deprecated。
