<template>
  <div class="slidev-layout summary">
    <slot />
  </div>
</template>

<style>
.slidev-layout.summary {
  padding-bottom: 64px;
}

.slidev-layout.summary > :is(ol, ul) {
  margin: 0;
  border-top: 1px solid var(--score-staff);
  counter-reset: score-summary;
}

.slidev-layout.summary > :is(ol, ul) > li {
  margin: 0;
  padding: 20px 0 20px 104px;
  border-bottom: 1px solid var(--score-staff);
  counter-increment: score-summary;
  font-family: var(--score-font-display);
  font-size: 36px;
  font-weight: 500;
  line-height: 1.3;
  color: var(--score-blue);
}

/* Items are marked like rehearsal letters in a score: a boxed A, B, C centered in a 72px gutter */
.slidev-layout.summary > :is(ol, ul) > li::before {
  content: counter(score-summary, upper-alpha);
  position: absolute;
  top: 50%;
  left: 36px;
  width: auto;
  height: auto;
  padding: 1px 11px;
  border: 2px solid var(--score-ink);
  border-radius: 0;
  background: none;
  font-family: var(--score-font-numeral);
  font-size: 30px;
  font-style: normal;
  font-weight: 700;
  line-height: 1.2;
  color: var(--score-ink);
  transform: translate(-50%, -50%);
}

.slidev-layout.summary > :is(ol, ul) > li > :is(ol, ul),
.slidev-layout.summary > :is(ol, ul) > li > p:not(:first-child) {
  margin: 6px 0 0;
  font-family: var(--score-font-body);
  font-size: 24px;
  font-weight: 400;
  line-height: 1.4;
  color: var(--score-ink-2);
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
