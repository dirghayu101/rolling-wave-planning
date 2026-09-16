# v2 acceptance criteria, from the developer's brief of 2026-09-16

Each row is one requirement the developer stated when commissioning v2, in their own terms. The
agent fills the "Agent check" column with evidence before handing over; the developer fills the
"Human verdict" column. `v2.0.0` is tagged only when every human verdict reads PASS or ACCEPTED.

| # | Requirement (developer's brief) | Where it lives now | Agent check (evidence) | Human verdict |
|---|---|---|---|---|
| 1 | One directory the developer maintains, holding rolling-wave-planning, pre-rolling-wave-planning, human-assisted-verification and the mentor documentation system; third-party skills (superpowers, etc.) stay out | Repo root `SKILL.md`; `skills/pre-rolling-wave-planning`, `skills/human-assisted-verification`, `skills/mentor-documentation-system`; symlinks in `~/.agents/skills` | | open |
| 2 | The bloated SKILL.md is decomposed so only relevant information loads at any given time | `SKILL.md` router (57 lines) + `references/` loaded one per phase; README "What loads when" table | | open |
| 3 | It is a state/context management system: quit at 30% context in any state, even mid-rant or mid-interview, and resume | `00-plan.md` `phase:` field; `planning/` checkpoints per pre-phase; `references/resume.md`; scenarios 01 and 02 | | open |
| 4 | The start of a rolling wave is the developer ranting; from there, solutions and design decisions | `pre-rolling-wave-planning` Phase 0 intake; `templates/intake.md` keeps the rant verbatim | | open |
| 5 | UI first: a rough wireframe of screens and their features (basic HTML), not implementation, so backend needs surface and agents do not invent unintuitive UIs | Phase 3 blueprint; `references/blueprint.md`; `templates/wireframe.html`; `ui-guidelines` role | | open |
| 6 | Pre-rolling-wave focuses on clarifying, interviewing and grilling for long-term decisions; methodology moves out of it | Pre-planning Phase 4 interview via `grilling`; execution discipline removed from pre-planning, fixed defaults in `references/lifecycle.md`, `review.md`, `verification.md` | | open |
| 7 | Rolling-wave mentions and enforces TDD | `references/lifecycle.md` `in-progress` gate names `superpowers:test-driven-development`; `tdd` role on every implementer packet | | open |
| 8 | Retain all the information in both skills; consolidate, do not lose | `CHANGELOG.md` 2.0.0 lists every drop; retention audits in the plan; `git show v1.0.0:` for the originals | | open |
| 9 | Push back and suggest better approaches; prefer existing proven tools | Brainstorm record in the plan file; kernel-plus-drivers frame; existing skills bound by role rather than re-implemented | | open |
| 10 | A central orchestrator with fresh-context subagents that use existing skills (ponytail, agent-browser, ui-ux-pro-max, next/stripe/supabase skills); a step that finds the right skill for a task, dynamically | `references/dispatch.md` packet contract, role table, description-grep fallback; `02-adapters.md` bindings | | open |
| 11 | Better verification of web and mobile: agent-browser, mobile simulator/MCP; levels: sub-feature, features together, human | `references/verification.md` ladder L1 to L5; L4 cross-feature at item level; surface coverage gate in `references/adapters.md` | | open |
| 12 | Raise confidence with agent-driven testing first; human-assisted steps only for the rest; no agent steps inside human verification (the human runs the SQL/CLI); two scores, agent-only and after-human | `skills/human-assisted-verification/SKILL.md` (zero agent steps, verdicts `open`); `agent` and `ceiling` in `references/verification.md` and `templates/feature.md` | | open |
| 13 | Confidence scores stay current across later phases, or say they will rise | Evidence log + re-derivation rule in `references/verification.md`; resume sweep promotes on human ticks | | open |
| 14 | Code review more often; a reuse review (the Supabase generated-types example) | `references/review.md` four review points; reuse and duplication dimension | | open |
| 15 | Human verification central and feature-specific; testing per feature and for features together | `01-verification.md` index + `verification/<n>.<f>-<slug>.md` + `group-<slug>.md`; L4 rows | | open |
| 16 | Documentation: mentor-documentation-system moved under; human docs written by an external CLI (codex today) from a feature boundary plus terms; decoupled from any model | `templates/doc-handoff.md`; docs-writer binding in `02-adapters.md` with subagent fallback; `human-engineering-docs` docs-writer contract | | open |
| 17 | Model-agnostic: no explicit model labels in the skill | tiers `judge`/`heavy`/`light`; vendor names only as examples in `references/adapters.md` (grep proves it) | | open |
| 18 | Out-of-scope work gets its own SSOT (a sibling dir with a README, brief description); improvements to the current batch stay in the flow | `references/resume.md` mid-flight inputs; `templates/deferred-README.md` | | open |
| 19 | Git init, public repo, first commit of the initial version as a revert point | github.com/dirghayu101/rolling-wave-planning; tag `v1.0.0` | | open |
| 20 | Version the skill | `VERSION`, `CHANGELOG.md`, git tags | | open |
| 21 | Line limits are soft and apply to documentation files, not agent files | `references/ssot-layout.md`; `validate_docset.py` warns | | open |
| 22 | Lifecycle: pending, in-progress (TDD), code-reviewed, agent verification, agent verified, documented, human verification, completed; the agent is done at documented | `references/lifecycle.md` feature and item stage sets (`reviewed`, `agent-verified`, `documented`, `merged` / `complete`) | | open |
| 23 | Keep all the good parts; the skill already works | Retention audit; execution-slot rules, ceremony, pause protocol, integrity sweep all carried over with their evidence sentences | | open |
| 24 | Verification tooling as a kickoff step (mobile MCP next time); suggest open-source tools | Surface coverage check and candidate table in `references/adapters.md`; mashric `adapters.default.md` records the mobile gap and the Maestro finding | | open |
| 25 | Skills like ponytail are referenced fresh so upgrades flow through | `references/dispatch.md`: name skills, never paraphrase; subagent invokes them itself | | open |
| 26 | The adapter config lives in the SSOT, lists available tools by category with instructions, a default is generated during pre-planning, and the developer swaps values | `templates/02-adapters.md`, `templates/adapters.default.md` (project defaults at `<project root>/adapters.default.md`), `references/adapters.md` detection and delta procedure | | open |
| 27 | graphify set up in the mashric repo, with an enable/disable switch | mashric branch `chore/graphify-code-map`: `.graphifyignore`, gitignored `graphify-out/`, repo-root `adapters.default.md` code-map row `enabled: true` | | open |
| 28 | README: every referenced skill, setup for macOS and Windows, skills.sh pointer, the problem explained (many skills, models, tools; configure the best without burning context), integrates the best of everything, written with a writing skill, no em dashes; verified to solve the stated problem | `README.md`; scenario 05 problem fit | | open |
| 29 | Per-role skill overrides in the config (e.g. swap the UI/UX skill used to build on top of the wireframe) | Skill roles section of `02-adapters.md`; `ui-implementation` role | | open |
| 30 | The test runs are documented in the README for reference | README "Tests" section (pending) | | open |
| 31 | The confidence rubric carries actionable steps ("what would raise this"), and agent-actionable raises are done, not listed | `references/verification.md`; `templates/feature.md` "What would raise this" | | open |
| 32 | Cheap agents do the dumb, simple verification work (take screenshots, compare against the agreed wireframe) so the orchestrator does not | `light` tier in `references/dispatch.md`; L3 comparison in `references/blueprint.md`; visual-diff adapter | | open |
| 33 | Some features must be tested together; the SSOT has a place for that testing phase | L4 cross-feature pass at item `agent-verified`; `verification/group-<slug>.md` for human group checks | | open |
| 34 | Documentation is not coupled to codex or to this skill's model; tomorrow's writer can be swapped | docs-writer binding in `02-adapters.md`; `templates/doc-handoff.md` is self-contained for any CLI | | open |
| 35 | Recording the model per dispatch was model-dependent; the record must be model-agnostic | Dispatch record holds tier and roles, never a model name; rogue-check reads tiers against `02-adapters.md` | | open |
| 36 | Human verification steps must not break the developer's flow: no "make the edit, then ask the agent to check via MCP" | Each L5 row's "Check it yourself" column holds the exact SQL/CLI/console path; no interrupt handshake | | open |
| 37 | Ceremony (branches, PR ladder, issues), pausing, execution-slot numbering and the integrity sweep are kept intact | `references/ceremony.md`, `references/resume.md` | | open |
| 38 | Explain in the README how to configure the best skills, models and tools without burning context, and how new tools such as graphify assimilate | README "Kernel plus drivers", "What loads when", "Adapters and roles", "Optional: a code map" | | open |

Added 2026-09-16 (post-compaction review round), from the developer's follow-up:

| # | Requirement (developer's brief) | Where it lives now | Agent check (evidence) | Human verdict |
|---|---|---|---|---|
| 39 | README leads with setup and use; people care about using it before understanding it | `README.md` Quick start and Referenced skills before The problem | | open |
| 40 | `adapters.default.md` is created at the project root by default, since projects have several feature dirs, spec dirs and monorepos | `references/adapters.md`, `references/ssot-layout.md`, `templates/adapters.default.md`, `skills/pre-rolling-wave-planning/SKILL.md`; mashric `adapters.default.md` at the repo root | | open |
| 41 | The generated defaults file supplies chosen values, never asks the developer to choose; comments only where they raise output quality (tool absence with detect command, invocation notes, honest gaps); machine paths only when an agent needs them; no em dashes | mashric `adapters.default.md` (93 lines); Capacitor gap closed as a row rather than narrated | | open |
| 42 | graphify installed at `~/.agents/skills` and linked everywhere else, following the existing convention | `~/.agents/skills/graphify` real dir; `~/.claude/skills/graphify` relative symlink; `references/dispatch.md` code-map row | | open |
| 43 | A bash script and a PowerShell script set up the symlinks and everything needed, tested in a container; the README says what the script does | `setup.sh`, `setup.ps1`, `setup/referenced-skills.txt`, `tests/setup/run.sh`; README Quick start | | open |
| 44 | Docker installed on this machine (CLI for the tests; Desktop GUI requested as well) | colima + docker CLI running; Docker Desktop cask needs the developer's sudo password | | open |
| 45 | Sub-skills work when installed as siblings by skills.sh, not only inside the repo | path rule in `skills/*/SKILL.md` resolves against the `rolling-wave-planning` skill dir | | open |
