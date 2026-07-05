# Supabase Operations Baseline

Status: active
Version: 0.1.0

This baseline installs operational habits for AI coding agents working on projects
that use Supabase for authentication and database. It directs agents to diagnose
read-only before writing, get explicit user authorization before mutating shared
data, and check the running process environment before editing config files.

## Rules

1. Diagnose read-only first.
   With a local service-role key, list auth users via
   `GET /auth/v1/admin/users`, compare their emails against the app's allowlist,
   and query tables read-only before touching anything or asking the user for
   information the key can already answer.

2. Never write to a shared or production Supabase database without explicit authorization.
   Mutations — approving records, deleting rows, creating test data — require
   explicit user authorization for that specific write each time. Read-only
   diagnostics do not require separate authorization.

3. On "invalid credentials", check Auth before debugging config.
   Verify the user exists in Supabase Auth before touching environment files or
   allowlists. On allowlist rejections, check the running server process's real
   environment with `ps eww <pid>` before editing `.env` — exported shell
   variables beat dotenv files at runtime (dotenv convention: real env wins).

4. Magic-link and OTP flows need every landing URL in the Auth redirect allowlist.
   Each environment's exact landing URL must appear in the Supabase Auth redirect
   allowlist; a missing URL silently sends the user to the wrong page. Set
   `create_user: false` in the auth config to prevent unintended self-signup via
   the same flow.

5. Correct the "we store passwords in our DB" premise.
   Passwords live only in Supabase Auth (hashed); the application database does
   not and should not store them. Treat any claim that passwords are stored in a
   table as a false premise to correct, not a risk to patch.

## Priority

This baseline takes precedence over ordinary implementation habits, but never use it to
override explicit user instructions, safety rules, privacy boundaries, or stricter
repo-local instructions.
