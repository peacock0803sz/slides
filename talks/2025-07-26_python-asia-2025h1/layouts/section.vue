<template>
  <div class="slidev-layout section">
    <div class="my-auto w-full">
      <slot />
    </div>
  </div>
</template>

<style>
.slidev-layout.section {
  display: flex;
  flex-direction: column;
  justify-content: center;

  h1 {
    font-weight: 700;
    line-height: 1.5;
    font-size: 60px;
    padding-bottom: 20px;
  }
  h2 {
    font-weight: 700;
    font-size: 36px;
  }
}
</style>
