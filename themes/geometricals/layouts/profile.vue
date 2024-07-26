<template>
  <div class="slidev-layout profile">
    <slot />
  </div>
</template>

<style>
.slidev-layout.profile.box {
  display: grid;
  grid-template-columns: 600px 180px;
  column-gap: 25px;
}

.slidev-layout.profile.inner {
  grid-column: 1;
}

.slidev-layout.profile img {
  margin-top: 10px;
  grid-column: 2;
  border-radius: 15%;
}
</style>
