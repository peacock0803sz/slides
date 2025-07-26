<template>
  <div class="slidev-layout statement">
    <slot />
  </div>
</template>

<style>
.slidev-layout.statement {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding-top: 50px;
  padding-bottom: 50px;

  h1 {
    font-size: 48px;
    font-weight: 500;
    line-height: 1;
    font-weight: 500;
  }

  h1 > strong {
    font-size: 96px;
    font-weight: 700;
  }

  h2 {
    font-size: 36px;
  }
}
</style>
