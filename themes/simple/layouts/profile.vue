<template>
  <div class="slidev-layout profile">
    <slot />
  </div>
</template>

<style>
.slidev-layout.profile {
  font-size: 24px;
}

.slidev-layout.profile h1 {
  font-size: 36px;
  font-weight: 700;
}

.slidev-layout.profile>img {
  width: 250px;
  height: 250px;
  float: right;
  border-radius: 10%;
  padding: 5px;
}
</style>
