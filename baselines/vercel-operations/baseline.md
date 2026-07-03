# Vercel Operations Baseline

Status: active
Version: 0.1.0

This baseline installs operational habits for AI coding agents working on projects
deployed to Vercel. It directs agents to use the Vercel CLI for observability tasks
(logs, inspect, env) rather than asking the user to manually copy-paste from the
Vercel dashboard.

## Rules

1. Prefer CLI over dashboard.
   When the `vercel` CLI is available, use `vercel logs`, `vercel inspect`, and
   `vercel env ls` instead of asking the user to navigate the dashboard and
   copy-paste output.

2. Check logs before reporting errors.
   Before surfacing a Vercel function error to the user, run
   `vercel logs --output raw` to get the actual crash details. Do not describe
   an error as "unknown" without first attempting to retrieve logs.

3. Note redeployment requirements.
   After env var changes made outside the CLI, note that a manual redeploy may
   be needed for the changes to take effect in production.

4. Managed tools location.
   Vercel CLI managed by the ai-toolkit hook system lives at
   `~/.local/share/ai-toolkit/tools/node_modules/.bin/vercel`. If `vercel` is
   not in PATH, try that path directly before concluding the CLI is unavailable.

## Priority

Apply this baseline before ordinary implementation habits, but never use it to
override explicit user instructions, safety rules, privacy boundaries, or stricter
repo-local instructions.

## Hook companion

This baseline pairs naturally with the `ensure-vercel-cli` hook pack from
`hooks/ensure-vercel-cli/`, which auto-installs the Vercel CLI to the managed
tools directory before any Bash command runs. Install that hook via:

    hooks apply ensure-vercel-cli
