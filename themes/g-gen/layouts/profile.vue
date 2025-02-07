<template>
  <HeaderRectangle />
  <div class="slidev-layout profile text-ggen-black">
    <slot name="text" />
    <slot name="image-alt" />
  </div>
  <Footer />
</template>

<style lang="postcss">
.slidev-layout.profile>img {
  position: absolute;
  top: 70px;
  right: 50px;
  width: 150px;
  height: 150px;
  float: right;
  border-radius: 15%;
}
</style>
