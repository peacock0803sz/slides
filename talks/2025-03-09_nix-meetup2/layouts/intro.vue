<template>
  <div class="slidev-layout intro">
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
.slidev-layout.intro {
  background-image: linear-gradient(to right,
      rgba(255, 255, 255, 25%),
      rgba(255, 255, 255, 25%)),
    url("../assets/nix-wallpaper-nineish-catppuccin-latte-alt.png");
  background-size: cover;
  color: #333;
}

.slidev-layout.intro h1 {
  color: #333;
  font-size: 48px;
  font-weight: 600;
  margin-bottom: 50px;
}

.slidev-layout.intro h2 {
  color: #333;
  font-size: 48px;
  font-weight: 500;
  margin-top: 50px;
}

.slidev-layout.intro h2>svg {
  width: 48px;
  height: 48px;
}

.slidev-layout.intro h3 {
  color: #333;
  font-size: 36px;
  margin-top: 10px;
  margin-bottom: 10px;
}

.slidev-layout.intro img {
  position: absolute;
  right: 50px;
  top: 200px;
  float: right;
  width: 250px;
  height: 250px;
}
</style>
