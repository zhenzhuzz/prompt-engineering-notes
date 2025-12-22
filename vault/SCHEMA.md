# Vault Schema

> Field definitions for vault assets. All metadata uses YAML.

---

## CARD Metadata (YAML Front Matter)

Cards are Markdown files with required YAML front matter.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | Yes | Format: `CARD-YYYYMMDD-XXXX` |
| `status` | enum | Yes | `draft` \| `validated` \| `deprecated` |
| `created_at` | date | Yes | Format: `YYYY-MM-DD` |
| `last_verified_at` | date | Yes | Format: `YYYY-MM-DD` |
| `confidence` | enum | Yes | `low` \| `medium` \| `high` |
| `scope` | string | Yes | Short description of what this card covers |
| `tags` | list | Yes | List of relevant tags |
| `sensitivity` | enum | Yes | `public` \| `internal` \| `private` |
| `evidence_refs` | list | Yes | List of evidence IDs (min 1) |
| `sources` | list | No | Optional list of source URLs/references |

### Card Body Sections (Required)

```markdown
## Claim
[The atomic claim this card makes]

## Evidence
[Summary of supporting evidence]

## Transferable Rule
[Generalizable principle derived from this claim]
```

---

## EVIDENCE Metadata (.yml file)

Evidence metadata files describe captured sources.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | Yes | Format: `EVI-YYYYMMDD-XXXX` |
| `captured_at` | date | Yes | Format: `YYYY-MM-DD` |
| `source_type` | enum | Yes | `web` \| `video` \| `pdf` \| `note` \| `code` \| `other` |
| `source` | string | Yes | URL or local path to the evidence |
| `title` | string | No | Title of the source |
| `author` | string | No | Author/creator |
| `license` | string | Yes | `unknown` \| `public` \| `restricted` (+ free text) |
| `sha256` | string | No | Hash of the evidence file (if local) |
| `notes` | string | No | Additional context |
| `sensitivity` | enum | Yes | `public` \| `internal` \| `private` |

---

## ID Format

```
CARD-YYYYMMDD-XXXX
EVI-YYYYMMDD-XXXX
KNOW-YYYYMMDD-descriptor

Examples:
- CARD-20251222-0001
- EVI-20251222-0001
- KNOW-20251222-sample
```

- `YYYYMMDD` = creation date
- `XXXX` = 4-digit sequence number (0001-9999)
- `descriptor` = kebab-case name for KNOW docs
