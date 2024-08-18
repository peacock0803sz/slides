<template>
  <div class="slidev-layout intro">
    <slot />
  </div>
</template>

<style>
.slidev-layout.intro h1 {
  font-size: 48px;
  margin-bottom: 20px;
}

.slidev-layout.intro>div.head {
  margin-top: 10px;
  font-size: 28px;
}

.slidev-layout.intro>div.url {
  font-size: 30px;
}

.slidev-layout.intro>div.box {
  margin-top: 50px;
  font-size: 42px;

  * {
    line-height: 1.7;
  }
}

.slidev-layout.intro img {
  float: right;
  width: 250px;
  height: 250px;
}
</style>
