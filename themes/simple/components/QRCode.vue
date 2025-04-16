<template>
  <canvas height="250" width="250" ref="canvasRef"></canvas>
</template>

<script setup lang="ts">
import * as QRCode from "qrcode";
import { ref, onMounted } from "vue";

const props = defineProps<{ text: string }>();
const canvasRef = ref<HTMLElement | null>(null);

onMounted(() => {
  if (canvasRef.value) {
    QRCode.toCanvas(canvasRef.value, props.text, function (error) {
      if (error) console.error(error);
    });
  }
});
</script>

<style>
.slidev-layout canvas {
  position: absolute;
  right: 75px;
  bottom: 75px;
  float: right;
  width: 250px !important;
  height: 250px !important;
}
</style>
