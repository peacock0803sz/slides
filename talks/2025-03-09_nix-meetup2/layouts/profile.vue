<template>
  <div class="slidev-layout profile">
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
.slidev-layout.profile {
  font-size: 24px;
}

.slidev-layout.profile h1 {
  font-size: 36px;
  font-weight: 700;
}

.slidev-layout.profile img {
  position: absolute;
  right: 50px;
  top: 50px;
  width: 200px;
  height: 200px;
  float: right;
  border-radius: 10%;
}
</style>
