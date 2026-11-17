<template>
  <div class="slidev-layout toc">
    <slot />
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
  counter-reset: oa-toc;
}

.slidev-layout.toc .slidev-toc-list-level-1 > li,
.slidev-layout.toc > :is(ol, ul) > li {
  margin: 0 0 28px;
  padding-left: 50px;
  break-inside: avoid;
  counter-increment: oa-toc;
  font-family: var(--oa-font-display);
  font-size: 32px;
  font-weight: 700;
  line-height: 1.3;
  color: var(--oa-text);
}

.slidev-layout.toc .slidev-toc-list-level-1 > li::before,
.slidev-layout.toc > :is(ol, ul) > li::before {
  content: counter(oa-toc, decimal-leading-zero);
  position: absolute;
  top: 0;
  left: 0;
  width: auto;
  height: auto;
  border-radius: 0;
  background: none;
  font-family: var(--oa-font-numeral);
  font-weight: 700;
  color: var(--oa-pgm);
}

.slidev-layout.toc .slidev-toc-list-level-1 li :is(ol, ul),
.slidev-layout.toc > :is(ol, ul) li :is(ol, ul) {
  margin: 4px 0 0;
}

.slidev-layout.toc .slidev-toc-list-level-1 li li,
.slidev-layout.toc > :is(ol, ul) li li {
  margin: 4px 0 0;
  padding-left: 0;
  font-family: var(--oa-font-body);
  font-size: 24px;
  font-weight: 400;
  line-height: 1.3;
  color: var(--oa-text-2);
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
