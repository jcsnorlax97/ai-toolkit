#!/usr/bin/env bash
# Apply a preset's baselines to a target repo's CLAUDE.md.
#
# Usage: scripts/apply-preset.sh <preset-name> <target-repo>
#
# Reads presets/<preset-name>.txt, appends each listed baseline's CLAUDE.md.block
# to <target-repo>/CLAUDE.md (creating CLAUDE.md if absent), and prints
# instructions for any hooks listed under [hooks].
#
# Re-apply behaviour: blocks are appended unconditionally; running the script
# twice produces duplicate blocks. De-duplication is not performed. Use the
# managed-block marker (<!-- BEGIN baseline:... -->) to identify and remove
# duplicates manually, or use the baseline CLI to update individual packs.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"

usage() {
  cat >&2 <<USAGE
Usage: $0 <preset-name> <target-repo>

  Apply a preset's baselines to <target-repo>/CLAUDE.md.

  <preset-name>  Name of a preset file in $REPO_ROOT/presets/ (without .txt)
  <target-repo>  Path to the target repository root
USAGE
  exit 1
}

[[ $# -eq 2 ]] || usage

PRESET_NAME="$1"
TARGET_REPO="${2%/}"

if [[ ! -d "$TARGET_REPO" ]]; then
  echo "Error: target-repo not found: $TARGET_REPO" >&2
  exit 1
fi

TARGET_REPO="$(cd "$TARGET_REPO" && pwd -P)"
PRESET_FILE="$REPO_ROOT/presets/$PRESET_NAME.txt"
TARGET_CLAUDE="$TARGET_REPO/CLAUDE.md"

if [[ ! -f "$PRESET_FILE" ]]; then
  echo "Error: preset not found: $PRESET_FILE" >&2
  echo "Available presets:" >&2
  for f in "$REPO_ROOT/presets/"*.txt; do
    [[ -f "$f" ]] && echo "  $(basename "$f" .txt)" >&2
  done
  exit 1
fi

# Parse preset file into baselines and hooks arrays.
# Lines before [hooks] are baseline directory names; lines after are hook names.
# Blank lines and lines starting with # are ignored.
IN_HOOKS=0
BASELINES=()
HOOKS=()

while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  [[ "$line" =~ ^# ]] && continue
  if [[ "$line" == "[hooks]" ]]; then
    IN_HOOKS=1
    continue
  fi
  if [[ "$IN_HOOKS" -eq 1 ]]; then
    HOOKS+=("$line")
  else
    BASELINES+=("$line")
  fi
done < "$PRESET_FILE"

# Create CLAUDE.md if it does not exist.
if [[ ! -f "$TARGET_CLAUDE" ]]; then
  touch "$TARGET_CLAUDE"
  echo "created $TARGET_CLAUDE"
fi

# Append each baseline block.
for baseline in "${BASELINES[@]}"; do
  BLOCK_FILE="$REPO_ROOT/baselines/$baseline/adapters/CLAUDE.md.block"
  if [[ ! -f "$BLOCK_FILE" ]]; then
    echo "Warning: block file not found for baseline '$baseline': $BLOCK_FILE" >&2
    continue
  fi
  printf '\n' >> "$TARGET_CLAUDE"
  cat "$BLOCK_FILE" >> "$TARGET_CLAUDE"
  echo "appended $baseline"
done

# Print hook installation instructions (never silently edit target settings).
if [[ "${#HOOKS[@]}" -gt 0 ]]; then
  echo ""
  echo "Hooks to install — run these commands from inside $TARGET_REPO:"
  for hook in "${HOOKS[@]}"; do
    echo "  hooks apply $hook"
  done
fi

echo ""
echo "Done. Applied ${#BASELINES[@]} baseline(s) from preset '$PRESET_NAME' to $TARGET_CLAUDE."
