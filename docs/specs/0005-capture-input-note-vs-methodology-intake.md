# Spec 0005: Capture Input Note vs Methodology Intake

## Status

Accepted

## Purpose

Clarify the boundary between `capture-input-note` and `methodology-intake`, and
record why both currently live under `skills/engineering/`.

## Short Version

`capture-input-note` ingests and preserves external source material safely when
source access, extraction, redaction, or provenance work is required.

`methodology-intake` decides whether source material should change repo
artifacts.

Use them in this order when a source is private, long, authenticated, noisy, or
likely to need later review:

```text
external source
  -> capture-input-note
  -> redacted input note in ai-work-logs/inbox/.../notes/
  -> methodology-intake
  -> Rule | Skill | Context term | ADR | Spec | Issue | No-op
```

For a small public source that is safe to read directly, `methodology-intake`
may run without a prior input note.

## Boundary

| Question | capture-input-note | methodology-intake |
| --- | --- | --- |
| Primary job | Ingest, redact, and preserve external source material that needs source-access or provenance work. | Classify adoption into repo artifacts. |
| Main output | One input note in the work-log inbox. | One methodology intake report. |
| Side effect | Writes to `ai-work-logs/inbox/YYYY/MM/DD/notes/`. | Read-only by default. |
| Source scope | AI chats, Slack/Teams, transcripts, recordings, articles, papers, workflow sources, and links requiring ingestion. | Methodology sources being considered for adoption. |
| Classification | Records `routing_class: selected_source`, `source_type: external_source`, adapter-specific `source_kind`, `source_access_status`, and `scope`. | Assigns one destination and one retention status. |
| Does not do | Promote ideas into durable knowledge or repo changes. | Persist raw source material or create repo artifacts unless explicitly asked later. |

## When To Use Which

Use `capture-input-note` when:

- the source may disappear, require auth, or need a safe local summary;
- the source is a meeting, chat, transcript, recording, shared AI conversation,
  article, paper, or link that requires reading, rendering, parsing,
  transcription planning, or provenance preservation;
- the source may contain confidential or personal content that must be redacted;
- the source should feed a daily capture review, later methodology intake, or manual
  review.

Use `capture-to-outbox --input-type external_source` instead when the user has
already selected and pasted the exact excerpt or snippet and only needs a local
review-stage note.

Use `methodology-intake` when:

- the question is whether a source should become a Rule, Skill, Context term,
  ADR, Spec, Issue, or No-op;
- a captured input note, public source, or redacted excerpt is already available
  for evaluation;
- the user wants an adoption recommendation before changing repo artifacts.

If the user asks for both capture and adoption analysis, capture first, then run
methodology intake from the captured note.

## Placement Decision

`methodology-intake` belongs in `skills/engineering/` as a permanent local
companion skill because it governs admission into engineering workflow
artifacts: skills, specs, ADRs, issues, and stable repo language.

`capture-input-note` is more borderline. Its primary side effect writes into
the AI work-log vault, so its natural long-term owner may be
`ai-work-log-bootstrap`. It currently remains in `skills/engineering/` because:

- it feeds the engineering methodology pipeline before `methodology-intake`;
- the current install scripts expose canonical personal skills from
  `skills/engineering/`;
- moving it now would create churn before the Teams / meeting-source workflow is
  validated on a work computer;
- duplicating the same skill body in two repos would create competing sources
  of truth.

## Migration Trigger

Revisit moving `capture-input-note` to `ai-work-log-bootstrap` when one of these
happens:

- work-log bootstrap gains its own full personal-skill install path;
- most changes to `capture-input-note` are about work-log vault contracts rather
  than methodology-source capture;
- non-engineering source capture becomes the dominant usage;
- another work-log capture skill needs to share its routing references or
  extraction scripts.

If it moves, perform a deliberate migration:

1. Choose one canonical owner.
2. Update install scripts and adapter docs.
3. Replace any old copy with a pointer or remove it in a separate migration.
4. Run verification in both affected repos.
5. Update the ecosystem roadmap and spec.

Do not maintain duplicate canonical skill bodies.
