<template>
  <div class="slidev-layout section">
    <div class="my-auto w-full">
      <slot />
    </div>
  </div>
</template>

<style>
.slidev-layout.section {
  background-image: linear-gradient(to right,
      rgba(253, 246, 227, 50%),
      rgba(253, 246, 227, 0%)),
    url("../assets/nix-wallpaper-nineish-solarized-light.png");
  background-size: cover;

  display: flex;
  flex-direction: column;
  justify-content: center;
  color: #333;
}

.slidev-layout.section h1 {
  color: #333;
  font-weight: 700;
  line-height: 1.5;
  font-size: 60px;
  padding-bottom: 20px;
  background: linear-gradient(to right,
      rgba(253, 246, 227, 0%),
      rgba(253, 246, 227, 50%));
}

.slidev-layout.section h2 {
  color: #333;
  font-weight: 700;
  font-size: 36px;
}
</style>
