# @peacock0803sz/theme-riso

A light [Slidev](https://sli.dev) theme modeled on a risograph zine: Dela Gothic One headings with a misregistered green shadow, green, blue and yellow ink circles that multiply where they overlap, and square green markers.

Run `pnpm dev` in this directory to preview [`example.md`](./example.md).

## Usage

```md
---
theme: ../../themes/riso
htmlAttrs:
  lang: ja
---
```

The theme sets a 1280×720 canvas, turns off the copy button on code blocks (`codeCopy: true` brings it back) and loads its fonts from Google Fonts: Dela Gothic One (headings), BIZ UDPGothic (body), Bricolage Grotesque (numerals), Zen Kaku Gothic New (cover subtitle), Space Mono (cover meta) and JetBrains Mono (code).

## Conventions

- The first heading of a slide is its title, whatever its level, so `##` sub-slides nest under `#` sections in `<Toc>` and still look like titles. Later `##` render as a lead and `###` as a subheading.
- A paragraph right after a blockquote or a table is styled as its source.
- ```` ```nix [devenv.nix] ```` shows the file name above the code block.

## Motion

- Slides change with the theme's `riso-register` transition: the page fades in over 300ms while the ink circles and title shadows slide 6px back into register. Set `transition` in the frontmatter to pick another one; Slidev's built-in transitions also run for 300ms.
- `v-click` targets print in two passes: their ink (markers, tints, shadows) fades in over 200ms and their text follows 100ms later.
- `<Misregister>text</Misregister>` takes one click and gives the text the green title shadow, which jumps 8px off register and settles back in 240ms. `at` works as in `v-click`.
- With `prefers-reduced-motion: reduce`, every slide change is a plain fade and the shadow appears without the jump.

## Layouts

| Layout | Notes |
| --- | --- |
| `cover` | `#` title, `##` subtitle, `###` meta lines at the bottom (separate them with `<br>`). A figure in the `::figure::` slot or `image` sits right of the title at 88px. `callout` is ignored. |
| `toc` | Write `<Toc columns="2" maxDepth="2" />`. Top-level entries are numbered 01, 02, ... A hand-written list works too. |
| `profile` | `image` shows a square photo on the right. Write a tight list (no blank lines between items) of `- **Key** value`, each with an optional nested list for sub lines. The key column fits the longest key. |
| `section` | `#` title and optional `##` subtitle. The number follows the entry's position in `<Toc>` (04 for the fourth); override it with `number: 4` or any text, or hide it with `number: false`. |
| `two-cols` | The default slot is the header. Columns go in `::left::` and `::right::`, each starting with a heading. |
| `default` | Title and body with a page number. |
| `image-portrait` | `image` fills the right 512px. `backgroundSize` defaults to `cover`. |
| `image-landscape` | `image` is a 4:3 figure on the right; the text is centered beside it. |
| `table` | Same as `default`, intended for a full-width table. |
| `numbers` | After the title, repeat `## value`, `### unit` and a paragraph for each figure. Every trio becomes a column, with its rule and unit in green, blue and yellow in turn. |
| `summary` | An ordered or bulleted list numbered 01, 02, 03 on green, blue and yellow blocks. Nest a list under each item for the detail line. |
