# Agentic Engineering Skills

Reusable engineering workflows for AI coding agents.

This repository stores portable skills for software engineering work. The
design is tool-aware but keeps one canonical source for every skill.

It also stores portable baselines: always-on instruction packs that can be
applied to repo-level agent instruction files without installing machine-global
runtime state.

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
├── baselines/
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

`baselines/` is the canonical source for always-on instruction packs.
Baselines are not skills: they do not require invocation and should be easy to
apply, verify, update, and remove through managed marker blocks.

Future reusable agent workflow definitions should live under
`workflows/` when introduced, not inside one skill or baseline pack.
Use that tree for tool-neutral workflow specs, role catalogs, team profiles,
execution-packet templates, and handoff contracts. A skill may expose or launch
a workflow, but the reusable workflow definition should remain its own source.

## Lifecycle Metadata

Reusable skills in this repo may start as candidates. Their implementation
still belongs under `skills/engineering/<skill-name>/`.

Lifecycle status, confidence, evidence, and promotion decisions are tracked by
SkillOps in:

```text
../skillops/inventory/skills.yaml
```

Do not create maturity folders or a repo-local `inventory/` directory here for
SkillOps lifecycle data. If the SkillOps inventory is unavailable, leave the
inventory update pending rather than creating a substitute.

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
- `capture-input-note`: ingest external sources that need access, extraction,
  redaction, or provenance work before later review or methodology intake.
- `setup-agent-team`: create a bounded manual execution packet for multi-domain, parallelizable, context-heavy agent-team work, or refuse when work should stay single-agent.
- `staff-level-review`: perform read-only, findings-first engineering review across correctness, architecture, safety, tests, and operability.
- `ship-vertical-slice`: deliver one externally verifiable behavior at a time.
- `diagnose-regression`: debug by reproducing, minimizing, instrumenting, fixing, and regression testing.

See `docs/specs/0005-capture-input-note-vs-methodology-intake.md` for the
boundary between source capture and methodology adoption.

## Portable Baselines

Portable baselines are reusable default instructions for AI coding agents. They
are intended for repo-local managed blocks in files such as `AGENTS.md` and
`CLAUDE.md`.

Current baseline packs:

- `repo-context-grounding`: read local instructions, inspect context,
  discover workflows, respect boundaries, follow local patterns, and verify
  with repo-native checks when entering an existing repository.
- `git-collaboration-hygiene`: inspect Git status, protect user
  changes, stage explicit paths, review diffs, and avoid unsafe remote or
  conflict handling.
- `karpathy-principles`: think before coding, simplicity first, surgical
  changes, and goal-driven execution.
- `oop-extension-safety`: guard OOP extension points with complete template
  methods, primitive hook parameters, concrete injected-type mocks, and class
  level delegate declarations.
- `code-doc-sync`: scan adjacent architecture docs after behavior changes and
  show concrete runtime types in flow diagrams.

Apply a baseline to a downstream repo:

```powershell
./scripts/apply-baseline.ps1 -TargetRepo C:\path\to\repo -Pack karpathy-principles -Tools codex,claude,copilot -DryRun
./scripts/apply-baseline.ps1 -TargetRepo C:\path\to\repo -Pack karpathy-principles -Tools codex,claude,copilot
```

Or call the CLI from the target repo and omit `-TargetRepo`:

```powershell
cd C:\path\to\repo
C:\path\to\agentic-engineering-skills\scripts\baseline.ps1 list
C:\path\to\agentic-engineering-skills\scripts\baseline.ps1 show
C:\path\to\agentic-engineering-skills\scripts\baseline.ps1 apply -Tools codex,claude,copilot -DryRun
```

When exactly one pack exists, the CLI can infer it. When more than one pack
exists, pass `-Pack <name>` for `show`, `apply`, `remove`, and `verify`.

Install an optional global shim when you want to type `baseline list`
from PowerShell, CMD, or a Unix shell:

```powershell
./scripts/install-baseline-shim.ps1 -AddToUserPath
baseline list
```

```bash
./scripts/install-baseline-shim.sh
baseline list
```

The shim only forwards to this repository's CLI. It does not install baseline
packs into assistant runtimes and can be removed later. Installing the
`baseline` shim also removes older matching `p-baseline` or `portable-baseline`
shims from the same install directory.

Windows shim argument note: the `.cmd` shim forwards arguments through CMD, so
comma-separated PowerShell arrays may arrive as one string. The CLI normalizes
comma-separated tool lists, so both the direct `.ps1` CLI and the
`baseline` shim support multiple tools in one command:

```powershell
C:\path\to\agentic-engineering-skills\scripts\baseline.ps1 apply -Pack karpathy-principles -Tools codex,claude,copilot -DryRun
baseline apply -Pack karpathy-principles -Tools codex,claude,copilot -DryRun
```

For narrow changes, one tool per command is also valid:

```powershell
baseline apply -Pack karpathy-principles -Tools codex -DryRun
baseline apply -Pack karpathy-principles -Tools claude -DryRun
baseline apply -Pack karpathy-principles -Tools copilot -DryRun
```

Baseline placement in instruction files: the installer updates an existing
managed baseline block in place. If the block is missing, it appends the block
to the end of the target instruction file; if the target file is created with
`-CreateMissing`, the block is the whole file. Do not rely on top-vs-bottom
placement as a precise model weighting mechanism. Put durable priority and
conflict rules in explicit wording. In general, keep repo-local instructions
easy to read first and let portable baselines act as broad fallback habits; if a
team wants a baseline near the top, move the managed block deliberately and
future updates will preserve that location.

Remove it later:

```powershell
./scripts/remove-baseline.ps1 -TargetRepo C:\path\to\repo -Pack karpathy-principles
C:\path\to\agentic-engineering-skills\scripts\baseline.ps1 remove -Pack karpathy-principles -Tools codex,claude,copilot -DryRun
./scripts/install-baseline-shim.ps1 -Remove
./scripts/install-baseline-shim.sh --remove
```

Verify pack shape and a downstream repo:

```powershell
./scripts/verify-baselines.ps1
./scripts/verify-baselines.ps1 -TargetRepo C:\path\to\repo
C:\path\to\agentic-engineering-skills\scripts\baseline.ps1 verify -Pack karpathy-principles -Tools codex,claude,copilot
```

Target verification reads the managed block marker in each instruction file and
compares the installed version with the source pack version. Matching targets
report the installed version; stale targets fail with both installed and source
versions so operators know which repos need `apply` rerun. Legacy
`portable-agent-baseline` blocks are accepted for backward compatibility; the
next `baseline apply` migrates them in place to the current `baseline` marker.

## Installation

Canonical skills live under `skills/engineering/`. Personal runtime entries in
`~/.claude/skills/` and `~/.codex/skills/` are adapters, not the source of
truth.

### Project-Local Claude Code

Clone the repo and verify the project-local adapters before starting Claude
Code:

```bash
git clone <repo-ssh-url> agentic-engineering-skills
cd agentic-engineering-skills
./scripts/verify-skills.sh
claude
```

Claude Code should discover project skills under `.claude/skills/`.

### Windows Symlink Mode

Windows symlink mode should be run from Git Bash opened as Administrator, not
PowerShell or the VS Code integrated terminal. Before installing, verify that
the shell is Git Bash and that `$HOME` points at the Windows user profile:

```bash
bash -lc 'uname -s; echo $HOME'
```

Expected output starts with `MINGW64_NT...` and `/c/Users/<WindowsUser>`. If it
prints `Linux` and `/home/<user>`, use Git Bash instead, or use `--copy` as the
Windows fallback.

### Personal Runtime Install

For personal Claude Code usage across all projects:

```bash
./scripts/install-claude-code-skills.sh
```

For personal Codex usage:

```bash
./scripts/install-codex-skills.sh
```

For both:

```bash
./scripts/repair-personal-skill-links.sh
```

### Personal Install Verification

Verify personal installs without changing files:

```bash
./scripts/verify-personal-skill-links.sh
```

See [Personal Skill Installation](docs/install.md) for the deterministic
behavior matrix, symlink-vs-copy behavior, Windows commands, and notes on why
files appear inside symlinked runtime skill folders.

## Development

After editing skills or adapters, run:

```bash
./scripts/verify-skills.sh
```

Keep each `SKILL.md` concise. Move long references, examples, or scripts into
supporting files inside the skill directory.

Keep maintenance metadata in `SKILL.md` frontmatter rather than companion
metadata files. `name` and `description` are required runtime fields; new local
skills should also include `status`, `problem`, `when-not-to-use`, and
`maintainer` when known.

Unprocessed notes and article captures are tracked in `docs/intake.md` and may
live under ignored scratch paths such as `.scratch/captures/`.

## Attribution

The upstream engineering skills are imported from
[`mattpocock/skills`](https://github.com/mattpocock/skills), licensed under MIT.
See `NOTICE.md` and `docs/upstream-sources.md`.
