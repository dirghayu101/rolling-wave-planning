# Use cases: template

Template for `rolling-wave-planning`. Lives at `use-cases/<area>.md`, one file per area of the product, grouped by who does the work (for example `terminal-staff.md`, `store-operator.md`, `accounts.md`). Written by the `heavy` tier before any screen that serves the use case is wireframed, and extended (never copied) when a later item exercises the same use case.

**A use case states a goal, never a how.** The developer runs the `ready` ones freely on dev and finds the steps themselves; that is how they review the flow and discover missing features. Forbidden in a use case: steps, button labels, routes, control names, SQL, expected values. If the reader needs a step to succeed, either the UI fails the use case (a finding, returned as a `feedback/` round) or the detail belongs in a verification file.

Ids are `UC-<n>`, unique in the batch and never renumbered. Status is `ready` when every flow the use case needs is merged into the batch branch, otherwise `waiting on item <n>`.

## Template: copy verbatim, replacing bracketed text

```markdown
# Use cases: <area> (<who does this work>)

## UC-<n> <One-line title>

- **Who:** <role>
- **Situation:** <what just happened in their day>
- **Goal:** <what they want to be true>
- **Done when:** <the outcome they can see, in product terms>
- **Variations:** <two or three one-liners, or delete the line>
- **Items:** <item numbers whose flows it exercises>
- **Status:** ready | waiting on item <n>
```

## Example

```markdown
# Use cases: store operator (the person who runs the store's stock)

## UC-3 Check what happened to an item before reordering it

- **Who:** store operator
- **Situation:** the walk-in fridge looks short on oat milk and the weekly order is due.
- **Goal:** know whether the oat milk is really running low or was used up, wasted or miscounted.
- **Done when:** they can say how much was used, wasted and received over the last two weeks, and decide the order quantity.
- **Variations:** an item that was recounted mid-week; an item with no activity at all.
- **Items:** 2, 4
- **Status:** ready

## UC-4 Ask head office for supplies

- **Who:** store operator
- **Situation:** two items are nearly out and one more is needed that the store has never stocked.
- **Goal:** get all three requested in one go.
- **Done when:** the request is submitted and they can see it is waiting for head office.
- **Variations:** a request with one inventory item and one item that is not in inventory; a request abandoned half-written and resumed the next day.
- **Items:** 5, 6
- **Status:** waiting on item 6
```
