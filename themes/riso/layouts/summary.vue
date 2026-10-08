<template>
  <div class="slidev-layout summary">
    <slot />
    <span class="riso-ink riso-ink-green" />
  </div>
</template>

<style>
.slidev-layout.summary {
  padding-bottom: 48px;
}

.slidev-layout.summary > :is(ol, ul) {
  margin: 0;
  border-top: 1px solid var(--riso-ink);
  counter-reset: riso-summary;
}

.slidev-layout.summary > :is(ol, ul) > li {
  margin: 0;
  padding: 20px 0 20px 104px;
  border-bottom: 1px solid var(--riso-ink);
  counter-increment: riso-summary;
  font-family: var(--riso-font-display);
  font-size: 36px;
  font-weight: 400;
  line-height: 1.3;
}

/* Each number sits on a 64px block of ink centered in a 72px gutter, the inks taking turns: green, blue, yellow */
.slidev-layout.summary > :is(ol, ul) > li::before {
  content: counter(riso-summary, decimal-leading-zero);
  display: flex;
  align-items: center;
  justify-content: center;
  position: absolute;
  top: 50%;
  left: 4px;
  width: 64px;
  height: 64px;
  background: var(--riso-green);
  font-family: var(--riso-font-numeral);
  font-size: 28px;
  font-weight: 800;
  line-height: 1;
  color: var(--riso-ink);
  transform: translateY(-50%);
}

.slidev-layout.summary > :is(ol, ul) > li:nth-child(3n + 2)::before {
  background: var(--riso-blue);
  color: var(--riso-paper);
}

.slidev-layout.summary > :is(ol, ul) > li:nth-child(3n)::before {
  background: var(--riso-yellow);
}

.slidev-layout.summary > :is(ol, ul) > li > :is(ol, ul),
.slidev-layout.summary > :is(ol, ul) > li > p:not(:first-child) {
  margin: 6px 0 0;
  font-family: var(--riso-font-body);
  font-size: 24px;
  font-weight: 400;
  line-height: 1.4;
  color: var(--riso-ink-2);
}

.slidev-layout.summary > :is(ol, ul) > li li {
  margin: 0;
  padding-left: 0;
  font-size: inherit;
  color: inherit;
}

.slidev-layout.summary > :is(ol, ul) > li li::before {
  content: none;
}
</style>
