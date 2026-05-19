#!/usr/bin/env bash
set -eu

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CANONICAL_DIR="$ROOT_DIR/skills/engineering"
CLAUDE_SKILLS_DIR="$ROOT_DIR/.claude/skills"

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

[ -d "$CANONICAL_DIR" ] || fail "Missing canonical skills directory: $CANONICAL_DIR"
[ -d "$CLAUDE_SKILLS_DIR" ] || fail "Missing Claude skills adapter directory: $CLAUDE_SKILLS_DIR"

found=0

for skill_dir in "$CANONICAL_DIR"/*; do
  [ -d "$skill_dir" ] || continue
  found=1

  skill_name="$(basename "$skill_dir")"
  skill_file="$skill_dir/SKILL.md"
  adapter_dir="$CLAUDE_SKILLS_DIR/$skill_name"
  adapter_file="$adapter_dir/SKILL.md"

  [ -f "$skill_file" ] || fail "Missing SKILL.md for canonical skill: $skill_name"
  grep -q '^---$' "$skill_file" || fail "Missing YAML frontmatter fence in $skill_file"
  grep -q '^name:[[:space:]]*'"$skill_name"'[[:space:]]*$' "$skill_file" || fail "Missing or mismatched name frontmatter in $skill_file"
  grep -q '^description:[[:space:]]*' "$skill_file" || fail "Missing description frontmatter in $skill_file"

  [ -e "$adapter_dir" ] || fail "Missing Claude adapter for skill: $skill_name"
  [ -f "$adapter_file" ] || fail "Claude adapter does not resolve to SKILL.md for: $skill_name"
done

[ "$found" -eq 1 ] || fail "No canonical skills found under $CANONICAL_DIR"

printf 'Verified skills and adapters successfully.\n'
