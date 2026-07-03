#!/usr/bin/env bash
set -eu

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"

"$ROOT_DIR/scripts/skills-setup/install-codex.sh" --verify-only "$@"
"$ROOT_DIR/scripts/skills-setup/install-claude-code.sh" --verify-only "$@"
