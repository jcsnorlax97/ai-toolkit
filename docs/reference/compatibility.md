# Compatibility

This repo was previously named `agentic-engineering-skills`, then
`ai-agent-library`. The current intended name is `ai-toolkit`.

## Repo Name

The GitHub repository and local clone may still use the old name during the
transition. Commands should not assume the clone directory name.

After the remote and local folder are renamed, reinstall or repair personal
skill adapters:

```powershell
./scripts/skills.ps1 install -Target all -Scope personal -Copy
```

For symlink mode, run the equivalent Git Bash installer from the renamed clone.

## Machine-Local State

New symlink installs should use:

```text
~/.local/share/ai-toolkit/current
```

The installer still accepts the older state variables and path:

```text
AI_TOOLKIT_STATE_DIR
AI_AGENT_LIBRARY_STATE_DIR
AGENTIC_ENGINEERING_SKILLS_STATE_DIR
AGENTIC_SKILLS_STATE_DIR
~/.local/share/ai-agent-library
~/.local/share/agentic-engineering-skills
```

The old state path should not be bulk-deleted. Once all runtime skill links have
been repaired to the new state path and verified, the old path can be reviewed
manually.

## Baseline Markers

Current managed baseline blocks use:

```text
<!-- BEGIN baseline:<pack-name> vX.Y.Z -->
...
<!-- END baseline:<pack-name> -->
```

Legacy `portable-agent-baseline:<pack-name>` blocks remain supported. Verify
and remove detect them; apply migrates them in place to the current marker.

## Script Paths

Public commands:

```text
scripts/baseline.ps1
scripts/skills.ps1
scripts/baseline
```

Legacy command names live under:

```text
scripts/compat/
```

New docs should not point at `scripts/compat/` unless they are specifically
explaining migration behavior.
