# Handoff: 2026-07-05 Carman Church Website Retro Actions

Source: retro of the carman_church_website sessions (2026-07-04/05: parish
content + prayer requests, magic-link admin login, multi-page split, Vercel
preview/production split, CI gate). This file is self-contained; the executing
session should not need the original transcript. Product-side decisions live
in `carman_church_website/CONTEXT.md` (owned there — do not mirror them here).

Doctrine gates were applied during the retro; execute only the three tasks
below. Explicit non-goals at the bottom.

## Task 1 — Update `baselines/vercel-operations/baseline.md`

Add these dated learnings (all hit on 2026-07-05 in carman_church_website):

- Changing the production branch is `PATCH /v9/projects/{id}/branch` with
  `{"branch": "<name>"}`; it fails with `git_branch_not_found` unless the
  branch already exists on the connected Git remote. The `PATCH /v9/projects`
  body does NOT accept a `link.productionBranch` property.
- A stable per-branch preview URL ("INT link") is a branch-pinned custom
  domain: `POST /v10/projects/{id}/domains` with
  `{"name": "<sub>.vercel.app", "gitBranch": "<branch>"}` — prefer this over
  the auto-generated `-git-<branch>-` aliases (those get length-truncated).
- Preview deployments 302 to Vercel SSO login by default (Deployment
  Protection). Check this before sharing a preview/INT link with a client;
  disabling it is a security decision the user must make explicitly.
- `vercel link --yes` may create `.vercel/repo.json` (repo-style link, project
  id under `projects[]`) instead of `.vercel/project.json`; read both when
  looking for the project/org id.

## Task 2 — New baseline: `baselines/supabase-operations/`

Pain evidence (four distinct incidents, one project, one day — 2026-07-04/05):

1. Admin login failed "Invalid login credentials"; root cause was zero users
   in Supabase Auth, suspected cause was a stale `.env`. Diagnosed read-only
   via `GET /auth/v1/admin/users` with the service-role key.
2. Server rejected a valid allowlisted login; root cause was a stale
   `export ADMIN_EMAILS=...` in the shell overriding `.env` (dotenv
   convention: real env wins). Diagnosed via `ps eww <pid>` on the running
   server process.
3. Agent-side writes to the shared INT database (approving records, deleting
   rows) needed explicit user authorization; read-only diagnostics did not.
4. Magic-link login silently landed on the wrong page until the site URL was
   added to the Supabase Auth redirect allowlist.

Suggested principles (draft, tighten in place):

- Diagnose read-only first: with a local service-role key, list auth users,
  compare emails against the app's allowlist, and query tables read-only
  before touching anything or asking the user for info the key can answer.
- Never write to a shared/INT/prod Supabase database without explicit user
  authorization for that specific write; test data creation counts.
- On "invalid credentials", check the user exists in Auth before debugging
  config. On allowlist rejections, check the running process's real
  environment (`ps eww <pid>`) before editing `.env` — exported shell vars
  beat dotenv files.
- Magic-link/OTP flows require the exact landing URL in the Auth redirect
  allowlist (per environment); `create_user: false` prevents self-signup.
- Passwords live only in Supabase Auth (hashed); "we store passwords in our
  DB" is a false premise to correct, not a risk to fix.

## Task 3 — Minimal preset mechanism (`presets/`)

Pain: baselines are hand-pasted into each repo's CLAUDE.md
(carman_church_website carries 8; the a-ai-codex root carries 3 — repeated
manual assembly across repos).

Doctrine fit: kills the manual copy-paste layer (rule 2); minimal form only
(rule 3): a `presets/` directory in THIS repo — one text file per preset
listing baseline/skill/hook names — plus one apply script (e.g.
`scripts/apply-preset.sh <preset> <target-repo>`) that concatenates the named
baselines into the target's CLAUDE.md and installs the named hooks. No new
repo, no spec dir, no CONTEXT.md for presets.

First preset `supabase-vercel-site`: git-collaboration-hygiene,
repo-context-grounding, karpathy-principles, code-doc-sync,
vercel-operations, supabase-operations (from Task 2), layered-ownership,
process-vs-work-doctrine; hook: ensure-vercel-cli.

## Non-goals (rejected in the retro, do not resurrect here)

- No church-website template/sample extraction — one use only (doctrine
  rule 3). The carman repo itself is the reference; a second similar client
  clones it directly; only a third justifies an ai-workbench template.
- No new skills or hooks — nothing failed twice for lack of one.
- No automation for tagging releases or spawning cross-repo sessions — the
  existing one-liners suffice until the same friction has two dated
  occurrences.
