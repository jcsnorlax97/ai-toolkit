# Handoff: 2026-07-03 Skill / Baseline Audit

One-time deep audit of this repo's skills, baselines, and install chain,
followed by user-approved fixes. This file records the judgment basis, the
parts that remain uncertain, and instructions for future (possibly weaker)
models. Read it together with
`docs/adr/0002-no-parallel-thin-skill-variants.md`.

## What changed and why

1. **Retired `diagnose-regression` and `ship-vertical-slice`.**
   Evidence: their SKILL.md descriptions triggered on the same signals as the
   imported `diagnose` and `tdd` ("broken/failing/slower", "one behavior at a
   time"), while containing strict subsets of the methodology. See ADR 0002.
   Lifecycle records: `../skillops/inventory/skills.yaml`.

2. **Repositioned `grill-spec` and `staff-level-review` descriptions.**
   `grill-spec` = pre-plan requirements grilling, exits with a first vertical
   slice; `grill-with-docs` = challenge an existing plan against docs.
   `staff-level-review` = fixed findings/verdict contract, review context
   bundles, non-GitHub diffs; routine diff review goes to built-in
   `/code-review`.

3. **Added a lightweight route to `improve-codebase-architecture`.**
   Single-module / narrow questions skip the HTML report and present markdown
   candidates inline. Recorded as a local modification in
   `docs/upstream-sources.md` (imported skill, MIT).

4. **Baseline wording (packs bumped 0.1.0 → 0.2.0; `oop-extension-safety`
   was already 0.2.0 and went to 0.3.0).**
   - "Apply this baseline before ordinary X habits" → "This baseline takes
     precedence over ordinary X habits". The old wording read as temporal
     ordering ("do this first"), which could make a weaker model run
     baseline rituals before starting work. The intent was always precedence.
   - `code-doc-sync` principle 1 narrowed: check docs only when the repo has
     architecture docs AND the change affects observable behavior or a
     contract; purely internal changes are exempt. The old wording ("any
     method signature ... runtime control flow") matched nearly every edit
     and invited full-repo doc scans on trivial fixes.
   - `repo-context-grounding/baseline.md` gained Status/Version/Priority
     sections for format consistency (block content unchanged).
   - Managed blocks re-applied to this repo (CLAUDE.md, AGENTS.md,
     `.github/copilot-instructions.md`) and to `../a-ai-codex/CLAUDE.md`.

5. **Personal install chain repaired.**
   Every symlink in `~/.claude/skills` and `~/.codex/skills` had been broken
   since the repo was renamed from `agentic-engineering-skills` to
   `ai-toolkit` — the stable link `~/.local/share/agentic-engineering-skills/current`
   pointed at the old, deleted clone path, so **no toolkit skill was loading
   in any project without a project-local adapter**. Fixed by running
   `./scripts/skills-setup/repair-personal-links.sh` (now links through
   `~/.local/share/ai-toolkit/current`). Removed 34 leftover `.tmp-link.*`
   symlinks (17 per tool dir) created by a pre-fix installer bug on
   2026-06-09 (fixed logically in commit `4a59660` the same night, but the
   leftovers were never cleaned). Added one defensive `unlink` to the
   `mv`-failure path in `scripts/lib/personal-skill-install.sh`, and a
   warn-only personal-install check at the end of
   `scripts/skills-setup/verify.sh` so this failure mode is no longer
   invisible to the documented verify command.

6. **Doc drift fixed.** CONTEXT.md no longer claims `capture-input-note`
   lives here (it lives in `../ai-second-brain`); CLAUDE.md / AGENTS.md /
   README.md skill and baseline lists match the actual tree; ROADMAP has a
   one-line record of the retirements.

## Judgment basis (how conclusions were reached)

- Read every `SKILL.md` under `skills/`, all 7 `baselines/*/baseline.md` and
  their adapter blocks, CONTEXT.md, ROADMAP, specs list, NOTICE.md,
  upstream-sources.md, and the installer library.
- Compared trigger descriptions pairwise for overlap; compared adapter copies
  against canonical sources (no drift; project adapters are symlinks).
- Inspected the live `~/.claude/skills`, `~/.codex/skills`, and
  `~/.local/share` state to find the broken chain, and git history
  (`4a59660`) to date the tmp-link leak.
- User-supplied usage facts: `client-flow-diagrams` and
  `improve-codebase-architecture` are frequently used; most others rarely or
  never. This informed which skills got usability fixes vs. retirement.

## Not fully verified / watch out

- **`.tmp-link` leak root cause is dated, not reproduced.** The leftovers'
  timestamps (2026-06-09 23:42) predate the fix commit (23:46), so they are
  attributed to the pre-fix `mv -f` logic. The current logic was not
  fuzz-tested; the added `unlink` is defensive.
- **Break-start date unknown.** It is unclear how long the personal installs
  were broken (the rename commit was not traced). Any "skills weren't
  helping" impressions from that window are contaminated by skills simply not
  loading.
- **`oop-extension-safety` principle 4 was deliberately left alone.** It is
  prescriptive (push variation into declaration-level generics) and could
  make a weaker model over-generalize unrelated classes. It has a scoping
  clause, so it was judged medium-risk; revisit if over-engineering shows up
  in repos using this pack.
- **Downstream repos other than this one and `../a-ai-codex` still carry
  v0.1.0 baseline blocks.** Re-run
  `pwsh ./scripts/baseline.ps1 apply <pack> -TargetRepo <repo>` in each repo
  that has managed blocks to pick up the 0.2.0 wording.
- **Skill metadata schema is still inconsistent** (`query-azure-devops` uses
  flat frontmatter fields; `social-live-photo-card` nests under `metadata:`;
  most skills have none). verify.sh accepts both. Not fixed this round —
  standardize when there is a reason to touch those files anyway.
- **staff-level-review usefulness is still unproven in practice.** It was
  kept on design quality and its non-GitHub niche, not on usage evidence. If
  it stays unused after the narrowed trigger, retire it via the same process
  as ADR 0002.

## Instructions for future models

- Do not recreate `diagnose-regression` or `ship-vertical-slice`, and do not
  add new thin local variants of imported skills. See ADR 0002. If a skill
  needs different behavior, edit the canonical skill and note it in
  `docs/upstream-sources.md`.
- One trigger surface, one skill. Before adding a skill, grep existing
  descriptions for overlapping trigger language.
- Skill lifecycle data (status, confidence, evidence) goes to
  `../skillops/inventory/skills.yaml`, never into this repo.
- After moving or renaming this repo clone, run
  `./scripts/skills-setup/repair-personal-links.sh`. If
  `./scripts/skills-setup/verify.sh` prints a personal-install WARN, that is
  the signal.
- When changing baselines: edit `baselines/<pack>/baseline.md` AND its three
  `adapters/*.block` files, bump the version in `pack.json`, then re-apply
  with the baseline CLI and run `pwsh ./scripts/baseline.ps1 verify`.
- Deletions in this repo: one explicit file path at a time; never recursive.
