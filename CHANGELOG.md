# Changelog

All notable changes to this skill family are recorded here. Versions follow semver.

## 2.0.0 - 2026-09-16

The restructure. One repo, one router, one file loaded per phase, drivers bound by role.

### Added
- `SKILL.md` is a router: core principles, find the SSOT, read `phase:` and `layout:` from
  `00-plan.md`, load exactly one target. Everything else moved to `references/`.
- `references/`: `ssot-layout`, `lifecycle`, `dispatch`, `review`, `verification`, `blueprint`,
  `adapters`, `ceremony`, `resume`.
- `templates/`: `00-plan`, `0-card`, `feature`, `02-adapters`, `adapters.default`,
  `handoff.agent`, `doc-handoff`, `verification-feature`, `deferred-README`, `wireframe.html`,
  `intake`.
- Pre-planning phases `intake` (the SSOT is created at minute zero and the developer's rant is
  kept verbatim in `planning/00-intake.md`) and `blueprint` (plain-HTML wireframes as a feature
  inventory per screen). Every phase writes a checkpoint before its work, so a session can end
  at any point and resume there.
- `02-adapters.md` per batch, seeded from `<project root>/adapters.default.md` and fresh
  detection; roles (`simplicity`, `tdd`, `ui-implementation`, `browser-verification`, ...) bound
  to installed skills, tools and model-tier aliases. Kickoff shows only the delta. A surface with
  no verification tool is a recorded decision, not a silent ceiling.
- Verification ladder L1 to L5 with a dated evidence log per feature, and the rubric evaluated
  twice: `agent` (L1 to L4) and `ceiling` (as if every human row passed). Later phases append
  evidence and re-derive; the resume sweep promotes items when human rows all read PASS.
- Five review points per feature/item/batch, with reuse and duplication as a review dimension. Four
  ride a PR; the fifth is the audit below, which is the only one that does not.
- `setup.sh` and `setup.ps1`: link the six skill entries into a skills directory, verify each
  resolves, report referenced skills present or missing with an install command, and report the
  tools on PATH. `--check` is the health check after either install path. `tests/setup/run.sh`
  proves both in Docker containers (Ubuntu for bash, the official PowerShell image for pwsh).
- Sub-skill paths resolve against the `rolling-wave-planning` skill directory (a sibling in the
  skills folder, or the repo root), so the family works both cloned and installed by skills.sh.
- A `framework` trigger for `@capacitor/core` in `references/dispatch.md`, with no default skill
  bound until one is installed.
- Docs chapter per feature, written on the feature branch by the docs-writer binding (an external
  CLI, or a subagent fallback that is not a failure state).
- Testing plan at three levels: the feature file's per-layer table, the card's `## Test strategy`
  (the item's L4 flow and cross-item group, the environment, the non-functional criterion, and how
  it was actually tested, filled at the item's open gate and closed at `agent-verified`), and
  `00-plan.md` § Testing plan (cross-item groups, end-to-end flows, environment, load criteria,
  written from the interview's testing round). `02-adapters.md` gained an `Environment` category
  beside load testing (Docker, a compose file, the Supabase local stack, testcontainers, staging),
  and the confidence rubric gained a sixth dimension, environment fidelity and stated limits.
- Ephemera cleanup. The dispatch packet has an eighth required slot, `Ephemera`: one scratch
  directory named on the packet for everything a subagent writes outside the repo and the SSOT,
  and a required "Ephemera started" list in the evidence it returns. Each line becomes a row in
  the item's `## Ephemera` ledger (`| What | Where | Teardown | Swept on |`) in
  `working/<item>.agent.md`. The item `agent-verified` gate, the batch `done` gate and the pause
  ceremony sweep that ledger: every row teardown-run and dated, or `kept: <reason>`.
  `02-adapters.md` gained a `Cleanup` category (scratch root, teardown lines in the order they
  run, cache to reclaim, and the date each line was actually run once), so nothing
  machine-specific reaches a packet.
- Acceptance list from the rant. Pre-planning Phase 0 writes `planning/00-acceptance.md` from
  `templates/00-acceptance.md`, one row per requirement in the developer's own words plus a fixed
  block of implicit rows (security pass on flagged surfaces, tested as far as L1 to L4 allow,
  a docs chapter per feature, no machine-specific binding in shared files, standing rules
  honoured). The interview's first round confirms the list before any design question. Cards carry
  `Acceptance rows served:`, the item `agent-verified` gate appends evidence to those rows, the
  batch `done` gate refuses a row still reading `open`, and `00-plan.md` STATE carries
  `acceptance: <n> of <m> rows met`. Resume does not load the file, so the entry load stays O(1).
  Agents never write `met`; the developer does, exactly as with an L5 verdict.
- Audit pass, the fifth review point and the only one not attached to a PR. `heavy` tier, fresh
  context, `templates/audit-handoff.md`, reading only `00-plan.md`, `planning/00-acceptance.md`,
  the open item's working file and `02-adapters.md`. Triggers are observable rather than
  scheduled: N dispatches since the last `audit` row (`dispatches_per_audit` in `02-adapters.md`
  § Audit, default 8), every pause, and before the batch PR opens. Findings and realignment actions go into `00-plan.md` STATE; the audit is recorded as a
  dispatch row, which resets the count. A harness scheduler is an optional binding in
  `02-adapters.md`, never part of the skill.
- `tests/scenarios/`: eight fresh-agent scenarios that gate a release. `07-acceptance-from-the-rant`
  (cold start from a rant; the baseline run wrote no acceptance file, RED confirmed 2026-09-17) and
  `08-ephemera-and-audit` (fixture 12 patched with Cleanup and Audit sections and six dispatch rows;
  the baseline run wrote no Ephemera slot and no audit packet, RED confirmed 2026-09-17). Both
  passed against the changed skill on 2026-09-17; scenarios 01 and 03 re-ran clean on the patched fixture.
- `TODO.md`: work that is deliberately parked, one entry per item with what is missing, why, and
  what closes it.
- `README.md`, `LICENSE` (MIT), `VERSION`.

### Changed (breaking for new batches; existing batches keep `layout: v1`)
- Lifecycle: feature `pending -> in-progress -> reviewed -> agent-verified -> documented -> merged`;
  item `pending -> in-progress -> agent-verified -> documented -> complete`. `code-done` and
  `verified` are gone. `documented` is the agent's terminal state.
- `human/` is `docs/`, one chapter per feature with three-digit reading-order prefixes.
- `human-assisted-verification` has zero agent steps: each row carries the exact query or command
  the human runs. The interrupt handshake is gone; its 24h concern is a time-sensitive row flag.
- Line caps are soft targets on human-facing files only; `validate_docset.py` warns instead of
  failing. Agent files have no cap.
- Model-vendor names appear only as examples in `references/adapters.md`. Skill bodies name
  tiers (`judge`, `heavy`, `light`) and roles.
- `pre-rolling-wave-planning` no longer has an execution-discipline phase; TDD, review cadence
  and verification are fixed defaults in the main skill.
- `mentor-documentation-system` ships inside this repo; `human-engineering-docs` and
  `senior-mentor` are invocable by name through symlinks.

### Removed
- `02-deferred.md`. Out-of-scope work becomes a sibling stub directory `<M>-<slug>/README.md`,
  linked from `00-plan.md`, and is the intake seed when picked up.
- Item-level `rollout/<n>-<item>/docs/`. Architecture notes become a reading-order chapter in the
  batch `docs/`.
- The repo-specific project-state-table step in the pause ceremony (generalised).

### Fixed
- `tests/setup/run.sh` skips its PowerShell cases when the Docker daemon is not amd64. The
  `mcr.microsoft.com/powershell` image is amd64-only and crashes at startup under Docker Desktop's
  emulation on Apple silicon (exit 134 or 139); the cases passed under colima, so `setup.ps1`
  itself is not known to be broken. `RUN_PWSH=1` forces them to run. Building an arm64 PowerShell
  test image so the skip stops being necessary is parked in `TODO.md`.
- Frontmatter descriptions state only when to use. The human-assisted-verification description
  is quoted, because an unquoted colon broke strict YAML parsers (skills.sh skipped the skill).

## 1.0.0 - 2026-09-16

Verbatim import of the four skills as they existed before the v2 restructure:
`rolling-wave-planning` (SKILL.md, ceremony.md, feature-file-template.md),
`pre-rolling-wave-planning`, `human-assisted-verification`, and the
`mentor-documentation-system` bundle. No content edits. Tag `v1.0.0` is the
revert point.
