# Claude Project Instructions

Use traditional Chinese unless the user explicitly asks for another language.

## Project Purpose

This repo stores portable engineering skills for AI coding agents. Treat
`skills/` as the canonical source. Treat `.claude/skills/` as the Claude Code
project adapter.

## Required Context

- Read `CONTEXT.md` before creating, renaming, or substantially changing skills.
- Read `docs/specs/0001-cross-tool-skills-repo.md` before changing repository layout or install behavior.
- Use `docs/adr/0000-template.md` for decisions that are hard to reverse and need future context.

## Skills

The following skills are imported from `mattpocock/skills`; preserve attribution
in `NOTICE.md` when changing or refreshing them.

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
- Use `/ship-vertical-slice` when implementing a focused behavior or refactor.
- Use `/diagnose-regression` when behavior is failing, flaky, or slower than expected.

## Verification

Run this after skill or layout changes:

```bash
./scripts/verify-skills.sh
```

## Safety

- 禁止批量刪除文件或目錄。
- Do not use `rm -rf`, `rmdir /s`, `rd /s`, `del /s`, or `Remove-Item -Recurse`.
- Delete only one explicit file path at a time when deletion is necessary.
