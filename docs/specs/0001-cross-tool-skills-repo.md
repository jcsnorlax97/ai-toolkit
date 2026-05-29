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
~/.local/share/agentic-engineering-skills/current -> <this repo clone>
~/.claude/skills/<skill-name>  -> ~/.local/share/agentic-engineering-skills/current/skills/engineering/<skill-name>
~/.codex/skills/<skill-name>   -> ~/.local/share/agentic-engineering-skills/current/skills/engineering/<skill-name>
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

Installation scripts link canonical skill directories into personal tool
directories through a stable machine-local repo link:

```text
~/.local/share/agentic-engineering-skills/current
```

Rerunning an install script after pulling latest changes repairs personal
symlinks and links any newly added skills. Because installed skills point at the
canonical source, existing skills see the latest repo version without manual
deletion or recopying.

If a personal target already exists as a real directory from an older copy-based
install, the installer moves that directory into:

```text
<tool-skills-dir>/.agentic-engineering-skills-backups/<timestamp>/<skill-name>
```

It then creates the symlink. This preserves local customizations without keeping
the stale copy active. Pass `--keep-existing` to leave non-symlink targets in
place.

If the repository is renamed or moved, rerun an install script or
`scripts/repair-personal-skill-links.sh` from the new clone. Existing personal
skill links continue to point through the stable repo link, so repair updates
the repo pointer instead of rewriting every path by hand.

`scripts/repair-personal-skill-links.sh` is a convenience wrapper, not a
separate install mode. It runs both personal install scripts:

```text
scripts/install-codex-skills.sh
scripts/install-claude-code-skills.sh
```

Each install script is idempotent for its target runtime: it creates missing
links, repairs broken or stale symlinks, migrates older copy-based targets to a
timestamped backup unless `--keep-existing` is passed, and updates the stable
repo link when needed.

On Windows, installation still requires real symlink support. Git Bash should be
run with Windows symlink creation enabled, such as
`MSYS=winsymlinks:nativestrict`, and Windows may require Developer Mode or an
elevated shell. If `ln -s` does not produce a real symlink, the installer must
fail instead of treating a copied directory or placeholder as success.

If an older Windows run left the stable repo pointer path as a non-symlink, the
installer moves that path into the state directory's timestamped backup folder
before creating the real symlink. It must preserve the old path rather than
deleting it.

Project-level Claude Code usage uses `.claude/skills/`. In this repo those
entries are symlinks so local edits immediately affect the canonical files.

## Upstream Imports

The upstream-compatible engineering skills are imported from
`mattpocock/skills` under the MIT License. They were not originally authored in
this repository. Keep `NOTICE.md` updated whenever a substantial upstream
import or refresh happens.

## License And Source Review

Before importing or refreshing external skill material:

1. Identify the source repository and exact paths being imported.
2. Verify the license from the upstream repository's license file or official
   repository metadata.
3. Confirm the license permits the planned use, modification, redistribution,
   and publication.
4. Record the source, imported paths, local paths, license, copyright notice,
   verification date, and import commit in `docs/upstream-sources.md`.
5. Preserve required notices in `NOTICE.md`.
6. Do not import unclear, missing-license, proprietary, or incompatible material
   without explicit human review.

The source registry is part of the design, not optional bookkeeping. It exists
so a public skills repo can be audited without reconstructing history from git
alone.

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
4. Run `./scripts/verify-personal-skill-links.sh` after personal install or repair.
5. Update `README.md` only if the skill changes the public catalog or bootstrap story.
