# Interview — New-user onboarding flow

Set at `phase: interview`. Transcript accumulates round by round; a settled question is never
re-asked.

## Round 1 — 2026-09-14

1. **Entry point: modal over the dashboard, or a real page at its own route?**
   - Modal: faster to build, but not resumable from a reopened email link, and doesn't survive a
     page refresh cleanly.
   - Real page (`/onboarding`): resumable, bookmarkable, survives refresh.
   - Recommendation: real page, given the "reopen the signup email later" constraint.
   - **Answer: real page.** → Decision 1.

2. **Step count: fixed list, or dynamic based on workspace type?**
   - Fixed 4 steps (name, invite, connect, first action): simple, ships fast.
   - Dynamic: more correct long-term, no evidence yet that different workspace types need
     different steps.
   - Recommendation: fixed 4 steps for v1; revisit if usage data says otherwise.
   - **Answer: fixed 4 steps.** → Decision 2.

## Round 2 — 2026-09-15

3. **Skip affordance: allowed from step 1, or only from step 2 onward?**
   - From step 1: maximum flexibility, but workspace name is a hard dependency for every later
     screen.
   - From step 2 onward: step 1 stays required, everything after is optional.
   - Recommendation: step 2 onward, since step 1 has no fallback default worth shipping.
   - **Answer: step 2 onward.** → Decision 3.

## Round 3 — not yet asked

Next questions, per `planning/02-edge-cases.md`: progress persistence (server-side vs
browser-local) and the data-source step's provider scope. Resume here.
