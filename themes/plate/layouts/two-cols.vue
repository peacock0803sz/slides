<script setup lang="ts">
import PageNumber from '../components/PageNumber.vue'
</script>

<template>
  <div class="slidev-layout two-cols">
    <slot />
    <div class="plate-columns">
      <div class="plate-column plate-column-left">
        <slot name="left" />
      </div>
      <div class="plate-column plate-column-right">
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

.slidev-layout.two-cols .plate-columns {
  display: grid;
  flex: 1;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  column-gap: 56px;
  min-height: 0;
}

.slidev-layout.two-cols .plate-column > :is(h1, h2, h3, h4):first-child {
  margin: 0 0 20px;
  padding-bottom: 10px;
  border-bottom: 3px solid currentColor;
  font-family: var(--plate-font-display);
  font-size: 32px;
  font-weight: 700;
  line-height: 1.2;
}

.slidev-layout.two-cols .plate-column-left > :is(h1, h2, h3, h4):first-child {
  color: var(--plate-accent);
}

.slidev-layout.two-cols .plate-column-right > :is(h1, h2, h3, h4):first-child {
  color: var(--plate-ink-2);
}
</style>
