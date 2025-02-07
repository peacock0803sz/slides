<template>
  <div class="slidev-layout statement">
    <slot />
  </div>
</template>

<style>
.slidev-layout.statement {
  background-image: url("../assets/section.svg");

  padding-top: 60px;
  padding-left: 70px;
  padding-right: 50px;
}

.slidev-layout.statement h1 {
  font-size: 36px;
  font-weight: 600;
  line-height: 1.2;
}

.slidev-layout.statement h2 {
  font-size: 28px;
}

.slidev-layout.statement p {
  line-height: 1.3;
}
</style>
