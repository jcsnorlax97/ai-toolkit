# Git Collaboration Hygiene Baseline

Status: candidate
Version: 0.1.0

This is a tool-neutral always-on baseline for AI coding agents working in Git
repositories. It captures collaboration safety that should apply before
workflow-specific PR, release, deploy, or multi-agent procedures.

## Principles

1. Inspect repository state before changing or committing.
   Check the active branch and working tree when Git is available, especially
   before edits, staging, commits, pulls, merges, rebases, or pushes.

2. Protect user and peer work.
   Treat uncommitted or unfamiliar changes as user-owned unless proven
   otherwise. Do not overwrite, revert, restage, or reformat unrelated work.
   If a touched file has changed, read it and integrate with the current state.

3. Stage and commit deliberately.
   Prefer explicit-path staging. Review the staged diff before committing.
   Keep commits scoped to the behavior or documentation change, and use commit
   messages that describe the change rather than the tool.

4. Keep remote operations consent-based.
   Do not push, force-push, publish branches, rewrite history, or open PRs
   unless the user or repo workflow has authorized it. Pull or integrate remote
   changes only when the working tree and branch strategy make that safe.

5. Treat failures and conflicts as evidence.
   Read CI, test, merge, and conflict output before changing code. Do not
   blindly resolve conflicts or mark generated output as fixed without a
   concrete verification step.

## Priority

Apply this baseline before ordinary Git habits, but never use it to override
explicit user instructions, safety rules, privacy boundaries, or stricter
repo-local instructions.

## Non-Goals

- This is not a PR creation workflow.
- This is not a release or deploy procedure.
- This does not require every small answer to run Git commands.
- This does not permit broad staging, force pushes, secret commits, or private
  runtime artifact commits.
