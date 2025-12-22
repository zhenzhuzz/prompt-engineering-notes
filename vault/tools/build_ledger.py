#!/usr/bin/env python3
"""
Build Ledger Script
Generates inventory and review queue from vault assets.
Provides accounting/audit view of vault state.
No external dependencies - Python 3 stdlib only.
"""

import os
import re
import sys
from pathlib import Path
from datetime import date, datetime, timedelta
from typing import Dict, List, Tuple, Any, Optional
from collections import Counter


# ============================================================================
# Configuration
# ============================================================================

VAULT_ROOT = Path(__file__).parent.parent
EVIDENCE_DIR = VAULT_ROOT / "evidence"
CARDS_DIR = VAULT_ROOT / "cards"
KNOW_DIR = VAULT_ROOT / "know"
PUBLISH_DIR = VAULT_ROOT / "publish"
LEDGER_DIR = VAULT_ROOT / "ledger"

# Review threshold: cards older than this many days need review
REVIEW_THRESHOLD_DAYS = 30


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
# Scanners
# ============================================================================

def scan_evidence() -> Tuple[List[Dict[str, Any]], List[str]]:
    """Scan evidence directory. Returns (metadata_list, warnings)."""
    results = []
    warnings = []

    if not EVIDENCE_DIR.exists():
        return [], ["Evidence directory not found"]

    for f in sorted(EVIDENCE_DIR.glob("*.yml")):
        try:
            content = f.read_text(encoding='utf-8')
            meta = parse_yaml_simple(content)
            meta['_filename'] = f.name
            results.append(meta)

            # Check hygiene
            if not meta.get('sha256'):
                warnings.append(f"{f.name}: missing sha256")
            if meta.get('license', '').lower() == 'unknown':
                warnings.append(f"{f.name}: license=unknown")

        except Exception as e:
            warnings.append(f"{f.name}: parse error - {e}")

    return results, warnings


def scan_cards() -> Tuple[List[Dict[str, Any]], List[str], List[str]]:
    """Scan cards directory. Returns (metadata_list, review_queue, warnings)."""
    results = []
    review_queue = []
    warnings = []

    if not CARDS_DIR.exists():
        return [], [], ["Cards directory not found"]

    today = date.today()
    threshold_date = today - timedelta(days=REVIEW_THRESHOLD_DAYS)

    for f in sorted(CARDS_DIR.glob("*.md")):
        try:
            content = f.read_text(encoding='utf-8')
            meta, success = extract_yaml_frontmatter(content)
            if not success:
                warnings.append(f"{f.name}: no valid front matter")
                continue

            meta['_filename'] = f.name
            results.append(meta)

            # Check review queue
            card_id = meta.get('id', f.name)
            last_verified = meta.get('last_verified_at')

            if not last_verified:
                warnings.append(f"{card_id}: missing last_verified_at")
            else:
                try:
                    # Parse date (YYYY-MM-DD)
                    verified_date = datetime.strptime(str(last_verified), '%Y-%m-%d').date()
                    if verified_date < threshold_date:
                        review_queue.append(card_id)
                except ValueError:
                    warnings.append(f"{card_id}: invalid last_verified_at format")

            if not meta.get('created_at'):
                warnings.append(f"{card_id}: missing created_at")

        except Exception as e:
            warnings.append(f"{f.name}: read error - {e}")

    return results, review_queue, warnings


def scan_know() -> Tuple[List[Dict[str, Any]], List[str]]:
    """Scan know directory. Returns (metadata_list, warnings)."""
    results = []
    warnings = []

    if not KNOW_DIR.exists():
        return [], ["Know directory not found"]

    for f in sorted(KNOW_DIR.glob("*.md")):
        try:
            content = f.read_text(encoding='utf-8')
            meta, success = extract_yaml_frontmatter(content)
            if success:
                meta['_filename'] = f.name
            else:
                meta = {'_filename': f.name}
            results.append(meta)
        except Exception as e:
            warnings.append(f"{f.name}: read error - {e}")

    return results, warnings


def count_publish() -> int:
    """Count publish files."""
    if not PUBLISH_DIR.exists():
        return 0
    return len(list(PUBLISH_DIR.glob("PUBLISH-*.md")))


# ============================================================================
# Report Builder
# ============================================================================

def build_distribution_table(items: List[Dict[str, Any]], field: str, title: str) -> List[str]:
    """Build a distribution table for a given field."""
    counter = Counter()
    for item in items:
        value = item.get(field, '(missing)')
        counter[value] += 1

    lines = []
    lines.append(f"### {title}")
    lines.append("")
    lines.append("| Value | Count |")
    lines.append("|-------|-------|")
    for value, count in sorted(counter.items(), key=lambda x: (-x[1], x[0])):
        lines.append(f"| {value} | {count} |")
    lines.append("")
    return lines


def build_ledger_report(
    evidence_list: List[Dict[str, Any]],
    cards_list: List[Dict[str, Any]],
    know_list: List[Dict[str, Any]],
    publish_count: int,
    review_queue: List[str],
    evidence_warnings: List[str],
    card_warnings: List[str],
    know_warnings: List[str]
) -> str:
    """Build the complete ledger report."""

    today = date.today().strftime('%Y-%m-%d')
    now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    lines = []

    # Header
    lines.append("# Vault Ledger")
    lines.append("")
    lines.append(f"*Generated: {now}*")
    lines.append("")

    # Inventory
    lines.append("## 1. Inventory")
    lines.append("")
    lines.append("| Asset Type | Count |")
    lines.append("|------------|-------|")
    lines.append(f"| Evidence | {len(evidence_list)} |")
    lines.append(f"| Cards | {len(cards_list)} |")
    lines.append(f"| Know Docs | {len(know_list)} |")
    lines.append(f"| Publish | {publish_count} |")
    lines.append("")

    # Cards distributions
    lines.append("## 2. Cards Distribution")
    lines.append("")
    lines.extend(build_distribution_table(cards_list, 'status', 'By Status'))
    lines.extend(build_distribution_table(cards_list, 'confidence', 'By Confidence'))
    lines.extend(build_distribution_table(cards_list, 'type', 'By Type'))
    lines.extend(build_distribution_table(cards_list, 'sensitivity', 'By Sensitivity'))

    # Evidence distributions
    lines.append("## 3. Evidence Distribution")
    lines.append("")
    lines.extend(build_distribution_table(evidence_list, 'source_type', 'By Source Type'))
    lines.extend(build_distribution_table(evidence_list, 'type', 'By Type'))

    # License distribution with grouping
    license_counter = Counter()
    for item in evidence_list:
        lic = str(item.get('license', '(missing)')).lower()
        if lic.startswith('unknown'):
            license_counter['unknown'] += 1
        elif lic.startswith('public'):
            license_counter['public'] += 1
        elif lic.startswith('restricted'):
            license_counter['restricted'] += 1
        else:
            license_counter[lic] += 1

    lines.append("### By License")
    lines.append("")
    lines.append("| License | Count |")
    lines.append("|---------|-------|")
    for lic, count in sorted(license_counter.items(), key=lambda x: (-x[1], x[0])):
        lines.append(f"| {lic} | {count} |")
    lines.append("")

    # Review queue
    lines.append("## 4. Review Queue")
    lines.append("")
    lines.append(f"Cards not verified in last {REVIEW_THRESHOLD_DAYS} days:")
    lines.append("")
    if review_queue:
        for card_id in review_queue:
            lines.append(f"- `{card_id}`")
    else:
        lines.append("*(none)*")
    lines.append("")

    # Warnings - Actionable format
    lines.append("## 5. Warnings Summary")
    lines.append("")

    all_warnings = evidence_warnings + card_warnings + know_warnings

    # Categorize evidence warnings
    sha256_missing_files = [w.split(':')[0] for w in evidence_warnings if 'missing sha256' in w]
    license_unknown_files = [w.split(':')[0] for w in evidence_warnings if 'license=unknown' in w]
    other_evidence_warnings = [w for w in evidence_warnings if 'missing sha256' not in w and 'license=unknown' not in w]

    lines.append("| Category | Count |")
    lines.append("|----------|-------|")
    lines.append(f"| Evidence: missing sha256 | {len(sha256_missing_files)} |")
    lines.append(f"| Evidence: license=unknown | {len(license_unknown_files)} |")
    lines.append(f"| Card warnings | {len(card_warnings)} |")
    lines.append(f"| Know warnings | {len(know_warnings)} |")
    lines.append(f"| **Total warnings** | {len(all_warnings)} |")
    lines.append("")

    # Actionable: Missing sha256
    if sha256_missing_files:
        lines.append("### 5.1 Evidence: Missing sha256")
        lines.append("")
        lines.append("**Files:**")
        for f in sha256_missing_files:
            lines.append(f"- `vault/evidence/{f}`")
        lines.append("")
        lines.append("**How to fix:**")
        lines.append("```bash")
        lines.append("python vault/tools/fix_evidence_sha256.py")
        lines.append("```")
        lines.append("")

    # Actionable: License unknown
    if license_unknown_files:
        lines.append("### 5.2 Evidence: License = unknown")
        lines.append("")
        lines.append("**Files:**")
        for f in license_unknown_files:
            lines.append(f"- `vault/evidence/{f}`")
        lines.append("")
        lines.append("**How to fix:**")
        lines.append("Edit each `.yml` file and update `license:` to one of: `public`, `restricted`, or a specific license name.")
        lines.append("")

    # Card warnings
    if card_warnings:
        lines.append("### 5.3 Card Warnings")
        lines.append("")
        lines.append("**Issues:**")
        for w in card_warnings:
            lines.append(f"- {w}")
        lines.append("")
        lines.append("**How to fix:**")
        lines.append("Edit the card front matter to add missing fields (`created_at`, `last_verified_at`).")
        lines.append("")

    # Know warnings
    if know_warnings:
        lines.append("### 5.4 Know Doc Warnings")
        lines.append("")
        lines.append("**Issues:**")
        for w in know_warnings:
            lines.append(f"- {w}")
        lines.append("")

    # Other evidence warnings
    if other_evidence_warnings:
        lines.append("### 5.5 Other Evidence Warnings")
        lines.append("")
        for w in other_evidence_warnings:
            lines.append(f"- {w}")
        lines.append("")

    # Footer
    lines.append("---")
    lines.append("")
    lines.append("*This ledger is auto-generated. Do not edit manually.*")
    lines.append("")

    return '\n'.join(lines)


# ============================================================================
# Main
# ============================================================================

def main():
    print("=" * 60)
    print("BUILD LEDGER")
    print("=" * 60)
    print(f"Vault root: {VAULT_ROOT}")
    print()

    # Scan all directories
    print("Scanning evidence...")
    evidence_list, evidence_warnings = scan_evidence()
    print(f"  Found {len(evidence_list)} evidence files, {len(evidence_warnings)} warnings")

    print("Scanning cards...")
    cards_list, review_queue, card_warnings = scan_cards()
    print(f"  Found {len(cards_list)} cards, {len(review_queue)} need review, {len(card_warnings)} warnings")

    print("Scanning know docs...")
    know_list, know_warnings = scan_know()
    print(f"  Found {len(know_list)} know docs, {len(know_warnings)} warnings")

    print("Counting publish files...")
    publish_count = count_publish()
    print(f"  Found {publish_count} publish files")

    print()

    # Build report
    print("Building ledger report...")
    report = build_ledger_report(
        evidence_list,
        cards_list,
        know_list,
        publish_count,
        review_queue,
        evidence_warnings,
        card_warnings,
        know_warnings
    )

    # Ensure ledger directory exists
    LEDGER_DIR.mkdir(exist_ok=True)

    # Write report
    output_path = LEDGER_DIR / "ledger-latest.md"
    output_path.write_text(report, encoding='utf-8')
    print(f"  Written to: {output_path}")

    print()
    print("=" * 60)
    print("SUMMARY")
    print("=" * 60)
    print(f"Evidence:    {len(evidence_list)}")
    print(f"Cards:       {len(cards_list)}")
    print(f"Know docs:   {len(know_list)}")
    print(f"Publish:     {publish_count}")
    print(f"Review queue: {len(review_queue)}")
    print(f"Warnings:    {len(evidence_warnings) + len(card_warnings) + len(know_warnings)}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
