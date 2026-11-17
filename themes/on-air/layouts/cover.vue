<script setup lang="ts">
import { handleBackground, useIsSlideActive, useNav } from '@slidev/client'
import { computed, nextTick, onMounted, onUnmounted, onUpdated, useTemplateRef, watch } from 'vue'

const props = defineProps<{
  image?: string
}>()

const { isPrintMode } = useNav()
const isActive = useIsSlideActive()
const root = useTemplateRef<HTMLElement>('root')
const style = computed(() => props.image ? handleBackground(props.image) : undefined)

/*
 * Chrome sizes a shrink-to-fit box as if every line had the ::first-line style, which would stretch
 * the lower third to fit its meta at the name's size. Fit the box to the rendered lines instead.
 */
function fitLowerThird() {
  const box = root.value?.querySelector<HTMLElement>(':scope > h3')
  if (!box)
    return
  box.style.width = ''
  const rect = box.getBoundingClientRect()
  const range = document.createRange()
  range.selectNodeContents(box)
  const lines = Array.from(range.getClientRects())
  // A hidden slide has no layout to measure; the watcher below fits it once it is shown
  if (!rect.width || !lines.length)
    return
  const right = Math.max(...lines.map(line => line.right))
  const scale = rect.width / box.offsetWidth
  const { paddingRight, borderRightWidth } = getComputedStyle(box)
  box.style.width = `${Math.ceil((right - rect.left) / scale + Number.parseFloat(paddingRight) + Number.parseFloat(borderRightWidth))}px`
}

onMounted(() => {
  fitLowerThird()
  document.fonts.addEventListener('loadingdone', fitLowerThird)
})
onUnmounted(() => document.fonts.removeEventListener('loadingdone', fitLowerThird))
onUpdated(fitLowerThird)
watch(isActive, active => active && nextTick(fitLowerThird))
</script>

<template>
  <div ref="root" class="slidev-layout cover" :class="{ 'oa-with-monitor': image, 'oa-still': isPrintMode }">
    <div class="oa-cover-rec oa-rec-on">
      <span class="oa-rec-lamp" />REC 00:00:00:00
    </div>
    <slot />
    <div v-if="$slots.figure" class="oa-cover-figure">
      <slot name="figure" />
    </div>
    <div v-if="image" class="oa-shot oa-cover-monitor" :style="style" />
  </div>
</template>

<style>
/*
 * The title, its figure and the subtitle sit between two flexible rows, which center them on the
 * monitor on the right. An empty pseudo-element holds rows 2 to 5, so the lower third and anything
 * after it always flow in below them.
 */
.slidev-layout.cover {
  display: grid;
  grid-template-rows: auto 1fr auto auto 1fr;
  grid-template-columns: auto 1fr;
  column-gap: 24px;
  padding: 56px 72px 64px;
}

/* The monitor is 500px wide, 40px from the title block */
.slidev-layout.cover.oa-with-monitor {
  grid-template-columns: auto 1fr 516px;
}

.slidev-layout.cover::before {
  content: "";
  grid-area: 2 / 1 / 6 / -1;
}

.slidev-layout.cover > * {
  grid-column: 1 / -1;
  margin: 0;
}

.slidev-layout.cover .oa-cover-rec {
  display: flex;
  grid-row: 1;
  gap: 12px;
  align-items: center;
  margin-bottom: 32px;
  font-family: var(--oa-font-readout);
  font-size: 24px;
  line-height: 1.3;
  letter-spacing: 1px;
}

.slidev-layout.cover .oa-cover-rec > .oa-rec-lamp {
  width: 14px;
  height: 14px;
  margin: 0;
}

.slidev-layout.cover > h1 {
  grid-area: 3 / 1;
  padding-left: 0;
  font-size: 96px;
  line-height: 1.1;
}

.slidev-layout.cover > h1::before {
  content: none;
}

.slidev-layout.cover .oa-cover-figure {
  grid-area: 3 / 2;
  align-self: center;
  width: 72px;
  height: 72px;
  color: var(--oa-text-2);
}

.slidev-layout.cover .oa-cover-figure :is(p, svg, img) {
  display: block;
  width: 100%;
  height: 100%;
  margin: 0;
  object-fit: contain;
}

.slidev-layout.cover > h2 {
  grid-area: 4 / 1 / 5 / 3;
  margin-top: 20px;
  font-family: var(--oa-font-display);
  font-size: 28px;
  font-weight: 700;
  line-height: 1.4;
}

.slidev-layout.cover .oa-cover-monitor {
  grid-area: 2 / 3 / 6 / 4;
  margin-left: 16px;
}

/*
 * The lower third: the first line is the name, set large, and the lines after it are the meta.
 * The meta's 8px of extra leading puts the 4px gap under the name; the bottom padding takes back the rest.
 */
.slidev-layout.cover > h3 {
  justify-self: start;
  margin-top: 32px;
  padding: 17px 28px 12px 32px;
  font-family: var(--oa-font-meta);
  font-size: 24px;
  font-weight: 400;
  line-height: calc(1.2em + 8px);
  color: var(--oa-text-2);
}

.slidev-layout.cover > h3::first-line {
  font-family: var(--oa-font-numeral);
  font-size: 36px;
  font-weight: 700;
  line-height: 1;
  color: var(--oa-text);
}
</style>
