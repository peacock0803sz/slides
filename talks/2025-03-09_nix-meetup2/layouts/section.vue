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
      rgba(239, 239, 239, 75%),
      rgba(239, 239, 239, 75%)),
    url("../assets/nix-wallpaper-nineish-solarized-light.png");
  background-size: cover;

  display: flex;
  flex-direction: column;
  justify-content: center;
  color: #111;
}

.slidev-layout.section h1 {
  font-weight: 700;
  line-height: 1.5;
  font-size: 60px;
  padding-bottom: 20px;
}

.slidev-layout.section h2 {
  font-weight: 700;
  font-size: 36px;
}
</style>
