# Planning mode

## TL;DR

Translate a machine-oriented plan into a reader model of what will be built, why, in what order, under which assumptions, and how success will be checked. Keep the current wave detailed and future waves progressively less specific.

## Evidence

Read the user's request, existing plans, relevant code, tests, schemas, local conventions, and current system behavior. Planned architecture must be grounded in the repository, not an idealized rewrite.

Label proposed files, symbols, schemas, and behavior as **Proposed**. Do not cite line numbers for code that does not exist.

## Structure

Choose only relevant chapters:

- context and problem;
- current system and constraints;
- shared architecture and execution path;
- one chapter per feature, bug group, or migration;
- cross-cutting data, security, caching, or observability concerns;
- delivery sequence and dependencies;
- verification and acceptance criteria;
- risks, limitations, and future enhancements;
- debugging and operational entry points.

For four features, prefer four focused feature chapters plus shared architecture and verification chapters. Do not combine unrelated features to reduce file count.

## Rolling-wave detail

The nearest implementation wave may include concrete files, symbols, contracts, tests, and sequence. Later waves should state goals, dependencies, assumptions, and decision points without pretending unknown details are settled.

Mark each chapter or section as one of:

- **Committed:** approved and ready to implement.
- **Proposed:** current design, still revisable.
- **Tentative:** direction only; details depend on earlier evidence.
- **Blocked:** cannot be planned responsibly until a named question is answered.

## Human voice

Do not copy task checklists, agent commands, internal delegation, or scratch reasoning into the docset. Explain the plan in past/current/future tense appropriate to its status.

## Devil's advocate

For consequential design choices, include the strongest realistic alternative, the assumptions favoring the proposal, its main limitation, and the trigger for revisiting it.

A plan is not verified behavior. Keep acceptance criteria separate from completed verification.
