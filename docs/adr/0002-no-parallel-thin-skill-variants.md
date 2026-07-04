# ADR 0002: No Parallel Thin Skill Variants

## Status

Accepted (2026-07-03)

## Context

A 2026-07-03 skill audit found three local skills that were thin rewrites of
imported `mattpocock/skills` skills, with overlapping trigger descriptions:

- `diagnose-regression` vs imported `diagnose` — both triggered on
  "broken / flaky / failing / slower than expected".
- `ship-vertical-slice` vs imported `tdd` — both triggered on implementing a
  feature one behavior at a time, test-first.
- `grill-spec` vs imported `grill-with-docs` — both triggered on grilling
  requirements/plans and clarifying domain language.

When two skills match the same trigger surface, the invoking model picks one
effectively at random. Picking the thin variant silently drops the full
methodology (for example `diagnose`'s feedback-loop-first discipline, or
`tdd`'s anti-horizontal-slicing rules and reference docs). This penalizes
weaker models the most, because they follow whichever skill loads and cannot
compensate for the missing steps.

## Decision

The same trigger surface must be owned by exactly one skill.

- `diagnose-regression` and `ship-vertical-slice` are retired. Their triggers
  route to `diagnose` and `tdd`. Do not recreate thin local variants of
  imported skills; if an imported skill's workflow needs local adjustments,
  edit the imported skill in place (MIT permits modification; record the local
  modification in `docs/upstream-sources.md`).
- `grill-spec` is kept but repositioned so its trigger is mutually exclusive
  with `grill-with-docs`: `grill-spec` is for when no concrete plan exists yet
  (its exit is a first vertical slice); `grill-with-docs` is for challenging
  an existing plan against `CONTEXT.md` and ADRs.
- `staff-level-review` is kept but narrowed to review-context-bundle,
  non-GitHub-diff, and fixed-output-contract scenarios, deferring routine
  local diff review to the built-in `/code-review`.

Lifecycle evidence for the retirements lives in
`../skillops/inventory/skills.yaml`, not in this repo.

## Alternatives Considered

- Keep all skills and only rewrite descriptions to be mutually exclusive:
  rejected because the thin variants added no methodology beyond the imported
  versions, so maintaining two near-identical workflows costs more than it
  returns.
- Retire `grill-spec` too and route everything to `grill-with-docs`: rejected
  because pre-plan requirements grilling with a vertical-slice exit is a real,
  distinct entry point that `grill-with-docs` does not provide.

## Consequences

- Positive: one skill per trigger surface; weaker models cannot pick a
  degraded variant.
- Positive: less duplicate maintenance when the imported skills are refreshed.
- Negative: the retired skills' Traditional Chinese phrasing is gone; if
  localization matters later, translate the canonical skill rather than
  forking it.
- Follow-up: when refreshing from `mattpocock/skills`, re-check that local
  modifications noted in `docs/upstream-sources.md` survive the refresh.
