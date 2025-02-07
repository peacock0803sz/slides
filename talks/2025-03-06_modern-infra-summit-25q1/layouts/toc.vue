<template>
  <div class="slidev-layout toc">
    <div class="flex flex-row">
      <slot />
    </div>
  </div>
</template>

<style lang="css">
.slidev-layout.toc {
  background-image: url("../assets/toc.svg");
}

.slidev-layout.toc h1 {
  font-size: 30px;
  flex-basis: 420px;
}

@counter-style toc-counter {
  system: extends decimal-leading-zero;
  suffix: "";
}

.slidev-layout.toc ol {
  flex-basis: 540px;
  list-style-type: toc-counter;
  margin-top: 40px;
}

.slidev-layout.toc ol>li::before,
.slidev-layout.toc ol>li::after {
  content: "";
  position: absolute;
  left: -20px;
  right: -10px;
  border-top: 1px solid #bdc1c6;
}

.slidev-layout.toc ol>li::before {
  top: 0;
}

.slidev-layout.toc ol>li::after {
  bottom: 0;
}

.slidev-layout.toc ol>li+li::before {
  display: none;
}

.slidev-layout.toc ol>li::marker {
  color: #4285f4;
  font-size: 14px;
  font-weight: 600;
}

.slidev-layout.toc ol>li {
  color: #595959;
  font-size: 12px;
  font-weight: 600;
  line-height: 2;
  position: relative;
  padding-left: 50px;
  padding-bottom: 2px;
}
</style>
