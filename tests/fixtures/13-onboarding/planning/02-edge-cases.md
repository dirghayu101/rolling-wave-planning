# Edge cases and risks — New-user onboarding flow

Set at `phase: edge-cases`.

## Edge cases

- User reopens the signup confirmation email hours later and lands back on the flow: must resume
  where they left off, not restart (feeds interview round 3, premise 3).
- User closes the tab mid-flow with no explicit "skip": next login must not re-show a completed
  step, and must not silently skip an incomplete required step (workspace name).
- Team invite (step 2) sent to an email that is already a member: the invite step must handle
  "already invited" without erroring the whole flow.
- A workspace created via SSO provisioning (no manual signup) — does it enter this flow at all?
  Carried to the interview as an open question.
- Integration setup (step 3) fails (bad credentials, provider outage): the flow must let the user
  skip forward rather than getting stuck, since step 2 onward is already skippable (Decision 3).

## Blast radius

- Shared type: the `workspaces.name` column is read by several existing screens; moving its first
  edit earlier does not change its shape, only when it's first set.
- Downstream consumer: telemetry dashboards that already chart `checkout.step_completed`-shaped
  events will need a parallel onboarding funnel chart — out of scope for this batch, noted as a
  likely deferred item once this batch ships.

## Premortem

"This effort failed three weeks from now — why?" Most likely cause: the four-step count (Decision
2) turns out too rigid once the data-source step's provider list (premise 4) is decided, forcing a
mid-batch decision reversal. Noted so a reversal there is an edit to STATE, not a crisis.

## Questions graduating to the interview

- Progress persistence: server-side vs browser-local (premise 3).
- Data-source step scope: which provider(s), or a generic "connect later" fallback (premise 4).
- Does an SSO-provisioned workspace enter this flow.
