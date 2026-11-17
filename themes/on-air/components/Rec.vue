<script setup lang="ts">
import type { ClicksInfo } from '@slidev/types'
import { useNav, useSlideContext } from '@slidev/client'
import { computed, onMounted, onUnmounted, shallowRef } from 'vue'

const props = withDefaults(defineProps<{
  at?: string | number
}>(), {
  at: '+1',
})

const { $clicksContext: clicks } = useSlideContext()
const { isPrintMode } = useNav()
const id = Symbol('rec')
const info = shallowRef<ClicksInfo | null>(null)

// v-click registers on mount, so registering here too keeps clicks in document order
onMounted(() => {
  info.value = clicks?.calculateSince(props.at) ?? null
  clicks?.register(id, info.value)
})
onUnmounted(() => clicks?.unregister(id))

const active = computed(() => !clicks || (info.value?.isActive.value ?? false))
</script>

<template>
  <span class="oa-rec" :class="{ 'oa-rec-on': active, 'oa-still': isPrintMode }"><span class="oa-rec-lamp" aria-hidden="true" /><slot /></span>
</template>
