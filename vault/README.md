# Knowledge Asset Vault

> Auditable, evidence-based knowledge management.

---

## Directory Structure

```
vault/
├── evidence/     # Raw sources + snapshots (append-only)
├── cards/        # Atomic claim–evidence assets
├── know/         # Human-readable syntheses (reference cards only)
├── schema/       # Reserved for future schema files
├── ledger/       # Generated audit reports
├── publish/      # Rebuilt exports for external use
├── templates/    # Templates for creating new assets
└── tools/        # Validation and utility scripts
```

## Core Documents

- [CONTRACT.md](CONTRACT.md) - Hard rules (sovereignty, evidence-first, etc.)
- [SCHEMA.md](SCHEMA.md) - Field definitions for cards and evidence

---

## Day-1 Workflow

```
Evidence → Cards → Know → Validate
```

### 1. Capture Evidence

```bash
# Create evidence content
vault/evidence/EVI-YYYYMMDD-XXXX.note.md   # or .pdf, .png, etc.

# Create metadata file
vault/evidence/EVI-YYYYMMDD-XXXX.yml
```

Use template: `vault/templates/evidence.meta.template.yml`

### 2. Create Cards

```bash
vault/cards/CARD-YYYYMMDD-XXXX.md
```

Use template: `vault/templates/card.template.md`

Each card must:
- Have YAML front matter with all required fields
- Reference at least one evidence ID
- Include Claim, Evidence, and Transferable Rule sections

### 3. Write Know Docs

```bash
vault/know/KNOW-YYYYMMDD-descriptor.md
```

Use template: `vault/templates/know.template.md`

Know docs:
- Synthesize multiple cards into readable narratives
- **Only reference existing CARD IDs** — no new claims
- Provide context and connections

### 4. Validate

```bash
python vault/tools/validate_vault.py
```

Checks:
- All cards have required YAML fields
- Status and confidence enums are valid
- Each card has at least one evidence_ref
- All evidence metadata files have required fields

---

## Quick Commands

```bash
# Validate all assets
python vault/tools/validate_vault.py

# List all cards
ls vault/cards/

# List all evidence
ls vault/evidence/*.yml
```

---

## Adding New Assets

### New Evidence
1. Copy `vault/templates/evidence.meta.template.yml`
2. Rename to `vault/evidence/EVI-YYYYMMDD-XXXX.yml`
3. Fill in metadata fields
4. Add source file if local (same base name, different extension)

### New Card
1. Copy `vault/templates/card.template.md`
2. Rename to `vault/cards/CARD-YYYYMMDD-XXXX.md`
3. Fill in YAML front matter
4. Write Claim, Evidence, Transferable Rule sections
5. Run validation

### New Know Doc
1. Copy `vault/templates/know.template.md`
2. Rename to `vault/know/KNOW-YYYYMMDD-descriptor.md`
3. Reference only existing CARD IDs
4. No new claims — synthesis only
