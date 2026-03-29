#!/usr/bin/env bash
set -euo pipefail

FONT_NAME="${1:-LXGW WenKai}"
MISSING=0

check_cmd() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '[OK] %s -> %s\n' "$cmd" "$(command -v "$cmd")"
  else
    printf '[MISSING] %s\n' "$cmd"
    MISSING=1
  fi
}

check_cmd pandoc
check_cmd xelatex
check_cmd fc-match

if command -v fc-match >/dev/null 2>&1; then
  MATCH="$(fc-match "$FONT_NAME" 2>/dev/null || true)"
  if [[ -n "$MATCH" ]]; then
    printf '[OK] font match for "%s" -> %s\n' "$FONT_NAME" "$MATCH"
  else
    printf '[MISSING] font "%s" not found via fc-match\n' "$FONT_NAME"
    MISSING=1
  fi
fi

if [[ "$MISSING" -eq 1 ]]; then
  echo "One or more dependencies are missing. Fix them before relying on print-formal mode." >&2
  exit 1
fi

echo "All checked dependencies look available."
