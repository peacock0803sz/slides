<template>
  <div class="slidev-layout default">
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
