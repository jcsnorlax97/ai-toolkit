#!/usr/bin/env bash
set -eu

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$ROOT_DIR/skills/engineering"
TARGET_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

[ -d "$SOURCE_DIR" ] || fail "Missing source directory: $SOURCE_DIR"
mkdir -p "$TARGET_DIR"

for skill_dir in "$SOURCE_DIR"/*; do
  [ -d "$skill_dir" ] || continue
  skill_name="$(basename "$skill_dir")"
  target="$TARGET_DIR/$skill_name"

  if [ -e "$target" ] || [ -L "$target" ]; then
    printf 'Skipping existing Claude Code skill: %s\n' "$target"
    continue
  fi

  cp -R "$skill_dir" "$target"
  printf 'Installed Claude Code skill: %s\n' "$target"
done
