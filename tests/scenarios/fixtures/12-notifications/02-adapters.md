# Adapters

Tool bindings and roles for this batch.

| Role | Tier | Tool | Why |
|---|---|---|---|
| tdd | heavy | Unit tests (TDD) | Testing framework |
| integration | heavy | Branch DB integration tests | Seam verification |
| browser-verification | light | agent-browser | L3 surface drive |
| human-assisted-verification | judge | human-assisted-verification skill | L5 only |

## Conventions

- Feature files are reviewed and merged to main before moving to L5 verification
- Evidence log must be updated at each stage transition
- Confidence scores are re-derived with fresh dates when evidence is added
