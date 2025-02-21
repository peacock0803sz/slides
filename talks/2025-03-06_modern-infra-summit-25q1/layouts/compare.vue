<template>
  <div class="slidev-layout compare">
    <slot />
    <div class="grid grid-cols-2 justify-between">
      <div class="mr-5">
        <slot name="left" />
      </div>
      <div class="ml-5">
        <slot name="right" />
      </div>
    </div>
  </div>
</template>

<style lang="postcss">
.slidev-layout.compare {
  background-image: url("../assets/default.svg");

  padding-top: 20px;
  padding-left: 50px;
  padding-right: 50px;
}

.slidev-layout.compare h1 {
  margin-bottom: 0px;
}

.slidev-layout.compare h2 {
  margin-top: 5px;
}

.slidev-layout.compare li {
  line-height: 1.5;
}
</style>
