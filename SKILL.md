---
name: markdown-pdf
description: Convert Markdown documents into polished PDFs optimized for printing and sharing. Use when asked to turn .md files into PDF, export Markdown as a printable document, preserve Markdown formatting (headings, bold, lists, tables, code blocks), or generate Chinese-friendly PDFs with academic-style formal layout. Prefer this skill for long-form articles, reports, proposals, technical notes, README exports, and other Markdown documents that need stable A4 output, LXGW WenKai body text, and fallback routing between formal print layout and web-clean rendering.
---

# Markdown PDF

Convert Markdown into finished PDFs rather than raw text printouts. Preserve Markdown semantics, aim for A4 print-friendly output, and default to a formal academic-inspired layout for Chinese documents.

## Quick workflow

1. Confirm the input is Markdown and decide the target output path.
2. Choose a mode:
   - `print-formal`: default; use for articles, reports, proposals, docs meant for printing.
   - `web-clean`: use when the Markdown is README-like, style-heavy, or more web-shaped than document-shaped.
3. Run `scripts/render-markdown-pdf.sh` with the input file and optional flags.
4. If dependencies or fonts are missing, run `scripts/check-markdown-pdf-deps.sh` and fix the reported issue.
5. Verify the output exists and spot-check headings, bold text, lists, code blocks, tables, page size, and fonts.

## Default output contract

Treat these as the default expectations unless the user asks otherwise:

- Paper size: A4
- Primary mode: `print-formal`
- Chinese body font: `LXGW WenKai`
- Body size: `30pt` target in the template, then verify against actual PDF output and tune by measured results rather than trusting template numbers.
- Page numbers: enabled
- Margins: print-friendly
- Markdown syntax must render into real formatting; do not leave `#`, `**`, or backticks visible unless the source intentionally shows literal Markdown.

## Mode selection

### `print-formal`

Use for most document-style Markdown.

Characteristics:
- academic-inspired formal layout
- comfortable for A4 printing
- restrained heading hierarchy
- suitable for Chinese long-form reading
- page numbers and optional table of contents

Route here first unless the document is clearly README/web-oriented.

### `web-clean`

Use when the source behaves more like a webpage than a paper document.

Good fits:
- GitHub README exports
- Markdown with lots of badges/images/HTML fragments
- style-heavy technical docs
- cases where preserving web-like visual rhythm matters more than formal print styling

## Scripts

### `scripts/render-markdown-pdf.sh`

Primary entry point.

Expected usage pattern:

```bash
scripts/render-markdown-pdf.sh input.md -o output.pdf --mode print-formal --toc
```

Supported options in v1:
- positional input Markdown file
- `-o, --output`
- `--mode print-formal|web-clean`
- `--toc`
- `--font`
- `--font-size`
- `--dry-run`

### `scripts/check-markdown-pdf-deps.sh`

Check for required tools and font availability before blaming the document.

Run this when:
- pandoc is missing
- xelatex is missing
- the preferred font cannot be found
- PDF generation fails before content rendering starts

## Resources

### Assets

- `assets/defaults.yaml`: Pandoc defaults for the formal route.
- `assets/print-formal.tex`: XeLaTeX template for the default print layout.
- `assets/web-clean.css`: CSS placeholder for the fallback web-oriented route.

### References

- `references/modes.md`: mode guidance and selection heuristics.
- `references/troubleshooting.md`: common failure patterns and fallback guidance.

Read only the reference file you need.

## Verification checklist

Before handing results back, verify as many of these as possible:

- PDF file was created at the expected path.
- Headings render as headings.
- Bold/italic/list syntax renders correctly.
- Chinese text uses the intended body font or a clear fallback.
- Code blocks and tables are readable.
- Page size and margins look suitable for printing.
- No obvious raw Markdown markers appear in the main body.

## Failure handling

If `print-formal` fails:
1. run the dependency checker
2. identify whether the failure is toolchain, font, or content related
3. retry with adjusted font or settings if the fix is obvious
4. if the document is more README/web-like, switch to `web-clean`
5. explain the fallback plainly
