<script setup lang="ts"></script>

<template>
  <div class="slidev-layout cover">
    <div class="my-auto w-full relative">
      <slot />
    </div>
  </div>
</template>

<style>
.slidev-layout.cover h1 {
  font-family: var(--font-title-family);
  font-size: 60px;
  font-weight: 600;
  line-height: 1.3;
}

.slidev-layout.cover h2 {
  font-family: var(--font-title-family);
  font-size: 36px;
  font-weight: 400;
  line-height: 1.1;

  margin-top: 10px;
}

.slidev-layout.cover h3 {
  font-family: var(--font-main-family);
  font-size: 24px;
  font-weight: 400;
  line-height: 1.3;

  padding-right: 50px;
  margin-top: 120px;
}
</style>
