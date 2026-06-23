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

Portable baseline command shims are separate from skill runtime installs:

| Goal | Command | Scope |
| --- | --- | --- |
| Install Windows `portable-baseline` shim | `./scripts/install-portable-baseline-shim.ps1 -AddToUserPath` | User PATH and one `.cmd` wrapper |
| Verify Windows shim | `./scripts/install-portable-baseline-shim.ps1 -VerifyOnly` | No writes |
| Remove Windows shim | `./scripts/install-portable-baseline-shim.ps1 -Remove` | One managed `.cmd` wrapper |
| Install macOS/Linux `portable-baseline` shim | `./scripts/install-portable-baseline-shim.sh` | One shell wrapper in `~/.local/bin` |
| Verify macOS/Linux shim | `./scripts/install-portable-baseline-shim.sh --verify-only` | No writes |
| Remove macOS/Linux shim | `./scripts/install-portable-baseline-shim.sh --remove` | One managed shell wrapper |

The portable baseline shim does not install skills or write to
`~/.claude/skills`, `~/.codex/skills`, or assistant runtime state. It only makes
the repo CLI available as `portable-baseline`.

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

For the portable baseline command shim:

```bash
./scripts/install-portable-baseline-shim.sh
portable-baseline list
```

If `~/.local/bin` is not in `PATH`, add it to the shell profile:

```bash
export PATH="$HOME/.local/bin:$PATH"
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

Git Bash may be installed even when `where.exe bash` finds nothing. The normal
Git for Windows executable is:

```powershell
& "C:\Program Files\Git\bin\bash.exe" -lc "uname -s; echo `$HOME"
```

If the preflight is correct but link creation fails with
`Operation not permitted`, enable Windows Developer Mode or run Git Bash as
Administrator. Developer Mode allows a normal user shell to create symbolic
links; an elevated Git Bash session is the fallback when Developer Mode cannot
be enabled.

After enabling Developer Mode, PowerShell can launch the Git Bash installer
explicitly:

```powershell
$env:MSYS = "winsymlinks:nativestrict"
& "C:\Program Files\Git\bin\bash.exe" -lc `
  "cd /c/Users/<WindowsUser>/Documents/a-codex/agentic-engineering-skills && ./scripts/repair-personal-skill-links.sh"
```

If neither option is available, keep using copy mode and rerun the copy
installer after each repository update.

For the portable baseline command shim, PowerShell is the supported Windows
installer because it creates a `.cmd` wrapper usable from both PowerShell and
CMD:

```powershell
.\scripts\install-portable-baseline-shim.ps1 -AddToUserPath
portable-baseline list
```

Open a new terminal after `-AddToUserPath`. Remove the shim later with:

```powershell
.\scripts\install-portable-baseline-shim.ps1 -Remove
```

The Windows `.cmd` shim forwards arguments through CMD, so comma-separated
PowerShell arrays may arrive as one string. The CLI normalizes comma-separated
tool lists, so both the direct `.ps1` script and the global
`portable-baseline` shim support multiple tools in one command:

```powershell
.\scripts\portable-baseline.ps1 apply -Pack karpathy-principles -Tools codex,claude,copilot -DryRun
portable-baseline apply -Pack karpathy-principles -Tools codex,claude,copilot -DryRun
```

For narrow changes, one tool per command is also valid:

```powershell
portable-baseline apply -Pack karpathy-principles -Tools codex -DryRun
portable-baseline apply -Pack karpathy-principles -Tools claude -DryRun
portable-baseline apply -Pack karpathy-principles -Tools copilot -DryRun
```

Portable baseline placement is intentionally conservative. The installer
updates an existing managed block in place; when a block is missing, it appends
the block to the target instruction file. Top-vs-bottom placement should not be
treated as a reliable model weighting control. Use explicit instruction text
for priority and conflict behavior. If a team intentionally wants the portable
baseline near the top, move the managed block there once; later updates preserve
the block's location.

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
