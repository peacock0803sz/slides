<script setup lang="ts"></script>

<template>
  <div class="slidev-layout cover">
    <div class="my-auto w-full relative">
      <slot />
    </div>
  </div>
</template>

<style>
.slidev-layout.cover {
  background-image: url("../assets/cover.svg");
  font-family: var(--font-main-family);
}

.slidev-layout.cover div {
  padding-left: 15px;
  padding-right: 100px;

  position: relative;
}

.slidev-layout.cover h1 {
  font-family: var(--font-title-family);
  font-size: 56px;
  font-weight: 600;
  line-height: 1.3;

  position: absolute;
  top: 0px;
}

.slidev-layout.cover h2 {
  font-family: var(--font-title-family);
  font-size: 36px;
  font-weight: 400;
  line-height: 1.1;

  position: absolute;
  top: 200px;
}

.slidev-layout.cover h3 {
  font-family: var(--font-main-family);
  font-size: 24px;
  font-weight: 400;
  line-height: 1.3;
  padding-right: 50px;

  position: absolute;
  bottom: -420px;
}
</style>
