<script setup lang="ts">
import type { ClicksInfo } from '@slidev/types'
import { useSlideContext } from '@slidev/client'
import { computed, onMounted, onUnmounted, shallowRef } from 'vue'

const props = withDefaults(defineProps<{
  at?: string | number
}>(), {
  at: '+1',
})

const OPACITY_STEPS = 2

const { $clicksContext: clicks } = useSlideContext()
const id = Symbol('crescendo')
const info = shallowRef<ClicksInfo | null>(null)

// v-click registers on mount, so registering here too keeps clicks in document order
onMounted(() => {
  info.value = clicks?.calculateSince(props.at, OPACITY_STEPS) ?? null
  clicks?.register(id, info.value)
})
onUnmounted(() => clicks?.unregister(id))

// 0 → 0.4, 1 → 0.7, 2 → full; print mode jumps past every click and gets full
const step = computed(() => {
  if (!clicks)
    return OPACITY_STEPS
  if (!info.value)
    return 0
  return Math.min(OPACITY_STEPS, Math.max(0, info.value.currentOffset.value + 1))
})
</script>

<template>
  <span class="score-crescendo" :data-step="step">
    <slot />
  </span>
</template>
