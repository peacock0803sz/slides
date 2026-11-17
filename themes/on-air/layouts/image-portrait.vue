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
    <div class="oa-shot oa-portrait-image" :style="style">
      <span class="oa-chip oa-chip-pgm">PGM</span>
      <span class="oa-chip">CAM 1</span>
    </div>
    <PageNumber />
  </div>
</template>

<style>
.slidev-layout.image-portrait {
  --oa-list-gap: 16px;

  padding-right: 568px;
}

.slidev-layout.image-portrait .oa-portrait-image {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  width: 512px;
}

.slidev-layout.image-portrait .oa-page-number {
  right: 568px;
}
</style>
