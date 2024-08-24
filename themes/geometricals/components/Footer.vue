<template>
  <footer>
    <div class="powerd-by">
      <PoweredBySlidev />
    </div>
    <div class="progress">
      <SlideCurrentNo /> /
      <SlidesTotal />
    </div>
  </footer>
</template>

<style lang="css">
footer>div.powerd-by {
  position: absolute;
  text-align: left;
  bottom: 10px;
  left: 100px;
  font-size: 24px;
}

footer>div.progress {
  position: absolute;
  text-align: right;
  bottom: 10px;
  right: 60px;
  font-size: 22px;
}
</style>
