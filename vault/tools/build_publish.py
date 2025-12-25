#!/usr/bin/env python3
"""
Build Publish Script
Generates derivative publish files from Know docs.
Only exports docs with sensitivity: public.
No external dependencies - Python 3 stdlib only.
"""

import os
import re
import sys
from pathlib import Path
from datetime import date
from typing import Dict, List, Tuple, Any, Optional


# ============================================================================
# Configuration
# ============================================================================

VAULT_ROOT = Path(__file__).parent.parent
KNOW_DIR = VAULT_ROOT / "know"
PUBLISH_DIR = VAULT_ROOT / "publish"


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


def extract_yaml_frontmatter(content: str) -> Tuple[Dict[str, Any], str, bool]:
    """
    Extract YAML front matter from Markdown file.
    Returns (parsed_yaml, body_content, success).
    """
    if not content.startswith('---'):
        return {}, content, False

    # Find closing ---
    end_match = re.search(r'\n---\s*\n', content[3:])
    if not end_match:
        return {}, content, False

    yaml_content = content[3:3 + end_match.start()]
    body_content = content[3 + end_match.end():]

    try:
        parsed = parse_yaml_simple(yaml_content)
        return parsed, body_content, True
    except Exception:
        return {}, content, False


# ============================================================================
# Content Extraction
# ============================================================================

def extract_title(body: str) -> str:
    """Extract the title from the markdown body (first H1)."""
    match = re.search(r'^#\s+(.+)$', body, re.MULTILINE)
    if match:
        return match.group(1).strip()
    return "Untitled"


def extract_takeaway(body: str) -> str:
    """
    Extract the One Paragraph Takeaway section.
    Best effort: look for Takeaway heading, then get first paragraph.
    """
    # Look for Takeaway heading
    takeaway_match = re.search(
        r'##\s+(?:One Paragraph\s+)?Takeaway\s*\n([\s\S]*?)(?=\n##|\Z)',
        body,
        re.IGNORECASE
    )
    if takeaway_match:
        section = takeaway_match.group(1).strip()
        # Get first non-empty paragraph
        paragraphs = [p.strip() for p in section.split('\n\n') if p.strip()]
        if paragraphs:
            return paragraphs[0]

    # Fallback: look for first blockquote
    blockquote_match = re.search(r'^>\s*(.+)$', body, re.MULTILINE)
    if blockquote_match:
        return blockquote_match.group(1).strip()

    # Fallback: first paragraph after title
    paragraphs = re.split(r'\n\n+', body)
    for p in paragraphs:
        p = p.strip()
        # Skip headings and empty
        if p and not p.startswith('#'):
            return p[:500] + ('...' if len(p) > 500 else '')

    return "(No takeaway found)"


def extract_card_refs(metadata: Dict[str, Any], body: str) -> List[str]:
    """
    Extract card references from front matter or body content.
    """
    # First check front matter 'cards' field
    if 'cards' in metadata and isinstance(metadata['cards'], list):
        return metadata['cards']

    # Scan body for CARD-YYYYMMDD-XXXX patterns
    pattern = r'CARD-\d{8}-\d{4}'
    matches = re.findall(pattern, body)
    # Deduplicate while preserving order
    seen = set()
    unique = []
    for m in matches:
        if m not in seen:
            seen.add(m)
            unique.append(m)
    return unique


# ============================================================================
# Publisher
# ============================================================================

def build_publish_content(
    know_filename: str,
    metadata: Dict[str, Any],
    body: str,
    today: str
) -> str:
    """Build the publish document content."""

    title = extract_title(body)
    know_id = metadata.get('id', know_filename)
    takeaway = extract_takeaway(body)
    card_refs = extract_card_refs(metadata, body)

    lines = []

    # Title
    lines.append(f"# {title} (Publish)")
    lines.append("")

    # Source section
    lines.append("## Source")
    lines.append("")
    lines.append(f"- **File**: `{know_filename}`")
    lines.append(f"- **ID**: `{know_id}`")
    lines.append("")

    # Takeaway section
    lines.append("## Takeaway")
    lines.append("")
    lines.append(takeaway)
    lines.append("")

    # Cards referenced
    lines.append("## Cards Referenced")
    lines.append("")
    if card_refs:
        for ref in card_refs:
            lines.append(f"- `{ref}`")
    else:
        lines.append("- (No cards referenced)")
    lines.append("")

    # Footer
    lines.append("---")
    lines.append("")
    lines.append(f"*Generated by build_publish.py on {today}*")
    lines.append("")

    return '\n'.join(lines)


def process_know_docs() -> Tuple[int, int, int]:
    """
    Process all Know docs and generate publish files.
    Returns (processed, generated, skipped).
    """
    processed = 0
    generated = 0
    skipped = 0

    today = date.today().strftime('%Y-%m-%d')

    # Ensure publish directory exists
    PUBLISH_DIR.mkdir(exist_ok=True)

    if not KNOW_DIR.exists():
        print(f"Know directory not found: {KNOW_DIR}")
        return 0, 0, 0

    for know_file in sorted(KNOW_DIR.glob("*.md")):
        processed += 1
        filename = know_file.name

        try:
            content = know_file.read_text(encoding='utf-8')
        except Exception as e:
            print(f"  [ERROR] Cannot read {filename}: {e}")
            skipped += 1
            continue

        metadata, body, success = extract_yaml_frontmatter(content)
        if not success:
            print(f"  [SKIP] {filename}: No valid YAML front matter")
            skipped += 1
            continue

        # Check sensitivity
        sensitivity = metadata.get('sensitivity', None)
        if sensitivity != 'public':
            print(f"  [SKIP] {filename}: sensitivity={sensitivity} (not public)")
            skipped += 1
            continue

        # Generate publish content
        publish_content = build_publish_content(filename, metadata, body, today)

        # Write to publish directory
        publish_filename = f"PUBLISH-{filename}"
        publish_path = PUBLISH_DIR / publish_filename

        try:
            publish_path.write_text(publish_content, encoding='utf-8')
            print(f"  [OK] {filename} -> {publish_filename}")
            generated += 1
        except Exception as e:
            print(f"  [ERROR] Cannot write {publish_filename}: {e}")
            skipped += 1

    return processed, generated, skipped


# ============================================================================
# Main
# ============================================================================

def main():
    print("=" * 60)
    print("BUILD PUBLISH")
    print("=" * 60)
    print(f"Know dir:    {KNOW_DIR}")
    print(f"Publish dir: {PUBLISH_DIR}")
    print()

    print("Processing Know docs...")
    processed, generated, skipped = process_know_docs()

    print()
    print("=" * 60)
    print("SUMMARY")
    print("=" * 60)
    print(f"Processed: {processed}")
    print(f"Generated: {generated}")
    print(f"Skipped:   {skipped}")

    if generated > 0:
        print()
        print("Generated files:")
        for f in sorted(PUBLISH_DIR.glob("PUBLISH-*.md")):
            print(f"  - {f.name}")

    return 0 if generated > 0 or processed == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
