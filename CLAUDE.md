# Claude Project Instructions

Use traditional Chinese unless the user explicitly asks for another language.

## Project Purpose

This repo stores reusable AI agent assets: skills, baselines, workflow
definitions, agent role packs, and supporting templates. Treat `skills/` as the
canonical source for invoked skills. Treat `.claude/skills/` as the Claude Code
project adapter.

Treat `baselines/` as the canonical source for always-on baseline
packs that can be applied to repo instruction files through managed blocks.

Reusable candidate skills may live here, but SkillOps lifecycle metadata does
not. Record status, confidence, evidence, and promotion decisions in
`../skillops/inventory/skills.yaml`. Do not create a repo-local `inventory/`
directory for SkillOps data.

## Required Context

- Read `CONTEXT.md` before creating, renaming, or substantially changing skills.
- Read `docs/reference/repo-layout.md` and `docs/specs/0001-cross-tool-skills-repo.md` before changing repository layout or install behavior.
- Use `docs/adr/0000-template.md` for decisions that are hard to reverse and need future context.

## Skills

The following skills are imported from `mattpocock/skills`; preserve attribution
in `NOTICE.md` and `docs/upstream-sources.md` when changing or refreshing them.

- Use `/diagnose` for disciplined debugging and performance regression work.
- Use `/grill-with-docs` when plans need to be challenged against domain language and ADRs.
- Use `/improve-codebase-architecture` for architecture review and refactoring opportunities.
- Use `/prototype` for throwaway design or UI experiments.
- Use `/setup-matt-pocock-skills` when a downstream repo needs agent-skill configuration.
- Use `/tdd` for test-first feature or bug-fix work.
- Use `/to-issues` to split a plan or PRD into independently grabbable issues.
- Use `/to-prd` to turn conversation context into a PRD.
- Use `/triage` to classify and move issues through workflow states.
- Use `/zoom-out` when the current code or plan needs broader context.

The following skills are local additions in this repository.

- Use `/grill-spec` when requirements are unclear and no concrete plan exists yet; it ends with a first vertical slice. For challenging an existing plan against docs, use `/grill-with-docs` instead.
- Use `/methodology-intake` to classify external methodology sources before promoting them into repo artifacts.
- Use `/setup-agent-team` to create a bounded manual execution packet for multi-domain, parallelizable, context-heavy agent-team work, or to refuse when single-agent work is more appropriate.
- Use `/staff-level-review` for reviews that need a fixed findings/verdict contract, a review context bundle, or a non-GitHub diff source; for routine local diff review prefer the built-in `/code-review`.
- Use `/client-flow-diagrams` to create or revise high-level workflow, process, or integration diagrams for client or non-technical audiences.
- Use `/query-azure-devops` to query Azure DevOps work items and pull requests via the Azure CLI.
- Use `/social-live-photo-card` to turn user-provided media into a social-platform Live Photo card.

Retired local skills (see `docs/adr/0002-no-parallel-thin-skill-variants.md`):
`ship-vertical-slice` (use `/tdd`) and `diagnose-regression` (use `/diagnose`).
Do not recreate thin local variants of imported skills.

## Verification

Run this after skill or layout changes:

```bash
./scripts/skills-setup/verify.sh
```

Run this after portable baseline changes:

```powershell
./scripts/baseline.ps1 verify
```

## Safety

- 禁止批量刪除文件或目錄。
- Do not use `rm -rf`, `rmdir /s`, `rd /s`, `del /s`, or `Remove-Item -Recurse`.
- Delete only one explicit file path at a time when deletion is necessary.

<!-- BEGIN baseline:karpathy-principles v0.2.0 -->
## Portable Agent Baseline: Karpathy Principles

- Think before coding: state assumptions, surface ambiguity, and ask when the safe interpretation is unclear.
- Simplicity first: prefer the smallest design that satisfies the request; avoid speculative abstractions or extra configuration.
- Surgical changes: touch only files and lines needed for the task, match local style, and mention unrelated concerns instead of editing them.
- Goal-driven execution: turn open-ended work into success criteria and verify the result with tests, scripts, inspection, or another concrete check.

This baseline takes precedence over ordinary implementation habits, but never use it to override explicit user instructions, safety rules, privacy boundaries, or stricter repo-local instructions.
<!-- END baseline:karpathy-principles -->


<!-- BEGIN baseline:layered-ownership v0.2.0 -->
## Portable Agent Baseline: Layered Ownership

- Each repo or layer records its own decisions, status, and roadmap; do not write another layer's decisions into this repo's documents.
- Cross-layer references are pointers, not ownership: link to the owning repo's artifact instead of duplicating or governing it.
- Before recording a status or decision entry, identify which layer owns the affected asset and record it in that layer's own documents.
- Do not create or grow a central governance hub; if a document starts mirroring another repo's changes, stop and move the content to its owner.

This baseline takes precedence over ordinary documentation habits, but never use it to override explicit user instructions, safety rules, privacy boundaries, or stricter repo-local instructions.
<!-- END baseline:layered-ownership -->

