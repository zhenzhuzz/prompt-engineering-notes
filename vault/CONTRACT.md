# Vault Contract

> Hard rules for the Knowledge Asset Vault. Enforceable, not philosophical.

---

## 1. Sovereignty

`vault/` is the **canonical source of truth**.

- Notion, NotebookLM, and other tools are optional UIs.
- If there's a conflict, `vault/` wins.
- All authoritative content lives here.

## 2. Evidence-First

Every claim **MUST** reference evidence.

- No evidence → status must be `draft`.
- Cards require at least one `evidence_ref`.
- Evidence must exist before cards can reference it.

## 3. Non-Repudiation

Changes are tracked and verifiable.

- All changes via git commits.
- Key assets must be reviewable (diff-friendly formats).
- `vault/publish/` artifacts are rebuildable from source.

## 4. Least Privilege (Sensitivity)

Classify all content, even in a public repo.

| Level | Description |
|-------|-------------|
| `public` | Safe to share openly |
| `internal` | For team/personal use only |
| `private` | Contains sensitive information |

Every card and evidence item has a `sensitivity` field.

## 5. Accounting

Assets are identifiable and trackable.

- Stable IDs: `CARD-YYYYMMDD-XXXX`, `EVI-YYYYMMDD-XXXX`
- Status lifecycle: `draft` → `validated` → `deprecated`
- Must be able to list all assets and verify their state.
- Run `python vault/tools/validate_vault.py` to audit.

---

## Enforcement

- Validation script checks compliance before commits.
- Pre-commit hooks (optional) can automate checks.
- Violations = fix before merge.
