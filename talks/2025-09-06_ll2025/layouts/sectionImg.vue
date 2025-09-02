<template>
  <div class="slidev-layout sectionImg">
    <slot />
  </div>
</template>

<style>
.slidev-layout.sectionImg {
  display: flex;
  flex-direction: column;
  justify-content: center;

  h1 {
    font-weight: 700;
    font-size: 60px;
  }

  h2 {
    font-weight: 400;
    font-size: 32px;
  }

  .box {
    display: grid;
    grid-template-columns: 250px 600px;
    column-gap: 25px;
  }

  .inner {
    display: flex;
    flex-direction: column;
    justify-content: center;
    grid-column: 2;
    grid-row: 1;
  }

  img {
    display: flex;
    flex-direction: column;
    justify-content: center;
    grid-column: 1;
    grid-row: 1;
    width: 250px;
  }

  img.rye {
    background-color: #333;
    padding: 10px;
    border-radius: 50%;
  }
}
</style>
