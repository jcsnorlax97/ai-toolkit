# Shared AI Conversations

Use for public or user-provided Gemini, ChatGPT, Claude, Copilot, or other AI
chat conversations.

## Accepted Inputs

- Public shared conversation URL.
- Rendered conversation page visible without login.
- User-provided redacted excerpt from a private or work-account conversation.

## Access Method

- Read public shared links when technically possible.
- Use browser rendering when static HTML does not contain the conversation.
- For `https://gemini.google.com/share/...`, prefer the bundled helper:

```bash
scripts/extract_gemini_share_text.py https://gemini.google.com/share/<id>
```

- For private, login-gated, expired, deleted, Workspace-restricted, or CAPTCHA
  blocked pages, ask the user for a redacted excerpt.

## Extraction Steps

1. Capture title, source URL, platform, publication/share date if visible, and
   access status.
2. Extract the user's original question or intent.
3. Summarize the assistant's useful claims, workflows, tools, and decisions.
4. Separate source claims from your own follow-up recommendations.
5. Do not save the full conversation unless the user explicitly asks and the
   content is safe.

## Redaction Risks

- Shared links may expose the full conversation to anyone with the link.
- AI chats often contain private prompts, company details, customer references,
  copied code, logs, or URLs.
- Treat account names, internal links, customer names, and unpublished work as
  sensitive unless the user says otherwise.

## What To Summarize

- Why the source matters.
- Reusable workflow signals.
- Tools or file formats mentioned.
- Platform-specific constraints.
- Claims that need verification before becoming a skill, rule, or spec.

## Stop Conditions

- Login or work-account access is required.
- The source is blocked, expired, deleted, or CAPTCHA gated.
- The visible conversation contains sensitive data that cannot be safely
  summarized without user redaction.
- The user asks to import multiple shared conversations at once.

## Verification

- `source_access_status` is accurate.
- The note says whether rendered extraction was used.
- The note contains no raw transcript and no sensitive details.
- Follow-ups identify whether `methodology-intake` should run next.

## Related Scripts

- `scripts/extract_gemini_share_text.py` for public Gemini share links.
