<template>
  <div class="slidev-layout intro override">
    <slot />
  </div>
  <Footer />
</template>

<style>
.slidev-layout.intro {
  @apply text-ggen-gray1;
  padding-top: 50px;
  padding-left: 80px;
  padding-right: 80px;
}

.slidev-layout.intro h1 {
  font-size: 36pt;
  font-weight: 600;
  margin-bottom: 50px;
}

.slidev-layout.intro h2 {
  font-size: 36pt;
  font-weight: 500;
  margin-top: 50px;
}

.slidev-layout.intro h2>svg {
  width: 64px;
  height: 64px;
}

.slidev-layout.intro h3 {
  font-size: 28pt;
  margin-top: 10px;
  margin-bottom: 10px;
}
</style>
