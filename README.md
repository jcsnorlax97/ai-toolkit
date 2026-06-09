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

## Lifecycle Metadata

Reusable skills in this repo may start as candidates. Their implementation
still belongs under `skills/engineering/<skill-name>/`.

Lifecycle status, confidence, evidence, and promotion decisions are tracked by
SkillOps in:

```text
../skillops/inventory/skills.yaml
```

Do not create maturity folders or a repo-local `inventory/` directory here for
SkillOps lifecycle data. If the SkillOps inventory is unavailable, leave the
inventory update pending rather than creating a substitute.

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

## Installation

Canonical skills live under `skills/engineering/`. Personal runtime entries in
`~/.claude/skills/` and `~/.codex/skills/` are adapters, not the source of
truth.

### Project-Local Claude Code

Clone the repo and verify the project-local adapters before starting Claude
Code:

```bash
git clone <repo-ssh-url> agentic-engineering-skills
cd agentic-engineering-skills
./scripts/verify-skills.sh
claude
```

Claude Code should discover project skills under `.claude/skills/`.

### Windows Symlink Mode

Windows symlink mode should be run from Git Bash opened as Administrator, not
PowerShell or the VS Code integrated terminal. Before installing, verify that
the shell is Git Bash and that `$HOME` points at the Windows user profile:

```bash
bash -lc 'uname -s; echo $HOME'
```

Expected output starts with `MINGW64_NT...` and `/c/Users/<WindowsUser>`. If it
prints `Linux` and `/home/<user>`, use Git Bash instead, or use `--copy` as the
Windows fallback.

### Personal Runtime Install

For personal Claude Code usage across all projects:

```bash
./scripts/install-claude-code-skills.sh
```

For personal Codex usage:

```bash
./scripts/install-codex-skills.sh
```

For both:

```bash
./scripts/repair-personal-skill-links.sh
```

### Personal Install Verification

Verify personal installs without changing files:

```bash
./scripts/verify-personal-skill-links.sh
```

See [Personal Skill Installation](docs/install.md) for the deterministic
behavior matrix, symlink-vs-copy behavior, Windows commands, and notes on why
files appear inside symlinked runtime skill folders.

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
