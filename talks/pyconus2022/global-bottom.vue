<template>
  <footer
    v-if="
      $slidev.nav.currentLayout !== 'cover' &&
      $slidev.nav.currentLayout !== 'intro' &&
      $slidev.nav.currentLayout !== 'fact'
    "
    class="
      absolute
      bottom-1
      text-right
      left-0
      right-0
      p-5
      text-2xl
      font-bold
      text-gray-750
    "
  >
    {{ $slidev.nav.currentPage }} / {{ $slidev.nav.total }}
  </footer>
</template>