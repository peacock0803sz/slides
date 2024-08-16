<template>
  <div class="slidev-layout default">
    <div class="my-auto w-full">
      <slot />
    </div>
    <footer>
      <div class="text-right absolute bottom-5 right-5 z-10">
        <SlideCurrentNo /> /
        <SlidesTotal />
      </div>
    </footer>
  </div>
</template>

<style>
.slidev-layout.default {
  font-size: 24px;
}

.slidev-layout.default p {
  line-height: 1.5;
}

.slidev-layout.default h1 {
  margin-bottom: 1.5rem;
  font-size: 36px;
  font-weight: 700;
}

.slidev-layout.default h2 {
  margin-top: 1rem;
  margin-bottom: 1.5rem;
  font-size: 36px;
  font-weight: 600;
}

.slidev-layout.default h3 {
  margin-top: 1rem;
  margin-bottom: 1.5rem;
  font-size: 36px;
  font-weight: 700;
}

.slidev-layout.default blockquote {
  margin-top: 1rem;
  margin-bottom: 1rem;
  font-size: 20px;
  line-height: 1.5;
}

.slidev-layout.default pre {
  background: #f9f9f9;
}

.slidev-layout.default pre>code {
  font-size: 18px;
  line-height: 1.5;
  background: #f9f9f9;
}

.slidev-layout.default footer {
  font-size: 16px;
}
</style>
