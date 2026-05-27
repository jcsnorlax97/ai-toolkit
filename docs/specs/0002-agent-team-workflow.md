# Spec 0002: Agent Team Workflow

## Status

Draft / initial skill extracted

## Goal

Define a tool-neutral workflow for decomposing large, multi-domain,
parallelizable, context-heavy work into bounded agent roles and handoffs.

## Non-Goals

- Replace normal single-agent workflows for small tasks.
- Require every tool to support subagent execution.
- Define Claude Code, Codex, or other runtime-specific subagent configuration.
- Create a fixed team roster that runs for every task.

## Trigger Criteria

Use an agent team workflow only when all of these are true:

- The work spans multiple domains or viewpoints.
- Meaningful parts of the work can proceed in parallel.
- A single agent's context would become too large or tangled.

Avoid this workflow for small bugs, single-file edits, clear one-slice
features, or short documentation tasks.

## Output

The first output is a tool-neutral execution packet.

An execution packet includes:

- Goal
- Trigger reason
- Project baseline and worktree state
- Selected agent roles
- Context packet per role
- Ownership boundaries
- Parallelizable tasks
- Blocking dependencies
- External systems and credential policy
- Handoff protocol
- Integration owner
- Verification plan
- Team budget
- Per-worker budget
- Stop conditions

## Role Selection

Use a role catalog, then select only the roles required for the task.

Selection rule:

```text
Only include a role if it owns a distinct question, artifact, or verification responsibility.
```

Do not start every task with the full role catalog.

## Role Catalog

Coordinator: Maintains the goal, decomposition, dependencies, integration
order, and final synthesis.

Product Analyst: Clarifies user behavior, scope, acceptance criteria, and
product trade-offs.

Architecture Reviewer: Checks boundaries, data flow, risks, existing patterns,
and long-term design pressure.

Frontend Engineer: Owns UI, UX, component boundaries, frontend tests, and
browser verification.

Backend Engineer: Owns APIs, domain logic, data contracts, persistence, and
server-side tests.

Test Engineer: Owns test strategy, coverage gaps, regression checks, and
verification risk.

Documentation Maintainer: Owns README, CONTEXT, ADRs, specs, issue notes, and
handoff documentation.

## Coordination

The Coordinator is the final integration owner.

The Coordinator owns:

- Final synthesis
- Sequencing
- Dependency management
- Context allocation
- Conflict resolution between role outputs
- Final verification summary

The Coordinator should not become a universal implementer. Implementing roles
own their assigned artifacts. The Coordinator may make small integration edits,
but should not silently rewrite role-owned work.

## Context Allocation

The Coordinator decides what context each role or worker receives.

Context packets should be intentionally bounded:

- Include the task goal.
- Include the project baseline when it affects ownership, such as clean
  worktree, dirty worktree, fully untracked project, or missing repo guide.
- Include only the files, decisions, constraints, and prior outputs needed.
- State what the worker owns.
- State what the worker must not change.
- State the expected output format.
- State when the worker should stop and report back.

The goal is to maximize output quality and efficiency by avoiding both missing
context and unnecessary context.

## Project Baseline

The Coordinator must record the target project's baseline before delegation.

The baseline should include:

- Repository path
- Relevant repo guide or instruction files
- Whether the worktree is clean, dirty, or fully untracked
- Known user changes that must be preserved
- Existing verification command results, if any
- Whether the task continues an existing project or starts a new one

A dirty or untracked baseline does not block the workflow, but it must tighten
ownership boundaries and checkpoint cadence. Roles must not normalize, stage,
commit, delete, or overwrite unrelated files unless explicitly assigned.

## Ad Hoc Workers

The Coordinator may delegate to an ad hoc worker when a task is useful to split
out but does not match a reusable role in the catalog.

An ad hoc worker must have:

- A bounded task
- A context packet
- An output contract
- A clear stop condition

Avoid vague delegation such as "look around" or "help with this". The
Coordinator should phrase the assignment as a concrete question, patch scope,
or verification responsibility.

## Delegation Modes

Roles and ad hoc workers default to analysis-only mode.

Analysis-only mode allows:

- Reading assigned context
- Answering assigned questions
- Identifying risks
- Proposing a patch plan
- Reporting verification recommendations

Analysis-only mode does not allow file edits.

Edit mode must be explicitly granted in the execution packet.

Edit mode requires:

- Explicit file or module ownership
- Permission to edit only the assigned scope
- A rule not to revert or overwrite other workers' changes
- A report of changed files
- A report of verification performed or skipped

The Coordinator may make small integration edits, but broad write access should
be assigned deliberately.

## External Systems And Credentials

The execution packet must identify external systems before delegation.

External systems include:

- Hosted databases
- Cloud services
- Payment providers
- Email providers
- Auth providers
- Analytics services
- Third-party APIs
- Package registries
- Production or staging environments

For each external system, the packet should define:

- Purpose in the task
- Whether it is required for implementation, verification, or both
- Whether a no-secret verification path exists
- Whether a disposable test environment is required
- Who provides credentials or access
- Which credentials, scopes, or roles are needed
- Whether production data or production credentials are forbidden
- Stop condition when credentials or access are unavailable

Default rules:

- Prefer no-secret verification before credentialed verification.
- Use disposable test environments for risky or stateful integration checks.
- Do not use production credentials, production customer data, private vault
  content, or live payment/email systems unless the user explicitly approves
  that specific use.
- Do not ask workers to infer, locate, or exfiltrate credentials.
- If credentials are needed, stop and request explicit user-provided test
  credentials or a narrower no-secret slice.

## File Deletion Safety

Roles and workers must not batch-delete files or directories.

Do not use:

- `del /s`
- `rd /s`
- `rmdir /s`
- `Remove-Item -Recurse`
- `rm -rf`

When deleting a file is necessary, delete only one explicit file path at a time.
If batch deletion appears necessary, stop and ask the user to handle it
manually.

## Workspace Sandbox

Roles and workers operate inside a workspace sandbox by default.

The execution packet must define:

- Read scope
- Write scope
- Allowed commands or command families, when relevant
- Package manager and dependency execution policy, when relevant
- Disallowed paths
- When to ask for more access

Default restrictions:

- Do not scan the operating system broadly.
- Do not inspect home directories, private vaults, browser profiles, SSH config,
  credential stores, or unrelated repositories.
- Do not follow symlinks, shortcuts, or junctions into unrelated private
  folders.
- If more context is needed, report the reason and wait for Coordinator or user
  approval.

## Package Execution Safety

Package managers are an execution boundary, not just a setup detail.

The execution packet must distinguish:

- local project scripts, such as `npm run check` or `npm start`
- dependency installation, such as `npm install`, `npm ci`, or package-manager
  equivalents
- remote package execution, such as `npx`, `npm exec`, `pnpm dlx`, or similar
  commands that may fetch and run package code

Default rules:

- Prefer existing local scripts when they do not install new dependencies.
- Do not use `npx` or remote package execution as a security shortcut.
- Do not add, update, or install dependencies without explicit approval.
- Pin package names and versions before any approved install or remote
  execution.
- Prefer lockfile-based installs and review install scripts before running
  them.
- Use `--ignore-scripts` or an isolated runtime when install scripts are not
  required for the task.
- Ask for approval before running package-manager commands that fetch from a
  registry or execute package code outside the current repo.

## Isolated Runtime

Docker, devcontainers, or ephemeral worktrees are optional hardening layers, not
mandatory for every task.

Use an isolated runtime when the delegated work involves:

- Untrusted code
- Unknown install scripts
- Third-party repositories with unclear build behavior
- Commands that may modify many files
- Long-running autonomous execution
- Risky dependency installation or generated code execution

For small analysis-only tasks or narrow in-repo edits, the workspace sandbox is
usually sufficient.

## Budgets And Stop Conditions

The execution packet must define both team-level and per-worker budgets.

Team budget should define:

- Maximum parallel workers
- Maximum total runtime
- Maximum total file changes before an integration checkpoint
- Required checkpoint cadence

Per-worker budget should define:

- Maximum elapsed time
- Maximum files to inspect
- Maximum commands to run
- Maximum edit scope
- Maximum handoff size

Stop conditions should include:

- Assigned question answered
- Blocker found
- Context insufficient
- Risk exceeds assigned scope
- Verification fails and requires Coordinator decision
- Budget exhausted

When a stop condition is met, the role or worker should stop and report back
instead of continuing exploration.

## Handoff Format

Every role and worker must report back using a standard handoff format.

```markdown
## Result

- ...

## Evidence

- Files inspected:
- Commands run:
- Findings:
- Changed files:

## Decisions Needed

- ...

## Risks

- ...

## Verification

- Passed:
- Failed:
- Not run:

## Next Handoff

- Recommended next owner:
- Context they need:
- Suggested task:
```

The Coordinator uses handoff reports to synthesize the final result, resolve
conflicts, decide follow-up delegation, and produce the final verification
summary.

## Operating Modes

Agent team workflows support two operating modes.

Manual mode:

- The Coordinator produces an execution packet.
- The user decides whether to launch workers.
- Use this mode for first-time runs, high-risk work, unclear scope, or sensitive
  repositories.

Checkpointed autonomous mode:

- The Coordinator may delegate work according to the execution packet.
- The Coordinator must synthesize progress at each checkpoint.
- The Coordinator must stop when budget, sandbox, scope, or risk limits are
  exceeded.
- The Coordinator must stop before destructive actions, credential use, private
  path access, broad filesystem scanning, or unapproved external network access.

Unrestricted autonomous mode is not supported. The workflow should not continue
indefinitely just because more exploration is possible.
