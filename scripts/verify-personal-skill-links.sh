#!/usr/bin/env bash
set -eu

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

"$ROOT_DIR/scripts/install-codex-skills.sh" --verify-only "$@"
"$ROOT_DIR/scripts/install-claude-code-skills.sh" --verify-only "$@"
