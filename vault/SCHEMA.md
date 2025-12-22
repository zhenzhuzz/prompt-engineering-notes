# 元数据规范 (Schema)

> 资产字段定义。所有元数据使用 YAML 格式。

**写作规范:** 参见 [STYLE.md](STYLE.md)

---

## CARD 元数据 (YAML Front Matter)

Card 是带有 YAML front matter 的 Markdown 文件。

| 字段 | 类型 | 必需 | 说明 |
|------|------|------|------|
| `id` | string | 是 | 格式: `CARD-YYYYMMDD-XXXX` |
| `type` | enum | 否 | `tech_blog` \| `interview` \| `company_research` \| `debug_playbook` \| `other`（分型资产） |
| `status` | enum | 是 | `draft` \| `validated` \| `deprecated` |
| `created_at` | date | 是 | 格式: `YYYY-MM-DD` |
| `last_verified_at` | date | 是 | 格式: `YYYY-MM-DD` |
| `confidence` | enum | 是 | `low` \| `medium` \| `high` |
| `scope` | string | 是 | 简述本卡片涵盖的内容 |
| `tags` | list | 是 | 相关标签列表 |
| `sensitivity` | enum | 是 | `public` \| `internal` \| `private` |
| `evidence_refs` | list | 是 | Evidence ID 列表（至少 1 条） |
| `sources` | list | 否 | 可选的来源 URL/引用 |

### Card 正文部分（必需）

```markdown
## Claim
[本卡片的原子主张，一个清晰、可验证的陈述]

## Evidence
[支持证据的摘要，引用上方列出的 Evidence ID]

## Transferable Rule
[从主张泛化出的通用原则]
```

---

## EVIDENCE 元数据 (.yml 文件)

Evidence 元数据文件描述采集的来源。

| 字段 | 类型 | 必需 | 说明 |
|------|------|------|------|
| `id` | string | 是 | 格式: `EVI-YYYYMMDD-XXXX` |
| `type` | enum | 否 | `tech_blog` \| `interview` \| `company_research` \| `debug_playbook` \| `other`（分型资产） |
| `captured_at` | date | 是 | 格式: `YYYY-MM-DD` |
| `source_type` | enum | 是 | `web` \| `video` \| `pdf` \| `note` \| `code` \| `other` |
| `source` | string | 是 | URL 或本地路径 |
| `title` | string | 否 | 来源标题 |
| `author` | string | 否 | 作者/创建者 |
| `license` | string | 是 | `unknown` \| `public` \| `restricted`（可加自由文本） |
| `sha256` | string | 否 | 证据文件的哈希值（如为本地文件） |
| `notes` | string | 否 | 附加上下文 |
| `sensitivity` | enum | 是 | `public` \| `internal` \| `private` |

---

## ID 格式

```
CARD-YYYYMMDD-XXXX
EVI-YYYYMMDD-XXXX
KNOW-YYYYMMDD-descriptor

示例:
- CARD-20251222-0001
- EVI-20251222-0001
- KNOW-20251222-sample
```

- `YYYYMMDD` = 创建日期
- `XXXX` = 4 位序列号 (0001-9999)
- `descriptor` = Know Doc 的 kebab-case 名称
