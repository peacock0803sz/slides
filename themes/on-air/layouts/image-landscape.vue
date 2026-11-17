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
  <div class="slidev-layout image-landscape">
    <slot />
    <div class="oa-shot oa-landscape-image" :style="style">
      <span class="oa-chip oa-chip-pgm">PGM</span>
      <span class="oa-chip">CAM 1</span>
    </div>
    <PageNumber />
  </div>
</template>

<style>
.slidev-layout.image-landscape {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

/* Auto margins on the title and ::after center the text block beside the image */
.slidev-layout.image-landscape > :first-child {
  margin: 0 0 auto;
  padding-bottom: 12px;
}

.slidev-layout.image-landscape::after {
  content: "";
  margin: auto 0 -20px;
}

.slidev-layout.image-landscape > :not(:first-child, .oa-landscape-image, .oa-page-number) {
  max-width: 496px;
  margin: 0;
}

.slidev-layout.image-landscape .oa-landscape-image {
  position: absolute;
  top: 171.5px;
  right: 88px;
  width: 560px;
  height: 420px;
}
</style>
