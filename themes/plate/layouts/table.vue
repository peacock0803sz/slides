<script setup lang="ts">
import PageNumber from '../components/PageNumber.vue'
</script>

<!-- Not `table`: UnoCSS turns that class into `display: table` -->
<template>
  <div class="slidev-layout plate-table">
    <slot />
    <PageNumber />
  </div>
</template>
