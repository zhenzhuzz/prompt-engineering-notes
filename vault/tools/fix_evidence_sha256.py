#!/usr/bin/env python3
"""
Fix Evidence SHA256 Script
Automatically fills missing sha256 values in evidence metadata files.
No external dependencies - Python 3 stdlib only.
"""

import hashlib
import re
import sys
from pathlib import Path
from typing import Optional, Tuple


# ============================================================================
# Configuration
# ============================================================================

VAULT_ROOT = Path(__file__).parent.parent
EVIDENCE_DIR = VAULT_ROOT / "evidence"


# ============================================================================
# Helpers
# ============================================================================

def compute_sha256(filepath: Path) -> str:
    """Compute SHA256 hash of a file."""
    sha256_hash = hashlib.sha256()
    with open(filepath, 'rb') as f:
        for chunk in iter(lambda: f.read(4096), b''):
            sha256_hash.update(chunk)
    return sha256_hash.hexdigest()


def extract_evidence_id(yml_filename: str) -> str:
    """Extract evidence ID from yml filename (e.g., EVI-20251222-0001.yml -> EVI-20251222-0001)."""
    return yml_filename.replace('.yml', '')


def find_content_file(evidence_id: str, evidence_dir: Path) -> Optional[Path]:
    """
    Find the content file for an evidence ID.
    Priority: .note.md > any other file starting with evidence_id (not .yml)
    """
    # First try .note.md
    note_file = evidence_dir / f"{evidence_id}.note.md"
    if note_file.exists():
        return note_file

    # Then try any other matching file
    for f in evidence_dir.iterdir():
        if f.name.startswith(evidence_id) and not f.name.endswith('.yml'):
            return f

    return None


def has_sha256(content: str) -> Tuple[bool, str]:
    """
    Check if content has sha256 field and return its value.
    Returns (has_value, current_value).
    """
    # Look for sha256: line
    match = re.search(r'^sha256:\s*(.*)$', content, re.MULTILINE)
    if match:
        value = match.group(1).strip().strip('"\'')
        return bool(value), value
    return False, ""


def update_sha256_in_content(content: str, new_sha256: str) -> str:
    """
    Update or add sha256 field in YAML content.
    """
    # Check if sha256 line exists
    if re.search(r'^sha256:', content, re.MULTILINE):
        # Replace existing line
        return re.sub(
            r'^sha256:\s*.*$',
            f'sha256: "{new_sha256}"',
            content,
            flags=re.MULTILINE
        )
    else:
        # Add after license line if exists, otherwise at end
        if re.search(r'^license:', content, re.MULTILINE):
            return re.sub(
                r'^(license:\s*.*)$',
                f'\\1\nsha256: "{new_sha256}"',
                content,
                flags=re.MULTILINE
            )
        else:
            return content.rstrip() + f'\nsha256: "{new_sha256}"\n'


# ============================================================================
# Main
# ============================================================================

def main():
    print("=" * 60)
    print("FIX EVIDENCE SHA256")
    print("=" * 60)
    print(f"Evidence dir: {EVIDENCE_DIR}")
    print()

    if not EVIDENCE_DIR.exists():
        print("ERROR: Evidence directory not found")
        return 1

    updated = 0
    skipped = 0
    already_ok = 0

    for yml_file in sorted(EVIDENCE_DIR.glob("*.yml")):
        evidence_id = extract_evidence_id(yml_file.name)

        try:
            content = yml_file.read_text(encoding='utf-8')
        except Exception as e:
            print(f"  [ERROR] {yml_file.name}: cannot read - {e}")
            skipped += 1
            continue

        has_value, current_value = has_sha256(content)

        if has_value:
            print(f"  [OK] {yml_file.name}: sha256 already set")
            already_ok += 1
            continue

        # Find content file
        content_file = find_content_file(evidence_id, EVIDENCE_DIR)

        if not content_file:
            print(f"  [WARN] {yml_file.name}: no content file found for {evidence_id}")
            skipped += 1
            continue

        # Compute sha256
        try:
            file_hash = compute_sha256(content_file)
        except Exception as e:
            print(f"  [ERROR] {yml_file.name}: cannot hash {content_file.name} - {e}")
            skipped += 1
            continue

        # Update yml file
        new_content = update_sha256_in_content(content, file_hash)

        try:
            yml_file.write_text(new_content, encoding='utf-8')
            print(f"  [FIXED] {yml_file.name}: sha256 = {file_hash[:16]}... (from {content_file.name})")
            updated += 1
        except Exception as e:
            print(f"  [ERROR] {yml_file.name}: cannot write - {e}")
            skipped += 1

    print()
    print("=" * 60)
    print("SUMMARY")
    print("=" * 60)
    print(f"Updated:    {updated}")
    print(f"Already OK: {already_ok}")
    print(f"Skipped:    {skipped}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
