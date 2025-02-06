<template>
  <div class="slidev-layout refs">
    <slot />
  </div>
</template>

<style lang="postcss">
.slidev-layout.refs {
  background-image: url("../assets/default.svg");

  padding-top: 40px;
  padding-left: 50px;
  padding-right: 50px;
}

.slidev-layout.refs :not(h1, h2) {
  font-size: 12px;
}
</style>
