<template>
  <div class="slidev-layout profile">
    <slot />
  </div>
  <Footer />
</template>

<style>
.slidev-layout.profile>img {
  width: 210px;
  height: 210px;
  float: right;
  border-radius: 10%;
  padding: 5px;
}
</style>
