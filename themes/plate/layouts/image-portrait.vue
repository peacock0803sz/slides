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
    <div class="plate-portrait-image" :style="style" />
    <PageNumber />
  </div>
</template>

<style>
.slidev-layout.image-portrait {
  --plate-list-gap: 16px;

  padding-right: 568px;
}

.slidev-layout.image-portrait .plate-portrait-image {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  width: 512px;
}

.slidev-layout.image-portrait .plate-page-number {
  right: 568px;
}
</style>
