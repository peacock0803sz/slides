<template>
  <footer v-if="$slidev.nav.currentLayout === 'default' ||
    $slidev.nav.currentLayout === 'profile' ||
    $slidev.nav.currentLayout === 'section'
    " class="text-right absolute absolute top-5 right-5">
    <div>{{ $slidev.nav.currentPage }} / {{ $slidev.nav.total }}</div>
  </footer>
</template>
