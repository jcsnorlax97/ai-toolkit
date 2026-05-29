# Meeting Transcripts

Use for Teams, Zoom, Google Meet, or other meeting transcripts in `.vtt`,
`.srt`, `.docx`, `.txt`, copied text, or equivalent exported formats.

## Accepted Inputs

- Explicit local transcript file path provided by the user.
- Redacted transcript excerpt pasted by the user.
- Meeting notes that include transcript-like discussion text.

## Access Method

- Read only the exact transcript file or excerpt the user provides.
- For Teams recordings, prefer the native meeting transcript export over the
  video file.
- Do not access the user's calendar, Teams account, or meeting chat directly.

## Extraction Steps

1. Identify meeting source, date, participants only if safe, and topic.
2. Strip timestamps and filler only for summarization; do not rewrite the
   transcript into the note.
3. Summarize purpose, outcome, decisions, action items, risks, blockers, and
   follow-up questions.
4. Mark uncertain speaker attribution as uncertain.
5. If the user wants formal meeting notes, recommend a separate
   meeting-transcript skill rather than expanding `capture-input-note`.

## Redaction Risks

- Meeting transcripts may include confidential strategy, customer data, employee
  details, credentials spoken aloud, private URLs, and unpublished decisions.
- Redact names, companies, links, and sensitive project details unless the user
  explicitly wants them retained.
- Do not retain complete transcript passages.

## What To Summarize

- Meeting purpose and outcome.
- Decisions made and their context.
- Explicit action items, owners, and due dates.
- Risks, blockers, and unresolved questions.
- Reusable workflow or knowledge candidates.

## Stop Conditions

- The transcript is too large for a single concise capture.
- The user asks to bulk process many meetings.
- The source contains sensitive material requiring human redaction first.
- The user needs production-quality meeting minutes rather than an inbox source
  note.

## Verification

- Action items are explicit in the transcript or clearly marked inferred.
- Decisions are supported by transcript content.
- The note captures review candidates without storing raw transcript text.
- Follow-ups state whether `methodology-intake`, `daily-work-log`, or a future
  meeting-specific skill should handle the next step.
