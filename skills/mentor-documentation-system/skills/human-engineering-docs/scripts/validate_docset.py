#!/usr/bin/env python3
"""Validate a human-engineering-docs directory."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

MAX_LINES = 100
MAX_PARAGRAPH_WORDS = 140
TLDR = re.compile(r"^##\s+TL;DR\s*$", re.MULTILINE | re.IGNORECASE)
H1 = re.compile(r"^#\s+\S", re.MULTILINE)
LINK = re.compile(r"\[[^\]]+\]\(([^)]+\.md(?:#[^)]+)?)\)")
AGENT_VOICE = (
    "the agent should",
    "next, the agent",
    "execute the following",
    "we need to inspect",
    "modify the file and",
)


def paragraphs(text: str) -> list[str]:
    blocks = re.split(r"\n\s*\n", text)
    return [b.replace("\n", " ").strip() for b in blocks if b.strip()]


def validate(root: Path) -> tuple[list[str], list[str]]:
    errors: list[str] = []
    warnings: list[str] = []
    markdown = sorted(root.rglob("*.md"))
    if not markdown:
        return [f"No Markdown files found under {root}"], warnings
    if not (root / "000-index.md").exists():
        errors.append("Missing required 000-index.md")

    for path in markdown:
        text = path.read_text(encoding="utf-8")
        rel = path.relative_to(root)
        line_count = len(text.splitlines())
        if line_count > MAX_LINES:
            errors.append(f"{rel}: {line_count} lines; maximum is {MAX_LINES}")
        if not H1.search(text):
            errors.append(f"{rel}: missing H1 title")
        if not TLDR.search(text):
            errors.append(f"{rel}: missing '## TL;DR'")
        lower = text.lower()
        for phrase in AGENT_VOICE:
            if phrase in lower:
                warnings.append(f"{rel}: possible agent-facing language: {phrase!r}")
        for number, block in enumerate(paragraphs(text), start=1):
            if block.startswith(("#", "```", "- ", "* ", ">")):
                continue
            words = len(block.split())
            if words > MAX_PARAGRAPH_WORDS:
                warnings.append(f"{rel}: paragraph {number} has {words} words")
        for target in LINK.findall(text):
            target_path = target.split("#", 1)[0]
            if "://" in target_path or target_path.startswith("mailto:"):
                continue
            resolved = (path.parent / target_path).resolve()
            if not resolved.exists():
                errors.append(f"{rel}: broken local link to {target_path}")
    return errors, warnings


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("root", type=Path, help="Path to human/<task-slug>")
    args = parser.parse_args()
    if not args.root.is_dir():
        print(f"ERROR: not a directory: {args.root}", file=sys.stderr)
        return 2
    errors, warnings = validate(args.root)
    for warning in warnings:
        print(f"WARNING: {warning}")
    for error in errors:
        print(f"ERROR: {error}")
    if errors:
        print(f"FAILED: {len(errors)} error(s), {len(warnings)} warning(s)")
        return 1
    print(f"PASS: 0 errors, {len(warnings)} warning(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
