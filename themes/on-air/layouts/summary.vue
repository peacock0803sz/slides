<template>
  <div class="slidev-layout summary">
    <slot />
  </div>
</template>

<style>
.slidev-layout.summary {
  padding-bottom: 48px;
}

.slidev-layout.summary > :is(ol, ul) {
  margin: 0;
  border-top: 1px solid var(--oa-line);
  counter-reset: oa-summary;
}

.slidev-layout.summary > :is(ol, ul) > li {
  margin: 0;
  padding: 20px 0 20px 104px;
  border-bottom: 1px solid var(--oa-line);
  counter-increment: oa-summary;
  font-family: var(--oa-font-display);
  font-size: 36px;
  font-weight: 700;
  line-height: 1.3;
}

/*
 * Each number sits beside a 64px tally bar in a 72px gutter. The bars take the mixer's tally colors
 * in turn: program red, standby amber and preview green.
 */
.slidev-layout.summary > :is(ol, ul) > li::before {
  content: counter(oa-summary, decimal-leading-zero);
  display: flex;
  align-items: center;
  position: absolute;
  top: 50%;
  left: 0;
  width: auto;
  height: 64px;
  padding-left: 16px;
  border-left: 8px solid var(--oa-pgm);
  border-radius: 0;
  background: none;
  font-family: var(--oa-font-readout);
  font-size: 24px;
  font-weight: 400;
  line-height: 1;
  color: var(--oa-text-2);
  transform: translateY(-50%);
}

.slidev-layout.summary > :is(ol, ul) > li:nth-child(3n + 2)::before {
  border-left-color: var(--oa-standby);
}

.slidev-layout.summary > :is(ol, ul) > li:nth-child(3n)::before {
  border-left-color: var(--oa-pvw);
}

.slidev-layout.summary > :is(ol, ul) > li > :is(ol, ul),
.slidev-layout.summary > :is(ol, ul) > li > p:not(:first-child) {
  margin: 6px 0 0;
  font-family: var(--oa-font-body);
  font-size: 24px;
  font-weight: 400;
  line-height: 1.4;
  color: var(--oa-text-2);
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
