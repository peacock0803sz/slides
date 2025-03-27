<template>
  <div class="slidev-layout override title text-ggen-white">
    <slot />
  </div>
</template>

<style lang="css">
.slidev-layout.title {
  background-image: url("../assets/title.svg");

  padding-top: 50px;
  padding-left: 100px;
  padding-right: 50px;
}

/* 
   Heading3 -> Event Title
   Heading4 -> DateTime & Place
   Heading1 -> Talk Title
   Heading2 -> Speaker Name & Affiliation
*/

.slidev-layout.title h3 {
  font-size: 16pt;
  font-weight: 600;
  line-height: 1.25;
  padding-bottom: 5px;
}

.slidev-layout.title h4 {
  font-size: 14pt;
  font-weight: 400;
  line-height: 1.25;
}

.slidev-layout.title h1 {
  @apply text-ggen-white;
  font-size: 36pt;
  font-weight: 600;
  line-height: 1.25;

  margin-top: 50px;
}

.slidev-layout.title h2 {
  @apply text-ggen-white;
  font-size: 20pt;
  font-weight: 600;

  position: absolute;
  bottom: 150px;
}
</style>
