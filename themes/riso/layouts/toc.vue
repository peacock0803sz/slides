<template>
  <div class="slidev-layout toc">
    <slot />
    <span class="riso-ink riso-ink-green" />
  </div>
</template>

<style>
.slidev-layout.toc {
  padding-bottom: 48px;
}

.slidev-layout.toc .slidev-toc {
  column-gap: 64px;
}

.slidev-layout.toc .slidev-toc-list-level-1,
.slidev-layout.toc > :is(ol, ul) {
  margin: 0;
  counter-reset: riso-toc;
}

.slidev-layout.toc .slidev-toc-list-level-1 > li,
.slidev-layout.toc > :is(ol, ul) > li {
  margin: 0 0 28px;
  padding-left: 60px;
  break-inside: avoid;
  counter-increment: riso-toc;
  font-family: var(--riso-font-display);
  font-size: 32px;
  font-weight: 400;
  line-height: 1.3;
  color: var(--riso-ink);
}

.slidev-layout.toc .slidev-toc-list-level-1 > li::before,
.slidev-layout.toc > :is(ol, ul) > li::before {
  content: counter(riso-toc, decimal-leading-zero);
  position: absolute;
  top: 0;
  left: 0;
  width: auto;
  height: auto;
  background: none;
  font-family: var(--riso-font-numeral);
  font-weight: 800;
  color: var(--riso-green-text);
}

.slidev-layout.toc .slidev-toc-list-level-1 li :is(ol, ul),
.slidev-layout.toc > :is(ol, ul) li :is(ol, ul) {
  margin: 4px 0 0;
}

.slidev-layout.toc .slidev-toc-list-level-1 li li,
.slidev-layout.toc > :is(ol, ul) li li {
  margin: 4px 0 0;
  padding-left: 0;
  font-family: var(--riso-font-body);
  font-size: 24px;
  font-weight: 400;
  line-height: 1.3;
  color: var(--riso-ink-2);
}

.slidev-layout.toc .slidev-toc-list-level-1 li li::before,
.slidev-layout.toc > :is(ol, ul) li li::before {
  content: none;
}

.slidev-layout.toc .slidev-toc a {
  color: inherit;
  text-decoration: none;
}

.slidev-layout.toc .slidev-toc p {
  line-height: inherit;
}
</style>
