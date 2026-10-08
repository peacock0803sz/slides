<script setup lang="ts">
import { useSlideContext } from '@slidev/client'

const { $page, $nav } = useSlideContext()
</script>

<template>
  <div class="riso-page-number">
    {{ $page }} / {{ $nav.total }}
  </div>
</template>
