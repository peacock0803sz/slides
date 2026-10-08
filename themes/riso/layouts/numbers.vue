<script setup lang="ts">
import PageNumber from '../components/PageNumber.vue'
</script>

<template>
  <div class="slidev-layout numbers">
    <slot />
    <PageNumber />
    <span class="riso-ink riso-ink-green" />
  </div>
</template>

<style>
/*
 * Each `## value` / `### unit` / paragraph trio fills one column: the rows are fixed per element
 * and column flow opens a new column whenever the next item goes back to an earlier row.
 */
.slidev-layout.numbers {
  display: grid;
  grid-template-rows: repeat(3, auto);
  grid-auto-columns: minmax(0, 1fr);
  grid-auto-flow: column;
  align-content: start;
  column-gap: 56px;
  padding-top: 213px;
}

/* Fewer than three paragraphs means two figures, which the design spaces wider */
.slidev-layout.numbers:not(:has(> p:nth-of-type(3))) {
  column-gap: 72px;
}

.slidev-layout.numbers > :is(h1, h2, h3, h4):first-child {
  position: absolute;
  top: 56px;
  right: 88px;
  left: 88px;
  margin: 0;
}

.slidev-layout.numbers > h2:not(:first-child) {
  grid-row: 1;
  margin: 0 0 16px;
  padding-top: 16px;
  border-top: 4px solid var(--riso-green);
  font-family: var(--riso-font-display);
  font-size: 80px;
  font-weight: 400;
  line-height: 1.1;
  text-shadow: var(--riso-text-shadow);
}

.slidev-layout.numbers > h3:not(:first-child) {
  grid-row: 2;
  margin: 0 0 4px;
  font-size: 24px;
  font-weight: 700;
  line-height: 1.5;
  color: var(--riso-green-text);
}

.slidev-layout.numbers > p {
  grid-row: 3;
  margin: 0;
  line-height: 1.4;
}

/* Rules and units take the inks in turn: green, blue, yellow */
.slidev-layout.numbers > :nth-child(3n + 2 of h2:not(:first-child)) {
  border-top-color: var(--riso-blue);
}

.slidev-layout.numbers > :nth-child(3n of h2:not(:first-child)) {
  border-top-color: var(--riso-yellow-deep);
}

.slidev-layout.numbers > :nth-child(3n + 2 of h3:not(:first-child)) {
  color: var(--riso-blue);
}

.slidev-layout.numbers > :nth-child(3n of h3:not(:first-child)) {
  color: var(--riso-yellow-deep);
}
</style>
