# CLI Comparison: baseline, skills, hooks

The three CLIs share a common lifecycle (list → show → apply/install → verify)
but differ in vocabulary and parameters. This page is a quick-reference for
operators who work with more than one CLI at a time.

## Commands

| Goal | `baseline` | `skills` | `hooks` |
| --- | --- | --- | --- |
| List packs | `baseline list` | `skills list` | `hooks list` |
| Inspect one pack | `baseline show <pack>` | `skills show <skill>` | `hooks show <pack>` |
| Apply / install | `baseline apply <pack>` | `skills apply <skill>` | `hooks apply <pack>` |
| Remove | `baseline remove <pack>` | — | `hooks remove <pack>` |
| Verify | `baseline verify` | `skills verify` | `hooks verify` |
| Install command shim | `baseline shim install` | `skills shim install` | `hooks shim install` |
| Apply everything | `baseline apply-all` | — | `hooks apply all` |
| Install managed toolchain | — | — | `hooks install-tools` |
| Add skill to project profile | — | `skills add repo <skill>` | — |

`skills apply` replaces the older `skills install` form. `skills install` is
kept as a backwards-compatible alias; new scripts and docs should use `apply`.

## Parameters

| Parameter | `baseline` | `skills` | `hooks` |
| --- | --- | --- | --- |
| Tool / target | `-Tools claude\|codex\|copilot\|all` | positional `claude\|codex\|copilot\|all` | `-Tools claude\|codex\|copilot\|all` |
| Scope | `-Scope project\|user` | positional `user\|repo` (or `-Scope personal\|project`) | `-Scope project\|user` |
| Target repo | `-TargetRepo <path>` | `-TargetRepo <path>` | `-TargetRepo <path>` |
| Dry run | `-DryRun` | — | `-DryRun` |
| Skip missing targets | `-SkipMissing` | — | — |
| Copy mode | — | `-Copy` | — |

`baseline` and `hooks` default `-Tools` to `claude` when the flag is omitted.
`skills` defaults to all supported personal targets when no tool is specified.

## Scope Values

| Scope | `baseline` | `skills` | `hooks` |
| --- | --- | --- | --- |
| Project / repo | writes to `<target-repo>/.claude/settings.json` (Claude), `<target-repo>/AGENTS.md` (Codex), `<target-repo>/.github/copilot-instructions.md` (Copilot) | copies or links into `<target-repo>/.claude/skills/` | writes to `<target-repo>/.claude/settings.json` (Claude), `<target-repo>/.codex/hooks.json` (Codex) |
| User / personal | writes to `~/.claude/settings.json` (Claude), `~/AGENTS.md` (Codex), global Copilot instructions (Copilot) | copies or links into `~/.claude/skills/` and `~/.codex/skills/` | writes to `~/.claude/settings.json` (Claude), `~/.codex/hooks.json` (Codex) |

`baseline` uses `-Scope project` (default) and `-Scope user`. `skills` uses the
positional `repo` and `user` forms; the older `-Scope personal|project` form is
also accepted. `hooks` uses `-Scope project` (default) and `-Scope user`.

## Copilot

Copilot is supported by `baseline` (instruction-block injection into
`.github/copilot-instructions.md`) and by `skills` (accepted as a target name,
though no Copilot skills runtime contract is currently defined).

Copilot does not have a shell hook API, so `hooks` reports `n/a` for Copilot
entries in `hooks list` and skips Copilot in apply, remove, and verify. Use
baselines for always-on Copilot instruction blocks instead.
