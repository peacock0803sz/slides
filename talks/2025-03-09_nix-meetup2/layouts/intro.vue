<template>
  <div class="slidev-layout intro">
    <slot />
  </div>
</template>

<style>
.slidev-layout.intro {
  background-image: linear-gradient(to right,
      rgba(255, 255, 255, 25%),
      rgba(255, 255, 255, 25%)),
    url("../assets/nix-wallpaper-nineish-catppuccin-latte-alt.png");
  background-size: cover;
  color: #222;
}

.slidev-layout.intro h1 {
  font-size: 48px;
  font-weight: 600;
  margin-bottom: 50px;
}

.slidev-layout.intro h2 {
  font-size: 48px;
  font-weight: 500;
  margin-top: 50px;
}

.slidev-layout.intro h3 {
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
