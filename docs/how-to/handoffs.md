# Cross-Repo Handoffs

How a session with context hands work to a future session in another repo,
without a central queue and without re-explaining context.

## Convention

- A handoff is one self-contained markdown file at
  `docs/handoffs/YYYY-MM-DD-<slug>.md` **in the repo that owns the work**
  (layered ownership: the owning repo records its own work items).
- Written by the session that has the context, at the moment it is fresh.
  It must be executable without the originating transcript: include the
  judgment basis, concrete specs, dated pain evidence, and explicit
  non-goals so a future (possibly weaker) model does not overreach.
- When executed, the executing session appends an `## Executed` section
  (date + one line per task). The file stays as a record.

## Finding pending handoffs (all repos)

There is deliberately no maintained global list — it would be a central
governance hub that goes stale (doctrine rule 4). Compute it instead:

```bash
grep -rL "## Executed" ~/Documents/a-ai-codex/*/docs/handoffs/*.md 2>/dev/null
```

## Executing one

```bash
cd <owning-repo> && claude "Execute docs/handoffs/<file>.md"
```

## Specs stop at the repo boundary

A handoff written from outside the owning repo specs **outcomes,
constraints, and evidence** — not implementation shape (language, framework,
file layout, tooling). Shape belongs to the owning repo's ADRs and
conventions, which the writer usually has not read.

- Writer rule: do not prescribe implementation shape across a repo boundary
  unless you have read the owning repo's ADRs and say so in the handoff.
- Executor rule: ground in the owning repo's ADRs/conventions before coding.
  If a handoff's implementation details conflict with a local ADR, the ADR
  wins — flag the conflict in `## Executed` instead of complying silently.

Dated evidence (2026-07-05): the carman retro handoff spec'd the preset
apply script as "bash, no dependencies beyond coreutils"; the executor built
exactly that, violating ADR 0001 (PowerShell as cross-platform core) and
bypassing the baseline CLI's managed-block engine. Corrected the same day by
`2026-07-05-preset-powershell-consistency.md`.

## Promotion threshold

Do not wrap the grep or the execute one-liner in a skill or alias yet
(doctrine rules 1 and 6). Promote only after two dated occurrences of a
pending handoff being forgotten or the one-liner failing someone; record
those dates here when they happen.
