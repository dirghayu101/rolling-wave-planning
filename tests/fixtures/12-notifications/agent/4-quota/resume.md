# Resume: item 4, in-app quota indicator

One block, overwritten every time. Never appended to.

## Where the item is

Stage `open`. Feature 4.1 (quota-banner) is `merged` into `12-notifications.4`. Feature 4.2
(quota-settings) is `reviewed`: PR 221 is ready, its one review came back clean at 9b2d5af0.
Feature 4.3 (quota-upgrade-modal) has not been opened; it has no HEAD file, no log and no flow.

## What is in flight

PR 221 only. No dispatch is outstanding. The local Supabase stack is deliberately left up
(`kept:` row in `2-quota-settings.log.md`) because item 4's L4 pass runs on it.

## The exact next step

Take feature 4.2 from `reviewed` to `merged`:

1. Invoke `human-assisted-verification` to write `verification/4.2-quota-settings.md`, every
   verdict cell reading `open`, riding PR 221.
2. Merge PR 221 into `12-notifications.4` with a merge commit.
3. Set the card's 4.2 row to `merged` and overwrite this file.

## The facts the next step rests on

- 4.2's L1 to L3 evidence is complete at 9b2d5af0; nothing at L1 to L4 is left for an agent to run on it.
- 4.2 needs no runbook: it ships no migration and no key.
- The item's L4 pass is gated on 4.3, so it does not run at 4.2's merge.
- Feature 4.3's wireframe state already lives in `planning/03-blueprint/quota-settings.html`.
