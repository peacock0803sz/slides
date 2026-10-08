<script setup lang="ts">
import PageNumber from '../components/PageNumber.vue'
</script>

<template>
  <div class="slidev-layout two-cols">
    <slot />
    <div class="riso-columns">
      <div class="riso-column riso-column-left">
        <slot name="left" />
      </div>
      <div class="riso-column riso-column-right">
        <slot name="right" />
      </div>
    </div>
    <PageNumber />
    <span class="riso-ink riso-ink-green" />
  </div>
</template>

<style>
.slidev-layout.two-cols {
  display: flex;
  flex-direction: column;
}

.slidev-layout.two-cols .riso-columns {
  display: grid;
  flex: 1;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  column-gap: 56px;
  min-height: 0;
}

.slidev-layout.two-cols .riso-column > :is(h1, h2, h3, h4):first-child {
  margin: 0 0 20px;
  padding-bottom: 10px;
  border-bottom: 3px solid;
  font-family: var(--riso-font-display);
  font-size: 32px;
  font-weight: 400;
  line-height: 1.2;
  text-shadow: none;
}

.slidev-layout.two-cols .riso-column-left > :is(h1, h2, h3, h4):first-child {
  border-color: var(--riso-green);
  color: var(--riso-green-text);
}

.slidev-layout.two-cols .riso-column-right > :is(h1, h2, h3, h4):first-child {
  border-color: var(--riso-ink-2);
  color: var(--riso-ink-2);
}
</style>
