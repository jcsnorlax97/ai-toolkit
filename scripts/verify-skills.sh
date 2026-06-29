#!/usr/bin/env bash
set -eu

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CANONICAL_DIR="$ROOT_DIR/skills/engineering"
CLAUDE_SKILLS_DIR="$ROOT_DIR/.claude/skills"

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

warn() {
  printf 'WARN: %s\n' "$1" >&2
}

[ -d "$CANONICAL_DIR" ] || fail "Missing canonical skills directory: $CANONICAL_DIR"
[ -d "$CLAUDE_SKILLS_DIR" ] || fail "Missing Claude skills adapter directory: $CLAUDE_SKILLS_DIR"

found=0
metadata_warnings=0
metadata_verbose="${VERIFY_SKILL_METADATA_VERBOSE:-0}"

for skill_dir in "$CANONICAL_DIR"/*; do
  [ -d "$skill_dir" ] || continue
  found=1

  skill_name="$(basename "$skill_dir")"
  skill_file="$skill_dir/SKILL.md"
  adapter_dir="$CLAUDE_SKILLS_DIR/$skill_name"
  adapter_file="$adapter_dir/SKILL.md"
  adapter_pointer="../../skills/engineering/$skill_name"

  [ -f "$skill_file" ] || fail "Missing SKILL.md for canonical skill: $skill_name"
  grep -q '^---[[:space:]]*$' "$skill_file" || fail "Missing YAML frontmatter fence in $skill_file"
  grep -q '^name:[[:space:]]*'"$skill_name"'[[:space:]]*$' "$skill_file" || fail "Missing or mismatched name frontmatter in $skill_file"
  grep -q '^description:[[:space:]]*' "$skill_file" || fail "Missing description frontmatter in $skill_file"

  missing_metadata=""
  for field in status problem when-not-to-use maintainer; do
    if ! grep -q "^$field:[[:space:]]*" "$skill_file"; then
      missing_metadata="${missing_metadata}${missing_metadata:+, }$field"
    fi
  done

  if [ -n "$missing_metadata" ]; then
    metadata_warnings=$((metadata_warnings + 1))
    if [ "$metadata_verbose" = "1" ]; then
      warn "Recommended metadata missing in $skill_file: $missing_metadata"
    fi
  fi

  [ -e "$adapter_dir" ] || fail "Missing Claude adapter for skill: $skill_name"
  if [ -f "$adapter_file" ]; then
    :
  elif [ -f "$adapter_dir" ]; then
    actual_pointer="$(tr -d '\r\n' < "$adapter_dir")"
    [ "$actual_pointer" = "$adapter_pointer" ] || fail "Invalid Claude adapter pointer for: $skill_name"
  else
    fail "Claude adapter does not resolve or contain a valid pointer for: $skill_name"
  fi
done

[ "$found" -eq 1 ] || fail "No canonical skills found under $CANONICAL_DIR"

if [ "$metadata_warnings" -gt 0 ]; then
  printf 'Metadata recommendations missing for %s skill(s); runtime verification still passed. Set VERIFY_SKILL_METADATA_VERBOSE=1 for details.\n' "$metadata_warnings" >&2
fi

printf 'Verified skills and adapters successfully.\n'
