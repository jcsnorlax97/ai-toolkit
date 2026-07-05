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

## Promotion threshold

Do not wrap the grep or the execute one-liner in a skill or alias yet
(doctrine rules 1 and 6). Promote only after two dated occurrences of a
pending handoff being forgotten or the one-liner failing someone; record
those dates here when they happen.
