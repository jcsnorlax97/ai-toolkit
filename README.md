# Agentic Engineering Skills

Reusable engineering workflows for AI coding agents.

This repository stores portable skills for software engineering work such as
spec clarification, vertical delivery, and regression diagnosis. The design is
tool-aware but keeps one canonical source for every skill.

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

- `grill-spec`: clarify ambiguous requirements, vocabulary, scope, and acceptance checks.
- `ship-vertical-slice`: deliver one externally verifiable behavior at a time.
- `diagnose-regression`: debug by reproducing, minimizing, instrumenting, fixing, and regression testing.

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

## Bootstrap On Codex

Install the canonical skills into the local Codex skills directory:

```bash
./scripts/install-codex-skills.sh
```

The default target is:

```text
~/.codex/skills/
```

## Development

After editing skills or adapters, run:

```bash
./scripts/verify-skills.sh
```

Keep each `SKILL.md` concise. Move long references, examples, or scripts into
supporting files inside the skill directory.
