# Repo Layout

`ai-agent-library` stores reusable AI agent assets without coupling them to one
assistant runtime.

## Canonical Source Trees

```text
skills/
baselines/
workflows/   # planned
agents/      # planned
templates/   # planned
```

`skills/` owns invoked workflow skills. Current skills live under
`skills/engineering/` because the first library slice focused on engineering
workflows. Do not move existing skills merely to express maturity or status.

`baselines/` owns always-on instruction packs. Baselines are applied to
downstream repo instruction files through managed blocks; they are not runtime
skills.

`workflows/` should own reusable tool-neutral workflow specs, role catalogs,
team profiles, execution-packet templates, and handoff contracts once those
definitions are ready to leave `docs/specs/`.

`agents/` should own reusable role or agent profiles only after the profile
contract is proven. Runtime-specific subagent configuration should stay in the
runtime adapter layer.

## Adapter Trees

```text
.claude/skills/
~/.claude/skills/
~/.codex/skills/
```

Adapters expose canonical assets to a runtime. Do not maintain duplicate skill
bodies by hand.

## Script Layout

```text
scripts/
├── baseline
├── baseline.ps1
├── skills.ps1
├── baselines/
├── compat/
├── skills/
└── lib/
```

Root `scripts/` contains public command entrypoints only. Domain folders contain
implementation scripts. `scripts/compat/` contains legacy command names kept for
operators who still know the old paths.

## Lifecycle Metadata

Lifecycle state belongs to SkillOps:

```text
../skillops/inventory/skills.yaml
```

This repo owns the implementation bodies, not central lifecycle inventory.
