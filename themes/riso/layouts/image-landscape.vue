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
    <div class="riso-landscape-image" :style="style" />
    <PageNumber />
    <span class="riso-ink riso-ink-green" />
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

.slidev-layout.image-landscape > :not(:first-child, .riso-landscape-image, .riso-page-number, .riso-ink) {
  max-width: 496px;
  margin: 0;
}

.slidev-layout.image-landscape .riso-landscape-image {
  position: absolute;
  top: 171.5px;
  right: 88px;
  width: 560px;
  height: 420px;
}

.slidev-layout.image-landscape .riso-ink-green {
  top: auto;
  right: auto;
  bottom: -140px;
  left: -130px;
}
</style>
