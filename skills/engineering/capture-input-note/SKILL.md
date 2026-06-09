---
name: capture-input-note
description: Capture an external source as a redacted markdown input note in the private AI work-log inbox when the source requires reading, rendering, parsing, transcription planning, access-status tracking, redaction, or provenance preservation. Use for shared AI conversations, Slack or Teams conversations, meeting transcripts, recordings, articles, papers, workflow sources, or links that need source ingestion before later review or methodology intake.
---

# Capture Input Note

## Overview

Create a safe, summarized input note from external source material and save it
to the AI work-log vault inbox. This is a specialized `selected_source`
ingestion adapter for material that needs source access or provenance work
before review.

An input note is source material for review. It is not final knowledge, not a
raw transcript, and not a formal skill.

## Boundary

- Use `capture-input-note` when an external source needs reading, rendering,
  parsing, transcription planning, access-status tracking, redaction, or
  provenance preservation.
- Use `capture-assistant-session` for the current Claude Code, Codex, or AI
  assistant session.
- Use `capture-to-outbox --input-type external_source` for an already-selected
  pasted excerpt or snippet that only needs local review staging and does not
  need source access or provenance work.
- Use `methodology-intake` after capture when deciding whether the source should
  become a Rule, Skill, Context term, ADR, Spec, Issue, or No-op.
- Do not inspect the user's private main Obsidian vault.
- Do not store raw transcripts by default.

## Workflow

1. Identify the source type and route to exactly one reference file below.
2. Read that reference file before extracting source details.
3. Decide whether the source is safe to inspect directly, needs rendering,
   needs parsing, needs transcription first, or requires a user-provided
   redacted excerpt.
4. Read accessible source content when permitted and technically possible.
5. Extract only enough context for later review.
6. Classify the note with `scope: work | personal | mixed`; infer
   conservatively when the source has no explicit scope.
7. Redact sensitive values and private details before writing.
8. Resolve the work-log root and create only today's `notes/` folder.
9. Write or update one markdown input note.
10. Report the capture file path, source access status, scope, redactions, and any
   assumptions.

## Source Routing

Choose the first matching route:

| Source | Read |
| --- | --- |
| Gemini, ChatGPT, Claude, or other public/shared AI conversation link | `references/shared-ai-conversations.md` |
| Slack thread/export, Teams chat, copied chat conversation, or channel excerpt that needs summarization, redaction, or provenance preservation | `references/chat-conversations.md` |
| Teams/Zoom/Meet transcript, `.vtt`, `.srt`, `.docx`, `.txt`, or meeting notes with transcript text | `references/meeting-transcripts.md` |
| Video/audio recording with no transcript, `.mp4`, `.mov`, `.m4a`, `.mp3`, or screen recording | `references/media-without-transcript.md` |
| Article, paper, blog post, workflow idea, repo note, or copied source excerpt that needs provenance or extraction work | `references/articles-and-papers.md` |

If no route fits, treat the source as `other`, capture only metadata and why it
matters, then add an open question about the missing route.

## Source Classification

Use the AI OS capture envelope:

```yaml
routing_class: selected_source
source_type: external_source
```

Use one of these adapter-specific `source_kind` values when possible:

- `gemini-conversation`
- `ai-chat`
- `slack-conversation`
- `teams-chat`
- `meeting-transcript`
- `video-notes`
- `media-without-transcript`
- `article`
- `paper`
- `workflow-idea`
- `copied-excerpt`
- `other`

Use one of these `source_access_status` values:

- `read-public`: content was read from a public source.
- `read-rendered`: content was read after browser rendering.
- `read-local-file`: content was read from a local file provided by the user.
- `partial`: only part of the source was readable.
- `user-excerpt`: the user supplied a redacted excerpt.
- `needs-transcription`: media cannot be usefully captured until transcript
  text exists.
- `unread-login-required`: reading required login or work-account access.
- `unread-blocked`: the source was blocked, expired, deleted, or inaccessible.
- `unread-empty`: no useful content was extractable.

## Output Location

Resolve the work-log root in this order:

1. A path explicitly provided by the user.
2. `AI_WORK_LOG_ROOT`, if available.
3. `WORK_DAILY_LOG_ROOT`, if available.
4. A nearby `ai-work-logs/` folder.
5. A nearby `work_daily_logs/` folder only as a compatibility fallback.

Recommended production roots:

```text
macOS:   ~/Documents/a-ai-obsidian-vaults/ai-work-logs/
Windows: %USERPROFILE%\Documents\a-ai-obsidian-vaults\ai-work-logs\
```

Write the capture file to:

```text
<work-log-root>/inbox/YYYY/MM/DD/notes/
```

Use the user's local date unless the user gives a different date.

## File Name

Use a stable, descriptive markdown filename:

```text
<source-type>-<topic>.md
```

Examples:

```text
gemini-meeting-video-workflow.md
slack-release-decision-thread.md
meeting-product-prioritization.md
media-no-transcript-onboarding-demo.md
article-ai-review-process.md
```

If a matching file already exists, update it instead of creating duplicates.

## Input Note Format

Use this structure:

```markdown
---
status: inbox
routing_class: selected_source
source: external-input
source_type: external_source
source_kind:
source_url:
source_access_status:
project:
domain:
scope:
topic:
candidate_tags:
  - selected-source/candidate
  - scope-appropriate/input
needs_review: true
---

# Input Note - YYYY-MM-DD - Short Topic

Source kind:
Source URL:
Source access status:
Project:
Domain:
Scope:
Topic:
Why captured:

## Source Access

- Attempted:
- Result:
- Limitation:

## Source Summary

- ...

## Useful Ideas

- ...

## Reusable Workflow Signals

- Trigger:
- Inputs:
- Steps:
- Outputs:
- Verification:
- Stop condition:

## Decisions Or Claims To Verify

- ...

## Open Questions

- ...

## Follow-ups

- ...

## Redactions

- Redacted secrets, credentials, private URLs, customer/private data, and
  sensitive internal details.
```

Omit empty sections only when they add no value. Prefer short bullets over long
prose.

## Redaction Rules

Before writing, remove or replace:

- API keys, access tokens, refresh tokens, session IDs, cookies, and passwords.
- Private keys, certificates, SSH keys, and signing secrets.
- Customer private data, personal data, private URLs, and internal confidential
  details.
- Full raw transcripts, long chat logs, or long copied source passages.
- Full stack traces or logs that contain sensitive values.

Use `[redacted]` for removed values. Do not claim a value was safely captured if
it was omitted for safety. Say it was redacted.

## Stop Conditions

Stop and ask the user for a redacted excerpt when:

- The source requires login or work-account access.
- The source may contain confidential, customer, employee, or private data.
- Capturing the source would require storing a raw transcript.
- The source is blocked by CAPTCHA, expired/deleted link, Workspace restriction,
  or no extractable rendered content.
- The user asks to bulk import many sources.

Stop after writing one input note unless the user explicitly asks for another
specific source to be captured.

## Relationship To Review

This skill creates source material in `inbox/.../notes/`.

It does not create the daily capture review or promote the source into durable
knowledge. It records enough redacted context for later review.

Use `daily-work-log` when the source should enter a daily capture review. Use
`methodology-intake` after capture when deciding whether the source should
become a Rule, Skill, Context term, ADR, Spec, Issue, or No-op.
