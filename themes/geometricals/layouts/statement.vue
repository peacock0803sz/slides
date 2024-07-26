<template>
  <div class="slidev-layout statement">
    <slot />
  </div>
</template>

<style>
.slidev-layout.statement {
  background-image: linear-gradient(
      to bottom,
      rgba(255, 255, 255, 25%),
      rgba(255, 255, 255, 25%)
    ),
    url("../assets/section.svg");

  padding-top: 100px;
  padding-bottom: 50px;
  padding-left: 100px;
  padding-right: 80px;
}

.slidev-layout.statement h1 {
  font-size: 48px;
  font-weight: 600;
  line-height: 1.3;
}

.slidev-layout.statement h2 {
  font-size: 36px;
}

.slidev-layout.statement p {
  line-height: 1.3;
}
</style>
