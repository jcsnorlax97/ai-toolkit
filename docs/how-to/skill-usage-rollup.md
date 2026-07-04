# Skill Usage Rollup (monthly)

Turn signal A (hook log) and signal B (capture frontmatter) into evidence entries and mechanical confidence adjustments in each canonical repo's `docs/skills-inventory.yaml`. Designed in `../ecosystem-audit-2026-07.md` (Phase 2).

## Inputs

- `~/.claude/skill-usage.log` — one line per Skill invocation: ISO timestamp, skill name, cwd (signal A; written by a user-level PostToolUse hook). Treat a missing file as zero triggers.
- Work-log captures for the month under `~/Documents/a-ai-obsidian-vaults/ai-work-logs/inbox/YYYY/MM/**/*.md` — optional `skills_used` frontmatter lists `{name, verdict: helped|neutral|fought, note}` (signal B). Treat missing fields as no data, not as neutral.

## Procedure

1. Count triggers per skill from the log for the target month.
2. Collect `skills_used` verdicts from that month's captures.
3. For each skill with any data, append ONE evidence entry of `type: usage-rollup` to its entry in the owning repo's inventory (`ai-toolkit/docs/skills-inventory.yaml` or `ai-second-brain/docs/skills-inventory.yaml`) with counts, verdict distribution, and at most one representative note.
4. Apply mechanical adjustments:
   - >=3 helped uses in rolling 90 days → set `confidence: validated`
   - 0 triggers in 60 days for an `active` or `candidate` skill → add flag line `stale: true` (freeze candidate, human decides)
   - >=2 fought verdicts in the month → add flag line `review: true` (deprecate candidate, human decides)
5. Never change `status:` mechanically — status changes stay human decisions.
6. Skip skills with zero data entirely: do not write empty rollup entries.

## Boundaries

- Read-only outside the two inventory files.
- Do not read the private main Obsidian vault.
- Do not create dashboards or new tooling.
- If the log format or inventory shape has drifted, stop and report instead of adapting silently.

## Trial run

**Date:** 2026-07-03

**Hook log status:** File does not exist (`~/.claude/skill-usage.log`). Triggers found: 0.

**Work-log captures with `skills_used` frontmatter:** Searched `~/Documents/a-ai-obsidian-vaults/ai-work-logs/inbox/2026/07/**/*.md` for YAML frontmatter `skills_used` field. Found: 0 captures with `skills_used` frontmatter.

**Conclusion:** Both signals (hook log installation and optional capture frontmatter adoption) went live on 2026-07-03. As of trial run date, no data has been collected. No inventory writes performed (zero-data skills are skipped by rule). Ready for next monthly rollup on 2026-08-03.
