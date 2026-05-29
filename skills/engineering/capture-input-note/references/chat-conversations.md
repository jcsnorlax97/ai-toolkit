# Chat Conversations

Use for Slack threads, Slack exports, Teams chats, copied channel discussions,
or other workplace chat conversations.

## Accepted Inputs

- User-provided redacted chat excerpt.
- Local exported chat file explicitly provided by the user.
- Screenshot-derived text only when the user provides the extracted text.
- Public chat archive page when it is safe and readable.

## Access Method

- Prefer user-provided redacted excerpts for workplace chat.
- Do not use work-account access, workspace search, channel browsing, or private
  message access unless the user provides the exact text to capture.
- If a local export file is provided, read only that explicit file.

## Extraction Steps

1. Identify platform, channel/thread if safe, date range, and topic.
2. Summarize the conversation intent and outcome.
3. Extract decisions, action items, open questions, blockers, and reusable
   workflow ideas.
4. Preserve enough context to understand why the thread matters.
5. Avoid reconstructing a complete conversation history.

## Redaction Risks

- Workplace chats often contain employee names, customer details, incidents,
  credentials, private links, sales details, and HR-sensitive context.
- Replace private names and links with `[redacted]` unless they are essential and
  approved by the user.
- Do not preserve message IDs, private channel names, or internal permalinks by
  default.

## What To Summarize

- Topic and why captured.
- Decision or unresolved question.
- Action items with assignees only when safe and explicit.
- Important context, constraints, and follow-up owners.
- Candidate reusable workflow or methodology signals.

## Stop Conditions

- The user asks the agent to browse private Slack/Teams directly.
- The source includes many threads or a bulk export.
- The excerpt contains sensitive data that cannot be summarized safely.
- The chat is primarily personal, HR, legal, medical, or confidential customer
  material.

## Verification

- The note is a summary, not a transcript.
- Explicit action items are not invented.
- Sensitive identities, links, and customer details are redacted.
- Open questions are clearly separated from decisions.
