<template>
  <div class="slidev-layout section">
    <slot />
  </div>
</template>

<style lang="css">
.slidev-layout.section {
  background-image: url("../assets/section.svg");

  padding-top: 60px;
  padding-left: 70px;
  padding-right: 50px;
}

.slidev-layout.section h1 {
  @apply text-ggen-white;
  font-size: 36px;
  font-weight: 500;
  line-height: 1.5;
  padding-top: 120px;
}

.slidev-layout.section h3 {
  @apply text-ggen-white;
  position: absolute;
  top: 120px;
  margin-left: -5px;
  font-size: 48px;
  font-weight: 600;
}

.slidev-layout.section h2 {
  @apply text-ggen-white;
  font-size: 24px;
  font-weight: 400;
  line-height: 1.2;
  position: absolute;
  bottom: 120px;
}
</style>
