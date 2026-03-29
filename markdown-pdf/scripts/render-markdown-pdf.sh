#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  render-markdown-pdf.sh INPUT.md [-o OUTPUT.pdf] [--mode print-formal|web-clean] [--toc] [--font FONT_NAME] [--font-size SIZE] [--dry-run]

Examples:
  render-markdown-pdf.sh notes.md
  render-markdown-pdf.sh notes.md -o notes.pdf --toc
  render-markdown-pdf.sh README.md --mode web-clean -o README.pdf
EOF
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ASSETS_DIR="$SKILL_DIR/assets"

MODE="print-formal"
FONT="LXGW WenKai"
FONT_SIZE="30pt"
TOC=0
DRY_RUN=0
INPUT=""
OUTPUT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -o|--output)
      OUTPUT="$2"
      shift 2
      ;;
    --mode)
      MODE="$2"
      shift 2
      ;;
    --toc)
      TOC=1
      shift
      ;;
    --font)
      FONT="$2"
      shift 2
      ;;
    --font-size)
      FONT_SIZE="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      if [[ -z "$INPUT" ]]; then
        INPUT="$1"
      else
        echo "Unexpected argument: $1" >&2
        usage >&2
        exit 2
      fi
      shift
      ;;
  esac
done

if [[ -z "$INPUT" ]]; then
  echo "Input Markdown file is required." >&2
  usage >&2
  exit 2
fi

if [[ ! -f "$INPUT" ]]; then
  echo "Input file not found: $INPUT" >&2
  exit 1
fi

if [[ -z "$OUTPUT" ]]; then
  OUTPUT="${INPUT%.*}.pdf"
fi

case "$MODE" in
  print-formal|web-clean) ;;
  *)
    echo "Unsupported mode: $MODE" >&2
    exit 2
    ;;
esac

PANDOC_CMD=(pandoc "$INPUT" -o "$OUTPUT")

if [[ "$MODE" == "print-formal" ]]; then
  PANDOC_CMD+=(
    --from=markdown
    --pdf-engine=xelatex
    --defaults "$ASSETS_DIR/defaults.yaml"
    --template "$ASSETS_DIR/print-formal.tex"
    --lua-filter "$SCRIPT_DIR/cleanup.lua"
    --lua-filter "$SCRIPT_DIR/tasklist.lua"
    --lua-filter "$SCRIPT_DIR/grid-table.lua"
    --highlight-style pygments
    -V "mainfont=$FONT"
    -V "fontsize=$FONT_SIZE"
  )

  if [[ "$TOC" -eq 1 ]]; then
    PANDOC_CMD+=(--toc)
  fi
else
  PANDOC_CMD+=(
    --from=markdown
    --standalone
    --css "$ASSETS_DIR/web-clean.css"
  )

  if [[ "$TOC" -eq 1 ]]; then
    PANDOC_CMD+=(--toc)
  fi
fi

printf 'Mode: %s\n' "$MODE"
printf 'Input: %s\n' "$INPUT"
printf 'Output: %s\n' "$OUTPUT"
printf 'Font: %s\n' "$FONT"
printf 'Font size: %s\n' "$FONT_SIZE"
printf 'Command:'
printf ' %q' "${PANDOC_CMD[@]}"
printf '\n'

if [[ "$DRY_RUN" -eq 1 ]]; then
  exit 0
fi

"${PANDOC_CMD[@]}"

echo "Generated PDF: $OUTPUT"
