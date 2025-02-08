<template>
  <div class="slidev-layout intro">
    <slot />
  </div>
</template>

<style>
.slidev-layout.intro h1 {
  font-size: 48px;
  font-weight: 600;
  margin-bottom: 50px;
}

.slidev-layout.intro h2 {
  font-size: 48px;
  font-weight: 500;
  margin-top: 50px;
}

.slidev-layout.intro h3 {
  font-size: 32px;
  margin-top: 10px;
  margin-bottom: 10px;
}

.slidev-layout.intro p {
  font-size: 24px;
  margin-top: 10px;
  font-size: 42px;
}

.slidev-layout.intro img {
  position: absolute;
  right: 50px;
  top: 200px;
  float: right;
  width: 250px;
  height: 250px;
  border-radius: 10%;
}
</style>
