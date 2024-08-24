<template>
  <div class="slidev-layout section">
    <slot />
  </div>
</template>

<style lang="css">
.slidev-layout.section {
  background-image: linear-gradient(to bottom,
      rgba(255, 255, 255, 10%),
      rgba(255, 255, 255, 10%)),
    url("../assets/section.svg");

  padding-top: 200px;
  padding-left: 120px;
  padding-right: 100px;
}

.slidev-layout.section h1 {
  font-size: 48px;
  font-family: var(--font-title-family);
  font-weight: 600;
}

.slidev-layout.section h2 {
  font-size: 30px;
  font-family: var(--font-title-family);
  font-weight: 400;
  line-height: 1.2;
}
</style>
