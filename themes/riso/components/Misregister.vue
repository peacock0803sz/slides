<script setup lang="ts">
import type { ClicksInfo } from '@slidev/types'
import { useSlideContext } from '@slidev/client'
import { computed, onMounted, onUnmounted, shallowRef } from 'vue'

const props = withDefaults(defineProps<{
  at?: string | number
}>(), {
  at: '+1',
})

const { $clicksContext: clicks } = useSlideContext()
const id = Symbol('misregister')
const info = shallowRef<ClicksInfo | null>(null)

// v-click registers on mount, so registering here too keeps clicks in document order
onMounted(() => {
  info.value = clicks?.calculateSince(props.at) ?? null
  clicks?.register(id, info.value)
})
onUnmounted(() => clicks?.unregister(id))

const active = computed(() => !clicks || (info.value?.isActive.value ?? false))
// The shadow jumps only on its own click; later clicks show it settled
const kick = computed(() => info.value?.isCurrent.value ?? false)
</script>

<template>
  <span :class="{ 'riso-misregister-on': active, 'riso-misregister-kick': kick }">
    <slot />
  </span>
</template>
