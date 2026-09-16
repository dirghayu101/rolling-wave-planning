# Validation report

## TL;DR

The bundle passed local structural checks. Both skills have valid required frontmatter fields, every text file in the bundle is under 100 lines, the generated-doc validator accepted a linked sample docset, and the ZIP archive passed an integrity test.

## Checks completed

- Skill directory names match their `name` fields.
- Skill names use lowercase letters, digits, and single hyphens.
- Both descriptions are present and below 1,024 characters.
- Compatibility fields are below 500 characters.
- Metadata fields are mappings.
- All Markdown, JSON, and Python files are 100 lines or fewer.
- The largest file is `validate_docset.py` at 89 lines.
- A sample `human/<task>/` docset passed with zero errors and zero warnings.
- The ZIP archive reported no corrupted entries.

## Validator behavior exercised

The sample included:

- `000-index.md`;
- a linked numbered chapter;
- one H1 per file;
- one `## TL;DR` per file;
- valid relative Markdown links.

The validator is also designed to report oversized files, missing titles, missing TL;DR sections, broken local links, overlong paragraphs, and common agent-facing phrases.

## Remaining validation gap

The official `skills-ref` validator was not available through the container's package registry, and direct GitHub cloning was blocked by network resolution. The frontmatter and naming rules were therefore checked locally against the public Agent Skills specification rather than by the official CLI.

Trigger evaluation cases are included for both skills, but they were not benchmarked against multiple live agent runs in this environment. They are a starting point for later invocation testing, not evidence of measured trigger accuracy.
