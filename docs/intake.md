# Intake

This file tracks unprocessed notes, article captures, and rough research briefs
that may inform future skills, specs, ADRs, or glossary updates.

Intake items are not design decisions. Treat them as inputs to future grilling
sessions until they have been verified, challenged, and either accepted into
canonical docs or rejected.

## Scratch Captures

Scratch captures may live under:

```text
.scratch/captures/
```

Current unprocessed captures:

- `.scratch/captures/2026-05-21-founder-playbook-skills-grill-brief.md`
- `.scratch/captures/2026-05-21-methodology-intake-skills-grill-brief.md`

Current external review-workflow references to grill before adoption:

- User-provided legacy `staff-review` skill: useful as a reference for review
  dimensions, severity labels, and constructive review principles. Do not import
  directly; grill against `docs/specs/0004-staff-level-review.md` first.
- ClaudSkills `staff-review`: conceptually relevant, but license/source details
  must be verified before importing.
- `speckit-staff-review-run`: relevant as a read-only staff-level review
  pattern, but appears tied to spec-kit structure.
- Empire `team-review`: relevant as a specialist review/team review pattern;
  license and source should be checked before reuse.
- Nanostack workflow model: relevant for phase-based delivery and artifact
  handoff, but not a direct staff-review skill.

## Processing Rules

- Do not commit `.scratch/captures/`.
- Do not promote capture content into a skill or spec without grilling it.
- Check source license and attribution before importing any external material.
- Convert accepted ideas into `CONTEXT.md`, a spec, an ADR, or a skill.
- Leave rejected or unverified ideas out of canonical docs.
