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

.slidev-layout.profile>div.box {
  display: grid;
  grid-template-columns: 650px 230px;
  column-gap: 10px;
}

.slidev-layout.profile>div.box>img {
  margin-top: 10px;
  grid-column: 2;
  border-radius: 15%;
}
</style>
