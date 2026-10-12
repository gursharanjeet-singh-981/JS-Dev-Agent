#!/usr/bin/env bash
# Install the JS Dev agent kit into a target project (default) or your VS Code user profile (--user).
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.github"
FORCE=false
MODE=project
TARGET=""

usage() {
  echo "Usage: $0 [--force] <target-project-dir>"
  echo "       $0 [--force] --user"
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force) FORCE=true ;;
    --user) MODE=user ;;
    -h|--help) usage ;;
    *) TARGET="$1" ;;
  esac
  shift
done

copy_dir() {
  local from="$1" to="$2"
  mkdir -p "$to"
  for item in "$from"/*; do
    local dest="$to/$(basename "$item")"
    if [[ -e "$dest" && "$FORCE" != true ]]; then
      echo "skip (exists): $dest"
    else
      cp -R "$item" "$dest"
      echo "installed: $dest"
    fi
  done
}

if [[ "$MODE" == user ]]; then
  case "$(uname -s)" in
    Darwin) PROMPTS_DIR="$HOME/Library/Application Support/Code/User/prompts" ;;
    Linux)  PROMPTS_DIR="$HOME/.config/Code/User/prompts" ;;
    *)      PROMPTS_DIR="$APPDATA/Code/User/prompts" ;;
  esac
  copy_dir "$SRC/agents" "$PROMPTS_DIR"
  copy_dir "$SRC/prompts" "$PROMPTS_DIR"
  copy_dir "$SRC/skills" "$HOME/.copilot/skills"
else
  [[ -z "$TARGET" ]] && usage
  [[ -d "$TARGET" ]] || { echo "Target directory not found: $TARGET"; exit 1; }
  DEST="$(cd "$TARGET" && pwd)/.github"
  copy_dir "$SRC/agents" "$DEST/agents"
  copy_dir "$SRC/prompts" "$DEST/prompts"
  copy_dir "$SRC/skills" "$DEST/skills"
fi

echo "Done. Reload VS Code, then pick 'JS Dev' in the Chat agent picker."
