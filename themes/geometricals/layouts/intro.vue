<template>
  <div class="slidev-layout intro">
    <slot />
  </div>
</template>

<style>
.slidev-layout.intro h1 {
  font-size: 48px;
}

.slidev-layout.intro p {
  line-height: 1.5;
}

.slidev-layout.intro.head {
  margin-top: 10px;
  font-size: 30px;
}

.slidev-layout.intro.box {
  margin-top: 25px;
  display: grid;
  grid-template-columns: 600px 300px;
  column-gap: 25px;
}

.slidev-layout.intro.inner {
  grid-column: 1;
  font-size: 30px;
}

.slidev-layout.intro img {
  grid-column: 2;
  width: 200px;
}
</style>
