# Troubleshooting

## Raw Markdown markers appear in output

Possible causes:
- the file was not rendered through pandoc
- the source uses malformed Markdown
- unsupported extension syntax confused parsing

Checks:
- confirm `scripts/render-markdown-pdf.sh` was used
- inspect the source for broken emphasis, heading, or fence syntax
- retry with explicit `--from=markdown`

## LXGW WenKai not applied

Checks:
- run `scripts/check-markdown-pdf-deps.sh`
- confirm the font is installed and visible to `fc-match`
- retry with `--font "LXGW WenKai"`

## XeLaTeX route fails

Checks:
- verify `xelatex` exists
- inspect template or package errors
- if the document is README-like, retry with `--mode web-clean`

## Tables or code blocks overflow

Mitigations:
- prefer readability over squeezing too much onto one line
- allow code wrapping
- consider using `web-clean` for layout-heavy technical docs
