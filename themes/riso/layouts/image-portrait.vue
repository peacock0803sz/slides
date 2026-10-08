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
    <div class="riso-portrait-image" :style="style" />
    <PageNumber />
    <span class="riso-ink riso-ink-green" />
  </div>
</template>

<style>
.slidev-layout.image-portrait {
  --riso-list-gap: 16px;

  padding-right: 568px;
}

.slidev-layout.image-portrait .riso-portrait-image {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  width: 512px;
}

.slidev-layout.image-portrait .riso-page-number {
  right: 568px;
}

.slidev-layout.image-portrait .riso-ink-green {
  top: auto;
  right: auto;
  bottom: -140px;
  left: -130px;
}
</style>
