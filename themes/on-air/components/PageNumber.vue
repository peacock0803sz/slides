<script setup lang="ts">
import { useSlideContext } from '@slidev/client'

const { $page, $nav } = useSlideContext()
</script>

<template>
  <div class="oa-page-number">
    {{ $page }} / {{ $nav.total }}
  </div>
</template>
