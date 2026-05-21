# Spec 0004: Staff-Level Review

## Status

Draft

## Goal

Define a reusable staff-level review checkpoint for development and PR review
workflows.

The checkpoint should produce high-signal engineering feedback that improves
correctness, architecture, safety, operability, maintainability, and author
learning.

## Non-Goals

- Replace normal code review by humans.
- Run formatters, linters, or broad automated checks by default.
- Post comments to a PR without explicit user approval.
- Edit files unless the user explicitly switches to review-fix mode.
- Save review artifacts to tool-specific folders by default.

## Inputs

Staff-level review may receive:

- PR number, URL, branch, or local diff
- PR title and description
- Changed files
- Related docs, ADRs, and CONTEXT files
- CI or test signals
- Review context bundle
- Optional additional repositories approved by the review workflow

## Default Mode

Staff-level review is read-only by default.

Allowed by default:

- Inspect diff.
- Inspect bounded surrounding context.
- Inspect relevant docs, ADRs, and CONTEXT files.
- Inspect existing test/CI output when provided or accessible.
- Produce review findings.

Not allowed by default:

- Edit files.
- Push changes.
- Post review comments.
- Run broad build/test commands without approval.
- Inspect unrelated repositories or private machine paths.

## Diff Source

The review should identify its diff source before reviewing.

Supported diff sources:

- PR number or URL
- Branch compared to an explicit base
- Current branch compared to detected base
- Provided patch or diff file

If the diff source is ambiguous, ask before reviewing.

When using a branch without a PR, the review is based on local diff context and
should not assume PR metadata exists.

## Preflight

Before reviewing, decide whether the review should proceed.

Check:

- Whether the PR is draft.
- Whether the PR is closed or already merged.
- Whether the PR is a trivial automated change.
- Whether the PR already has sufficient review.
- Whether the diff is too large and should be split.
- Whether the requirements or PR description are missing.
- Whether extra repositories or context are required before review.

Preflight output:

```text
proceed: yes | no | needs-info
reason:
required_context:
suggested_next_action:
```

If preflight returns `no` or `needs-info`, stop and report the reason instead of
forcing a low-confidence review.

## Review Dimensions

Review across these dimensions, applying staff-level judgment and filtering for
high-signal issues.

### Correctness

- Edge cases such as null, empty, zero, concurrent access, partial failure, and
  unexpected input.
- Error propagation and state transitions.
- Broken contracts or behavior regressions.

### Architecture

- Fit with existing patterns.
- Responsibility boundaries.
- Coupling, hidden dependencies, and abstraction level.
- Simpler alternatives that preserve the goal.

### Security And Privacy

- Input sanitization.
- Authentication and authorization boundaries.
- Sensitive data logging, storage, or exposure.
- Injection risks, path traversal, shell execution, and dependency risks.

### Performance

- N+1 queries or unnecessary round trips.
- Expensive work in loops or repeated paths.
- Memory growth or unbounded data structures.
- Caching correctness and invalidation.

### Test Quality

- Key behavior coverage, including edge cases and error paths.
- Interface-level tests instead of implementation-detail tests.
- Determinism and dependency on time, ordering, or external state.
- Test setup complexity that signals design problems.

### Maintainability

- Naming and clarity.
- Mixing of concerns.
- Magic values.
- Complexity that is not justified by the problem.
- Whether a new maintainer can understand why the code exists.

### API And Interface Design

- Consistency with existing public APIs.
- Safe defaults.
- Extension points and compatibility.
- Useful error types and messages.

### Breaking Changes And Migration

- Public API, database schema, configuration, or wire protocol changes.
- Migration path.
- Backward compatibility and coordinated deploy needs.

### Operability

- Rollout risk.
- Observability.
- Failure mode visibility.
- Recovery or rollback path.

## False Positive Filter

Before reporting an issue, check whether:

- It is pre-existing.
- It is already handled elsewhere in surrounding code.
- CI, type checks, linting, or tests already cover it.
- It is an intentional design decision documented in the PR, comments, ADRs, or
  project docs.
- It is preference without a clear better alternative.

## Test Execution Policy

Staff-level review should not run broad build or test commands by default.

Allowed by default:

- Read CI status or test output when available.
- Read existing test files.
- Reason about missing coverage.

Allowed with explicit approval or workflow permission:

- Run a targeted test command.
- Run typecheck or lint when the command is known, safe, and scoped.

Not allowed by default:

- Full build across a large monorepo.
- Dependency installation.
- Test commands that modify external services or data.
- Networked integration tests.

## Severity Model

Use a small severity vocabulary.

`BLOCKING`: Must be fixed before merge. Examples: bug, security issue, broken
contract, data loss risk, unsafe migration, or serious operational risk.

`SUGGESTION`: Important improvement worth discussing. Examples: design issue,
test coverage gap, maintainability risk, or meaningful clarity issue.

`QUESTION`: Intent is unclear and should be clarified before deciding whether it
is wrong.

`NIT`: Minor issue that should not block merge.

Be selective. A few well-supported findings are better than a long list of weak
or speculative comments.

## Verdict Model

The verdict must be driven by findings, not reviewer mood.

Use this vocabulary:

- `Approve`
- `Approve with suggestions`
- `Request changes`
- `Needs clarification`

Mapping:

- `Request changes`: at least one `BLOCKING` finding.
- `Needs clarification`: no confirmed `BLOCKING` finding, but one or more
  `QUESTION` findings block review confidence.
- `Approve with suggestions`: no `BLOCKING` findings, and suggestions are worth
  considering but should not block.
- `Approve`: no `BLOCKING` findings, no confidence-blocking `QUESTION` findings,
  and suggestions or nits are minor or absent.

## Output Format

The output should be findings-first. If there are `BLOCKING` findings, they
must appear before all other findings. If no findings are found, say so
explicitly.

```markdown
# Staff-Level Review

## Findings

[BLOCKING] Short title

- Issue:
- Why it matters:
- Evidence:
- Recommendation:
- Location:

[SUGGESTION] Short title

- Issue:
- Why it matters:
- Evidence:
- Recommendation:
- Location:

[QUESTION] Short title

- Question:
- Why it matters:
- Evidence:
- What would resolve it:
- Location:

[NIT] Short title

- Issue:
- Recommendation:
- Location:

## Verdict

Approve | Approve with suggestions | Request changes | Needs clarification

## Summary

...

## What's Working Well

- ...

## Verification

- Diff source:
- Context inspected:
- Commands run:
- Checks reviewed:
- Not run:

## Review Constraints

- Read-only:
- Extra repos:
- Disallowed paths:
- Sensitivity:
```

Praise should be specific and should appear after findings.

## What's Working Well

This section is allowed, but constrained.

Rules:

- Include only specific, evidence-backed positives.
- Do not include generic praise.
- Do not include praise that weakens the urgency of `BLOCKING` findings.
- Never place praise before findings.

## Delivery Formats

The default delivery format is a grouped review report.

Optional delivery formats:

- Inline comment draft
- Codex local code-comment directive
- GitHub or GitLab posted inline comments

An inline comment draft is a review artifact that names a file, line, finding,
and proposed comment. It is not posted anywhere by default.

Codex local code-comment directives may attach feedback to local files in the
Codex UI. They are not the same as PR platform comments.

Posted inline comments require explicit user approval and platform support. The
workflow must know the PR identifier, commit SHA, file path, target line or
range, side of diff, and comment body before posting.

## Artifact Placement

Staff-level review does not decide artifact placement by itself. The calling
workflow decides according to the artifact policy.

Default destinations:

- PR review findings: PR review body or PR comments only when the user asks.
- Private company notes: private AI work-log vault.
- Temporary review notes: ignored scratch space.
- Durable design findings: project docs only when accepted as durable context.

Do not default to tool-specific folders such as `.claude/reviews/`.

## Relationship To External `staff-review`

Older or external `staff-review` skills may be used as references, but they are
not assumed to be standard.

Do not import an external `staff-review` skill unless:

- Its source is known.
- Its license permits reuse and redistribution.
- Its behavior is grilled against this spec.
- `docs/upstream-sources.md` and `NOTICE.md` are updated if material is
  imported.

## Review-Fix Mode

Review-fix mode is separate from staff-level review.

If the user asks to fix issues:

- Confirm branch and write scope.
- Apply only scoped changes.
- Run verification.
- Report changed files.
- Do not push or comment unless explicitly asked.
