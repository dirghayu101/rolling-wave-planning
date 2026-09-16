# Blueprint — wireframes before backend decisions

Loaded at `phase: blueprint` (Phase 3 of `pre-rolling-wave-planning`), only when the effort has a screen. Paths here are relative to the repo root; SSOT paths are relative to the batch directory.

## Purpose

A blueprint is a **feature inventory per screen, not a design**. Left to design a screen themselves, agents produce interfaces nobody asked for: controls the developer never wanted, states that were never considered, navigation invented at implementation time. So the developer settles what the screen contains before any backend decision is made, and each control and each state then becomes a stated backend requirement in the item card.

The wireframe is the cheapest place to discover that a screen needs a filter, a pagination cursor, an empty state with a call to action, or a role the schema cannot express yet. Discovering it during implementation costs a migration.

## Procedure

1. **One plain-HTML file per screen**, copied from `templates/wireframe.html` into `planning/03-blueprint/<screen>.html`. Boxes and labels only: no CSS framework, no component library, no scripts, no colour work. The inline style block stays at the handful of border and spacing rules the template ships.
2. **List every control** on the screen: inputs with their types and validation, buttons with what they do, links with where they go, tables with their columns and sort or filter affordances.
3. **List every state**: empty, loading, error, success, and any partial state the screen has (unsaved, submitting, offline, read-only). A screen with one state is a screen whose states have not been thought about yet.
4. **List navigation**: how the user arrives, where each exit goes, and what a deep link into the screen must carry.
5. **List role-based variation**: what each role sees, what is hidden, what is disabled with an explanation versus absent entirely.
6. **Consult the `ui-guidelines` role's skill** bound in `02-adapters.md` (default `ui-ux-pro-max`) for **guideline lookup only**: form patterns, navigation patterns, accessibility requirements. Never for styling, palettes, typography or visual polish. A wireframe that looks designed has already failed its job.
7. **The developer reviews in a browser**: open the file locally, or drive the `browser-verification` adapter to screenshot it. Every control the developer changes or questions becomes a numbered interview question in Phase 4; nothing on a wireframe is settled by agent assumption.

## Output

- `planning/03-blueprint/<screen>.html`, one wireframe per screen.
- `planning/03-blueprint/inventory.md`, the table the item cards are built from:

  | Screen | Controls and states | Backend needs | Item |
  |---|---|---|---|
  | `<screen>` | `<control>`, `<state>`, ... | endpoint, table, column, policy, permission | `<n>-<item-slug>` |

Every row's backend needs are copied into that item's `0-card.md` as acceptance criteria. An entry with no item yet is an item the scaffold phase is missing.

## Later in the lifecycle

- **Implementation.** A screen feature's handoff packet carries the wireframe path and names the `ui-implementation` role's bound skill. The implementer builds from the wireframe's inventory, not from its own idea of the screen.
- **L3 verification.** The built screen is screenshotted through the `browser-verification` adapter, and a light-tier agent compares the screenshot against the wireframe control by control and state by state, reporting missing controls, missing states and invented ones. When a `visual-diff` adapter is bound, it produces the diff the agent reads; without one, the comparison is the agent's own reading of both images. The comparison result is an L3 evidence row in the feature's verification file.

## Red flags

- Styling in a wireframe: colours, fonts, spacing systems, a framework class. It is an inventory, not a mockup.
- A wireframe with no state list. Empty, loading and error are where the backend requirements hide.
- A screen feature packet that does not carry its wireframe path. The implementer then designs the screen again from scratch.
