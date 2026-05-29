#!/usr/bin/env bash
set -eu

usage() {
  cat <<'USAGE'
Usage: install script [--verify-only] [--keep-existing]

Installs personal skills as symlinks through a stable current link:

  ~/.local/share/agentic-engineering-skills/current

Options:
  --verify-only    Check links without changing them.
  --keep-existing  Leave non-symlink targets in place instead of moving them
                   to a backup directory and linking the canonical skill.
  -h, --help       Show this help.
USAGE
}

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

symlink_failure_hint() {
  case "$(uname -s 2>/dev/null || true)" in
    MINGW*|MSYS*|CYGWIN*)
      cat >&2 <<'HINT'

Windows note:
  This script requires real directory symlinks. In Git Bash, enable Windows
  Developer Mode or run the shell with privileges that can create symlinks.
  Prefer:

    MSYS=winsymlinks:nativestrict ./scripts/install-claude-code-skills.sh

  If you run from WSL, the default ~/.claude/skills path is inside WSL, not the
  Windows user's Claude Code profile, unless you explicitly set CLAUDE_SKILLS_DIR.
HINT
      ;;
  esac
}

create_symlink() {
  link_source="$1"
  link_target="$2"

  ln -s "$link_source" "$link_target"

  if [ ! -L "$link_target" ]; then
    printf 'ERROR: ln -s did not create a real symlink: %s -> %s\n' "$link_target" "$link_source" >&2
    symlink_failure_hint
    exit 1
  fi
}

replace_symlink() {
  link_source="$1"
  link_target="$2"
  link_parent="$(dirname "$link_target")"
  tmp_link="$link_parent/.tmp-link.$$.$RANDOM"

  create_symlink "$link_source" "$tmp_link"
  mv -f "$tmp_link" "$link_target"
}

install_personal_skills() {
  tool_label="$1"
  root_dir="$2"
  source_dir="$3"
  target_dir="$4"
  shift 4

  verify_only=0
  keep_existing=0

  while [ "$#" -gt 0 ]; do
    case "$1" in
      --verify-only)
        verify_only=1
        ;;
      --keep-existing)
        keep_existing=1
        ;;
      -h|--help)
        usage
        return 0
        ;;
      *)
        fail "Unknown option: $1"
        ;;
    esac
    shift
  done

  [ -d "$source_dir" ] || fail "Missing source directory: $source_dir"

  root_dir="$(cd "$root_dir" && pwd -P)"
  state_dir="${AGENTIC_ENGINEERING_SKILLS_STATE_DIR:-${AGENTIC_SKILLS_STATE_DIR:-$HOME/.local/share/agentic-engineering-skills}}"
  current_link="$state_dir/current"
  backup_stamp="$(date +%Y%m%d-%H%M%S)"

  if [ "$verify_only" -eq 0 ]; then
    mkdir -p "$state_dir"

    if [ -L "$current_link" ]; then
      if [ ! -d "$current_link" ]; then
        replace_symlink "$root_dir" "$current_link"
        printf 'Repaired repo current link: %s -> %s\n' "$current_link" "$root_dir"
      else
        current_resolved="$(cd "$current_link" && pwd -P)"
        if [ "$current_resolved" != "$root_dir" ]; then
          replace_symlink "$root_dir" "$current_link"
          printf 'Updated repo current link: %s -> %s\n' "$current_link" "$root_dir"
        fi
      fi
    elif [ -e "$current_link" ]; then
      fail "Current link path exists but is not a symlink: $current_link"
    else
      create_symlink "$root_dir" "$current_link"
      printf 'Created repo current link: %s -> %s\n' "$current_link" "$root_dir"
    fi

    mkdir -p "$target_dir"
  else
    [ -L "$current_link" ] || fail "Missing repo current symlink: $current_link"
    [ -d "$current_link/skills/engineering" ] || fail "Repo current link does not resolve to skills: $current_link"
    current_resolved="$(cd "$current_link" && pwd -P)"
    [ "$current_resolved" = "$root_dir" ] || fail "Repo current link points at $current_resolved, expected $root_dir"
    [ -d "$target_dir" ] || fail "Missing target directory: $target_dir"
  fi

  found=0
  linked=0
  repaired=0
  migrated=0
  kept=0

  for skill_dir in "$source_dir"/*; do
    [ -d "$skill_dir" ] || continue
    found=1

    skill_name="$(basename "$skill_dir")"
    target="$target_dir/$skill_name"
    desired="$current_link/skills/engineering/$skill_name"

    if [ "$verify_only" -eq 1 ]; then
      [ -L "$target" ] || fail "$tool_label skill is not a symlink: $target"
      link_target="$(readlink "$target")"
      [ "$link_target" = "$desired" ] || fail "$tool_label skill points at $link_target, expected $desired"
      [ -f "$target/SKILL.md" ] || fail "$tool_label skill link does not resolve to SKILL.md: $target"
      continue
    fi

    if [ -L "$target" ]; then
      link_target="$(readlink "$target")"
      if [ "$link_target" = "$desired" ] && [ -f "$target/SKILL.md" ]; then
        printf 'Verified %s skill link: %s\n' "$tool_label" "$target"
      else
        replace_symlink "$desired" "$target"
        repaired=$((repaired + 1))
        printf 'Repaired %s skill link: %s -> %s\n' "$tool_label" "$target" "$desired"
      fi
      continue
    fi

    if [ -e "$target" ]; then
      if [ "$keep_existing" -eq 1 ]; then
        kept=$((kept + 1))
        printf 'Keeping existing non-symlink %s skill: %s\n' "$tool_label" "$target"
        continue
      fi

      backup_dir="$target_dir/.agentic-engineering-skills-backups/$backup_stamp"
      backup_target="$backup_dir/$skill_name"
      mkdir -p "$backup_dir"
      [ ! -e "$backup_target" ] || fail "Backup target already exists: $backup_target"
      mv "$target" "$backup_target"
      create_symlink "$desired" "$target"
      migrated=$((migrated + 1))
      printf 'Moved existing %s skill to backup: %s\n' "$tool_label" "$backup_target"
      printf 'Linked %s skill: %s -> %s\n' "$tool_label" "$target" "$desired"
      continue
    fi

    create_symlink "$desired" "$target"
    linked=$((linked + 1))
    printf 'Linked %s skill: %s -> %s\n' "$tool_label" "$target" "$desired"
  done

  [ "$found" -eq 1 ] || fail "No canonical skills found under $source_dir"

  if [ "$verify_only" -eq 1 ]; then
    printf 'Verified %s personal skill links successfully.\n' "$tool_label"
  else
    printf 'Finished %s personal skill install: linked=%s repaired=%s migrated=%s kept=%s\n' \
      "$tool_label" "$linked" "$repaired" "$migrated" "$kept"
  fi
}
