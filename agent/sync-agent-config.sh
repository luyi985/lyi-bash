#!/usr/bin/env bash
set -euo pipefail

# Install shared instructions and agent-specific user-level entrypoints.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR"
DEST="${AGENTS_HOME:-$HOME/.agents}"
DRY_RUN=false
FORCE=false

usage() {
  cat <<'HELP'
Usage: agent/sync-agent-config.sh [--dry-run] [--force]

Install agent/AGENTS.md, standards, and optional SDD workflow into
~/.agents (or $AGENTS_HOME), then synchronize user-level adapters:
  Codex:        ~/.codex/AGENTS.md
  Claude Code:  ~/.claude/CLAUDE.md
  Copilot CLI:  ~/.copilot/copilot-instructions.md
  Gemini CLI:   ~/.gemini/GEMINI.md
  Cursor:       ~/.cursor/rules/shared-agent-instructions.mdc

Files already present and different are left untouched unless --force is used.
--force backs up each replaced file as <file>.bak (only if no .bak exists).
Copilot IDE-specific settings must be configured manually.
HELP
}

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --force) FORCE=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 2 ;;
  esac
done

[[ -f "$SOURCE/AGENTS.md" ]] || { echo "Missing $SOURCE/AGENTS.md" >&2; exit 1; }

sync_file() {
  local source="$1" target="$2" dir
  dir="$(dirname "$target")"
  if [[ -e "$target" || -L "$target" ]]; then
    if [[ -f "$target" && ! -L "$target" ]] && cmp -s "$source" "$target"; then
      printf 'unchanged %s\n' "$target"
      return
    fi
    if ! "$FORCE"; then
      printf 'SKIP existing file (use --force): %s\n' "$target" >&2
      return
    fi
    if [[ -e "$target.bak" || -L "$target.bak" ]]; then
      printf 'ERROR backup exists; resolve before --force: %s.bak\n' "$target" >&2
      return 1
    fi
    if "$DRY_RUN"; then
      printf 'would backup and replace %s\n' "$target"
      return
    fi
    mkdir -p "$dir"
    mv "$target" "$target.bak"
  else
    if "$DRY_RUN"; then
      printf 'would install %s\n' "$target"
      return
    fi
  fi
  mkdir -p "$dir"
  cp "$source" "$target"
  printf 'installed %s\n' "$target"
}

sync_file "$SOURCE/AGENTS.md" "$DEST/AGENTS.md"
for file in coding.md testing.md security.md llm.md; do
  sync_file "$SOURCE/docs/standards/$file" "$DEST/standards/$file"
done
sync_file "$SOURCE/docs/workflows/sdd.md" "$DEST/workflows/sdd.md"

# Full copies ensure agents receive instructions without relying on link/import support.
sync_file "$SOURCE/AGENTS.md" "$HOME/.codex/AGENTS.md"
sync_file "$SOURCE/AGENTS.md" "$HOME/.claude/CLAUDE.md"
sync_file "$SOURCE/AGENTS.md" "$HOME/.copilot/copilot-instructions.md"
sync_file "$SOURCE/AGENTS.md" "$HOME/.gemini/GEMINI.md"

# Cursor uses MDC frontmatter to apply the shared instructions to every chat.
CURSOR_RULE="$(mktemp "${TMPDIR:-/tmp}/sync-agent-config.XXXXXX")"
trap 'rm -f "$CURSOR_RULE"' EXIT
{
  printf '%s\n' '---' 'alwaysApply: true' '---' ''
  cat "$SOURCE/AGENTS.md"
} > "$CURSOR_RULE"
sync_file "$CURSOR_RULE" "$HOME/.cursor/rules/shared-agent-instructions.mdc"
printf '\nNote: Copilot IDE adapters need manual configuration.\n'
