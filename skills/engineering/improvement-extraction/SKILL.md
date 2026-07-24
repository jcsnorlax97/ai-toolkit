---
name: improvement-extraction
description: Scan the current session for candidate CLAUDE.md/AGENTS.md baselines or candidate Claude Code skills, and write them as structured notes to a configurable output folder for later manual review. Use when the user asks to extract improvement ideas, capture process improvements, or save candidate baselines/skills surfaced during this session — phrases like "extract improvements", "capture what we'd add to CLAUDE.md", or "save this as a candidate skill idea".
status: trial
problem: Candidate process improvements (baseline rules, skill ideas) surfaced during a session were only captured by manually asking, in full sentences, for the session to be scanned and written up — a repeated, mechanizable step done by hand every time.
when-not-to-use: Do not use for capturing a full session log (that belongs to a work-log capture skill such as capture-assistant-session), for cross-company-portable personal lessons (that belongs to a personal-vault lesson-extraction skill), or for ideas too narrow to generalize past the current task.
maintainer: Justin Choi
---

# Improvement Extraction

Scan the current session for candidate CLAUDE.md/AGENTS.md baselines or candidate skills, and write each as a structured note to a configurable output folder. This is a scratch capture step — candidates land here for later manual review, not automatic promotion into this repo's baselines or skills.

## Step 1 — Resolve the output root

- Read `IMPROVEMENTS_ROOT` from the environment.
- If unset, ask the user for the path once, then use it for this run only. Tell them how to persist it so this step isn't needed again:
  - Windows: `setx IMPROVEMENTS_ROOT "<path>"`
  - macOS/Linux: `export IMPROVEMENTS_ROOT="<path>"` in their shell profile
- Never write the resolved path into this skill file or any committed content — the environment variable is the only place it lives.

## Step 2 — What counts as a candidate

Only two categories qualify:

1. **Candidate portable baseline** — a rule that, had it existed in CLAUDE.md/AGENTS.md at the start of the session, would have prevented a mistake, correction, or ambiguity that actually came up. General enough to survive a future session or a different repo.
2. **Candidate skill** — a repeatable, at least partly mechanizable procedure that came up this session and would be cheaper to run as a scripted/semi-scripted skill next time than to redo by hand.

Exclude: routine bug fixes, one-off decisions, anything already covered by an existing baseline or skill, and anything too narrow to generalize past this one task.

## Step 3 — Dedup against existing notes

List the files already in `IMPROVEMENTS_ROOT` and skim their titles and first paragraphs. If a new candidate is a variation or reinforcement of an existing note's topic, extend that file (add an observation, a nuance, a "seen again" note) instead of creating a near-duplicate.

## Step 4 — Write one file per genuinely new idea

Filename: `kebab-case-topic.md`. Use this structure:

```markdown
# <one-line statement of the proposed rule/skill>

**Status:** improvement note / candidate baseline (or candidate skill) — not yet formalized
**Captured:** <date>
**Context:** <ticket/PR/repo this came from, one line>

## The observation
<what happened that surfaced this>

## The rule (proposed)
<the specific, actionable rule or skill description>

## Nuance (so we don't over-apply it)
<where this should NOT apply>

## What triggered this
<the concrete incident(s), with enough detail to be self-explanatory later>

## Future work
<what it would take to actually formalize this as a baseline or a skill>
```

No confirmation gate before writing — `IMPROVEMENTS_ROOT` is a working/scratch folder for candidate ideas, not curated long-term memory or this repo's governed skill/baseline inventory.

## Step 5 — Report back

State which files were created vs. extended, with a one-line summary of each.

## Relationship to other end-of-session tools

This is a third, distinct capture tool, not a replacement for whatever session-log or personal-lesson skills already exist in this environment:

- A **session-log capture skill** (e.g. `capture-assistant-session`) → full session log, written to a personal work-log vault.
- A **lesson-extraction skill** → sanitized, cross-company-portable personal lessons, written to a personal vault.
- `improvement-extraction` (this skill) → unsanitized, company/repo-specific candidate baselines and skills, staying inside the work context (a project folder, not a personal vault).

If neither of the other two skills exists in this environment, that's fine — this skill still runs standalone.
