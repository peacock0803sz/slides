# @peacock0803sz/theme-score

A light [Slidev](https://sli.dev) theme modeled on an engraved music score: a blue and gold double rule around every slide, blue Mincho headings, italic Newsreader numerals and boxed rehearsal letters.

Run `pnpm dev` in this directory to preview [`example.md`](./example.md).

## Usage

```md
---
theme: ../../themes/score
htmlAttrs:
  lang: ja
---
```

The theme sets a 1280×720 canvas, turns off the copy button on code blocks (`codeCopy: true` brings it back) and loads its fonts from Google Fonts: Shippori Mincho (headings), BIZ UDPGothic (body), Newsreader (numerals and cover meta) and JetBrains Mono (code).

## Conventions

- The first heading of a slide is its title, whatever its level, so `##` sub-slides nest under `#` sections in `<Toc>` and still look like titles. Later `##` render as a lead and `###` as a subheading.
- A paragraph right after a blockquote or a table is styled as its source.
- ```` ```nix [devenv.nix] ```` shows the file name above the code block.

## Motion

- Slides change with a 600ms fade by default. Set `transition` in the frontmatter to pick another one.
- `v-click` targets fade in while settling 24px from the right in 400ms. When one click reveals a whole list, its items follow at 120ms intervals.
- `<Crescendo>text</Crescendo>` takes two clicks and steps the text from 40% to 70% to full opacity. `at` works as in `v-click`.
- With `prefers-reduced-motion: reduce`, clicks reveal without movement and every slide change is a plain fade.

## Layouts

| Layout | Notes |
| --- | --- |
| `cover` | Centered `#` title, `##` subtitle and `###` meta lines (separate them with `<br>`), with a gold rule between subtitle and meta. A figure in the `::figure::` slot or `image` sits right of the title at 80px. `callout` is ignored. |
| `toc` | Write `<Toc columns="2" maxDepth="2" />`. Top-level entries are numbered 01, 02, ... A hand-written list works too. |
| `profile` | `image` shows a square photo on the right. Write a tight list (no blank lines between items) of `- **Key** value`, each with an optional nested list for sub lines. The key column fits the longest key. |
| `section` | Centered `#` title and optional `##` subtitle. The roman numeral follows the entry's position in `<Toc>`; override it with `number: IV` or hide it with `number: false`. |
| `two-cols` | The default slot is the header. Columns go in `::left::` and `::right::`, each starting with a heading. |
| `default` | Title and body with a page number. |
| `image-portrait` | `image` fills a 440px panel inside the right edge of the frame. `backgroundSize` defaults to `cover`. |
| `image-landscape` | `image` is a 4:3 figure on the right; the text is centered beside it. |
| `table` | Like `default` with 8px more room above and below, intended for a full-width table. |
| `numbers` | After the title, repeat `## value`, `### unit` and a paragraph for each figure. Every trio becomes a column. |
| `summary` | An ordered or bulleted list marked with boxed letters A, B, C. Nest a list under each item for the detail line. |
