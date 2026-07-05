# Handoff: 2026-07-05 Port Presets to the PowerShell Core (ADR 0001 Consistency)

Source: user review of the preset mechanism added earlier today
(`docs/handoffs/2026-07-05-carman-retro-actions.md`, commits 319247a/a976dd2/
7c97b37). That handoff spec'd the apply script as "bash, no dependencies
beyond coreutils" — a mistake: it contradicts ADR 0001 (PowerShell as
cross-platform core) and bypasses the baseline CLI's managed-block engine.

## Why the current bash implementation is wrong

1. ADR 0001: baseline/hooks/skills all have PowerShell cores with bash entry
   wrappers and `.cmd` Windows shims. `scripts/apply-preset.sh` is bash-only,
   so presets are dead on Windows and fork the script architecture.
2. Functional regression vs the baseline engine: `apply-preset.sh` blindly
   appends `CLAUDE.md.block` contents — re-applying duplicates blocks, there
   is no managed-block versioned update-in-place, and only the CLAUDE.md
   adapter is applied (codex/copilot adapters ignored). The baseline CLI
   already does all of this correctly per pack.

## Task

Make presets a thin layer over the existing baseline engine, PowerShell-core:

- **Preferred shape:** extend the baseline CLI (`scripts/baseline.ps1`) with a
  preset verb, e.g. `baseline apply-preset <preset-name> [-Tools ...]
  [-Repo <target>]`, which reads `presets/<name>.txt` (format unchanged:
  baseline names one per line, then `[hooks]` section) and runs the existing
  per-pack apply logic for each listed baseline. Investigate first whether
  `baseline apply` already supports applying into an arbitrary target repo
  path; if not, adding that capability is in scope (bootstrapping ANOTHER
  repo is the entire point of presets). Hooks section: print install
  instructions, never edit target settings (unchanged behavior).
- **Fallback shape** (only if modifying baseline.ps1 proves too risky): a
  standalone `scripts/preset.ps1` + bash entry wrapper `scripts/preset`
  mirroring the baseline entry-point pattern, composing the baseline CLI via
  repeated `baseline apply <pack>` invocations rather than reimplementing
  block handling.
- **Retire the bash pieces** (net meta layers must not rise): delete
  `scripts/apply-preset.sh` and `scripts/presets/install-shim.sh`, remove the
  installed `~/.local/bin/apply-preset` shim (run its `--remove` before
  deleting the installer), and replace the three `apply-preset` rows in
  `docs/how-to/install.md` with the new command's rows (macOS/Linux and
  Windows, mirroring the baseline/skills rows). Keep `presets/
  supabase-vercel-site.txt` unchanged. Update the `## Executed` notes in
  `2026-07-05-carman-retro-actions.md` with one line pointing here (do not
  rewrite history there).
- Follow the existing shim subcommand convention (`shim install|verify|remove`)
  for whichever entry point results.

## Verification (must do)

- Scratch test: apply the `supabase-vercel-site` preset to a temp repo dir
  twice; the second run must update managed blocks in place (no duplicate
  sections) — this is the concrete improvement over the bash version. Verify
  8 managed baseline blocks present exactly once, in preset order or
  documented order.
- `-DryRun` (or the CLI's equivalent) works for the preset verb.
- Existing repo verify scripts still pass (`scripts/skills-setup/verify.sh`;
  run any baseline verify command the CLI offers against the scratch target).
- Shim: install + verify on macOS; confirm the Windows path exists in docs
  (actual Windows execution not testable here).

## Non-goals

- No new preset features (no dedupe flags, no per-tool preset variants, no
  preset registry/CONTEXT.md).
- No changes to baseline pack contents or versions.
- No hooks auto-installation.

## Executed

Date: 2026-07-05

**Shape chosen:** Preferred — `apply-preset` verb added to `scripts/baseline.ps1`. The `-TargetRepo` parameter already existed in baseline.ps1 (defaulting to cwd), so no new target-repo plumbing was required.

**Target-repo support:** baseline.ps1 already accepted `-TargetRepo <path>` for all commands; `apply-preset` passes it through to `scripts/baselines/apply.ps1` per-pack, unchanged.

**Files created/edited:**
- `scripts/baseline.ps1` — added `apply-preset` to `$validCommands`, `Show-Usage`, `Write-FriendlyError`, tools-normalization block, and switch case; 43-line net addition.
- `docs/how-to/install.md` — removed 3 apply-preset shim rows; added 3 `baseline apply-preset` command rows to the Commands table.
- `docs/handoffs/2026-07-05-carman-retro-actions.md` — appended one pointer line to `## Executed`.

**Files deleted:**
- `scripts/apply-preset.sh` — retired bash implementation.
- `scripts/presets/install-shim.sh` — retired preset shim installer (directory `scripts/presets/` also removed as it became empty).

**Shim:** `scripts/presets/install-shim.sh --remove` ran first (removed `~/.local/bin/apply-preset`). No new shim needed — the existing `baseline` shim covers `baseline apply-preset`.

**Verification results:**
- `pwsh` syntax check: OK.
- First apply to scratch dir: all 8 baselines created (CLAUDE.md, AGENTS.md, copilot-instructions.md).
- Second apply (idempotency): all 8 show "updated", not "added" — no duplicate blocks.
- `grep -c "<!-- BEGIN baseline:"` on CLAUDE.md, AGENTS.md, copilot-instructions.md: **8 exactly** after both runs.
- `-DryRun`: printed "would create …" for all 24 file×pack combinations, wrote zero files.
- `baseline verify <pack> -TargetRepo <scratch>` for all 8 preset packs: all "target ok".
- `scripts/skills-setup/verify.sh`: passed ("Verified skills and adapters successfully.").
- `baseline shim verify`: "shim ok: ~/.local/bin/baseline".
- Scratch dirs cleaned up.
