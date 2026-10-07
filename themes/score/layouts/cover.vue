<script setup lang="ts">
import { resolveAssetUrl } from '@slidev/client'
import { computed } from 'vue'

const props = defineProps<{
  image?: string
}>()

const imageUrl = computed(() => props.image && resolveAssetUrl(props.image))
</script>

<template>
  <div class="slidev-layout cover">
    <slot />
    <div v-if="$slots.figure || imageUrl" class="score-cover-figure">
      <slot name="figure">
        <img :src="imageUrl" alt="">
      </slot>
    </div>
  </div>
</template>

<style>
/*
 * A wrapping flex row: the figure shares the title's line and every other block takes a full line.
 * `order` puts the figure after the title and the gold rule (::after) between subtitle and meta.
 */
.slidev-layout.cover {
  display: flex;
  flex-wrap: wrap;
  gap: 32px 24px;
  align-content: center;
  align-items: center;
  justify-content: center;
  padding: 80px 120px;
  text-align: center;
}

.slidev-layout.cover > * {
  flex-basis: 100%;
  order: 5;
  margin: 0;
}

.slidev-layout.cover > h1 {
  flex-basis: auto;
  order: 1;
  font-size: 112px;
  line-height: 1.1;
}

.slidev-layout.cover .score-cover-figure {
  flex-basis: auto;
  order: 2;
  width: 80px;
  height: 80px;
  color: var(--score-blue);
}

.slidev-layout.cover .score-cover-figure :is(p, svg, img) {
  display: block;
  width: 100%;
  height: 100%;
  margin: 0;
  object-fit: contain;
}

.slidev-layout.cover > h2 {
  order: 3;
  font-family: var(--score-font-display);
  font-size: 40px;
  font-weight: 500;
  line-height: 1.4;
  color: var(--score-ink);
}

.slidev-layout.cover::after {
  content: "";
  order: 4;
  width: 72px;
  height: 1px;
  background: var(--score-gold);
}

.slidev-layout.cover > :is(h3, p) {
  font-family: var(--score-font-numeral);
  font-size: 26px;
  font-style: italic;
  font-weight: 400;
  line-height: calc(1.3em + 4px);
  color: var(--score-ink-2);
}
</style>
