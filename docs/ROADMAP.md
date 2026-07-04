# AI Toolkit Roadmap

last_updated: 2026-07-03
status: active

This file is the current source of truth for toolkit priorities. It replaces
`../ai-ops-ecosystem-spec/spec/ROADMAP.md`, which is frozen as historical
reference (see Ecosystem Status below).

## Current Focus

1. Keep `ai-toolkit` as the center of gravity: canonical skills, baselines,
   and install/verify tooling that get daily use.
2. Use `methodology-intake` as the gatekeeper before promoting workflow ideas
   into formal skills. Do not promote unvalidated candidates.
3. Use real project work (for example `carman_church_website` vertical slices)
   to validate skills before expanding the skill set.
4. Record skill lifecycle status, evidence, and promotion decisions in
   `docs/skills-inventory.yaml` (this repo's skills only; the skillops
   journal was frozen and split on 2026-07-03).

## Next Actions

1. Use existing engineering skills on the next `carman_church_website`
   vertical slice before adding new skills.
2. Use `methodology-intake` to evaluate `artifact-reconstruction-loop`,
   `research-spike`, and `second-brain-formulate`.
3. Run `./scripts/skills.ps1 verify` after skill or adapter changes, and
   `./scripts/baseline.ps1 verify` after portable baseline changes.
4. Design future baseline packs in maturity order, starting with
   `git-collaboration-hygiene` rollout and `existing-repo-orientation`.
5. Forward-test `capture-input-note` on one meeting/video source before
   building any meeting-specific workflow.
6. Forward-test `social-live-photo-card` on one real user-provided short video
   before expanding it beyond trial status.
7. Done 2026-07-03: `docs/skills-inventory.yaml` adopted as this repo's
   lifecycle record (skillops inventory split executed; tickets in
   `ecosystem-audit-2026-07.md`).
8. Decide the single owner of multi-agent execution packets —
   `setup-agent-team` (this repo) vs ai-workbench task packets — before
   ai-workbench starts its Phase 2. One absorbs the other's role.
9. Add `review_by: 2026-10-01` sunset review to both baseline packs: at
   review, keep only rules with a concrete example of changing a session's
   behavior in the past 90 days.

## Recent Skill Decisions

- 2026-07-03: retired `ship-vertical-slice` and `diagnose-regression` as thin
  duplicates of `tdd` and `diagnose`; repositioned `grill-spec` (pre-plan
  grilling) and `staff-level-review` (bounded/non-GitHub review contract). See
  `docs/adr/0002-no-parallel-thin-skill-variants.md`; lifecycle evidence lives
  in `docs/skills-inventory.yaml` (split from skillops on 2026-07-03).
- 2026-07-03: ecosystem audit (`ecosystem-audit-2026-07.md`) froze
  skillops; this repo's lifecycle records now live in
  `docs/skills-inventory.yaml` (split executed 2026-07-03). Skill
  effectiveness evidence will come from a skill-usage hook log plus optional
  `skills_used` capture frontmatter, rolled up monthly by a cheap model.

## Do Not Do Yet

- Do not extend `setup-agent-team` into runtime-specific subagent launch or
  autonomous modes until manual execution packets have more real usage.
- Do not vendor unclear-license or non-commercial external skill content.
- Do not let the repo become a generic prompt dump.

## This Repo And Its Neighbors

This roadmap governs `ai-toolkit` only. Each layer records its own decisions:

- `skillops` — frozen (2026-07-03 ecosystem audit). Lifecycle records split
  to each canonical repo; this repo's records live in
  `docs/skills-inventory.yaml` (split executed 2026-07-03).
- `ai-workbench` — active (Phase 1 dev-task CLI implemented 2026-07); consumes
  this repo via `AI_TOOLKIT_PATH` and governs itself in its own repo.
- `ai-ops-ecosystem-spec` — frozen (2026-07-02). Historical ADRs and
  contracts; this file replaced its roadmap for toolkit priorities only.
- Capture / second-brain layer (`ai-second-brain`,
  `ai-work-log-bootstrap`, `personal-diary-capture`) — governs itself in
  `../ai-second-brain/docs/roadmap.md`. Not governed from here.

## Update Rules

Update this file when a priority changes, a candidate skill is promoted or
rejected, or a repo in Ecosystem Status changes state. Do not record
implementation details or session history here.
