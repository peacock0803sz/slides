<script setup lang="ts">
import { useSlideContext } from '@slidev/client'

const { $page, $nav } = useSlideContext()
</script>

<template>
  <div class="score-page-number">
    {{ $page }} / {{ $nav.total }}
  </div>
</template>
