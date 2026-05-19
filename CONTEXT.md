# Real Engineering Skills

Bootstrap repo for reusable AI-assisted software engineering workflows and skills.

Recommended repository name: `agentic-engineering-skills`.

## Language

Skill: A reusable agent workflow packaged as instructions, and optionally scripts or references. Avoid: prompt, magic command

Workflow: A repeatable multi-step engineering process with entry criteria, exit criteria, and expected outputs. Avoid: vibe, freestyle

Canonical source: The directory that owns the maintained copy of a skill. In this repo, canonical skills live under `skills/engineering/`. Avoid: duplicate source, copied truth

Adapter: A tool-specific exposure layer that points at or installs from the canonical source. Examples: `.claude/skills/`, `~/.claude/skills/`, `~/.codex/skills/`

Vertical slice: The thinnest end-to-end change that proves one behavior through a real interface. Avoid: layer task, partial plumbing

ADR: A short decision record for an architectural choice that is hard to reverse and needs future context. Avoid: note dump

Issue: A tracked unit of work. In this repo the default issue tracker is local markdown under `.scratch/issues/`. Avoid: ticket, todo blob

## Relationships

- A workflow can be captured as one or more skills.
- A skill should improve repeatability, not just verbosity.
- A skill should be edited in its canonical source, then exposed through adapters.
- An issue may produce code, documentation, or a new skill.
- A vertical slice should be small enough to implement and verify in one focused loop.

## Flagged Ambiguities

- "skill" can mean a personal capability or an agent capability. In this repo it means an agent capability unless explicitly stated otherwise.
