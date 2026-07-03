# AI Toolkit Roadmap

last_updated: 2026-07-02
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
   `../skillops/inventory/skills.yaml`. skillops stays a separate, active
   journal; do not create a repo-local `inventory/`.

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

## Do Not Do Yet

- Do not extend `setup-agent-team` into runtime-specific subagent launch or
  autonomous modes until manual execution packets have more real usage.
- Do not vendor unclear-license or non-commercial external skill content.
- Do not let the repo become a generic prompt dump.
- Do not resume `ai-workbench` implementation until a real task demands its
  first slice (`ai-workbench start dev-task`); the doc scaffold stays dormant.

## This Repo And Its Neighbors

This roadmap governs `ai-toolkit` only. Each layer records its own decisions:

- `skillops` — active. This repo's skill lifecycle journal; kept separate
  because it records evidence this repo intentionally does not hold.
- `ai-workbench` — dormant seed that consumes this repo via `AI_TOOLKIT_PATH`;
  revive on demand.
- `ai-ops-ecosystem-spec` — frozen (2026-07-02). Historical ADRs and
  contracts; this file replaced its roadmap for toolkit priorities only.
- Capture / second-brain layer (`ai-second-brain`,
  `ai-work-log-bootstrap`, `personal-diary-capture`) — governs itself in
  `../ai-second-brain/docs/roadmap.md`. Not governed from here.

## Update Rules

Update this file when a priority changes, a candidate skill is promoted or
rejected, or a repo in Ecosystem Status changes state. Do not record
implementation details or session history here.
