<template>
  <div class="slidev-layout section-blue">
    <slot />
  </div>
</template>

<style lang="css">
.slidev-layout.section-blue {
  background-image: url("../assets/section-blue.svg");

  padding-top: 120px;
  padding-left: 70px;
  padding-right: 50px;
}

.slidev-layout.section-blue h1 {
  color: #4285f4;
  font-size: 48px;
  font-weight: 600;
}

.slidev-layout.section-blue h2 {
  font-size: 28px;
  font-weight: 600;
}
</style>
