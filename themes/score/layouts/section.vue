<script setup lang="ts">
import { useSlideContext } from '@slidev/client'
import { computed } from 'vue'

// An explicit default stops Vue from casting a missing Boolean prop to false
const props = defineProps({
  number: { type: [String, Number, Boolean], default: undefined },
})

const { $page, $slidev } = useSlideContext()

const ROMAN: [number, string][] = [
  [1000, 'M'],
  [900, 'CM'],
  [500, 'D'],
  [400, 'CD'],
  [100, 'C'],
  [90, 'XC'],
  [50, 'L'],
  [40, 'XL'],
  [10, 'X'],
  [9, 'IX'],
  [5, 'V'],
  [4, 'IV'],
  [1, 'I'],
]

function toRoman(value: number) {
  let rest = value
  let result = ''
  for (const [unit, symbol] of ROMAN) {
    while (rest >= unit) {
      result += symbol
      rest -= unit
    }
  }
  return result
}

// Count top-level <Toc> entries so the numeral matches the agenda (hideInToc slides are already excluded)
const label = computed(() => {
  if (props.number === false)
    return ''
  if (props.number != null && props.number !== true)
    return String(props.number)
  const index = $slidev.nav.tocTree.findIndex(item => item.no === $page.value)
  return index >= 0 ? toRoman(index + 1) : ''
})
</script>

<template>
  <div class="slidev-layout section">
    <div v-if="label" class="score-section-number">
      {{ label }}.
    </div>
    <slot />
  </div>
</template>

<style>
.slidev-layout.section {
  display: flex;
  flex-direction: column;
  gap: 20px;
  align-items: center;
  justify-content: center;
  padding-bottom: 64px;
  text-align: center;
}

.slidev-layout.section > * {
  margin: 0;
}

.slidev-layout.section .score-section-number {
  font-family: var(--score-font-numeral);
  font-size: 72px;
  font-style: italic;
  line-height: 1;
  color: var(--score-blue);
}

.slidev-layout.section h1 {
  font-size: 88px;
  line-height: 1.2;
}

.slidev-layout.section h2 {
  font-family: var(--score-font-display);
  font-size: 40px;
  font-weight: 500;
  line-height: 1.3;
  color: var(--score-ink-2);
}
</style>
