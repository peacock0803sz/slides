<script setup lang="ts">
import { resolveAssetUrl } from '@slidev/client'
import { computed } from 'vue'
import PageNumber from '../components/PageNumber.vue'

const props = defineProps<{
  image?: string
}>()

const imageUrl = computed(() => props.image && resolveAssetUrl(props.image))
</script>

<template>
  <div class="slidev-layout profile" :class="{ 'riso-with-image': imageUrl }">
    <slot />
    <img v-if="imageUrl" class="riso-profile-photo" :src="imageUrl" alt="">
    <PageNumber />
    <span class="riso-ink riso-ink-green" />
  </div>
</template>

<style>
.slidev-layout.profile.riso-with-image {
  padding-right: 496px;
}

.slidev-layout.profile .riso-profile-photo {
  position: absolute;
  top: 56px;
  right: 88px;
  width: 360px;
  height: 360px;
  object-fit: cover;
}

/*
 * `- **Key** value` lays out as a table: the key becomes a cell and the rest of the item, links and
 * nested lists included, is wrapped in one anonymous cell, so the key column fits the longest key.
 */
.slidev-layout.profile > ul {
  display: table;
  margin: -32px 0;
  border-spacing: 0 32px;
}

.slidev-layout.profile > ul > li {
  display: table-row;
  line-height: 1.35;
}

.slidev-layout.profile > ul > li::before {
  content: none;
}

.slidev-layout.profile > ul > li > strong:first-child {
  display: table-cell;
  padding-right: 24px;
  font-size: 24px;
  white-space: nowrap;
  color: var(--riso-green-text);
}

.slidev-layout.profile > ul > li > ul {
  margin: 2px 0 0;
}

.slidev-layout.profile > ul > li li {
  margin: 0;
  padding-left: 0;
  line-height: 1.35;
}

.slidev-layout.profile > ul > li li::before {
  content: none;
}
</style>
