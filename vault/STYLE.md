# 写作规范 (Style Guide)

> 中英文混排规范，确保文档一致性和可读性。

---

## 语言标准

| 元素 | 语言 | 示例 |
|------|------|------|
| 正文说明 | 中文 | 每张卡片必须引用至少一条证据 |
| 技术术语（首次） | `English（中文）` | Evidence（证据） |
| 技术术语（后续） | English | Evidence |
| YAML 键名 | English | `id`, `status`, `evidence_refs` |
| 枚举值 | English | `draft`, `validated`, `public` |
| ID 标识符 | English/数字 | `CARD-20251222-0001` |
| 文件名 | English | `card.template.md` |
| ASCII 图表标签 | English | `Evidence → Cards → Know` |

---

## 核心规则

1. **中文为主** — 说明性文字用中文
2. **保留英文术语** — 技术名词保持英文，首次出现加中文注释
3. **ID/键名不变** — YAML 键名、枚举值、文件名保持英文
4. **引用保持原文** — 外部引用保持原语言

---

## 术语表 (Glossary)

| English | 中文 | 说明 |
|---------|------|------|
| Evidence | 证据 | 原始来源材料（网页、视频、PDF、笔记等） |
| Claim | 主张 | Card 的核心声明，必须有证据支持 |
| Card | 卡片 | 原子知识单元，包含主张和证据引用 |
| Know Doc | 知识文档 | 综合多张 Card 的文档，不引入新主张 |
| Transferable Rule | 可迁移规则 | 从具体主张泛化的通用原则 |
| Sovereignty | 主权 | `vault/` 为唯一权威来源 |
| Evidence-first | 证据优先 | 先有证据，后有主张 |
| Non-repudiation | 不可否认性 | 变更通过 git 追溯，不可抵赖 |
| Least Privilege | 最小权限 | 内容按敏感度分级 |
| Ledger | 账本 | 资产审计报告 |
| Sensitivity | 敏感度 | `public` / `internal` / `private` |
| Confidence | 置信度 | `low` / `medium` / `high` |
| Status | 状态 | `draft` / `validated` / `deprecated` |

---

## 示例

**正确写法：**
> 每张 Card（卡片）必须包含 `evidence_refs` 字段，引用至少一条 Evidence。

**错误写法：**
> 每张卡片必须包含证据引用字段，引用至少一条证据。
> （缺少英文术语，不利于与 YAML 字段对应）
