#!/usr/bin/env bash
set -eu

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"

"$ROOT_DIR/scripts/skills-setup/repair-personal-links.sh" "$@"
