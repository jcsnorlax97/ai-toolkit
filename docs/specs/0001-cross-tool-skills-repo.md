# Spec 0001: Cross-Tool Skills Repository

## Status

Accepted

## Goal

Create a repository that can store reusable AI agent assets once and expose
skills to multiple AI coding tools without hand-maintaining duplicate skill
files.

## Non-Goals

- Build a full plugin marketplace.
- Replace project-specific `AGENTS.md` or `CLAUDE.md` files in downstream repos.
- Store private memories, credentials, transcripts, or local tool state.
- Treat always-on baselines as workflow skills.

## Design

`skills/` is the canonical source tree for invoked workflow skills.

```text
skills/
└── engineering/
    └── <skill-name>/
        └── SKILL.md
```

Keep one directory per skill. A skill may own supporting references, scripts,
agents, examples, or tests next to its `SKILL.md`; do not flatten skills into
single files when that would scatter the implementation of the skill's
interface.

Skill metadata belongs in `SKILL.md` frontmatter, not a companion metadata
file. Required runtime fields are `name` and `description`. New local skills
should also include `status`, `problem`, `when-not-to-use`, and `maintainer`
when the information is known. Existing imported skills may be reconciled
gradually so source imports do not become noisy metadata churn.

Tool-specific adapters point at or install from that source tree.

```text
.claude/skills/<skill-name> -> ../../skills/engineering/<skill-name>
~/.local/share/ai-toolkit/current -> <this repo clone>
~/.claude/skills/<skill-name>  -> ~/.local/share/ai-toolkit/current/skills/engineering/<skill-name>
~/.codex/skills/<skill-name>   -> ~/.local/share/ai-toolkit/current/skills/engineering/<skill-name>
```

`baselines/` is the canonical source tree for always-on instruction
packs.

```text
baselines/
└── <pack-name>/
    ├── pack.json
    ├── baseline.md
    └── adapters/
        ├── AGENTS.md.block
        ├── CLAUDE.md.block
        └── copilot-instructions.md.block
```

Baseline adapters are applied to downstream repo instruction files as managed
blocks. They are not installed into personal runtime skill directories by
default, and they must be removable by deleting or replacing only the marked
block.

Future reusable agent/workflow definitions belong in their own canonical source
tree, not inside `skills/` or `baselines/`.

```text
workflows/
└── <workflow-name>/
    ├── workflow.md
    ├── roles/
    ├── profiles/
    └── templates/
```

Use `workflows/` for tool-neutral multi-agent workflow specs, reusable
role catalogs, team profiles, execution-packet templates, and handoff
contracts. A workflow may later expose a skill adapter such as
`skills/engineering/setup-agent-team/`, but the durable workflow definition
should not be hidden inside one invoked skill when it is meant to be reused by
multiple tools or coordinators.

## Repository-Level Files

- `README.md`: human onboarding and bootstrap commands.
- `AGENTS.md`: agent-facing operating rules for Codex-compatible workflows.
- `CLAUDE.md`: Claude Code project instructions loaded every session.
- `CONTEXT.md`: shared glossary and stable language.
- `docs/adr/`: durable architecture decisions.
- `docs/agents/`: issue, triage, and domain context conventions.
- `scripts/`: deterministic installation and verification commands.
- `baselines/`: always-on baseline packs and repo-local adapters.
- `workflows/`: future tool-neutral agent workflow packs, roles,
  profiles, execution-packet templates, and handoff contracts.

## Install Behavior

### Skill Install Behavior

Installation scripts expose canonical skill directories to personal tool
directories. The default mode is symlink mode:

```text
~/.local/share/ai-toolkit/current -> <this repo clone>
~/.claude/skills/<skill-name> -> ~/.local/share/ai-toolkit/current/skills/engineering/<skill-name>
~/.codex/skills/<skill-name> -> ~/.local/share/ai-toolkit/current/skills/engineering/<skill-name>
```

Pulling the repo updates installed skills immediately because runtime skill
entries point at the canonical source. Rerun the installer after pulling when a
new skill was added or when links need repair.

Copy mode is available only as an explicit fallback through `--copy`. In copy
mode, rerun the installer after pulling the repo to refresh personal skill
snapshots without manual deletion.

If a personal target already exists as a real directory from an older copy-based
install and symlink mode is requested, the installer moves that directory into:

```text
<tool-skills-dir>/.ai-toolkit-backups/<timestamp>/<skill-name>
```

It then creates the symlink. This preserves local customizations without keeping
the stale copy active. Pass `--keep-existing` to leave non-symlink targets in
place.

If the repository is renamed or moved, rerun `scripts/skills.ps1 install` or
`scripts/skills/repair-personal-links.sh` from the new clone. Existing personal
skill links continue to point through the stable repo link, so repair updates
the repo pointer instead of rewriting every path by hand. In explicit copy mode,
rerunning the installer refreshes the copied snapshots.

`scripts/skills.ps1` is the public skill CLI. Legacy command names live under
`scripts/compat/` as compatibility wrappers, not separate install modes. The
repair implementation runs both personal install implementations:

```text
scripts/skills/install-codex.sh
scripts/skills/install-claude-code.sh
```

Each install script is idempotent for its target runtime. It creates missing
links, repairs broken or stale symlinks, migrates older copy-based targets to a
timestamped backup unless `--keep-existing` is passed, and updates the stable
repo link when needed. In explicit copy mode, it copies canonical skill
snapshots into the runtime skill directory, backs up changed existing targets
before replacing them, and does not require symlink privileges.

On Windows Git Bash/MSYS/Cygwin, symlink mode requires real Windows symlink
support. The recommended command is
`MSYS=winsymlinks:nativestrict ./scripts/skills/install-claude-code.sh`, and
Windows may require Developer Mode or an elevated shell. If `ln -s` does not
produce a real symlink, the installer must fail instead of treating a copied
directory or placeholder as success.

If an older Windows run left the stable repo pointer path as a non-symlink, the
installer moves that path into the state directory's timestamped backup folder
before creating the real symlink. It must preserve the old path rather than
deleting it.

Project-level Claude Code usage in the toolkit repo itself uses
`.claude/skills/` symlinks so local edits immediately affect the canonical
files.

Downstream project-level skill profiles use copy mode by default:

```text
<project>/.ai-toolkit/skills.json
<project>/.claude/skills/<skill-name>/
```

The profile records the intended project skill set. The generated
`.claude/skills/` entries are copied snapshots, not symlinks, so a project does
not silently change when the user's personal runtime or toolkit clone changes.
Existing copied project skills must match the canonical source before install
continues; the installer stops on drift instead of overwriting or deleting the
project directory.

Operational commands, the scenario-by-scenario behavior matrix, and
macOS/Windows notes live in `docs/how-to/install.md`.

### Portable Baseline Apply Behavior

Portable baseline scripts update repo-local instruction files such as
`AGENTS.md` and `CLAUDE.md`. They do not write to `~/.claude`, `~/.codex`, or
other machine-global runtime directories by default.

The default downstream behavior is managed-block insertion:

```text
<!-- BEGIN baseline:<pack-name> vX.Y.Z -->
...
<!-- END baseline:<pack-name> -->
```

Applying a baseline should create or replace only the matching block. Removing
a baseline should remove only the matching block. Surrounding repo-specific
instructions remain owned by the downstream repo.

For backward compatibility, apply, remove, and verify must also detect legacy
`portable-agent-baseline:<pack-name>` blocks. If a target contains only the
legacy marker, apply replaces it in place with the current `baseline:<pack-name>`
block. If both marker namespaces exist for the same pack in one target file,
the command must stop and report a duplicate instead of guessing.

## Upstream Imports

The upstream-compatible engineering skills are imported from
`mattpocock/skills` under the MIT License. They were not originally authored in
this repository. Keep `NOTICE.md` updated whenever a substantial upstream
import or refresh happens.

## License And Source Review

Before importing or refreshing external skill material:

1. Identify the source repository and exact paths being imported.
2. Verify the license from the upstream repository's license file or official
   repository metadata.
3. Confirm the license permits the planned use, modification, redistribution,
   and publication.
4. Record the source, imported paths, local paths, license, copyright notice,
   verification date, and import commit in `docs/upstream-sources.md`.
5. Preserve required notices in `NOTICE.md`.
6. Do not import unclear, missing-license, proprietary, or incompatible material
   without explicit human review.

The source registry is part of the design, not optional bookkeeping. It exists
so a public skills repo can be audited without reconstructing history from git
alone.

## Verification Requirements

`scripts/skills.ps1 verify`, implemented by `scripts/skills/verify.sh`, must
check:

- Every canonical skill has a `SKILL.md`.
- Every `SKILL.md` contains frontmatter with `name` and `description`.
- Every `SKILL.md` contributes to a non-failing summary report for missing
  recommended metadata fields while existing imported skills are reconciled.
- Claude Code project adapter entries exist for every canonical skill.
- Adapter entries resolve to a readable `SKILL.md`.

`scripts/baseline.ps1 verify`, implemented by `scripts/baselines/verify.ps1`,
must check:

- The requested baseline pack has `pack.json`, `baseline.md`, and required
  adapter blocks.
- Adapter blocks contain matching BEGIN/END managed markers.
- When a target repo is supplied, existing target instruction files contain the
  requested managed block.

## Security And Privacy

Do not commit:

- `~/.claude/` or `~/.codex/` runtime state.
- transcripts, prompt history, cache files, local memory, or tool snapshots.
- credentials, tokens, `.env` files, cookies, or private keys.

## Migration Rule

When adding a new skill:

1. Create `skills/engineering/<skill-name>/SKILL.md`.
2. Add or refresh `.claude/skills/<skill-name>`.
3. Run `./scripts/skills.ps1 verify`.
4. Run `./scripts/skills.ps1 verify -Target claude -Scope personal` after
   personal symlink install or repair, or add `-Copy` after copy-mode install.
5. Update `README.md` and `docs/how-to/install.md` only if the skill changes the
   public catalog or bootstrap story.
