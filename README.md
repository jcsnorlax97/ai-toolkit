# Agentic Engineering Skills

Reusable engineering workflows for AI coding agents.

This repository stores portable skills for software engineering work. The
design is tool-aware but keeps one canonical source for every skill.

## Repository Name

Recommended repo name:

```text
agentic-engineering-skills
```

Rationale:

- Describes the audience: AI coding agents.
- Describes the domain: engineering workflows, not general prompting.
- Avoids coupling the repo to Claude Code, Codex, or any single runtime.

## Layout

```text
.
├── AGENTS.md
├── CLAUDE.md
├── CONTEXT.md
├── .claude/
│   └── skills/
├── docs/
│   ├── adr/
│   ├── agents/
│   ├── intake.md
│   └── specs/
├── scripts/
└── skills/
    └── engineering/
```

## Source Of Truth

`skills/` is the canonical source.

Adapters make the same skills usable in specific tools:

- Claude Code project adapter: `.claude/skills/<skill-name>`
- Claude Code personal install: `~/.claude/skills/<skill-name>`
- Codex personal install: `~/.codex/skills/<skill-name>`

Do not maintain duplicated skill bodies by hand.

## Current Skills

### Imported From `mattpocock/skills`

These skills were not built in this repo. They are imported from
[`mattpocock/skills`](https://github.com/mattpocock/skills) and kept here so
this repository can act as a cross-tool install source. See `NOTICE.md` for
attribution and `docs/upstream-sources.md` for license verification details.

- `diagnose`: disciplined diagnosis loop for hard bugs and regressions.
- `grill-with-docs`: stress-test plans against domain language and ADRs.
- `improve-codebase-architecture`: surface refactoring opportunities that improve testability and navigability.
- `prototype`: build throwaway prototypes to answer design questions.
- `setup-matt-pocock-skills`: scaffold repo-local configuration consumed by the engineering skills.
- `tdd`: deliver behavior with a red-green-refactor loop.
- `to-issues`: turn plans or specs into independently grabbable issues.
- `to-prd`: turn conversation context into a product requirements document.
- `triage`: triage issues through explicit workflow states.
- `zoom-out`: ask for broader context when a code area or decision feels too narrow.

### Local Additions

These skills were added in this repo as small companion workflows.

- `grill-spec`: clarify ambiguous requirements, vocabulary, scope, and acceptance checks.
- `methodology-intake`: classify external methodology sources before promoting them into repo artifacts.
- `capture-input-note`: capture external sources as redacted work-log inbox notes before later review, daily logging, or methodology intake.
- `setup-agent-team`: create a bounded manual execution packet for multi-domain, parallelizable, context-heavy agent-team work, or refuse when work should stay single-agent.
- `staff-level-review`: perform read-only, findings-first engineering review across correctness, architecture, safety, tests, and operability.
- `ship-vertical-slice`: deliver one externally verifiable behavior at a time.
- `diagnose-regression`: debug by reproducing, minimizing, instrumenting, fixing, and regression testing.

See `docs/specs/0005-capture-input-note-vs-methodology-intake.md` for the
boundary between source capture and methodology adoption.

## Bootstrap On Claude Code

For project-local usage:

```bash
git clone <repo-ssh-url> agentic-engineering-skills
cd agentic-engineering-skills
./scripts/verify-skills.sh
claude
```

Claude Code should discover project skills under `.claude/skills/`.

For personal usage across all projects:

```bash
./scripts/install-claude-code-skills.sh
```

This creates personal skill symlinks under:

```text
~/.claude/skills/
```

The symlinks point through a stable machine-local repo link:

```text
~/.local/share/agentic-engineering-skills/current
```

After that, pulling this repo updates existing personal Claude Code skills
without recopying them. If an older copied skill directory already exists, the
installer moves it into `.agentic-engineering-skills-backups/<timestamp>/` under
the target skills directory, then creates the symlink. Pass `--keep-existing` to
leave non-symlink targets untouched.

## Bootstrap On Codex

Install the canonical skills into the local Codex skills directory:

```bash
./scripts/install-codex-skills.sh
```

The default target is:

```text
~/.codex/skills/
```

Codex personal installs use the same symlink behavior as Claude Code. Pulling
the repo updates existing installed skills because the personal entries point at
the canonical `skills/engineering/` directories through the stable repo link.

## Personal Install Scripts

The install and repair scripts share the same underlying behavior. They are
different entrypoints for different scopes:

```text
scripts/install-codex-skills.sh
  Ensure Codex personal skills under ~/.codex/skills/ are linked and repaired.

scripts/install-claude-code-skills.sh
  Ensure Claude Code personal skills under ~/.claude/skills/ are linked and repaired.

scripts/repair-personal-skill-links.sh
  Convenience wrapper that runs both install scripts.
```

Use a specific `install-*-skills.sh` script when you only care about one tool.
Use `repair-personal-skill-links.sh` after moving or renaming this repo, or
when you want both Codex and Claude Code personal installs checked in one step.
It does not have separate repair logic; it delegates to the two install scripts.

If this repo is renamed or moved, rerun the relevant install script, or run:

```bash
./scripts/repair-personal-skill-links.sh
```

To check personal links without changing them:

```bash
./scripts/verify-personal-skill-links.sh
```

## Windows Notes

These scripts are Bash scripts. On Windows, run them from Git Bash or a WSL
shell that matches the Claude Code runtime you use.

For Windows Claude Code running outside WSL, prefer Git Bash with real Windows
symlinks enabled. Windows may require Developer Mode or an elevated shell to
create directory symlinks. A reliable invocation is:

```bash
MSYS=winsymlinks:nativestrict ./scripts/install-claude-code-skills.sh
```

If `ln -s` cannot create a real symlink, the installer now fails instead of
silently leaving a copied directory or placeholder. Verify with:

```bash
./scripts/install-claude-code-skills.sh --verify-only
```

If an earlier Windows run left a non-symlink at
`~/.local/share/agentic-engineering-skills/current`, rerun the installer after
pulling this version. The installer will move that stale `current` path into
`.agentic-engineering-skills-backups/<timestamp>/current` under the state
directory, then create the real symlink.

If you run from WSL, `~/.claude/skills/` means the WSL home directory. That is
only correct when Claude Code is also running in WSL. For Windows Claude Code,
set `CLAUDE_SKILLS_DIR` to the Windows user's Claude skills directory.

Project-local Claude Code usage through `.claude/skills/` does not need a
separate setup rerun after pulling; the symlinks point at the canonical
`skills/engineering/` directories in this repo.

## Development

After editing skills or adapters, run:

```bash
./scripts/verify-skills.sh
```

Keep each `SKILL.md` concise. Move long references, examples, or scripts into
supporting files inside the skill directory.

Unprocessed notes and article captures are tracked in `docs/intake.md` and may
live under ignored scratch paths such as `.scratch/captures/`.

## Attribution

The upstream engineering skills are imported from
[`mattpocock/skills`](https://github.com/mattpocock/skills), licensed under MIT.
See `NOTICE.md` and `docs/upstream-sources.md`.
