# Governance: Audit / Authorization / Release

本文件定义 `vault/` 的治理规则：如何做到可审核（audit）、可授权（authorization）、可审计（accounting/traceability），以及在 public 仓库里如何控制发布风险。它的目标不是增加流程，而是把“发布权、审批权、执行权”拆开，让系统长期稳定。

语言与术语规范遵循 `vault/STYLE.md`。底层对象与字段规范遵循 `vault/SCHEMA.md`；工作流程遵循 `vault/SOP.md`。

## Roles & Responsibilities (Human vs Claude Code)

Human（你）是资产所有者与发布者，负责最终批准与对外责任。Claude Code 是执行员（executor，执行工位），负责创建/修改文件、运行校验、生成报告与本地提交，但默认不做“对外发布动作”。

职责边界的核心规则：Claude Code 默认只做到 **本地 commit + 验证报告**；**push/merge 由 Human 执行**。原因不是省事，而是把“发布”当作授权动作：public repo 一旦 push，就等于公开发布，风险与不可逆性更高。

## Change Control (branch, commit, review, push/merge)

分支策略：所有结构性变更（新增 type、调整 schema、改 validator、增加模板）必须在 feature 分支完成（例如 `vault-v1`），保持可回滚与可审计。

提交策略：commit message 要描述“做了什么 + 为什么”，尤其是规则变更（schema/validator/governance）要写清意图。提交前必须运行 `python vault/tools/validate_vault.py`，并在 commit 前后保存输出（最少保留在终端记录即可，未来可扩展写入 ledger）。

Review 策略：push 前先 review diff。即使你不走 GitHub PR，也要把“review”当作发布门槛。对 public repo，推荐的发布动作是：先 push 分支，再由 Human 选择是否 merge 到 main（或是否开 PR）。

Release 原则：publish/ 是可重建的输出层（derivatives），不是事实源。事实源永远在 `vault/` 的 evidence/cards/know。

## Multi-agent Collaboration Rules

多 agent 的冲突，本质是“并发写同一块状态”导致的竞态（race condition，竞态条件）。治理策略是减少写冲突面，而不是祈祷模型自觉。

第一条规则：以 **Card（最小资产单元）为并发边界**。允许多 agent 同时新增 cards，但尽量避免同时重写同一张 card 或同一篇 know。

第二条规则：任何“重写型操作”都必须先缩小作用域：优先局部编辑而非全文件重写；如果必须重写，先复制为新文件并标记 deprecated 链接，而不是覆盖原文件。

第三条规则：并发前做“文件锁式协商”：同一时间只让一个 agent 改 schema/validator/governance 这类制度文件；其他 agent 只新增 evidence/cards。换句话说：制度文件是“单写多读”，资产卡片是“多写可合并”。

第四条规则：冲突处理优先级：先保证 evidence 不丢（append-only），再保证 cards 的 claim 不被混淆，最后再处理 know 的叙事。

## Testing Strategy (A/B isolation first)

当 Claude Code 为了定位问题而进行“无效测试”时，根因通常是：测试空间太大，变量太多，没有隔离策略。默认策略应是 A/B isolation（对照隔离）：一次只切一个变量，做二分定位（binary search，二分排查）。

工程化规则：遇到不确定故障时，先用最小复现（MR, minimal reproduction）构造 A/B：A=当前失败路径，B=只改一个变量（例如路径转换、编码、shell、工作目录、输入文件），看失败是否随变量迁移。只有当 A/B 把问题缩到一个组件/函数后，才跑全量测试套件。

测试的“禁忌”：在未隔离前做大规模“穷举式测试”，既耗时也会产生噪音结论。把 A/B 结果写进 debug_playbook 类型 evidence，沉淀成可复用的排查卡片。

## Sensitive Data & Public Repo Rules

本仓库为 public，因此 `sensitivity` 字段是硬要求（即便目前只是标签）。默认一切为 `public`，但凡涉及私密信息、内部系统路径、token、未公开商业信息，必须标为 `internal` 或 `private`，并且在写入前做脱敏。

public repo 的安全底线：不把密钥、个人隐私、内部链接与可被滥用的信息写入仓库。若确需记录，使用抽象化描述（例如“某 CI 服务”“某内部端点”），把可识别信息移出仓库（未来可扩展私有 vault 或加密目录）。

## Incident Recording Policy (debug_playbook workflow)

任何一次“踩坑/故障/协作冲突/编码陷阱”都应该以 `type=debug_playbook` 进入资产体系，因为它最容易复发、也最值钱。

最小记录标准（Evidence）：环境、症状、复现步骤、预期 vs 实际、根因假设、修复、预防。然后至少提炼两张 Cards：一张 Fix（修复动作），一张 Prevention（防复发护栏或 A/B 排查策略）。Cards 的 Claim 必须可证伪，scope 写清触发条件，evidence_refs 精确定位到 evidence 的 section。

## Glossary

| English term | 中文固定译法 | Notes |
|---|---|---|
| Governance | 治理 | 制度与边界 |
| Authorization | 授权 | 谁能发布/合并 |
| Audit / Traceability | 审核/可追溯 | 能回答“谁改了什么” |
| Non-repudiation | 不可抵赖 | 变更历史可审计 |
| Race condition | 竞态条件 | 并发写导致冲突 |
| A/B isolation | 对照隔离 | 一次只改一个变量 |
| MR (minimal reproduction) | 最小复现 | 构造可定位实验 |
