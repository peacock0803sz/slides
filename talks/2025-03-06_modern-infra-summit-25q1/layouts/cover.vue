<template>
  <div class="slidev-layout cover">
    <div class="container">
      <slot />
    </div>
  </div>
</template>

<style lang="css">
.slidev-layout.cover {
  background-image: url("../assets/cover.svg");
}

.slidev-layout.cover>div.container {
  margin-top: 50px;
  margin-left: -20px;
}

.slidev-layout.cover h1 {
  font-size: 48px;
  font-weight: 600;
}

.slidev-layout.cover h2 {
  font-size: 30px;
  font-weight: 550;
}

.slidev-layout.cover h3 {
  font-size: 16px;
  position: absolute;
  bottom: 50px;
}
</style>
