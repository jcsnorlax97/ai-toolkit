---
name: methodology-intake
description: Evaluate an external article, repository, tool list, paper, framework, or workflow before promoting it into repo artifacts. Use when deciding whether outside methodology material should become a Rule, Skill, Context term, ADR, Spec, Issue, or No-op.
---

# Methodology Intake

Use this as a read-only classifier before turning external methodology sources
into repo artifacts. Do not create or modify skills, specs, ADRs, issues, or
glossary terms during intake unless the user explicitly asks for the follow-up
work after reviewing the report.

## Inputs

- External methodology source: article, repository, X thread, paper, tool list,
  framework, workflow, or public discussion.
- Optional captured input note from `capture-input-note`.
- Optional user goal: learn, critique, adapt, implement, reject, or park.

## Workflow

1. Read the source, captured input note, or provided excerpt closely enough to
   classify it.
2. Check current repo language in `CONTEXT.md` and relevant roadmap/spec docs.
3. Produce one Markdown methodology intake report.
4. Assign exactly one primary intake destination.
5. Assign exactly one retention status.
6. Explain why the other destinations were not selected.
7. If implementation is recommended, name the minimum vertical slice and
   verification.

## Destinations

Use exactly one primary destination:

- `Rule`: A judgment principle that can be absorbed into an existing workflow.
- `Skill`: A repeatable workflow with trigger criteria, inputs, steps, outputs,
  verification, stop conditions, and repo fit.
- `Context term`: Stable project language that will be reused across workflows,
  specs, or skills and affects classification, acceptance, or boundaries.
- `ADR`: A hard-to-reverse, surprising-without-context repo decision that comes
  from a real trade-off surfaced during intake.
- `Spec`: Source material that should define or change cross-workflow
  structure, process, contracts, artifact policy, or acceptance rules.
- `Issue`: A tracked, scoped, independently verifiable work item.
- `No-op`: No formal workflow artifact should be created or updated.

## Retention Status

Use exactly one retention status:

- `discard`: Do not retain the source. Use for duplicates, low-signal material,
  irrelevant material, or unacceptable license / attribution risk.
- `parked`: Retain as background material, but do not process further now.
- `revisit-on-trigger`: Retain and define the concrete trigger that should make
  someone re-evaluate it.

`No-op` does not mean delete or forget. A no-op source may still be parked or
revisited later.

## Skill Admission Gate

Classify a source as `Skill` only when it shows a repeatable workflow:

- trigger: when to use it
- input: required source material or context
- workflow: repeatable steps, not just advice or a tool list
- output: artifact or decision produced
- verification: how the result is judged acceptable
- stop condition: when to stop exploring or iterating
- repo fit: how it belongs in the current skills/specs/workflow system

If these signals are missing, prefer `Rule`, `Spec`, `Issue`, `Context term`,
or `No-op`.

## Relationship To Capture Input Note

`capture-input-note` preserves source material as a redacted work-log inbox
note. `methodology-intake` classifies whether that source should change repo
artifacts.

Use a captured input note as the preferred input when the source is
authenticated, private, long, noisy, likely to disappear, or needs redaction.
Do not create persistent captures inside methodology intake; run
`capture-input-note` first when capture is needed.

## Tool-List-Only Sources

A tool-list-only source primarily lists tools, SDKs, repositories, or frameworks
without enough workflow, verification, or stop-condition detail. Do not promote
it directly into a skill.

Typical result:

```markdown
destination: No-op
retention: parked
```

Use `Rule` instead of `No-op` only when the source clearly supports a reusable
judgment principle for an existing workflow.

## Report Template

```markdown
# Methodology Intake Report

## Source

- title:
- url_or_path:
- source_type: article | repo | X thread | paper | tool list | workflow | other
- license_or_attribution_status:

## Classification

- destination: Rule | Skill | Context term | ADR | Spec | Issue | No-op
- retention: discard | parked | revisit-on-trigger
- confidence: low | medium | high

## Rationale

- why this destination:
- why not the other destinations:

## Evidence

- reusable workflow signals:
- missing signals:
- source excerpts or references:

## Risks

- adoption risk:
- license / attribution risk:
- repo fit risk:

## Recommended Next Step

- action:
- revisit_trigger:
- minimum vertical slice, if any:
- verification:
```

## Acceptance Examples

Use these examples to sanity-check the classification behavior:

- Tool-list-only source: classify as `No-op` or `Rule`; set retention to
  `parked` or `revisit-on-trigger`; do not recommend creating a skill directly.
- Visual prompt reconstruction workflow: classify as candidate `Skill` when it
  has a generation/evaluation/refinement loop; identify guardrails such as
  authorization, copyright, evaluator, max iterations, and stop condition; name
  a minimum vertical slice before implementation.
