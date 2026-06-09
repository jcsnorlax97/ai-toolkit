# Personal Skill Installation

This document is the operational cheatsheet for installing this repo's skills
into local assistant runtimes.

## Mental Model

The maintained source of truth is always:

```text
skills/engineering/<skill-name>/
```

Runtime skill directories are adapters:

```text
~/.claude/skills/<skill-name>
~/.codex/skills/<skill-name>
```

The preferred personal install mode is symlink mode:

```text
~/.local/share/agentic-engineering-skills/current
  -> <this repo clone>

~/.claude/skills/<skill-name>
  -> ~/.local/share/agentic-engineering-skills/current/skills/engineering/<skill-name>

~/.codex/skills/<skill-name>
  -> ~/.local/share/agentic-engineering-skills/current/skills/engineering/<skill-name>
```

Only `~/.local/share/agentic-engineering-skills/current` is the repo-level
symlink. Paths under it, such as
`~/.local/share/agentic-engineering-skills/current/skills/engineering/diagnose`,
resolve through `current` into the real repo directory. `ls -ld` on those deeper
paths may look like an ordinary directory and may not show `->`.

In other words, `current` is the pointer:

```text
~/.local/share/agentic-engineering-skills/current -> <this repo clone>
```

`current/skills/engineering/<skill-name>` is not a second symlink created by the
installer. It is the real skill directory reached after the shell follows
`current` into the repo. The repo remains the source of truth because every
runtime symlink points through this stable `current` pointer into
`skills/engineering/<skill-name>/`.

Because the runtime path is also a symlink to a directory, files will appear
inside `~/.claude/skills/<skill-name>` or `~/.codex/skills/<skill-name>`. That
is normal. Do not manually remove those files from the runtime path; if the path
is a symlink, deleting through it deletes files from the source-of-truth
directory.

## Commands

Use the command for the runtime you want to expose skills to:

| Goal | Command | Scope |
| --- | --- | --- |
| Install or repair Claude Code personal skills | `./scripts/install-claude-code-skills.sh` | `~/.claude/skills/` |
| Install or repair Codex personal skills | `./scripts/install-codex-skills.sh` | `~/.codex/skills/` |
| Install or repair both runtimes | `./scripts/repair-personal-skill-links.sh` | Claude Code and Codex |
| Verify both runtimes without changing files | `./scripts/verify-personal-skill-links.sh` | Claude Code and Codex |

`repair-personal-skill-links.sh` is only a wrapper around the two install
scripts. It does not contain separate repair logic.

The default mode is symlink mode. `--copy` is an explicit fallback, not the
preferred path:

```bash
./scripts/install-claude-code-skills.sh --link
./scripts/install-claude-code-skills.sh --copy
```

## Platform Commands

### macOS

macOS normally does not need special privileges for these symlinks:

```bash
./scripts/install-claude-code-skills.sh
./scripts/install-claude-code-skills.sh --verify-only
```

### Windows, Git Bash

Windows usually requires Developer Mode or an elevated shell for directory
symlinks. The known-good path for symlink mode is Git Bash opened as
Administrator. Do not use PowerShell or the VS Code integrated terminal for
symlink mode; they may resolve `bash` to WSL or use the wrong home directory.

Before changing files, verify that this shell is Git Bash and that `$HOME`
points at the Windows user profile:

```bash
bash -lc 'uname -s; echo $HOME'
```

Expected output looks like:

```text
MINGW64_NT...
/c/Users/<WindowsUser>
```

If you see `Linux` and `/home/<user>`, stop. That is WSL, not Git Bash for the
Windows user profile.

After the preflight passes, run the installer from the repo root:

```bash
MSYS=winsymlinks:nativestrict ./scripts/install-claude-code-skills.sh
MSYS=winsymlinks:nativestrict ./scripts/install-claude-code-skills.sh --verify-only
```

### Windows, VS Code PowerShell Or `pwsh`

Do not use PowerShell, `pwsh`, or the VS Code integrated terminal for Windows
symlink mode. Open Git Bash as Administrator and use the commands above.

From PowerShell or VS Code, use copy mode only:

```powershell
bash ./scripts/install-claude-code-skills.sh --copy
bash ./scripts/install-claude-code-skills.sh --copy --verify-only
```

If troubleshooting path resolution from PowerShell, confirm whether `bash`
resolves to Git Bash or WSL before running any installer:

```powershell
where.exe bash
bash -lc 'uname -s; echo $HOME'
```

Git Bash output should look like:

```text
MINGW64_NT...
/c/Users/<WindowsUser>
```

If you see `Linux` and `/home/<user>`, that is WSL.

### WSL

Use WSL only when Claude Code is also running inside WSL:

```bash
./scripts/install-claude-code-skills.sh
./scripts/install-claude-code-skills.sh --verify-only
```

If Claude Code is the Windows app, do not use WSL's default
`~/.claude/skills`; it points to the WSL home directory, not the Windows user's
Claude Code profile.

## Symlink Verification

Installer verification:

```bash
./scripts/install-claude-code-skills.sh --verify-only
```

Manual Git Bash verification:

```bash
ls -ld ~/.local/share/agentic-engineering-skills/current
ls -ld ~/.claude/skills/diagnose
readlink ~/.local/share/agentic-engineering-skills/current
readlink ~/.claude/skills/diagnose
realpath ~/.claude/skills/diagnose
test -L ~/.claude/skills/diagnose
```

Manual PowerShell verification:

```powershell
Get-Item "$HOME\.claude\skills\diagnose" | Format-List FullName,LinkType,Target
```

`LinkType` should report a symbolic link when symlink mode is active.

## Symlink Mode Behavior

Default symlink mode is deterministic:

| Scenario | Behavior |
| --- | --- |
| Fresh machine, no stable repo link | Create `~/.local/share/agentic-engineering-skills/current -> <this repo>`. |
| Fresh machine, no runtime skill target | Create `~/.claude/skills/<skill-name>` or `~/.codex/skills/<skill-name>` as a symlink through `current`. |
| New skill added under `skills/engineering/` | Rerun the relevant installer; it creates the missing runtime symlink. |
| Runtime skill symlink already correct | Leave it as-is and report it as verified. |
| Runtime skill symlink points elsewhere, is stale, or is broken | Replace it with the expected symlink through `current`. |
| Runtime skill exists as a real directory or copied install | Move it to `.agentic-engineering-skills-backups/<timestamp>/<skill-name>`, then create the symlink. |
| Runtime skill exists as a real directory and `--keep-existing` is passed | Leave it untouched and do not create the symlink for that skill. |
| Stable `current` symlink points at this repo | Leave it as-is. |
| Stable `current` symlink points at an old repo path | Replace it to point at the current clone. |
| Stable `current` symlink is broken | Replace it to point at the current clone. |
| Stable `current` path exists but is not a symlink | Move it to `.agentic-engineering-skills-backups/<timestamp>/current`, then create the real symlink. |
| Repo is moved or renamed | Run `scripts/repair-personal-skill-links.sh` from the new clone. |
| Repo content changes after `git pull` | Existing linked skills see changes immediately; rerun installer only for new skills or repair. |
| `--verify-only` | Check current state and fail if any expected symlink is missing, stale, or broken; do not mutate files. |

## Copy Fallback

Use copy mode only if a machine cannot create real symlinks:

```bash
./scripts/install-claude-code-skills.sh --copy
./scripts/install-claude-code-skills.sh --copy --verify-only
```

Copy mode behavior differs from symlink mode:

| Scenario | Behavior |
| --- | --- |
| Fresh machine, no runtime skill target | Copy `skills/engineering/<skill-name>/` into the runtime skills directory. |
| Runtime skill copy matches canonical source | Leave it as-is and report it as verified. |
| Runtime skill copy differs from canonical source | Move it to `.agentic-engineering-skills-backups/<timestamp>/<skill-name>`, then copy the canonical source. |
| Repo content changes after `git pull` | Rerun the installer to refresh copied snapshots. |
| Stable `current` symlink | Not used in copy mode. |
