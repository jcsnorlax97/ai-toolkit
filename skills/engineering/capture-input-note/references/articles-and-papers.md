# Articles And Papers

Use for articles, papers, blog posts, repo notes, framework descriptions,
workflow ideas, tool lists, and copied external methodology material.

## Accepted Inputs

- Public URL.
- Explicit local file path provided by the user.
- User-provided excerpt or notes.
- Bibliographic metadata for a paper or source.

## Access Method

- Read public sources when technically possible.
- Use primary sources when accuracy matters.
- For paywalled, login-gated, private, or copyrighted sources, ask for a short
  user-provided excerpt or summary.
- Avoid long quotations.

## Extraction Steps

1. Capture title, URL/path, source type, author/date if visible, and why the
   source matters.
2. Summarize the source's useful claims and workflow ideas.
3. Identify whether it has enough trigger, input, steps, output, verification,
   and stop-condition detail to feed `methodology-intake`.
4. Separate source claims from your own interpretation.
5. Add follow-ups for verification or intake.

## Redaction Risks

- Copied excerpts may include proprietary text, customer examples, or internal
  commentary.
- Research papers and articles may have copyright limits.
- Tool lists can become noisy prompt dumps if not classified.

## What To Summarize

- Main idea and relevance.
- Reusable workflow signals.
- Missing evidence or missing workflow details.
- Potential destination: Rule, Skill, Context term, ADR, Spec, Issue, or No-op.
- Minimum vertical slice if adoption seems plausible.

## Stop Conditions

- The user asks to save a full article or large copyrighted excerpt.
- The source is paywalled, private, or license-unclear and no summary/excerpt is
  provided.
- The material is only a tool list with no workflow signals; capture it as
  parked input rather than promoting it.

## Verification

- The note is short enough for later review.
- Quotes are minimal or omitted.
- The note names what needs `methodology-intake` and what should remain parked.
