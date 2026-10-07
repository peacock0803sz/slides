# @peacock0803sz/theme-plate

A light [Slidev](https://sli.dev) theme modeled on scientific plates: white ground, Mincho headings, italic Bodoni numerals and a single teal accent.

Run `pnpm dev` in this directory to preview [`example.md`](./example.md).

## Usage

```md
---
theme: ../../themes/plate
htmlAttrs:
  lang: ja
---
```

The theme sets a 1280×720 canvas, turns off the copy button on code blocks (`codeCopy: true` brings it back) and loads its fonts from Google Fonts: Zen Old Mincho (headings), BIZ UDPGothic (body), Bodoni Moda (numerals), JetBrains Mono (code) and Public Sans (cover meta).

## Conventions

- The first heading of a slide is its title, whatever its level, so `##` sub-slides nest under `#` sections in `<Toc>` and still look like titles. Later `##` render as a lead and `###` as a subheading.
- A paragraph right after a blockquote or a table is styled as its source.
- ```` ```nix [devenv.nix] ```` shows the file name above the code block.

## Layouts

| Layout | Notes |
| --- | --- |
| `cover` | `#` title, `##` subtitle, `###` meta lines at the bottom (separate them with `<br>`). Put a figure in the `::figure::` slot or set `image`. `callout` adds a leader line and a label to the figure. |
| `toc` | Write `<Toc columns="2" maxDepth="2" />`. Top-level entries are numbered 01, 02, ... A hand-written list works too. |
| `profile` | `image` shows a square photo on the right. Write a tight list (no blank lines between items) of `- **Key** value`, each with an optional nested list for sub lines. The key column fits the longest key. |
| `section` | `#` title and optional `##` subtitle. The roman numeral follows the entry's position in `<Toc>`; override it with `number: IV` or hide it with `number: false`. |
| `two-cols` | The default slot is the header. Columns go in `::left::` and `::right::`, each starting with a heading. |
| `default` | Title and body with a page number. |
| `image-portrait` | `image` fills the right 512px. `backgroundSize` defaults to `cover`. |
| `image-landscape` | `image` is a 4:3 figure on the right; the text is centered beside it. |
| `table` | Same as `default`, intended for a full-width table. |
| `numbers` | After the title, repeat `## value`, `### unit` and a paragraph for each figure. Every trio becomes a column. |
| `summary` | An ordered or bulleted list numbered I, II, III. Nest a list under each item for the detail line. |
