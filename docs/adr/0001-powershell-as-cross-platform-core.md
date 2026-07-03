# ADR 0001: PowerShell as Cross-Platform Core for baseline and skills CLIs

## Status

Accepted

## Context

`scripts/baseline` (bash, 494 lines) and `scripts/skills.ps1` (PowerShell, 612 lines) were two separate
full implementations of the same CLI behaviour. Any feature addition or bug fix had to be applied in
both places, and the two implementations could silently diverge over time.

On Mac, `scripts/skills` was a directory (not an executable), so there was no unified entry point for
the skills CLI. On Windows, `scripts/baseline` (bash) could not be run without WSL or Git Bash.

An OS-detecting adapter was considered to dispatch to the appropriate script per platform, but this
still required two full implementations to remain consistent.

Using bash as the shared core was ruled out because PowerShell scripts cannot cleanly call bash on
Windows without WSL, which has known development friction.

Using a third language (Node.js, Python) was ruled out because it introduces a new runtime dependency
with no existing foothold in the repo.

## Decision

PowerShell (`pwsh`) is the single authoritative implementation for both CLIs:

- `scripts/baseline.ps1` — core logic for the `baseline` command
- `scripts/skills.ps1` — core logic for the `skills` command

Platform entry points are thin shims that delegate immediately to the PS core:

- **Mac/Linux** — `scripts/baseline` and `scripts/skills` (4-line bash scripts calling `exec pwsh`)
- **Windows** — call `scripts/baseline.ps1` / `scripts/skills.ps1` directly, or use the installed `.cmd` shim

Shim installation is split by platform because the output artifacts differ:

- Mac/Linux: `install-shim.sh` creates a bash wrapper in `~/.local/bin/`
- Windows: `install-shim.ps1` creates a `.cmd` wrapper in `~/.local/bin/`

`scripts/skills.ps1 shim` detects `$IsMacOS`/`$IsLinux` at runtime and delegates to the correct
installer, so users only need to run `./scripts/skills shim install` regardless of platform.

`scripts/skills/` was renamed to `scripts/skills-setup/` to free the `scripts/skills` name for the
Mac entry-point shim file (a file and a directory cannot share the same name on Unix).

Mac requires PowerShell to be installed: `brew install powershell`.

## Alternatives Considered

- **Bash as core, PowerShell calls bash via subprocess** — ruled out; requires WSL on Windows, which has known friction
- **OS-detecting adapter dispatching to two full implementations** — ruled out; duplication and divergence risk remain
- **Node.js or Python as shared core** — ruled out; introduces a new runtime dependency with no existing presence in the repo

## Consequences

- Single source of truth for CLI behaviour; fixes and features only need to be applied once
- Mac users must install `pwsh` once (`brew install powershell`) before using `baseline` or `skills`
- Startup latency on Mac is ~0.5–1.5 s per invocation due to .NET runtime load; acceptable for infrequent admin operations
- If bash-native speed becomes necessary (e.g. tight CI loops), a bash reimplementation of specific commands can be introduced without invalidating this ADR
- `scripts/skills-setup/` is the new home for shim install/verify/remove helper scripts
