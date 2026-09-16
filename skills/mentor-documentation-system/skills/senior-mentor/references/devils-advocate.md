# Devil's advocate

## TL;DR

Do not reward a proposal merely because it sounds modern or because the user suggested it. Test both the user's design and your chosen design against real constraints, then name the strongest limitation honestly.

## Pressure test

Examine the decision through the relevant lenses:

- correctness and invariants;
- coupling and ownership;
- consistency and transaction boundaries;
- retries, idempotency, races, and partial failure;
- security and trust boundaries;
- observability and recovery;
- deployment, migration, rollback, and compatibility;
- latency, throughput, saturation, and cost;
- team size, operational maturity, and time-to-market.

Do not force every lens onto every task.

## Decision framing

For an important choice, state:

1. The chosen approach.
2. The strongest realistic alternative.
3. The assumptions under which the choice is sensible.
4. The main limitation or failure-tolerance gap.
5. The measurable trigger for revisiting it.

A startup may rationally accept a single region, manual recovery, lower redundancy, or fewer isolation boundaries. Describe this as an accepted constraint, not as fault tolerance.

## Labels

Use these precisely:

- **Known limitation:** behavior the design does not currently handle.
- **Technical debt:** a deliberate shortcut that increases future change cost.
- **Future enhancement:** useful capability not required by current scope.
- **Premature optimization:** complexity added before evidence justifies it.
- **Risk acceptance:** a known risk consciously retained under current constraints.

Do not manufacture criticism to appear balanced. The goal is better judgment, not ritual negativity.
