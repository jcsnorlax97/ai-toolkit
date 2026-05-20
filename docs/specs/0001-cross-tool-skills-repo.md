# Spec 0001: Cross-Tool Skills Repository

## Status

Accepted

## Goal

Create a repository that can store reusable engineering skills once and expose
them to multiple AI coding tools without hand-maintaining duplicate skill files.

## Non-Goals

- Build a full plugin marketplace.
- Replace project-specific `AGENTS.md` or `CLAUDE.md` files in downstream repos.
- Store private memories, credentials, transcripts, or local tool state.

## Design

`skills/` is the canonical source tree.

```text
skills/
└── engineering/
    └── <skill-name>/
        └── SKILL.md
```

Tool-specific adapters point at or install from that source tree.

```text
.claude/skills/<skill-name> -> ../../skills/engineering/<skill-name>
~/.claude/skills/<skill-name>  copied from skills/engineering/<skill-name>
~/.codex/skills/<skill-name>   copied from skills/engineering/<skill-name>
```

## Repository-Level Files

- `README.md`: human onboarding and bootstrap commands.
- `AGENTS.md`: agent-facing operating rules for Codex-compatible workflows.
- `CLAUDE.md`: Claude Code project instructions loaded every session.
- `CONTEXT.md`: shared glossary and stable language.
- `docs/adr/`: durable architecture decisions.
- `docs/agents/`: issue, triage, and domain context conventions.
- `scripts/`: deterministic installation and verification commands.

## Install Behavior

Installation scripts copy canonical skill directories into personal tool
directories. Copying is preferred for personal installs because it works across
machines and filesystems that may not preserve symlinks reliably.

Rerunning an install script after pulling latest changes installs newly added
skills and skips existing targets. This avoids overwriting a user's customized
personal skills.

Project-level Claude Code usage uses `.claude/skills/`. In this repo those
entries are symlinks so local edits immediately affect the canonical files.

## Upstream Imports

The upstream-compatible engineering skills are imported from
`mattpocock/skills` under the MIT License. They were not originally authored in
this repository. Keep `NOTICE.md` updated whenever a substantial upstream
import or refresh happens.

## Verification Requirements

`scripts/verify-skills.sh` must check:

- Every canonical skill has a `SKILL.md`.
- Every `SKILL.md` contains frontmatter with `name` and `description`.
- Claude Code project adapter entries exist for every canonical skill.
- Adapter entries resolve to a readable `SKILL.md`.

## Security And Privacy

Do not commit:

- `~/.claude/` or `~/.codex/` runtime state.
- transcripts, prompt history, cache files, local memory, or tool snapshots.
- credentials, tokens, `.env` files, cookies, or private keys.

## Migration Rule

When adding a new skill:

1. Create `skills/engineering/<skill-name>/SKILL.md`.
2. Add or refresh `.claude/skills/<skill-name>`.
3. Run `./scripts/verify-skills.sh`.
4. Update `README.md` only if the skill changes the public catalog or bootstrap story.
