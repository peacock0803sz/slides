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
  border-top: 1px solid var(--plate-line);
  counter-reset: plate-summary;
}

.slidev-layout.summary > :is(ol, ul) > li {
  margin: 0;
  padding: 20px 0 20px 104px;
  border-bottom: 1px solid var(--plate-line);
  counter-increment: plate-summary;
  font-family: var(--plate-font-display);
  font-size: 36px;
  font-weight: 700;
  line-height: 1.3;
}

.slidev-layout.summary > :is(ol, ul) > li::before {
  content: counter(plate-summary, upper-roman) ".";
  position: absolute;
  top: 50%;
  left: 0;
  width: 72px;
  height: auto;
  border-radius: 0;
  background: none;
  font-family: var(--plate-font-numeral);
  font-size: 40px;
  font-style: italic;
  font-weight: 500;
  line-height: 1;
  color: var(--plate-accent);
  text-align: center;
  transform: translateY(-50%);
}

.slidev-layout.summary > :is(ol, ul) > li > :is(ol, ul),
.slidev-layout.summary > :is(ol, ul) > li > p:not(:first-child) {
  margin: 6px 0 0;
  font-family: var(--plate-font-body);
  font-size: 24px;
  font-weight: 400;
  line-height: 1.4;
  color: var(--plate-ink-2);
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
