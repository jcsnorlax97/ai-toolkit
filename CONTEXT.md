# Real Engineering Skills

Bootstrap repo for reusable AI-assisted software engineering workflows and skills.

Recommended repository name: `agentic-engineering-skills`.

## Language

Skill: A reusable agent workflow packaged as instructions, and optionally scripts or references. Avoid: prompt, magic command

Workflow: A repeatable multi-step engineering process with entry criteria, exit criteria, and expected outputs. Avoid: vibe, freestyle

Canonical source: The directory that owns the maintained copy of a skill. In this repo, canonical skills live under `skills/engineering/`. Avoid: duplicate source, copied truth

Adapter: A tool-specific exposure layer that points at or installs from the canonical source. Examples: `.claude/skills/`, `~/.claude/skills/`, `~/.codex/skills/`

Source registry: A repository document that records each external skill source, imported paths, license, copyright notice, verification date, and obligations. In this repo, the source registry is `docs/upstream-sources.md`. Avoid: informal attribution

Agent team workflow: A repeatable workflow for decomposing a larger goal into bounded agent roles, context packets, handoffs, and acceptance checks. Avoid: agent swarm, autonomous team

Agent role: A reusable responsibility template inside an agent team workflow, such as product manager, frontend engineer, backend engineer, reviewer, or tester. Avoid: persona, bot

Ad hoc worker: A task-specific delegated agent that is not part of the reusable role catalog but receives a bounded context packet and output contract from the coordinator. Avoid: unspecified helper, generic subagent

Subagent runtime: A specific tool's mechanism for running delegated agents or workers. Examples: Codex sub-agents, Claude Code subagents. Avoid: agent team workflow

Execution packet: A tool-neutral plan produced by an agent team workflow that defines roles, context packets, ownership boundaries, handoffs, verification, and stop conditions. Avoid: runtime config, prompt dump

Analysis-only mode: A delegation mode where a role or worker may inspect context and report findings, risks, and proposed plans but may not edit files. Avoid: passive mode

Edit mode: A delegation mode where a role or worker may edit only explicitly assigned files or modules and must report changed files and verification. Avoid: freeform write access

Workspace sandbox: The default safety boundary for an agent team workflow, limiting each role or worker to assigned files, documents, context packets, and write scopes. Avoid: full machine access

Isolated runtime: An optional hardened execution environment such as Docker, a devcontainer, or an ephemeral worktree used for high-risk or long-running delegated work. Avoid: mandatory container for every task

Manual mode: An agent team workflow mode where the coordinator produces an execution packet and waits for the user to approve or launch workers. Avoid: stalled workflow

Checkpointed autonomous mode: An agent team workflow mode where the coordinator may delegate and continue work within explicit budgets, sandboxes, and checkpoint rules. Avoid: fully autonomous until done

Vertical slice: The thinnest end-to-end change that proves one behavior through a real interface. Avoid: layer task, partial plumbing

ADR: A short decision record for an architectural choice that is hard to reverse and needs future context. Avoid: note dump

Issue: A tracked unit of work. In this repo the default issue tracker is local markdown under `.scratch/issues/`. Avoid: ticket, todo blob

## Relationships

- A workflow can be captured as one or more skills.
- A skill should improve repeatability, not just verbosity.
- A skill should be edited in its canonical source, then exposed through adapters.
- Imported skills must be backed by the source registry and required license notices.
- An agent team workflow may define agent roles, but a subagent runtime is tool-specific.
- An agent team workflow may use ad hoc workers when a task needs delegation without a reusable role.
- An agent team workflow should be used when work is multi-domain, parallelizable, and context-heavy.
- An agent team workflow should first produce an execution packet before targeting a subagent runtime.
- Agent roles and ad hoc workers default to analysis-only mode unless an execution packet explicitly grants edit mode.
- Agent roles and ad hoc workers operate inside a workspace sandbox by default.
- Isolated runtimes are optional hardening for high-risk or long-running delegated work.
- Agent team workflows may run in manual mode or checkpointed autonomous mode, but not unrestricted autonomous mode.
- An issue may produce code, documentation, or a new skill.
- A vertical slice should be small enough to implement and verify in one focused loop.

## Flagged Ambiguities

- "skill" can mean a personal capability or an agent capability. In this repo it means an agent capability unless explicitly stated otherwise.
