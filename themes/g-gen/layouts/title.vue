<template>
  <div class="slidev-layout title text-ggen-white">
    <slot />
  </div>
</template>

<style lang="css">
.slidev-layout.title {
  background-image: url("../assets/title.svg");

  padding-top: 30px;
  padding-left: 70px;
  padding-right: 50px;
}

/* 
   Heading3 -> Event Title
   Heading4 -> DateTime & Place
   Heading1 -> Talk Title
   Heading2 -> Speaker Name & Affiliation
*/

.slidev-layout.title h3 {
  font-size: 14px;
  font-weight: 400;
  line-height: 1.25;
}

.slidev-layout.title h4 {
  font-size: 12px;
  font-weight: 400;
  line-height: 1.25;
}

.slidev-layout.title h1 {
  @apply text-ggen-white;
  font-size: 36px;
  font-weight: 600;
  line-height: 1.2;

  margin-top: 50px;
}

.slidev-layout.title h2 {
  @apply text-ggen-white;
  font-size: 20px;
  font-weight: 500;

  position: absolute;
  bottom: 100px;
}
</style>
