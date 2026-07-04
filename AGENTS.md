# Repo Agent Guide

## Communication

- Use traditional Chinese to reply unless the user explicitly asks for another language.
- Prefer concise, direct engineering communication.
- If the repo is missing context, inspect first and create the minimum viable scaffolding before coding.

## Roadmap

Before planning work related to methodology intake, engineering skills, agent
workflows, staff-level review, or external workflow intake, read the canonical
roadmap in this repo:

```text
docs/ROADMAP.md
```

Use it as the current source of truth for priorities and for deciding which
workflows are still being grilled before becoming formal skills. The former
ecosystem-wide roadmap at `../ai-ops-ecosystem-spec/spec/ROADMAP.md` is frozen
historical reference; do not treat it as current.

## Repository Design

- Recommended repo name: `ai-toolkit`.
- `skills/` is the canonical source for reusable skills.
- `baselines/` is the canonical source for always-on agent baseline packs.
- `workflows/`, `agents/`, and `templates/` are planned source trees for
  reusable workflow definitions, role packs, and supporting templates.
- `.claude/skills/` is the Claude Code project adapter.
- `scripts/skills.ps1` is the public skill CLI.
- `scripts/baseline.ps1` is the public baseline CLI.
- Personal installs use symlinks by default through
  `~/.local/share/ai-toolkit/current`. On Windows, use Git Bash
  with real symlink support, such as elevated Git Bash plus
  `MSYS=winsymlinks:nativestrict`. `--copy` is only an explicit fallback.
  After moving or renaming the repo, run `scripts/skills-setup/repair-personal-links.sh`.
- The upstream engineering skills are imported from `mattpocock/skills`; do not present them as original work from this repo.
- Local companion skills are `grill-spec`, `methodology-intake`,
  `setup-agent-team`, `staff-level-review`, `client-flow-diagrams`, and
  `query-azure-devops`. (`capture-input-note` migrated to
  `../ai-second-brain/skills/` on 2026-07-03; capture skills live in the
  capture layer. `ship-vertical-slice` and `diagnose-regression` were retired
  on 2026-07-03 as thin duplicates of `tdd` and `diagnose`; see
  `docs/adr/0002-no-parallel-thin-skill-variants.md`.)
- Reusable candidate skills may live in `skills/engineering/`. Record their
  lifecycle metadata in `docs/skills-inventory.yaml` (this repo's skills
  only; the skillops repo is frozen).
- Preserve `NOTICE.md` when changing or refreshing imported skills.
- Update `docs/upstream-sources.md` before importing or refreshing external skill material.
- Read `docs/reference/repo-layout.md` and
  `docs/specs/0001-cross-tool-skills-repo.md` before changing layout or install
  behavior.
- Read `docs/specs/0005-capture-input-note-vs-methodology-intake.md` before
  changing methodology-adoption behavior; the capture side
  (`capture-input-note`) now lives in `../ai-second-brain`.

## Delivery Loop

1. Clarify the request with `grill-spec` when no concrete plan exists yet; use `grill-with-docs` to challenge an existing plan against docs.
2. Update `CONTEXT.md` when a domain term or relationship is clarified.
3. Record an ADR only when the decision is hard to reverse, surprising without context, and the result of a real trade-off.
4. Implement with `tdd`: one behavior, one test, one slice at a time.
5. If behavior is broken or regressed, switch to `diagnose`.
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
