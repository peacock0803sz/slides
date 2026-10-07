<script setup lang="ts">
import { handleBackground } from '@slidev/client'
import { computed } from 'vue'
import PageNumber from '../components/PageNumber.vue'

const props = withDefaults(defineProps<{
  image?: string
  backgroundSize?: string
}>(), {
  backgroundSize: 'cover',
})

const style = computed(() => handleBackground(props.image, false, props.backgroundSize))
</script>

<template>
  <div class="slidev-layout image-portrait">
    <slot />
    <div class="score-portrait-image" :style="style" />
    <PageNumber />
  </div>
</template>

<style>
.slidev-layout.image-portrait {
  --score-list-gap: 16px;

  padding-right: 536px;
}

/* The picture sits inside the double rule, 8px from the gold line */
.slidev-layout.image-portrait .score-portrait-image {
  position: absolute;
  top: 48px;
  right: 48px;
  bottom: 48px;
  width: 440px;
}

.slidev-layout.image-portrait .score-page-number {
  right: 536px;
}
</style>
