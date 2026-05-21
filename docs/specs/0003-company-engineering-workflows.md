# Spec 0003: Company Engineering Workflows

## Status

Draft

## Goal

Define reusable workflow skills for recurring company engineering work while
keeping workflow orchestration separate from team composition.

## Core Model

Workflows and teams are separate concepts.

Workflows define:

- Entry criteria
- Ordered stages
- Decision gates
- Skill checkpoints
- Artifacts
- Verification
- Exit criteria

Team profiles define:

- Agent roles
- Responsibilities
- Context boundaries
- Delegation mode
- Handoff expectations

A workflow may select a team profile, but the workflow should not hard-code a
fixed team roster for every task.

## Candidate Workflow Skills

## Cross-Tool Orchestration

Workflow skills may reference lower-level skills as behavior sources, but they
must not assume a tool can programmatically invoke another skill.

At each stage, define:

- Stage name
- Behavior source skill
- Expected output
- Fallback behavior when skill invocation is unavailable

Example:

```text
Stage: TDD fix loop
Behavior source: tdd
Expected output: passing behavior test and verification notes
Fallback: follow the TDD rules directly if `/tdd` cannot be invoked
```

### Development Workflow

Candidate skill name:

```text
develop-feature-workflow
```

Purpose:

Guide feature or change development through requirement grilling, prototype or
TDD selection, review checkpoints, diagrams, architecture review, fix loops, and
artifact capture.

Use this workflow when:

- Requirements still need grilling.
- The implementation may need prototype, TDD, review, or architecture loops.
- The work will produce artifacts that need placement decisions.
- Multiple checkpoints are needed to finish safely.

Do not use this workflow for:

- Clear small bugs.
- Single failing test fixes.
- Single-file refactors.
- Short documentation edits.

Candidate stages:

1. Grill requirements.
2. Run the learning strategy gate.
3. Run implementation loop.
4. Run staff-level review checkpoint.
5. Run TDD fix loop.
6. Run the diagram gate.
7. Run architecture improvement checkpoint when risk or design pressure warrants it.
8. Run TDD fix loop again if architecture changes are made.
9. Store durable and temporary artifacts in the right location.

Decision gates:

- Skip prototype when the solution space is already clear.
- Skip diagrams when prose and tests are sufficient.
- Skip architecture review for narrow, low-risk changes.
- Stop before escalating from local scratch artifacts to durable docs.

#### Learning Strategy Gate

The workflow should decide whether to use TDD, prototype, or both before
starting implementation.

Use TDD first when:

- Expected behavior is clear.
- The public interface is known.
- The primary risk is correctness or regression.
- The change needs confidence while modifying existing code.

Use prototype first when:

- Behavior or UX is unclear.
- The data model or state model is uncertain.
- There are multiple plausible designs.
- The team needs to compare approaches before committing to production code.

Use both when:

- The prototype answers a design question.
- TDD converts the chosen answer into production behavior.

The gate output should include:

```text
strategy: tdd | prototype | prototype-then-tdd | tdd-with-spike
reason:
artifact expectations:
exit criteria:
```

#### Diagram Gate

The workflow should draw a diagram only when it reduces ambiguity or review
cost. Do not create a diagram just because the workflow has a diagram step.

Use a sequence diagram for:

- Cross-service flow
- Async or event flow
- Request lifecycle
- Failure or retry behavior

Use a tree diagram for:

- Ownership hierarchy
- Dependency shape
- Routing or module structure
- Decision trees

Use a class or module diagram for:

- Object or module relationships
- Interface boundaries
- Before/after architecture
- Coupling problems

The gate output should include:

```text
diagram_needed: yes | no
diagram_type:
reason:
audience:
artifact_destination:
```

#### Architecture Improvement Checkpoint

Run architecture improvement only when there is a design pressure signal.

Trigger this checkpoint when:

- The TDD fix loop keeps fighting the design.
- Tests require excessive mocking.
- The same change touches many unrelated modules.
- The public interface is too wide or unstable.
- The feature needs awkward plumbing across layers.
- A prototype reveals the current model is wrong.
- PR review finds maintainability or boundary risks.

Do not trigger this checkpoint for:

- Small behavior changes.
- Isolated bug fixes.
- Purely cosmetic UI changes.
- Clear implementations with local tests passing.

The checkpoint output should include:

```text
architecture_review_needed: yes | no
trigger_signal:
candidate_improvement:
risk_if_skipped:
artifact_destination:
```

### PR Review Workflow

Candidate skill name:

```text
review-pr-workflow
```

Purpose:

Guide PR review across one or more repositories by creating a bounded review
context bundle, running staff-level review where available, and producing
findings with evidence and verification notes.

Start with a primary review context bundle:

- PR diff
- Changed files
- Local tests or CI signal
- Related docs, ADRs, and CONTEXT files

Candidate stages:

1. Identify PR metadata, branch, diff, and changed files.
2. Build the primary review context bundle.
3. Ask for or register additional repositories only when they are needed for
   contracts, shared libraries, generated clients, deployment config, or caller
   behavior.
4. Run staff-level review checkpoint.
5. Produce findings ordered by severity.
6. Record verification performed or not performed.
7. Store review artifacts according to sensitivity.

Decision gates:

- Do not add extra repositories unless they answer a specific review question.
- Do not inspect unrelated machine paths or private folders.
- Stop and ask when credentials, private repositories, or external services are
  required.
- Stay read-only unless the user explicitly asks to fix the PR.

Extra repositories may be added only when needed for:

- Shared contracts
- Generated client/server pairs
- Deployment configuration
- Caller behavior
- Test fixture or schema sources

Each added repository must record:

- Repo path or remote
- Why it is needed
- Read scope
- Disallowed scope
- Whether it contains company-sensitive context

Default PR review mode is read-only:

- Inspect the PR diff.
- Inspect bounded review context.
- Run tests or checks only when allowed.
- Produce findings.
- Do not edit files.
- Do not push.
- Do not comment on the PR unless explicitly asked.

Review-fix mode is allowed only when the user asks to fix or apply changes.

Review-fix mode requires:

- Create or confirm the working branch.
- Edit only the assigned scope.
- Run verification.
- Produce a changed-files summary.
- Do not push or comment on the PR unless explicitly asked.

## Staff-Level Review

`staff-level-review` is the canonical checkpoint term in this repository.

There is no assumed standard external `staff-review` skill. If a private or
external `staff-review` skill is available, the workflow may invoke it at the
review checkpoint. If it is unavailable, the workflow should produce a
staff-level review checklist instead of failing.

Staff-level review is read-only by default and should cover:

- Correctness
- Architecture
- Security and privacy
- Performance
- Test quality
- Operational risk
- Maintainability
- Requirement compliance
- Rollout and observability

Do not import an external `staff-review` skill into this public repository
unless its source and license are verified. Prefer building a local
`staff-level-review` spec or skill before adopting an external implementation.

## Diagrams

Diagrams are artifacts, not mandatory ceremony.

Use diagrams when they clarify:

- Execution sequence
- Cross-service interactions
- Class or module relationships
- State transitions
- Before/after architecture

Avoid diagrams that merely restate obvious code structure.

## Artifact Policy

Artifact placement depends on durability and sensitivity.

Both development and PR review workflows use the same artifact policy, but each
workflow may define different default destinations.

Repo-local durable artifacts:

- ADRs
- Accepted architecture notes
- Accepted diagrams
- PRDs
- Public handoff docs

Repo-local scratch artifacts:

- Temporary diagrams
- Prototype notes
- Review work files
- Intermediate analysis

Machine-level private artifacts:

- AI work logs
- Company-sensitive review notes
- Multi-repo investigation notes
- Private or customer-sensitive context

Public repositories must not receive company-sensitive artifacts.

Development workflow defaults:

- Accepted ADRs go under `docs/adr/`.
- Accepted diagrams go under project docs or into the PR description.
- Prototype notes stay in ignored scratch space or on the feature branch until
  the prototype is deleted or absorbed.
- Architecture notes become durable docs only when they explain a decision or
  reusable design insight.

PR review workflow defaults:

- Findings go into the PR review body or PR comments.
- Private multi-repo notes go into the private AI work-log vault.
- Temporary context bundles stay in ignored scratch space.
- Diagrams are committed only if they become durable design documentation.

## Relationship To Agent Team Workflow

These workflows may use `Spec 0002: Agent Team Workflow` when the task is
multi-domain, parallelizable, and context-heavy.

For smaller work, the workflow should stay single-agent and use lower-level
skills directly.
