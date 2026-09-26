# Blueprint: wireframes before backend decisions

Loaded at `phase: blueprint` (Phase 3 of `pre-rolling-wave-planning`), only when the effort has a screen. Paths to templates are relative to this repo; SSOT paths are relative to the batch directory.

## Purpose

A blueprint is a **feature inventory per screen, not a design**. Left to design a screen themselves, agents produce controls nobody asked for, states nobody considered, and navigation invented at implementation time. The developer settles what the screen contains before any backend decision, and each control and state then becomes a stated backend requirement in the item card.

The wireframe is the cheapest place to discover that a screen needs a filter, a pagination cursor, an empty state with a call to action, or a role the schema cannot express yet. Discovering it during implementation costs a migration.

## Procedure

1. **One plain-HTML file per screen**, copied from `templates/wireframe.html` into `planning/03-blueprint/<screen>.html`. Boxes and labels only: no CSS framework, no component library, no scripts, no colour work.
   **Every wireframe and the index link the shared `templates/wireframe.css`**, copied once into `planning/03-blueprint/` beside them. No file carries an inline style block.
   **The three inventories are visible sections, not comments**: states, role variation and backend needs are `<details class="states">`, `<details class="roles">` and `<details class="backend">` in the body. Screen, Route, Roles and Item are a visible `<header><dl>`.
   **Sections are collapsible**: every screen box and every inventory is a native `<details>`/`<summary>`, with only the first section carrying `open`.
   **Plus one `planning/03-blueprint/index.html`**, copied from `templates/blueprint-index.html`: one table row per wireframe (link, Screen, Route, Roles, Item, question numbers) plus a suggested reading order. It is updated in the same edit as any wireframe it lists.
2. **List every control**: inputs with their types and validation, buttons with what they do, links with where they go, tables with their columns and sort or filter affordances.
3. **List every state**: empty, loading, error, success, and any partial state (unsaved, submitting, offline, read-only). A screen with one state is a screen whose states have not been thought about.
4. **List navigation**: how the user arrives, where each exit goes, what a deep link must carry.
5. **List role-based variation**: what each role sees, what is hidden, what is disabled with an explanation versus absent entirely.
6. **Consult the `ui-guidelines` role's skill** for **guideline lookup only**: form patterns, navigation patterns, accessibility requirements. Never for styling, palettes, typography or polish. A wireframe that looks designed has already failed its job.
7. **The developer reviews in a browser**, starting from `index.html`. Every control they change or question becomes a numbered interview question in Phase 4.
8. **The blueprint round's questions are written into `index.html` as the answer sheet.** A numbered block at the foot of the index, one `<details class="question">` per question, each with options, one-line trade-offs, the recommendation marked on the option it belongs to, and a free-text note. `templates/blueprint-index.html` carries the block, the draft-to-localStorage script and the Download and Copy actions; that script is the ONE script the blueprint directory holds. **Save the export verbatim as `planning/03-blueprint/round-<n>-answers.md`**, never retyped and never tidied, then record the round in `planning/04-interview.md` from it. A question marked "discuss" or left blank is not settled: carry it into the next round.

## Output

- `planning/03-blueprint/<screen>.html`, one wireframe per screen.
- `planning/03-blueprint/index.html`, the navigation table.
- `planning/03-blueprint/wireframe.css`, the shared readability sheet.
- `planning/03-blueprint/round-<n>-answers.md`, the developer's export, saved verbatim.
- `planning/03-blueprint/inventory.md`, the table the item cards are built from:

  | Screen | Controls and states | Backend needs | Item |
  |---|---|---|---|
  | `<screen>` | `<control>`, `<state>`, ... | endpoint, table, column, policy, permission | `<n>-<item-slug>` |

Every row's backend needs are copied into that item's `0-card.md` as acceptance criteria. An entry with no item yet is an item the scaffold phase is missing.

## Later in the lifecycle

- **Interview.** An answer that changes a control, a state or a route updates the wireframe, `inventory.md` and `index.html` in the same pass as the decisions table, before the next round is asked. The implementer builds from the wireframe, so a change living only in the decisions table leaves the SSOT contradicting itself.
- **Implementation.** A screen feature's packet carries the wireframe path and names the `ui-implementation` role's bound skill.
- **L3 verification.** The built screen is driven through the `browser-verification` adapter, and a `light`-tier agent compares the capture against the wireframe control by control and state by state, reporting missing, invented and mis-stated controls. The comparison result is an L3 evidence entry in the feature's `.log.md`.

## Red flags

- Styling beyond the shared `wireframe.css`: a brand colour, a component library, a framework class, an inline style.
- A wireframe with no state list. Empty, loading and error are where the backend requirements hide.
- A decision row that changes a control with no matching edit in the wireframe and the inventory.
- A screen feature packet that does not carry its wireframe path.
- Two or more wireframes and no `index.html`, or an index whose rows disagree with the wireframe headers.
- A script anywhere in `03-blueprint/` other than `index.html`.
- An answer sheet exported and then summarised instead of saved verbatim.
