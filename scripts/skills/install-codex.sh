#!/usr/bin/env bash
set -eu

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
SOURCE_DIR="$ROOT_DIR/skills/engineering"
TARGET_DIR="${CODEX_SKILLS_DIR:-$HOME/.codex/skills}"

source "$ROOT_DIR/scripts/lib/personal-skill-install.sh"

install_personal_skills "Codex" "$ROOT_DIR" "$SOURCE_DIR" "$TARGET_DIR" "$@"
