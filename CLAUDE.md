# Claude Project Instructions

Use traditional Chinese unless the user explicitly asks for another language.

## Project Purpose

This repo stores reusable AI agent assets: skills, baselines, workflow
definitions, agent role packs, and supporting templates. Treat `skills/` as the
canonical source for invoked skills. Treat `.claude/skills/` as the Claude Code
project adapter.

Treat `baselines/` as the canonical source for always-on baseline
packs that can be applied to repo instruction files through managed blocks.

Reusable candidate skills may live here. Record their lifecycle status,
confidence, evidence, and promotion decisions in
`docs/skills-inventory.yaml` (this repo's skills only; split from the frozen
skillops repo on 2026-07-03).

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

<!-- BEGIN baseline:process-vs-work-doctrine v0.1.0 -->
## Portable Agent Baseline: Process-vs-Work Doctrine（何時加流程、何時直接做事）

流程的預設答案是「不要」。想建新 repo、skill、spec、自動化或治理層時，先過以下七關；過不了就直接做事。引用本準則擋下違規提案是正當行為。

1. 痛先於流程：同一種失敗有兩次日期可指之前，不建流程、repo、skill 或 spec。
2. 加一層必先殺一層：新 meta 層必須指名它取代誰；meta repo 淨數不得上升。
3. 三次使用前只准最簡形式：不得有自己的 repo、spec 目錄、install script 或 CONTEXT.md。
4. 只寫不讀即是死：60 天沒被任何決策引用的紀錄預設凍結。
5. 凍結就是凍結：解凍需指出今天被擋住的真實任務；「可以更完整」不是理由。
6. 一個 session 能做完的事，不准先搭鷹架：自動化要等同樣的事第二次出現。
7. Meta 配額：連續 meta session 不得超過 1 個，開始前必須指出服務的下一個實際產出任務。

全文與快速判斷表見 ai-toolkit `baselines/process-vs-work-doctrine/baseline.md`。

This baseline takes precedence over ordinary planning habits, but never use it to override explicit user instructions, safety rules, privacy boundaries, or stricter repo-local instructions.
<!-- END baseline:process-vs-work-doctrine -->
