#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
CLI_PATH="$ROOT_DIR/scripts/portable-baseline"
INSTALL_DIR="${P_BASELINE_BIN_DIR:-${PORTABLE_BASELINE_BIN_DIR:-$HOME/.local/bin}}"
VERIFY_ONLY=0
REMOVE=0
MARKER="agentic-engineering-skills p-baseline shim"

usage() {
  cat <<'USAGE'
Usage:
  ./scripts/install-portable-baseline-shim.sh [--install-dir <dir>]
  ./scripts/install-portable-baseline-shim.sh --verify-only [--install-dir <dir>]
  ./scripts/install-portable-baseline-shim.sh --remove [--install-dir <dir>]
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --install-dir)
      INSTALL_DIR="$2"
      shift 2
      ;;
    --verify-only)
      VERIFY_ONLY=1
      shift
      ;;
    --remove)
      REMOVE=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

SHIM_PATH="$INSTALL_DIR/p-baseline"

path_contains_install_dir() {
  case ":$PATH:" in
    *":$INSTALL_DIR:"*) return 0 ;;
    *) return 1 ;;
  esac
}

verify_shim() {
  if [[ ! -f "$SHIM_PATH" ]]; then
    echo "Missing shim: $SHIM_PATH" >&2
    exit 1
  fi
  if ! grep -q "$MARKER" "$SHIM_PATH" || ! grep -q "$CLI_PATH" "$SHIM_PATH"; then
    echo "Shim exists but does not point at this repo: $SHIM_PATH" >&2
    exit 1
  fi
  if ! path_contains_install_dir; then
    echo "Install dir is not in PATH: $INSTALL_DIR" >&2
    exit 1
  fi
  echo "shim ok: $SHIM_PATH"
}

if [[ "$REMOVE" -eq 1 ]]; then
  if [[ ! -f "$SHIM_PATH" ]]; then
    echo "skip missing shim: $SHIM_PATH"
    exit 0
  fi
  if ! grep -q "$MARKER" "$SHIM_PATH" || ! grep -q "$CLI_PATH" "$SHIM_PATH"; then
    echo "Refusing to remove non-matching shim: $SHIM_PATH" >&2
    exit 1
  fi
  if [[ "$VERIFY_ONLY" -eq 1 ]]; then
    echo "would remove shim: $SHIM_PATH"
    exit 0
  fi
  rm "$SHIM_PATH"
  echo "removed shim: $SHIM_PATH"
  exit 0
fi

if [[ "$VERIFY_ONLY" -eq 1 ]]; then
  verify_shim
  exit 0
fi

mkdir -p "$INSTALL_DIR"
cat > "$SHIM_PATH" <<SHIM
#!/usr/bin/env bash
# $MARKER
P_BASELINE_COMMAND_NAME=p-baseline exec "$CLI_PATH" "\$@"
SHIM
chmod +x "$SHIM_PATH"

echo "installed shim: $SHIM_PATH"
if path_contains_install_dir; then
  echo "PATH already contains: $INSTALL_DIR"
else
  echo "PATH does not contain: $INSTALL_DIR"
  echo "add it to your shell profile, for example:"
  echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
fi
