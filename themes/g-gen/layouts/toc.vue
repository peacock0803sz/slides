<template>
  <div class="slidev-layout toc">
    <slot />
  </div>
  <Footer />
</template>

<style>
.slidev-layout.toc {
  display: grid;
  grid-column: 2;
  margin-top: 30px;
  margin-left: 50px;
  margin-right: 10px;
}

.slidev-layout.toc h1 {
  font-size: 22pt;
  font-weight: 600;
  grid-column-start: 1;
  padding-top: 5px;
  margin-left: -50px;
}

@counter-style toc-counter {
  system: extends decimal-leading-zero;
  suffix: " ";
}

.slidev-layout.toc ol {
  grid-column-start: 2;
  list-style-type: toc-counter;
}

.slidev-layout.toc>ol {
  margin-left: 100px;
}

.slidev-layout.toc>ol>li::marker {
  @apply text-ggen-sub;
  font-size: 20pt;
  font-weight: 600;
}

.slidev-layout.toc>ol>li {
  color: #595959;
  line-height: 1.5;
  font-size: 14pt;
  font-weight: 500;
}

.slidev-layout.toc>ol>li>ol {
  margin-left: 10px;
}

.slidev-layout.toc>ol>li>ol>li::marker {
  @apply text-ggen-sub;
  font-size: 16pt;
  font-weight: 600;
}

.slidev-layout.toc>ol>li>ol>li>* {
  color: #595959;
  margin-top: 2px;
  font-size: 10pt;
  font-weight: 500;
}
</style>
