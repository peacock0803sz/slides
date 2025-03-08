<template>
  <div class="slidev-layout toc">
    <div class="my-auto w-full">
      <slot />
    </div>
    <footer>
      <div class="text-right absolute bottom-5 right-5 z-10">
        <SlideCurrentNo /> /
        <SlidesTotal />
      </div>
    </footer>
  </div>
</template>

<style>
.slidev-layout.toc {
  font-size: 24px;
}

.slidev-layout.toc h1 {
  font-size: 36px;
  font-weight: 700;
}
</style>
