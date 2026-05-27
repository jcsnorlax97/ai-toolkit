# Real Engineering Skills

Bootstrap repo for reusable AI-assisted software engineering workflows and skills.

Recommended repository name: `agentic-engineering-skills`.

## Language

Skill: A reusable agent workflow packaged as instructions, and optionally scripts or references. Avoid: prompt, magic command

Workflow: A repeatable multi-step engineering process with entry criteria, exit criteria, and expected outputs. Avoid: vibe, freestyle

Workflow skill: A skill that orchestrates multiple lower-level skills, gates, artifacts, and verification steps for a recurring engineering process. Avoid: macro, one-click automation

Canonical source: The directory that owns the maintained copy of a skill. In this repo, canonical skills live under `skills/engineering/`. Avoid: duplicate source, copied truth

Adapter: A tool-specific exposure layer that points at or installs from the canonical source. Examples: `.claude/skills/`, `~/.claude/skills/`, `~/.codex/skills/`

Source registry: A repository document that records each external skill source, imported paths, license, copyright notice, verification date, and obligations. In this repo, the source registry is `docs/upstream-sources.md`. Avoid: informal attribution

Agent team workflow: A repeatable workflow for decomposing a larger goal into bounded agent roles, context packets, handoffs, and acceptance checks. Avoid: agent swarm, autonomous team

Team profile: A reusable selection of agent roles, responsibilities, and context boundaries for a class of work. Avoid: fixed roster, department

Agent role: A reusable responsibility template inside an agent team workflow, such as product manager, frontend engineer, backend engineer, reviewer, or tester. Avoid: persona, bot

Ad hoc worker: A task-specific delegated agent that is not part of the reusable role catalog but receives a bounded context packet and output contract from the coordinator. Avoid: unspecified helper, generic subagent

Subagent runtime: A specific tool's mechanism for running delegated agents or workers. Examples: Codex sub-agents, Claude Code subagents. Avoid: agent team workflow

Execution packet: A tool-neutral plan produced by an agent team workflow that defines roles, context packets, ownership boundaries, handoffs, verification, and stop conditions. Avoid: runtime config, prompt dump

Artifact store: The intended location for durable or temporary outputs such as diagrams, review notes, prototype verdicts, PRDs, ADRs, and handoff notes. Avoid: random output folder

Methodology intake: A read-only workflow for evaluating an external methodology source before deciding whether it should become a rule, skill, context term, ADR, spec, issue, or no-op. Avoid: inspiration dump, prompt collection

External methodology source: An article, repository, paper, tool list, framework, workflow, or public discussion being considered for adoption into this repo's workflow system. Avoid: internet idea, random source

Tool-list-only source: An external methodology source that primarily lists tools, SDKs, repositories, or frameworks without enough trigger criteria, workflow steps, outputs, verification, and stop conditions to become a skill. Avoid: tool worship

Intake destination: The single primary outcome assigned by methodology intake. Valid destinations are Rule, Skill, Context term, ADR, Spec, Issue, and No-op. Avoid: tag pile, mixed outcome

Retention status: The parking decision for an external methodology source after classification, independent from its intake destination. Valid statuses are discard, parked, and revisit-on-trigger. Avoid: destination, triage state

No-op: An intake destination meaning the source should not create or update a formal workflow artifact. A no-op source may still be retained, parked, or revisited according to its retention status. Avoid: delete, forget

Rule: An intake destination for a judgment principle that can be absorbed into an existing workflow without defining a new workflow structure. Avoid: reminder, preference

Spec: An intake destination for source material that should define or change cross-workflow structure, process, contracts, artifact policy, or acceptance rules. Avoid: long note, checklist pile

Context term: An intake destination for stable project language that will be reused across workflows, specs, or skills and affects classification, acceptance, or boundary decisions. Avoid: article jargon, branded term

ADR destination: An intake destination for a hard-to-reverse, surprising-without-context repo decision that comes from a real trade-off surfaced during methodology intake. Avoid: interesting decision, note

Review context bundle: A bounded set of repositories, files, diffs, docs, commands, and constraints provided for PR review. Avoid: whole machine context

Staff-level review: A read-only engineering review checkpoint that evaluates correctness, architecture, security, privacy, performance, test quality, operational risk, maintainability, and requirement compliance. Avoid: staff-review unless referring to an external or private skill

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
- A workflow skill may orchestrate lower-level skills and select a team profile.
- A skill should improve repeatability, not just verbosity.
- A skill should be edited in its canonical source, then exposed through adapters.
- Imported skills must be backed by the source registry and required license notices.
- An agent team workflow may define agent roles, but a subagent runtime is tool-specific.
- A team profile defines who should work; a workflow defines when and why they work.
- Staff-level review is the canonical review checkpoint term; external `staff-review` skills are optional dependencies until their source and license are verified.
- An agent team workflow may use ad hoc workers when a task needs delegation without a reusable role.
- An agent team workflow should be used when work is multi-domain, parallelizable, and context-heavy.
- An agent team workflow should first produce an execution packet before targeting a subagent runtime.
- A methodology intake assigns one intake destination and one retention status.
- A tool-list-only source may be retained for later reference without being promoted into a formal workflow artifact.
- An external methodology source should be classified as Skill only when it defines a repeatable workflow with trigger criteria, inputs, steps, outputs, verification, stop conditions, and repo fit.
- A no-op source does not create or update skills, specs, ADRs, issues, or glossary terms.
- A rule fits inside an existing workflow; a spec changes structure or contracts across workflows.
- A context term belongs in the glossary only when it stabilizes recurring project language rather than preserving one source's jargon.
- An ADR destination is for the repo decision caused by a source, not for the source merely being interesting.
- An issue destination is for a source that can already become a tracked, scoped, independently verifiable work item.
- Agent roles and ad hoc workers default to analysis-only mode unless an execution packet explicitly grants edit mode.
- Agent roles and ad hoc workers operate inside a workspace sandbox by default.
- Isolated runtimes are optional hardening for high-risk or long-running delegated work.
- Agent team workflows may run in manual mode or checkpointed autonomous mode, but not unrestricted autonomous mode.
- An issue may produce code, documentation, or a new skill.
- A vertical slice should be small enough to implement and verify in one focused loop.

## Flagged Ambiguities

- "skill" can mean a personal capability or an agent capability. In this repo it means an agent capability unless explicitly stated otherwise.
