#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$REPO_ROOT/agent/skills"
TARGET_DIR="${AGENTS_HOME:-$HOME/.agents}/skills"

pull=true
dry_run=false

for arg in "$@"; do
  case "$arg" in
    --no-pull) pull=false ;;
    --dry-run) dry_run=true ;;
    -h|--help)
      cat <<'EOF'
Usage: agent/sync-skills.sh [--no-pull] [--dry-run]

Synchronize repository skills from agent/skills to ~/.agents/skills.

Options:
  --no-pull  Skip git pull --ff-only before syncing.
  --dry-run  Show rsync changes without writing them.
EOF
      exit 0
      ;;
    *)
      echo "Unknown option: $arg" >&2
      exit 2
      ;;
  esac
done

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Skills source directory not found: $SOURCE_DIR" >&2
  exit 1
fi

if $pull; then
  if git -C "$REPO_ROOT" diff --quiet && git -C "$REPO_ROOT" diff --cached --quiet; then
    git -C "$REPO_ROOT" pull --ff-only
  else
    echo "Local changes detected; skipping git pull. Commit/stash them or rerun after cleanup." >&2
  fi
fi

mkdir -p "$TARGET_DIR"

rsync_args=(-a --delete --exclude '.DS_Store' --exclude '*.tmp')
if $dry_run; then
  rsync_args+=(--dry-run --itemize-changes)
fi

rsync "${rsync_args[@]}" "$SOURCE_DIR/" "$TARGET_DIR/"

echo "Skills synchronized:"
echo "  source: $SOURCE_DIR"
echo "  target: $TARGET_DIR"
