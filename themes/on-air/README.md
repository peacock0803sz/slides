# @peacock0803sz/theme-on-air

A light [Slidev](https://sli.dev) theme modeled on a live broadcast: safe-area marks on a pale gray monitor, black Noto Sans JP titles beside a red tally bar, lower thirds, and camera shots framed in program red.

Run `pnpm dev` in this directory to preview [`example.md`](./example.md).

## Usage

```md
---
theme: ../../themes/on-air
htmlAttrs:
  lang: ja
---
```

The theme sets a 1280×720 canvas, turns off the copy button on code blocks (`codeCopy: true` brings it back) and loads its fonts from Google Fonts: Noto Sans JP (headings), BIZ UDPGothic (body), Barlow Condensed (numerals and the cover name), Chivo (cover meta), Geist Mono (timecode, page numbers and chips) and JetBrains Mono (code).

## Conventions

- The first heading of a slide is its title, whatever its level, so `##` sub-slides nest under `#` sections in `<Toc>` and still look like titles. Later `##` render as a lead and `###` as a subheading.
- A paragraph right after a blockquote or a table is styled as its source.
- ```` ```nix [devenv.nix] ```` shows the file name above the code block.

## Motion

- Slides cut from one to the next like a vision mixer, because the theme sets no transition. Set `transition` in the frontmatter to pick one.
- The lower thirds of `cover` and `profile` wipe out of their tally in 200ms every time their slide comes up, and `v-click` targets wipe in from their left edge the same way. A target given its own animation (`v-click.up`, `clickAnimation`) keeps Slidev's.
- The REC lamp on the cover blinks once a second. `<Rec>text</Rec>` puts an unlit lamp before the text and takes one click, which lights the lamp and starts the same blinking. `at` works as in `v-click`.
- With `prefers-reduced-motion: reduce`, nothing wipes or blinks, and a slide that asks for a sliding transition fades instead.

## Layouts

| Layout | Notes |
| --- | --- |
| `cover` | `#` title, `##` subtitle and `###` as the lower third: its first line is set large as the name and the lines after it (separate them with `<br>`) as meta. A figure in the `::figure::` slot sits right of the title at 72px. `image` shows a photo in a red program frame on the right. `callout` is ignored. |
| `toc` | Write `<Toc columns="2" maxDepth="2" />`. Top-level entries are numbered 01, 02, ... A hand-written list works too. |
| `profile` | `image` shows a square photo with rounded corners on the right. Write a tight list (no blank lines between items) of `- **Key** value`, each with an optional nested list for sub lines. The key column fits the longest key. The title becomes a lower third at the bottom. |
| `section` | `#` title and optional `##` subtitle. The number follows the entry's position in `<Toc>` (04 for the fourth); override it with `number: 4` or any text, or hide it with `number: false`. |
| `two-cols` | The default slot is the header. Columns go in `::left::` and `::right::`, each starting with a heading. |
| `default` | Title and body with a page number. |
| `image-portrait` | `image` fills the right 512px in a red program frame with `PGM` and `CAM 1` chips. `backgroundSize` defaults to `cover`. |
| `image-landscape` | `image` is a 4:3 figure on the right, framed like `image-portrait`; the text is centered beside it. |
| `table` | Same as `default`, intended for a full-width table. |
| `numbers` | After the title, repeat `## value`, `### unit` and a paragraph for each figure. Every trio becomes a column under a red rule. |
| `summary` | An ordered or bulleted list numbered 01, 02, 03 beside tally bars in program red, standby amber and preview green. Nest a list under each item for the detail line. |
