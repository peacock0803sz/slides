<script setup lang="ts">
import PageNumber from '../components/PageNumber.vue'
</script>

<!-- Not `table`: UnoCSS turns that class into `display: table` -->
<template>
  <div class="slidev-layout score-table">
    <slot />
    <PageNumber />
  </div>
</template>

<style>
/* A full table needs the extra height, so the title and page number move 8px toward the frame */
.slidev-layout.score-table {
  padding-top: 64px;
  padding-bottom: 106px;
}

.slidev-layout.score-table .score-page-number {
  bottom: 56px;
}
</style>
