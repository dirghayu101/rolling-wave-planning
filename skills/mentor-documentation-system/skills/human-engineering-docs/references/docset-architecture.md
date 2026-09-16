# Docset architecture

## TL;DR

A docset is a small linked book whose chapters stay under 100 lines. `000-index.md` is the map and comprehensive abstract. Every other file answers one main question and links back to the index.

## Location

Default to:

```text
human/<task-slug>/
```

If the repository already has an explicit human-documentation root, use its `human/` child. Never place these files inside agent plan, scratch, task-state, or generated-code directories.

## Numbering

Use stable three-digit prefixes with gaps:

```text
000-index.md
010-context.md
020-current-system.md
030-architecture.md
040-feature-checkout.md
050-verification.md
060-debugging-map.md
070-limitations.md
```

Insert a new chapter between `030` and `040` as `035` rather than renaming the set.

## Required index

`000-index.md` contains:

- a comprehensive abstract in two to four short paragraphs;
- mode and status: planned, implemented, partially verified, verified, or superseded;
- the repository revision or evidence window;
- scope and explicit exclusions;
- suggested reading paths for overview, debugging, or implementation detail;
- a linked file map with one-sentence descriptions;
- material assumptions and unresolved questions.

## Splitting rule

Split by reader question, not arbitrary length. Good boundaries include one feature, one bug, one execution path, one architectural decision, one migration, one verification layer, or one debugging surface.

Split early when a file approaches 90 lines, contains more than one major execution path, or needs more than three substantial H2 sections. Do not cut a paragraph, code block, or causal explanation in half.

## Navigation

End each chapter with relative links to the index and useful adjacent chapters. Keep names stable after publication. When a chapter becomes obsolete, mark it superseded and link to the replacement rather than silently changing history.

Use the templates in `assets/` as scaffolding, not as mandatory empty sections.
