<script setup lang="ts">
import { resolveAssetUrl } from '@slidev/client'
import { computed } from 'vue'

const props = defineProps<{
  image?: string
  callout?: string
}>()

const imageUrl = computed(() => props.image && resolveAssetUrl(props.image))
</script>

<template>
  <div class="slidev-layout cover">
    <div class="plate-cover-text">
      <slot />
    </div>
    <figure v-if="$slots.figure || imageUrl" class="plate-specimen">
      <div class="plate-specimen-figure">
        <slot name="figure">
          <img :src="imageUrl" alt="">
        </slot>
      </div>
      <template v-if="callout">
        <span class="plate-specimen-dot" />
        <span class="plate-specimen-leader" />
        <span class="plate-specimen-callout">{{ callout }}</span>
      </template>
    </figure>
  </div>
</template>

<style>
.slidev-layout.cover {
  display: flex;
  gap: 40px;
  align-items: center;
  padding: 72px 72px 72px 88px;
}

.slidev-layout.cover .plate-cover-text {
  display: flex;
  flex: 1;
  flex-direction: column;
  align-self: stretch;
  min-width: 0;
}

/* Long subtitle lines may run into the gap; the specimen keeps its own margin */
.slidev-layout.cover .plate-cover-text:has(+ .plate-specimen) {
  margin-right: -40px;
}

.slidev-layout.cover h1 {
  margin: 0;
  font-family: var(--plate-font-display);
  font-size: 112px;
  font-weight: 700;
  line-height: 1.1;
}

.slidev-layout.cover h2 {
  margin: 24px 0 0;
  font-family: var(--plate-font-display);
  font-size: 40px;
  font-weight: 500;
  line-height: 1.4;
  color: var(--plate-ink-2);
}

.slidev-layout.cover .plate-cover-text > :is(h3, p) {
  margin: 0;
  font-family: var(--plate-font-latin);
  font-size: 24px;
  font-weight: 400;
  line-height: calc(1.3em + 4px);
  color: var(--plate-ink-2);
}

.slidev-layout.cover .plate-cover-text > :is(h1, h2) + :not(h1, h2) {
  margin-top: auto;
}

.slidev-layout.cover .plate-specimen {
  position: relative;
  flex: none;
  width: 340px;
  height: 420px;
  margin: 0;
}

.slidev-layout.cover .plate-specimen-figure {
  position: absolute;
  top: 70px;
  left: 0;
  width: 280px;
  height: 280px;
  color: var(--plate-accent);
}

.slidev-layout.cover .plate-specimen-figure :is(p, svg, img) {
  display: block;
  width: 100%;
  height: 100%;
  margin: 0;
  object-fit: contain;
}

.slidev-layout.cover .plate-specimen-dot {
  position: absolute;
  top: 205px;
  left: 135px;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background: var(--plate-ink);
}

.slidev-layout.cover .plate-specimen-leader {
  position: absolute;
  top: 209.5px;
  left: 140px;
  width: 150px;
  height: 1px;
  background: var(--plate-ink);
}

.slidev-layout.cover .plate-specimen-callout {
  position: absolute;
  top: 184px;
  left: 300px;
  font-family: var(--plate-font-numeral);
  font-size: 40px;
  font-style: italic;
  line-height: normal;
  white-space: nowrap;
}
</style>
