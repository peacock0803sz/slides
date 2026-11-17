<script setup lang="ts">
import PageNumber from '../components/PageNumber.vue'
</script>

<template>
  <div class="slidev-layout default">
    <slot />
    <PageNumber />
  </div>
</template>
