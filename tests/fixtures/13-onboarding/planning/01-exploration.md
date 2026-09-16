# Exploration — New-user onboarding flow

Set at `phase: exploring`.

## Findings

- Signup handler: `apps/dashboard/routes/signup/complete.tsx` redirects to `/dashboard`
  unconditionally after account creation — confirms intake premise 1.
- Telemetry client: `packages/telemetry/client.ts` exposes `track(event, props)`; existing events
  already carry a `step` prop pattern used elsewhere (`checkout.step_completed`) — confirms intake
  premise 2, no new telemetry primitive needed.
- Workspace naming: `workspaces` table already has a `name` column, currently defaulted to
  "Untitled" at creation — the onboarding flow would just be moving an existing edit UI earlier,
  not building new storage.
- Invite-teammates: `apps/dashboard/routes/settings/team/invite.tsx` already implements the invite
  flow; onboarding step 2 can embed it rather than rebuild it.
- Connect-a-data-source: no existing single "connect" surface — there are per-integration setup
  pages (`routes/integrations/<provider>/setup.tsx`). Which one(s) the onboarding step should offer
  is premise 4, carried to the interview.

## Dispatched packets

- Exploration packet 1 (light): map the signup redirect path. Covered above.
- Exploration packet 2 (light): map existing telemetry event shape. Covered above.
- Exploration packet 3 (light): map existing invite and integration-setup routes. Covered above.

## Premises status

Intake premises 1 and 2: settled (see Findings). Premises 3 and 4 remain open for the interview.
