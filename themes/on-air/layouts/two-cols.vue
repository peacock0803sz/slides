<script setup lang="ts">
import PageNumber from '../components/PageNumber.vue'
</script>

<template>
  <div class="slidev-layout two-cols">
    <slot />
    <div class="oa-columns">
      <div class="oa-column oa-column-left">
        <slot name="left" />
      </div>
      <div class="oa-column oa-column-right">
        <slot name="right" />
      </div>
    </div>
    <PageNumber />
  </div>
</template>

<style>
.slidev-layout.two-cols {
  display: flex;
  flex-direction: column;
}

.slidev-layout.two-cols .oa-columns {
  display: grid;
  flex: 1;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  column-gap: 56px;
  min-height: 0;
}

/* Each column opens with a label over a 3px rule: red for the left one, gray for the right one */
.slidev-layout.two-cols .oa-column > :is(h1, h2, h3, h4):first-child {
  margin: 0 0 20px;
  padding: 0 0 7px;
  border-bottom: 3px solid;
  font-family: var(--oa-font-display);
  font-size: 32px;
  font-weight: 700;
  line-height: 1.2;
}

.slidev-layout.two-cols .oa-column > :is(h1, h2, h3, h4):first-child::before {
  content: none;
}

.slidev-layout.two-cols .oa-column-left > :is(h1, h2, h3, h4):first-child {
  color: var(--oa-pgm);
}

.slidev-layout.two-cols .oa-column-right > :is(h1, h2, h3, h4):first-child {
  color: var(--oa-text-2);
}
</style>
