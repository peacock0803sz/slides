<template>
  <div class="slidev-layout section">
    <slot />
  </div>
</template>

<style lang="css">
.slidev-layout.section {
  background-image: url("../assets/section.svg");

  padding-top: 80px;
  padding-left: 100px;
  padding-right: 50px;
}

.slidev-layout.section h1 {
  @apply text-ggen-white;
  font-size: 36pt;
  font-weight: 600;
  line-height: 1.5;
  padding-top: 130px;
}

.slidev-layout.section h3 {
  @apply text-ggen-white;
  position: absolute;
  top: 120px;
  margin-left: -5px;
  font-size: 48pt;
  font-weight: 600;
}

.slidev-layout.section h2 {
  @apply text-ggen-white;
  font-size: 24pt;
  font-weight: 400;
  line-height: 1.2;
  position: absolute;
  bottom: 180px;
}
</style>
