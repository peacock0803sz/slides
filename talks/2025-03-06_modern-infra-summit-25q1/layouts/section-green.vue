<template>
  <div class="slidev-layout section-green">
    <slot />
  </div>
</template>

<style lang="css">
.slidev-layout.section-green {
  background-image: url("../assets/section-green.svg");

  padding-top: 120px;
  padding-left: 70px;
  padding-right: 50px;
}

.slidev-layout.section-green h1 {
  color: #4285f4;
  font-size: 48px;
  font-weight: 600;
}

.slidev-layout.section-green h2 {
  font-size: 28px;
  font-weight: 600;
}
</style>
