# Portable Baselines

Portable baselines are reusable always-on instruction packs for AI coding
agents. They are lighter than skills: a baseline changes the agent's default
posture in every chat, while a skill defines a triggered workflow with inputs,
steps, outputs, verification, and stop conditions.

Use this directory for baseline packs that should be easy to copy into a repo,
review in a diff, update by marker, and remove later without touching unrelated
repo-specific instructions.

## Catalog

| Pack | Status | Purpose |
|---|---|---|
| `repo-context-grounding` | active | Apply default startup habits for existing repositories: read local instructions, inspect context, discover workflows, respect boundaries, and verify with repo-native checks. |
| `git-collaboration-hygiene` | active | Apply default Git collaboration safety: inspect status, protect user changes, stage explicit paths, review diffs, and avoid unsafe remote or conflict handling. |
| `karpathy-principles` | active | Apply four default engineering principles: think before coding, simplicity first, surgical changes, and goal-driven execution. |
| `oop-extension-safety` | active | Guards for OOP extension points: complete template methods, prefer primitive hook parameters, and mock concrete injected types in tests. |
| `code-doc-sync` | active | Scan for adjacent architecture docs before closing any behavior-changing task; show concrete runtime types in flow diagrams rather than abstract declaration sites. |

## Pack Shape

Each pack should contain:

```text
baselines/<pack-name>/
  pack.json
  baseline.md
  adapters/
    AGENTS.md.block
    CLAUDE.md.block
    copilot-instructions.md.block
```

Add adapters only when the target runtime has a stable project-level
instruction surface.

## Adapter Contract

Each `.block` adapter is the complete runtime behavior contract for that
target instruction surface. Keep it minimal, but include every rule, exception,
priority note, and term definition the agent needs to make the same decisions
without reading `baseline.md`.

Use `baseline.md` for the fuller human-maintained source: rationale,
provenance, examples, non-goals, and revision context. Do not rely on an agent
to discover or read `baseline.md` at runtime unless the adapter explicitly
instructs it to do so.

## Managed Block Rule

Adapters must be bounded by clear markers:

```markdown
<!-- BEGIN portable-agent-baseline:<pack-name> vX.Y.Z -->
...
<!-- END portable-agent-baseline:<pack-name> -->
```

Downstream repos may remove a baseline by deleting only the marked block. Future
installer scripts should replace only the matching marked block and should not
rewrite surrounding repo instructions.

## Baseline Versus Skill

- Use a portable baseline for always-on judgment principles that should apply
  before tool-specific or repo-specific instructions.
- Use a skill for a repeatable workflow with trigger criteria, required inputs,
  steps, outputs, verification, and stop conditions.
- Do not turn every baseline into a skill; that makes always-on behavior depend
  on runtime skill discovery and invocation.
- Do not turn every skill into a baseline; that makes ordinary chats too heavy
  and hides workflow-specific entry criteria.

## Team Reuse

For a team skills repo, copy this directory shape first. Start with one baseline
pack, one adapter, and one verification script before adding profiles or
composition. Composition should be a thin profile that lists packs, not a second
copy of the baseline text.

## CLI

Use `scripts/baseline.ps1` as the human-friendly entrypoint:

```powershell
./scripts/baseline.ps1 list
./scripts/baseline.ps1 show
./scripts/baseline.ps1 apply -TargetRepo C:\path\to\repo -Tools codex,claude,copilot -DryRun
./scripts/baseline.ps1 remove -TargetRepo C:\path\to\repo -Tools codex,claude,copilot -DryRun
./scripts/baseline.ps1 verify -TargetRepo C:\path\to\repo -Tools codex,claude,copilot
```

When called from inside the target repo, omit `-TargetRepo`; it defaults to the
current directory.

When exactly one pack exists, the CLI infers it. Once multiple packs exist,
`show`, `apply`, `remove`, and `verify` require an explicit pack name.

On macOS or Linux, the native shell entrypoint is:

```bash
./scripts/baseline list
./scripts/baseline show
./scripts/baseline apply --tools codex,claude,copilot --dry-run
```

## Global Shim

Install a reversible command shim when you want to run `baseline` from
any repo.

Windows PowerShell or CMD:

```powershell
./scripts/install-baseline-shim.ps1 -AddToUserPath
baseline list
./scripts/install-baseline-shim.ps1 -Remove
```

macOS or Linux:

```bash
./scripts/install-baseline-shim.sh
baseline list
./scripts/install-baseline-shim.sh --remove
```

The shim writes only one command wrapper into the selected bin directory. It
forwards to this repo's CLI and does not copy packs or write assistant runtime
state. Installing it also removes older matching `p-baseline` or
`portable-baseline` shims from the same install directory.
