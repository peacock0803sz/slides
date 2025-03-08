<template>
  <div class="slidev-layout table">
    <div class="my-auto w-full">
      <slot />
    </div>
  </div>
</template>

<style>
.slidev-layout.table {
  display: flex;
}

.slidev-layout.table table {
  line-height: 0.75;
}

.slidev-layout.table table>tbody>tr>td {
  font-size: 22px;
  line-height: 0.5;
}

.slidev-layout.table code {
  font-size: 22px;
}
</style>
