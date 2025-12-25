# 契约 (Vault Contract)

> 知识资产库的硬规则。可执行，非哲学。

**写作规范:** 参见 [STYLE.md](STYLE.md)

---

## 1. Sovereignty（主权）

`vault/` 是**唯一权威来源**。

- Notion、NotebookLM 等工具仅为可选 UI
- 如有冲突，以 `vault/` 为准
- 所有权威内容存放于此

## 2. Evidence-first（证据优先）

每个 Claim（主张）**必须**引用 Evidence（证据）。

- 无证据 → `status` 必须为 `draft`
- Card 必须包含至少一条 `evidence_ref`
- Evidence 必须先于 Card 存在

## 3. Non-repudiation（不可否认性）

变更可追溯、可验证。

- 所有变更通过 git commit 记录
- 关键资产必须可审查（diff 友好格式）
- `vault/publish/` 产物可从源重建

## 4. Least Privilege（最小权限 / 敏感度分级）

即使在公开仓库，也需分级所有内容。

| 级别 | 说明 |
|------|------|
| `public` | 可公开分享 |
| `internal` | 仅供团队/个人使用 |
| `private` | 包含敏感信息 |

每张 Card 和 Evidence 都有 `sensitivity` 字段。

## 5. Accounting（记账）

资产可识别、可追踪。

- 稳定 ID：`CARD-YYYYMMDD-XXXX`、`EVI-YYYYMMDD-XXXX`
- 状态生命周期：`draft` → `validated` → `deprecated`
- 可列出所有资产并验证其状态
- 运行 `python vault/tools/validate_vault.py` 审计

---

## 执行

- 验证脚本在提交前检查合规性
- Pre-commit hooks（可选）可自动化检查
- 违规 = 合并前必须修复
