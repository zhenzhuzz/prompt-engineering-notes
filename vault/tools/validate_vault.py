#!/usr/bin/env python3
"""
Vault Validation Script
Validates cards and evidence metadata in the vault.
No external dependencies - Python 3 stdlib only.
"""

import os
import re
import sys
from pathlib import Path
from typing import Dict, List, Tuple, Any


# ============================================================================
# Configuration
# ============================================================================

VAULT_ROOT = Path(__file__).parent.parent
CARDS_DIR = VAULT_ROOT / "cards"
EVIDENCE_DIR = VAULT_ROOT / "evidence"

# Required fields and valid enums
CARD_REQUIRED_FIELDS = [
    "id", "status", "created_at", "last_verified_at",
    "confidence", "scope", "tags", "sensitivity", "evidence_refs"
]

CARD_ENUMS = {
    "status": ["draft", "validated", "deprecated"],
    "confidence": ["low", "medium", "high"],
    "sensitivity": ["public", "internal", "private"],
}

EVIDENCE_REQUIRED_FIELDS = [
    "id", "captured_at", "source_type", "source", "license", "sensitivity"
]

EVIDENCE_ENUMS = {
    "source_type": ["web", "video", "pdf", "note", "code", "other"],
    "sensitivity": ["public", "internal", "private"],
}


# ============================================================================
# YAML Parser (Simple, no external deps)
# ============================================================================

def parse_yaml_simple(content: str) -> Dict[str, Any]:
    """
    Simple YAML parser for flat structures with lists.
    Handles basic YAML used in vault metadata.
    """
    result = {}
    current_key = None
    current_list = None

    for line in content.split('\n'):
        # Skip empty lines and comments
        stripped = line.strip()
        if not stripped or stripped.startswith('#'):
            continue

        # Check for list item
        if stripped.startswith('- '):
            if current_list is not None:
                value = stripped[2:].strip().strip('"\'')
                current_list.append(value)
            continue

        # Check for key-value pair
        if ':' in line:
            # Get indentation level
            indent = len(line) - len(line.lstrip())

            # Split on first colon
            colon_idx = line.index(':')
            key = line[:colon_idx].strip()
            value = line[colon_idx + 1:].strip()

            # Skip if this is a nested key (indented)
            if indent > 0 and current_list is not None:
                continue

            # Handle multiline string indicator
            if value == '|':
                current_key = key
                current_list = None
                result[key] = ""
                continue

            # Handle empty value (likely a list follows)
            if value == '' or value is None:
                current_key = key
                current_list = []
                result[key] = current_list
                continue

            # Handle regular value
            current_key = key
            current_list = None

            # Clean up value (remove quotes)
            value = value.strip('"\'')

            # Try to parse as list if it looks like one
            if value.startswith('[') and value.endswith(']'):
                # Inline list
                inner = value[1:-1]
                if inner:
                    result[key] = [v.strip().strip('"\'') for v in inner.split(',')]
                else:
                    result[key] = []
            else:
                result[key] = value

    return result


def extract_yaml_frontmatter(content: str) -> Tuple[Dict[str, Any], bool]:
    """
    Extract YAML front matter from Markdown file.
    Returns (parsed_yaml, success).
    """
    if not content.startswith('---'):
        return {}, False

    # Find closing ---
    end_match = re.search(r'\n---\s*\n', content[3:])
    if not end_match:
        return {}, False

    yaml_content = content[3:3 + end_match.start()]

    try:
        parsed = parse_yaml_simple(yaml_content)
        return parsed, True
    except Exception:
        return {}, False


# ============================================================================
# Validators
# ============================================================================

def validate_card(filepath: Path) -> List[str]:
    """Validate a single card file. Returns list of errors."""
    errors = []

    try:
        content = filepath.read_text(encoding='utf-8')
    except Exception as e:
        return [f"Cannot read file: {e}"]

    # Parse front matter
    metadata, success = extract_yaml_frontmatter(content)
    if not success:
        return ["Missing or invalid YAML front matter"]

    # Check required fields
    for field in CARD_REQUIRED_FIELDS:
        if field not in metadata:
            errors.append(f"Missing required field: {field}")
        elif metadata[field] is None or metadata[field] == '':
            errors.append(f"Empty required field: {field}")

    # Check enums
    for field, valid_values in CARD_ENUMS.items():
        if field in metadata and metadata[field] not in valid_values:
            errors.append(f"Invalid {field}: '{metadata[field]}' (must be one of: {valid_values})")

    # Check evidence_refs is non-empty list
    if 'evidence_refs' in metadata:
        refs = metadata['evidence_refs']
        if not isinstance(refs, list) or len(refs) == 0:
            errors.append("evidence_refs must be a non-empty list")
        elif all(r == '' or r is None for r in refs):
            errors.append("evidence_refs must contain at least one valid reference")

    # Check ID format
    if 'id' in metadata:
        id_val = metadata['id']
        if not re.match(r'^CARD-\d{8}-\d{4}$', str(id_val)):
            errors.append(f"Invalid ID format: '{id_val}' (expected CARD-YYYYMMDD-XXXX)")

    # Check tags is a list
    if 'tags' in metadata:
        if not isinstance(metadata['tags'], list):
            errors.append("tags must be a list")

    return errors


def validate_evidence(filepath: Path) -> List[str]:
    """Validate a single evidence metadata file. Returns list of errors."""
    errors = []

    try:
        content = filepath.read_text(encoding='utf-8')
    except Exception as e:
        return [f"Cannot read file: {e}"]

    # Parse YAML
    try:
        metadata = parse_yaml_simple(content)
    except Exception as e:
        return [f"Invalid YAML: {e}"]

    # Check required fields
    for field in EVIDENCE_REQUIRED_FIELDS:
        if field not in metadata:
            errors.append(f"Missing required field: {field}")
        elif metadata[field] is None or metadata[field] == '':
            errors.append(f"Empty required field: {field}")

    # Check enums
    for field, valid_values in EVIDENCE_ENUMS.items():
        if field in metadata and metadata[field] not in valid_values:
            errors.append(f"Invalid {field}: '{metadata[field]}' (must be one of: {valid_values})")

    # Check ID format
    if 'id' in metadata:
        id_val = metadata['id']
        if not re.match(r'^EVI-\d{8}-\d{4}$', str(id_val)):
            errors.append(f"Invalid ID format: '{id_val}' (expected EVI-YYYYMMDD-XXXX)")

    # Check license format (allow any string starting with valid prefix)
    if 'license' in metadata:
        license_val = str(metadata['license']).lower()
        if not any(license_val.startswith(v) for v in ['unknown', 'public', 'restricted']):
            errors.append(f"Invalid license: '{metadata['license']}' (must start with: unknown, public, or restricted)")

    return errors


# ============================================================================
# Main
# ============================================================================

def main():
    print("=" * 60)
    print("VAULT VALIDATION")
    print("=" * 60)
    print(f"Vault root: {VAULT_ROOT}")
    print()

    all_errors: List[Tuple[str, List[str]]] = []
    total_cards = 0
    total_evidence = 0

    # Validate cards
    print("Validating cards...")
    if CARDS_DIR.exists():
        for card_file in sorted(CARDS_DIR.glob("*.md")):
            total_cards += 1
            errors = validate_card(card_file)
            if errors:
                all_errors.append((str(card_file.relative_to(VAULT_ROOT)), errors))
                print(f"  [FAIL] {card_file.name}")
            else:
                print(f"  [OK] {card_file.name}")
    else:
        print("  (no cards directory)")

    print()

    # Validate evidence
    print("Validating evidence...")
    if EVIDENCE_DIR.exists():
        for evi_file in sorted(EVIDENCE_DIR.glob("*.yml")):
            total_evidence += 1
            errors = validate_evidence(evi_file)
            if errors:
                all_errors.append((str(evi_file.relative_to(VAULT_ROOT)), errors))
                print(f"  [FAIL] {evi_file.name}")
            else:
                print(f"  [OK] {evi_file.name}")
    else:
        print("  (no evidence directory)")

    print()
    print("=" * 60)

    # Summary
    if all_errors:
        print("RESULT: FAIL")
        print(f"Found {len(all_errors)} file(s) with errors")
        print()
        print("ERRORS:")
        for filepath, errors in all_errors:
            print(f"\n  {filepath}:")
            for err in errors:
                print(f"    - {err}")
        print()
        sys.exit(1)
    else:
        print("RESULT: PASS")
        print(f"Validated {total_cards} card(s) and {total_evidence} evidence file(s)")
        print()
        sys.exit(0)


if __name__ == "__main__":
    main()
