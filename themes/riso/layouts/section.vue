<script setup lang="ts">
import { useSlideContext } from '@slidev/client'
import { computed } from 'vue'

// An explicit default stops Vue from casting a missing Boolean prop to false
const props = defineProps({
  number: { type: [String, Number, Boolean], default: undefined },
})

const { $page, $slidev } = useSlideContext()

function pad(value: number) {
  return String(value).padStart(2, '0')
}

// Count top-level <Toc> entries so the number matches the agenda (hideInToc slides are already excluded)
const label = computed(() => {
  if (props.number === false)
    return ''
  if (typeof props.number === 'number')
    return pad(props.number)
  if (props.number != null && props.number !== true)
    return props.number
  const index = $slidev.nav.tocTree.findIndex(item => item.no === $page.value)
  return index >= 0 ? pad(index + 1) : ''
})
</script>

<template>
  <div class="slidev-layout section">
    <div v-if="label" class="riso-section-number">
      {{ label }}
    </div>
    <slot />
    <span class="riso-ink riso-ink-blue" />
    <span class="riso-ink riso-ink-green" />
  </div>
</template>

<style>
.slidev-layout.section {
  display: flex;
  flex-direction: column;
  gap: 20px;
  justify-content: center;
  padding-bottom: 48px;
}

.slidev-layout.section > * {
  margin: 0;
}

.slidev-layout.section .riso-section-number {
  font-family: var(--riso-font-numeral);
  font-size: 72px;
  font-weight: 800;
  line-height: 1;
  color: var(--riso-green-text);
}

.slidev-layout.section h1 {
  font-size: 88px;
  line-height: 1.2;
}

.slidev-layout.section h2 {
  font-family: var(--riso-font-display);
  font-size: 40px;
  font-weight: 400;
  line-height: 1.3;
  color: var(--riso-ink-2);
}

.slidev-layout.section .riso-ink-blue {
  top: 360px;
  right: -140px;
  width: 520px;
  height: 520px;
}
</style>
