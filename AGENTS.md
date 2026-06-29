# Repo Agent Guide

## Communication

- Use traditional Chinese to reply unless the user explicitly asks for another language.
- Prefer concise, direct engineering communication.
- If the repo is missing context, inspect first and create the minimum viable scaffolding before coding.

<!-- BEGIN baseline:karpathy-principles v0.1.0 -->
## Portable Agent Baseline: Karpathy Principles

- Think before coding: state assumptions, surface ambiguity, and ask when the safe interpretation is unclear.
- Simplicity first: prefer the smallest design that satisfies the request; avoid speculative abstractions or extra configuration.
- Surgical changes: touch only files and lines needed for the task, match local style, and mention unrelated concerns instead of editing them.
- Goal-driven execution: turn open-ended work into success criteria and verify the result with tests, scripts, inspection, or another concrete check.

Apply this baseline before ordinary implementation habits, but never use it to override explicit user instructions, safety rules, privacy boundaries, or stricter repo-local instructions.
<!-- END baseline:karpathy-principles -->

## Personal AI OS Roadmap

Before planning work related to methodology intake, engineering skills, agent
workflows, staff-level review, external workflow intake, or cross-system roadmap
decisions, read the canonical roadmap from the `ai-ops-ecosystem-spec` repo:

```text
spec/ROADMAP.md
```

In the standard sibling-repo workspace layout, this repo can reach it at
`../ai-ops-ecosystem-spec/spec/ROADMAP.md`. If that repo is not available, ask
the user where the canonical roadmap is cloned.

Use that roadmap as the current source of truth for priorities and for deciding
which workflows are still being grilled before becoming formal skills.

Before cross-repo AI OS work, run the central freshness check from the standard
sibling repo:

```text
../ai-ops-ecosystem-spec/scripts/check-ecosystem-repos.sh --fetch
```

## Repository Design

- Recommended repo name: `ai-agent-library`.
- `skills/` is the canonical source for reusable skills.
- `baselines/` is the canonical source for always-on agent baseline packs.
- `workflows/`, `agents/`, and `templates/` are planned source trees for
  reusable workflow definitions, role packs, and supporting templates.
- `.claude/skills/` is the Claude Code project adapter.
- `scripts/skills.ps1` is the public skill CLI.
- `scripts/baseline.ps1` is the public baseline CLI.
- Personal installs use symlinks by default through
  `~/.local/share/ai-agent-library/current`. On Windows, use Git Bash
  with real symlink support, such as elevated Git Bash plus
  `MSYS=winsymlinks:nativestrict`. `--copy` is only an explicit fallback.
  After moving or renaming the repo, run `scripts/skills/repair-personal-links.sh`.
- The upstream engineering skills are imported from `mattpocock/skills`; do not present them as original work from this repo.
- Local companion skills are `grill-spec`, `methodology-intake`,
  `capture-input-note`, `setup-agent-team`, `staff-level-review`,
  `ship-vertical-slice`, and `diagnose-regression`.
- Reusable candidate skills may live in `skills/engineering/`, but SkillOps
  lifecycle metadata belongs in `../skillops/inventory/skills.yaml`. Do not
  create a repo-local `inventory/` directory for SkillOps data.
- Preserve `NOTICE.md` when changing or refreshing imported skills.
- Update `docs/upstream-sources.md` before importing or refreshing external skill material.
- Read `docs/reference/repo-layout.md` and
  `docs/specs/0001-cross-tool-skills-repo.md` before changing layout or install
  behavior.
- Read `docs/specs/0005-capture-input-note-vs-methodology-intake.md` before
  changing either source-capture or methodology-adoption behavior.

## Delivery Loop

1. Clarify the request with `grill-spec` when the task is ambiguous, cross-cutting, or domain-heavy.
2. Update `CONTEXT.md` when a domain term or relationship is clarified.
3. Record an ADR only when the decision is hard to reverse, surprising without context, and the result of a real trade-off.
4. Implement with `tdd` or `ship-vertical-slice`: one behavior, one test, one slice at a time.
5. If behavior is broken or regressed, switch to `diagnose` or `diagnose-regression`.
6. End substantial work with a short verification summary and next-step risks.

## Repo Docs

- `CONTEXT.md`: glossary only. No implementation notes, no scratch planning.
- `docs/adr/`: architecture decision records and templates.
- `docs/agents/issue-tracker.md`: where work items live and how to create them.
- `docs/agents/triage-labels.md`: canonical triage states.
- `docs/agents/domain.md`: where agents should read domain context from.
- `docs/how-to/`: current operational guides.
- `docs/reference/`: current repo contracts and compatibility notes.
- `docs/intake.md`: repo-level queue of unprocessed notes and captures to grill later.
- `skills/`: repo-local skills that define reusable workflows.
- `baselines/`: repo-local always-on baseline packs with managed-block adapters.
- `.claude/skills/`: Claude Code adapter for project-local skill discovery.
- `scripts/`: deterministic install and verification commands.

## Default Engineering Standards

- Prefer small public interfaces with deep implementations.
- Tests should verify behavior through public interfaces, not implementation details.
- Prefer vertical slices over horizontal task splitting.
- Prefer deterministic scripts and explicit commands over vague instructions.
- Keep naming aligned with `CONTEXT.md`.
- Keep portable baselines distinct from skills: baseline packs are always-on
  managed instruction blocks; skills are triggered workflows.

## Local Issue Workflow

- Default tracker: local markdown issues under `.scratch/issues/`.
- File naming: `NNNN-short-kebab-title.md`.
- Each issue should describe user-visible behavior, scope, acceptance checks, and out-of-scope items.

## Safety

- 禁止批量刪除文件或目錄。
- 不要使用 `del /s`、`rd /s`、`rmdir /s`、`Remove-Item -Recurse`、`rm -rf`。
- 如需刪除文件，只能一次刪除一個明確路徑的文件。
- 如果需要批量刪除，停止並請用戶手動處理。
