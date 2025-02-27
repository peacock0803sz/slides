<template>
  <div class="slidev-layout blog">
    <slot />
  </div>
</template>

<style lang="postcss">
.slidev-layout.blog {
  background-image: url("../assets/default.svg");

  padding-top: 30px;
  padding-left: 50px;
  padding-right: 30px;
}

.slidev-layout.blog h1>a {
  font-weight: 500;
}

.slidev-layout.blog img {
  width: 120px;
  height: 120px;
  float: right;
}

.slidev-layout.blog li {
  font-size: 18px;

  margin-left: -10px;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.slidev-layout.blog li>img {
  height: 90px;
  width: 90px;

  object-fit: cover;
  margin-right: 10px;
  border-radius: 5%;
}
</style>
