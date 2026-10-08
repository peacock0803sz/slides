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
    <div v-if="$slots.figure || imageUrl" class="riso-cover-figure">
      <slot name="figure">
        <img :src="imageUrl" alt="">
      </slot>
    </div>
    <span class="riso-ink riso-ink-blue" />
    <span class="riso-ink riso-ink-green" />
    <span class="riso-ink riso-ink-yellow" />
  </div>
</template>

<style>
/*
 * The figure shares the title's row and every other block spans the full width. An empty
 * pseudo-element holds rows 2 and 3, so the meta lines always flow in below the flexible third row.
 */
.slidev-layout.cover {
  display: grid;
  grid-template-rows: auto auto 1fr;
  grid-template-columns: auto 1fr;
  column-gap: 24px;
  padding: 64px 88px;
}

.slidev-layout.cover::before {
  content: "";
  grid-area: 2 / 1 / 4 / -1;
}

.slidev-layout.cover > :where(:not(.riso-ink)) {
  grid-column: 1 / -1;
  margin: 0;
}

.slidev-layout.cover > h1 {
  grid-area: 1 / 1;
  font-size: 120px;
  line-height: 1.1;
}

.slidev-layout.cover .riso-cover-figure {
  grid-area: 1 / 2;
  align-self: center;
  width: 88px;
  height: 88px;
  color: var(--riso-blue);
}

.slidev-layout.cover .riso-cover-figure :is(p, svg, img) {
  display: block;
  width: 100%;
  height: 100%;
  margin: 0;
  object-fit: contain;
}

.slidev-layout.cover > h2 {
  grid-row: 2;
  margin-top: 24px;
  font-family: var(--riso-font-subtitle);
  font-size: 40px;
  font-weight: 700;
  line-height: 1.4;
}

.slidev-layout.cover > :is(h3, p) {
  font-family: var(--riso-font-meta);
  font-size: 24px;
  font-weight: 400;
  line-height: calc(1.3em + 4px);
}

.slidev-layout.cover .riso-ink-blue {
  top: 100px;
  right: -97px;
  width: 480px;
  height: 480px;
}

.slidev-layout.cover .riso-ink-green {
  top: auto;
  right: -53px;
  bottom: -53px;
  width: 400px;
  height: 400px;
}

.slidev-layout.cover .riso-ink-yellow {
  right: 373px;
  bottom: 13px;
  width: 200px;
  height: 200px;
}
</style>
