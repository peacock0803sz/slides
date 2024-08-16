<template>
  <div class="slidev-layout cover">
    <div class="my-auto w-full">
      <slot />
    </div>
  </div>
</template>

<style>
.slidev-layout.cover {
  :root {
    @apply relative;
  }

  h1,
  h2 {
    line-height: 1.2;
    font-weight: 700;
  }

  h1 {
    font-size: 5rem;
  }

  h2 {
    font-size: 3rem;
  }

  h3 {
    @apply absolute bottom-10;
  }
}
</style>
