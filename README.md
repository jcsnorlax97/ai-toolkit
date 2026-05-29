# Agentic Engineering Skills

Reusable engineering workflows for AI coding agents.

This repository stores portable skills for software engineering work. The
design is tool-aware but keeps one canonical source for every skill.

## Repository Name

Recommended repo name:

```text
agentic-engineering-skills
```

Rationale:

- Describes the audience: AI coding agents.
- Describes the domain: engineering workflows, not general prompting.
- Avoids coupling the repo to Claude Code, Codex, or any single runtime.

## Layout

```text
.
├── AGENTS.md
├── CLAUDE.md
├── CONTEXT.md
├── .claude/
│   └── skills/
├── docs/
│   ├── adr/
│   ├── agents/
│   ├── intake.md
│   └── specs/
├── scripts/
└── skills/
    └── engineering/
```

## Source Of Truth

`skills/` is the canonical source.

Adapters make the same skills usable in specific tools:

- Claude Code project adapter: `.claude/skills/<skill-name>`
- Claude Code personal install: `~/.claude/skills/<skill-name>`
- Codex personal install: `~/.codex/skills/<skill-name>`

Do not maintain duplicated skill bodies by hand.

## Current Skills

### Imported From `mattpocock/skills`

These skills were not built in this repo. They are imported from
[`mattpocock/skills`](https://github.com/mattpocock/skills) and kept here so
this repository can act as a cross-tool install source. See `NOTICE.md` for
attribution and `docs/upstream-sources.md` for license verification details.

- `diagnose`: disciplined diagnosis loop for hard bugs and regressions.
- `grill-with-docs`: stress-test plans against domain language and ADRs.
- `improve-codebase-architecture`: surface refactoring opportunities that improve testability and navigability.
- `prototype`: build throwaway prototypes to answer design questions.
- `setup-matt-pocock-skills`: scaffold repo-local configuration consumed by the engineering skills.
- `tdd`: deliver behavior with a red-green-refactor loop.
- `to-issues`: turn plans or specs into independently grabbable issues.
- `to-prd`: turn conversation context into a product requirements document.
- `triage`: triage issues through explicit workflow states.
- `zoom-out`: ask for broader context when a code area or decision feels too narrow.

### Local Additions

These skills were added in this repo as small companion workflows.

- `grill-spec`: clarify ambiguous requirements, vocabulary, scope, and acceptance checks.
- `methodology-intake`: classify external methodology sources before promoting them into repo artifacts.
- `capture-input-note`: capture external sources as redacted work-log inbox notes before later review, daily logging, or methodology intake.
- `setup-agent-team`: create a bounded manual execution packet for multi-domain, parallelizable, context-heavy agent-team work, or refuse when work should stay single-agent.
- `staff-level-review`: perform read-only, findings-first engineering review across correctness, architecture, safety, tests, and operability.
- `ship-vertical-slice`: deliver one externally verifiable behavior at a time.
- `diagnose-regression`: debug by reproducing, minimizing, instrumenting, fixing, and regression testing.

See `docs/specs/0005-capture-input-note-vs-methodology-intake.md` for the
boundary between source capture and methodology adoption.

## Bootstrap On Claude Code

For project-local usage:

```bash
git clone <repo-ssh-url> agentic-engineering-skills
cd agentic-engineering-skills
./scripts/verify-skills.sh
claude
```

Claude Code should discover project skills under `.claude/skills/`.

For personal usage across all projects:

```bash
./scripts/install-claude-code-skills.sh
```

This installs personal skills under:

```text
~/.claude/skills/
```

The default install mode is symlink mode on every platform. Personal runtime
entries point through a stable machine-local repo link:

```text
~/.local/share/agentic-engineering-skills/current
```

After that, pulling this repo updates existing linked skills immediately. Rerun
the installer after pulling when a new skill was added or when you want to
repair links.

## Bootstrap On Codex

Install the canonical skills into the local Codex skills directory:

```bash
./scripts/install-codex-skills.sh
```

The default target is:

```text
~/.codex/skills/
```

Codex personal installs use the same behavior as Claude Code.

## Personal Install Scripts

The install and repair scripts share the same underlying behavior. They are
different entrypoints for different scopes:

```text
scripts/install-codex-skills.sh
  Ensure Codex personal skills under ~/.codex/skills/ are installed.

scripts/install-claude-code-skills.sh
  Ensure Claude Code personal skills under ~/.claude/skills/ are installed.

scripts/repair-personal-skill-links.sh
  Convenience wrapper that runs both install scripts.
```

Install mode is automatic by default:

```text
default: symlink mode
```

You can force a mode:

```bash
./scripts/install-claude-code-skills.sh --link
./scripts/install-claude-code-skills.sh --copy
```

`--copy` is an explicit fallback for environments that cannot create real
symlinks. It is not the preferred mode.

Use a specific `install-*-skills.sh` script when you only care about one tool.
Use `repair-personal-skill-links.sh` after moving or renaming this repo, or
when you want both Codex and Claude Code personal installs checked in one step.
It does not have separate repair logic; it delegates to the two install scripts.

If this repo is renamed or moved, rerun the relevant install script, or run:

```bash
./scripts/repair-personal-skill-links.sh
```

To check personal installs without changing them:

```bash
./scripts/verify-personal-skill-links.sh
```

If you explicitly installed with copy mode, verify copy mode explicitly:

```bash
./scripts/verify-personal-skill-links.sh --copy
```

## Install Behavior Cheatsheet

Default symlink mode is deterministic:

| Scenario | Behavior |
| --- | --- |
| Fresh machine, no stable repo link | Create `~/.local/share/agentic-engineering-skills/current -> <this repo>`. |
| Fresh machine, no runtime skill target | Create `~/.claude/skills/<skill-name>` or `~/.codex/skills/<skill-name>` as a symlink through `current`. |
| New skill added under `skills/engineering/` | Rerun the relevant installer; it creates the missing runtime symlink. |
| Runtime skill symlink already correct | Leave it as-is and report it as verified. |
| Runtime skill symlink exists but points elsewhere, is stale, or is broken | Replace it with the expected symlink through `current`. |
| Runtime skill exists as a real directory or copied install | Move it to `.agentic-engineering-skills-backups/<timestamp>/<skill-name>`, then create the symlink. |
| Runtime skill exists as a real directory and `--keep-existing` is passed | Leave it untouched and do not create the symlink for that skill. |
| Stable `current` symlink points at this repo | Leave it as-is. |
| Stable `current` symlink points at an old repo path | Replace it to point at the current clone. |
| Stable `current` symlink is broken | Replace it to point at the current clone. |
| Stable `current` path exists but is not a symlink | Move it to `.agentic-engineering-skills-backups/<timestamp>/current`, then create the real symlink. |
| Repo is moved or renamed | Run `scripts/repair-personal-skill-links.sh` from the new clone. |
| Repo content changes after `git pull` | Existing linked skills see changes immediately; rerun installer only for new skills or repair. |
| `--verify-only` | Check current state and fail if any expected link/copy is missing, stale, or broken; do not mutate files. |
| `--copy` | Copy canonical skill directories into the runtime skills directory; rerun after pulling to refresh snapshots. |

## Windows Notes

These scripts are Bash scripts. On Windows, run them from Git Bash, or from
PowerShell / `pwsh` by invoking Git Bash's `bash`.

Windows differs from macOS in one important way: creating directory symlinks
usually requires Windows Developer Mode or an elevated shell. macOS generally
does not require special privileges for this repo's symlinks.

For Windows Claude Code running outside WSL, use Git Bash with real Windows
symlinks enabled. A known-good path is Git Bash opened as Administrator:

```bash
MSYS=winsymlinks:nativestrict ./scripts/install-claude-code-skills.sh
./scripts/install-claude-code-skills.sh --verify-only
```

First confirm which `bash` you are using:

```powershell
where.exe bash
bash -lc "uname -s; echo \$HOME"
```

Expected for Git Bash:

```text
MINGW64_NT...
/c/Users/<WindowsUser>
```

If you see `Linux` and `/home/<user>`, you are in WSL.

### Git Bash

From Git Bash:

```bash
MSYS=winsymlinks:nativestrict ./scripts/install-claude-code-skills.sh
./scripts/install-claude-code-skills.sh --verify-only
```

### VS Code With Git Bash Terminal

If the VS Code integrated terminal profile is Git Bash, use the same command:

```bash
MSYS=winsymlinks:nativestrict ./scripts/install-claude-code-skills.sh
./scripts/install-claude-code-skills.sh --verify-only
```

### VS Code With PowerShell Or `pwsh`

If the VS Code integrated terminal is PowerShell / `pwsh`, call Git Bash's
`bash` from PowerShell:

```powershell
$env:MSYS = "winsymlinks:nativestrict"
bash ./scripts/install-claude-code-skills.sh
bash ./scripts/install-claude-code-skills.sh --verify-only
```

If PowerShell resolves `bash` to WSL instead of Git Bash, select the Git Bash
terminal profile in VS Code or put Git Bash earlier on `PATH`.

### WSL

Use WSL only when Claude Code is also running inside WSL. In that case:

```bash
./scripts/install-claude-code-skills.sh
./scripts/install-claude-code-skills.sh --verify-only
```

If Claude Code is the Windows app, do not use the default WSL `~/.claude/skills`
target. It points to the WSL home directory, not the Windows user's Claude Code
profile. Prefer Git Bash or PowerShell calling Git Bash for Windows Claude Code.

### Explicit Copy Fallback

Use copy mode only if symlinks are not available on that machine:

```bash
./scripts/install-claude-code-skills.sh --copy
./scripts/install-claude-code-skills.sh --copy --verify-only
```

Copy mode does not use the stable `current` symlink. Rerun the installer after
pulling this repo to refresh copied snapshots.

### Verify Install

For symlink mode, verify through the installer:

```bash
./scripts/install-claude-code-skills.sh --verify-only
```

From PowerShell:

```powershell
bash ./scripts/install-claude-code-skills.sh --verify-only
Test-Path "$HOME\.claude\skills\diagnose\SKILL.md"
```

From Git Bash:

```bash
test -L ~/.claude/skills/diagnose
readlink ~/.claude/skills/diagnose
```

From PowerShell:

```powershell
Get-Item "$HOME\.claude\skills\diagnose" | Format-List FullName,LinkType,Target
```

`LinkType` should report a symbolic link in symlink mode.

If an earlier Windows run left a non-symlink at
`~/.local/share/agentic-engineering-skills/current`, rerun the installer after
pulling this version. The installer will move that stale `current` path into
`.agentic-engineering-skills-backups/<timestamp>/current` under the state
directory, then create the real symlink.

Project-local Claude Code usage through `.claude/skills/` does not need a
separate setup rerun after pulling; the symlinks point at the canonical
`skills/engineering/` directories in this repo.

## Development

After editing skills or adapters, run:

```bash
./scripts/verify-skills.sh
```

Keep each `SKILL.md` concise. Move long references, examples, or scripts into
supporting files inside the skill directory.

Unprocessed notes and article captures are tracked in `docs/intake.md` and may
live under ignored scratch paths such as `.scratch/captures/`.

## Attribution

The upstream engineering skills are imported from
[`mattpocock/skills`](https://github.com/mattpocock/skills), licensed under MIT.
See `NOTICE.md` and `docs/upstream-sources.md`.
