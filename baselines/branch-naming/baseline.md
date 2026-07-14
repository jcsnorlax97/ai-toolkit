# Branch Naming Baseline

Status: active
Version: 0.1.0

This is a tool-neutral always-on baseline for AI coding agents that create
branches in a repository. It sets the *shape* of a new branch name so branches
are self-describing, sortable by kind, and easy to tie back to a commit and a
tracking item.

It deliberately shares its type vocabulary with the
[Conventional Commits](https://www.conventionalcommits.org/) standard used by
the `commit-conventions` baseline, so a branch and the commits on it rhyme
(`feat/oauth-login` carries `feat(auth): ...` commits). Branch naming is not
itself a public standard, so the specific form below is an opinionated
convention rather than a ported spec; it is kept generic so it applies to work
and personal repositories alike.

## Format

    <type>/<short-kebab-description>

with an optional tracking id in front of the description:

    <type>/<tracking-id>-<short-kebab-description>

## Allowed types

Use the same types as the `commit-conventions` baseline:

- `feat` — a new feature
- `fix` — a bug fix
- `docs` — documentation only
- `style` — formatting, whitespace, no logic change
- `refactor` — a code restructure that is neither a fix nor a feature
- `test` — adding or correcting tests
- `chore` — build process, tooling, or dependency updates
- `ci` — CI/CD configuration changes

## Rules

1. Start with a type and a single slash.
   `feat/`, `fix/`, `docs/` — one slash only, no deep nesting.

2. Describe the work in lowercase kebab-case.
   Two to five words, words separated by hyphens. No spaces, no uppercase, no
   characters other than `a-z`, `0-9`, `-`, and the one type slash.

3. Reference the tracking item with the bare id, not the commit-footer form.
   Prefix the description with the number, e.g. `feat/12345-oauth-login`. Do not
   put `AB#` or `#` in a branch name — `#` is a comment character in most shells
   and awkward to type. The full `AB#12345` / `Closes #123` reference belongs in
   the commit footer (see `commit-conventions`), not the branch.

4. Keep it short.
   Aim for 50 characters or fewer. The name is a handle, not a summary.

5. Leave long-lived and shared branches alone.
   This governs *new* topic branches. Do not rename or re-scope `main`,
   `master`, `develop`, or `release/*`; follow the repository's existing scheme
   for those.

## Examples

    feat/oauth-login
    feat/12345-oauth-login
    fix/null-upstream-response
    docs/readme-setup-steps
    chore/bump-typescript-5-4
    refactor/orders-pricing-v2

## Priority

This baseline takes precedence over ordinary branch-naming habits, but never use
it to override explicit user instructions, safety rules, privacy boundaries, or
stricter repo-local instructions. If a repository already defines and follows
its own branch naming scheme (for example `users/<name>/<topic>`), follow that
instead.

## Non-Goals

- This governs the branch *name* only. It composes with, and does not replace,
  the `git-collaboration-hygiene` baseline (inspect state, fetch and
  fast-forward the base branch before branching, keep pushes consent-based) and
  the `commit-conventions` baseline (the message written on the branch).
- This does not govern commit messages, PR descriptions, merge vs. rebase
  policy, or how and when branches are deleted after merge.
- This does not require or forbid any branch-protection or naming-enforcement
  tooling; it describes the name the agent should choose.
