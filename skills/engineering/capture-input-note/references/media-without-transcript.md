# Media Without Transcript

Use for video or audio recordings where no transcript is available yet.

## Accepted Inputs

- Local video/audio file path explicitly provided by the user.
- Public video/audio URL when safe and accessible.
- User-provided metadata about a recording.

## Access Method

- Do not process raw media directly inside `capture-input-note` by default.
- Capture metadata and mark `source_access_status: needs-transcription`.
- Recommend obtaining a transcript first through an approved workflow or tool.
- If the user explicitly asks for transcription, treat that as a separate task
  and verify tool availability, privacy constraints, and output location before
  proceeding.

## Extraction Steps

1. Capture source identifier, file name or URL if safe, date, topic, and why the
   media matters.
2. Record whether a transcript exists.
3. If no transcript exists, explain that review-quality capture requires
   transcript text first.
4. Add follow-ups to generate or obtain a transcript.
5. Do not infer meeting decisions from a file name or vague description.

## Redaction Risks

- Recordings may contain voices, faces, screen shares, customer data, internal
  documents, credentials, private chat panes, and personal data.
- Public video URLs may still include copyrighted or sensitive material.
- Local transcription may create derivative text that needs the same privacy
  treatment as the recording.

## What To Summarize

- What the recording appears to be.
- Why it should be captured.
- Whether transcript text exists.
- What must happen before a useful input note can be completed.
- Any user-provided safe metadata.

## Stop Conditions

- No transcript exists and the user has not approved transcription.
- The media appears to include sensitive screen share, customer data, private
  faces/voices, or confidential material.
- The user asks to transcribe or process many recordings at once.
- The tool would need external services, credentials, or upload of private media
  without explicit approval.

## Verification

- `source_access_status` is `needs-transcription` unless transcript text was
  provided.
- The note does not pretend to summarize content that was not read.
- Follow-ups clearly name the next safe action.
