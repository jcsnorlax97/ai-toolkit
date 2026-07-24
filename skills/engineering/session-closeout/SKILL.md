---
name: session-closeout
description: Chain the personal end-of-session skills — a session-log capture skill, lesson-extraction, and improvement-extraction — into a single wrap-up pass instead of invoking them one at a time. Use when the user wants to close out, wrap up, or end a work/coding session and capture everything worth keeping in one go. Triggers on "wrap up this session", "close out", "let's wrap", "session closeout", "收工", "收官三連".
status: trial
problem: Ending a work session that produced a session log, a personal lesson, and a repo-specific improvement candidate required three separate skill invocations every time, each easy to forget individually.
when-not-to-use: Do not use inside the personal knowledge vault itself — that repo runs its own after-action.md three-step process (after-action, capture-assistant-session, lesson-extraction; no improvement-extraction, since the vault isn't a company/work repo). Do not use for a session that produced nothing worth keeping; each sub-skill already knows how to report "nothing to capture."
maintainer: Justin Choi
---

# Session Closeout

Chain three personal skills into one end-of-session pass instead of invoking each separately: a session-log capture skill (e.g. `capture-assistant-session`), `lesson-extraction`, and `improvement-extraction`. This skill does not duplicate their logic — it only sequences them and reports one consolidated summary. If any of the three changes its own behavior later, this skill picks that up automatically since it just invokes them by name.

## When to run this

At the natural end of a work/coding session in a company or project repo — not the personal knowledge vault (see `when-not-to-use`; that repo already has its own three-step after-action process).

## Step 1 — Session-log capture

Invoke whichever session-log capture skill is installed (e.g. `capture-assistant-session`) via the Skill tool. If none is installed on this machine, note that plainly and move on to Step 2 — do not treat it as a hard failure.

## Step 2 — Lesson extraction

Invoke `lesson-extraction` via the Skill tool. It has its own confirm-before-write gate into the personal vault. Do not skip or auto-approve that gate on the user's behalf — let it run exactly as it's designed to, including asking the user to confirm before writing.

## Step 3 — Improvement extraction

Invoke `improvement-extraction` via the Skill tool. It writes candidate baseline/skill notes to `IMPROVEMENTS_ROOT` with no confirmation gate, since that folder is scratch material for later manual review.

## Step 4 — Consolidated report

After all three finish (or are explicitly skipped), give the user one summary covering all three: what was written, what was extended, what each skill found nothing worth capturing, and anything skipped because a skill wasn't installed. Do not print three separate skill reports back to back — merge them into a single readable summary.

## Notes

- Run the steps in order, not in parallel. `lesson-extraction`'s confirmation gate is interactive and should resolve before moving on to the next skill.
- If a skill isn't installed on this machine (not present via the Skill tool's listing), say so plainly rather than silently skipping it without mention.
- This is a sequencer, not a rewrite of any of the three skills' logic. Improvements to the individual skills' triggers, gates, or output formats apply automatically the next time this runs.
