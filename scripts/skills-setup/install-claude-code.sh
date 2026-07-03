#!/usr/bin/env bash
set -eu

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
SOURCE_DIR="$ROOT_DIR/skills"
TARGET_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

source "$ROOT_DIR/scripts/lib/personal-skill-install.sh"

install_personal_skills "Claude Code" "$ROOT_DIR" "$SOURCE_DIR" "$TARGET_DIR" "$@"
