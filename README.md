# AI Agent Library

Reusable AI agent assets: skills, baselines, workflow definitions, agent role
packs, and supporting templates.

This repo keeps reusable agent behavior in one maintained source tree and
exposes it to tools such as Codex, Claude Code, and Copilot through explicit
adapters or managed instruction blocks.

## Layout

```text
.
├── AGENTS.md
├── CLAUDE.md
├── CONTEXT.md
├── .claude/
│   └── skills/
├── baselines/
├── docs/
│   ├── adr/
│   ├── agents/
│   ├── how-to/
│   ├── reference/
│   └── specs/
├── scripts/
│   ├── baselines/
│   ├── compat/
│   ├── skills/
│   └── lib/
└── skills/
    └── engineering/
```

Planned future source trees:

```text
agents/
workflows/
templates/
```

## Source Trees

- `skills/` owns invoked workflow skills.
- `baselines/` owns always-on managed instruction packs.
- `workflows/` will own reusable tool-neutral workflow definitions when they
  graduate out of specs.
- `agents/` will own reusable role or agent profiles when the contract is
  proven.
- `scripts/` owns deterministic install, apply, remove, verify, and shim
  commands.

Skill lifecycle status, confidence, evidence, and promotion decisions are
tracked by SkillOps in:

```text
../skillops/inventory/skills.yaml
```

Do not create a repo-local `inventory/` directory for SkillOps lifecycle data.

## Quickstart

Verify skills and adapters:

```powershell
./scripts/skills.ps1 verify
```

List and inspect skills:

```powershell
./scripts/skills.ps1 list
./scripts/skills.ps1 show diagnose
```

Install personal skill adapters:

```powershell
./scripts/skills.ps1 install -Target codex -Scope personal -Copy
./scripts/skills.ps1 install -Target claude -Scope personal -Copy
```

List and apply baselines:

```powershell
./scripts/baseline.ps1 list
./scripts/baseline.ps1 apply -Pack karpathy-principles -Tools codex,claude -DryRun
./scripts/baseline.ps1 apply -Pack all -Tools all -DryRun
```

Install optional command shims:

```powershell
./scripts/baseline.ps1 shim install -AddToUserPath
./scripts/skills.ps1 shim install -AddToUserPath
```

## Docs

- [Install Guide](docs/how-to/install.md): personal skill install, shims,
  symlink/copy behavior, and platform notes.
- [Repo Layout](docs/reference/repo-layout.md): current source trees, script
  folders, and ownership rules.
- [Compatibility](docs/reference/compatibility.md): legacy repo name, legacy
  paths, legacy baseline markers, and migration behavior.
- [Upstream Sources](docs/upstream-sources.md): source and license records for
  imported material.
- [Specs](docs/specs/): accepted and draft workflow/design specs.
- [Context](CONTEXT.md): glossary and stable domain language.

## Current Contents

Imported engineering skills from `mattpocock/skills` are kept here with
attribution in `NOTICE.md` and `docs/upstream-sources.md`.

Local companion skills include `grill-spec`, `methodology-intake`,
`capture-input-note`, `setup-agent-team`, `staff-level-review`,
`ship-vertical-slice`, `diagnose-regression`, and `client-flow-diagrams`.

Current baseline packs include `karpathy-principles`,
`git-collaboration-hygiene`, `repo-context-grounding`,
`oop-extension-safety`, and `code-doc-sync`.

## Development

After editing skills or adapters:

```powershell
./scripts/skills.ps1 verify
```

After editing baseline packs:

```powershell
./scripts/baseline.ps1 verify
```

Keep each `SKILL.md` concise. Move long references, examples, or scripts into
supporting files inside the skill directory.

Keep maintenance metadata in `SKILL.md` frontmatter rather than companion
metadata files. Runtime fields `name` and `description` are required; new local
skills should also include `status`, `problem`, `when-not-to-use`, and
`maintainer` when known.
