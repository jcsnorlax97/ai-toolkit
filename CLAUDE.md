# Claude Project Instructions

Use traditional Chinese unless the user explicitly asks for another language.

<!-- BEGIN portable-agent-baseline:karpathy-principles v0.1.0 -->
## Portable Agent Baseline: Karpathy Principles

- Think before coding: state assumptions, surface ambiguity, and ask when the safe interpretation is unclear.
- Simplicity first: prefer the smallest design that satisfies the request; avoid speculative abstractions or extra configuration.
- Surgical changes: touch only files and lines needed for the task, match local style, and mention unrelated concerns instead of editing them.
- Goal-driven execution: turn open-ended work into success criteria and verify the result with tests, scripts, inspection, or another concrete check.

Apply this baseline before ordinary implementation habits, but never use it to override explicit user instructions, safety rules, privacy boundaries, or stricter repo-local instructions.
<!-- END portable-agent-baseline:karpathy-principles -->

## Project Purpose

This repo stores portable engineering skills for AI coding agents. Treat
`skills/` as the canonical source. Treat `.claude/skills/` as the Claude Code
project adapter.

Treat `portable-baselines/` as the canonical source for always-on baseline
packs that can be applied to repo instruction files through managed blocks.

Reusable candidate skills may live here, but SkillOps lifecycle metadata does
not. Record status, confidence, evidence, and promotion decisions in
`../skillops/inventory/skills.yaml`. Do not create a repo-local `inventory/`
directory for SkillOps data.

## Required Context

- Read `CONTEXT.md` before creating, renaming, or substantially changing skills.
- Read `docs/specs/0001-cross-tool-skills-repo.md` before changing repository layout or install behavior.
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

- Use `/grill-spec` when requirements, terminology, scope, or acceptance checks are unclear.
- Use `/methodology-intake` to classify external methodology sources before promoting them into repo artifacts.
- Use `/setup-agent-team` to create a bounded manual execution packet for multi-domain, parallelizable, context-heavy agent-team work, or to refuse when single-agent work is more appropriate.
- Use `/staff-level-review` for read-only findings-first engineering review across correctness, architecture, safety, tests, and operability.
- Use `/ship-vertical-slice` when implementing a focused behavior or refactor.
- Use `/diagnose-regression` when behavior is failing, flaky, or slower than expected.
- Use `/client-flow-diagrams` to create or revise high-level workflow, process, or integration diagrams for client or non-technical audiences.

## Verification

Run this after skill or layout changes:

```bash
./scripts/verify-skills.sh
```

Run this after portable baseline changes:

```powershell
./scripts/verify-portable-baselines.ps1
```

## Safety

- 禁止批量刪除文件或目錄。
- Do not use `rm -rf`, `rmdir /s`, `rd /s`, `del /s`, or `Remove-Item -Recurse`.
- Delete only one explicit file path at a time when deletion is necessary.
