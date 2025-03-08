<template>
  <div class="slidev-layout cover">
    <div class="container">
      <PoweredBySlidev class="text-[#222] text-lg absolute top-5" />
      <slot />
    </div>
  </div>
</template>

<style lang="css">
.slidev-layout.cover {
  background-image: linear-gradient(to right,
      rgba(255, 255, 255, 25%),
      rgba(255, 255, 255, 0%)),
    url("../assets/nix-wallpaper-nineish.png");
  background-size: cover;
}

.slidev-layout.cover>div.container {
  margin-top: 100px;
}

.slidev-layout.cover h1 {
  color: #333;
  font-size: 72px;
  font-weight: 600;
  line-height: 1;
}

.slidev-layout.cover h2 {
  color: #333;
  font-size: 60px;
  font-weight: 500;
}

.slidev-layout.cover h3 {
  color: #333;
  font-size: 36px;
  font-weight: 400;
  position: absolute;
  bottom: 100px;
}

.slidev-layout.cover h4 {
  color: #333;
  font-size: 30px;
  position: absolute;
  bottom: 75px;
}

.slidev-layout.cover h5 {
  color: #333;
  font-size: 20px;
  position: absolute;
  bottom: 25px;
}

.slidev-layout.cover code {
  font-size: inherit;
}
</style>
