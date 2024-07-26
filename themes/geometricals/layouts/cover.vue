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
  font-family: var(--font-main);
}

.slidev-layout.cover h1,
h2,
h3,
h4,
h5,
h6 {
  padding-top: 20px;
  padding-bottom: 20px;
  padding-left: 70px;
  padding-right: 100px;
}

.slidev-layout.cover h1 {
  font-family: var(--font-title);
  font-size: 48px;
  font-weight: 600;
  line-height: 1.3;
}

.slidev-layout.cover h2 {
  font-size: 24px;
  font-weight: 400;
  line-height: 1.3;
  padding-right: 250px;
  position: absolute;
  bottom: -300px;
}
</style>
