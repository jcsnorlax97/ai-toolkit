# Repo Agent Guide

## Communication

- Use traditional Chinese to reply unless the user explicitly asks for another language.
- Prefer concise, direct engineering communication.
- If the repo is missing context, inspect first and create the minimum viable scaffolding before coding.

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

- Recommended repo name: `agentic-engineering-skills`.
- `skills/` is the canonical source for reusable skills.
- `.claude/skills/` is the Claude Code project adapter.
- `scripts/install-codex-skills.sh` exposes canonical skills in `~/.codex/skills/`.
- `scripts/install-claude-code-skills.sh` exposes canonical skills in `~/.claude/skills/`.
- Personal installs use symlinks by default on macOS/Linux/WSL and copy mode by
  default on Windows Git Bash/MSYS/Cygwin. Symlink installs point through
  `~/.local/share/agentic-engineering-skills/current`; after moving or renaming
  the repo, run `scripts/repair-personal-skill-links.sh`.
- The upstream engineering skills are imported from `mattpocock/skills`; do not present them as original work from this repo.
- Local companion skills are `grill-spec`, `methodology-intake`,
  `capture-input-note`, `setup-agent-team`, `staff-level-review`,
  `ship-vertical-slice`, and `diagnose-regression`.
- Preserve `NOTICE.md` when changing or refreshing imported skills.
- Update `docs/upstream-sources.md` before importing or refreshing external skill material.
- Read `docs/specs/0001-cross-tool-skills-repo.md` before changing layout or install behavior.
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
- `docs/intake.md`: repo-level queue of unprocessed notes and captures to grill later.
- `skills/`: repo-local skills that define reusable workflows.
- `.claude/skills/`: Claude Code adapter for project-local skill discovery.
- `scripts/`: deterministic install and verification commands.

## Default Engineering Standards

- Prefer small public interfaces with deep implementations.
- Tests should verify behavior through public interfaces, not implementation details.
- Prefer vertical slices over horizontal task splitting.
- Prefer deterministic scripts and explicit commands over vague instructions.
- Keep naming aligned with `CONTEXT.md`.

## Local Issue Workflow

- Default tracker: local markdown issues under `.scratch/issues/`.
- File naming: `NNNN-short-kebab-title.md`.
- Each issue should describe user-visible behavior, scope, acceptance checks, and out-of-scope items.

## Safety

- 禁止批量刪除文件或目錄。
- 不要使用 `del /s`、`rd /s`、`rmdir /s`、`Remove-Item -Recurse`、`rm -rf`。
- 如需刪除文件，只能一次刪除一個明確路徑的文件。
- 如果需要批量刪除，停止並請用戶手動處理。
