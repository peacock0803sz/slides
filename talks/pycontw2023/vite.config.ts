import { defineConfig } from "vite";

export default defineConfig({
  build: {
    rollupOptions: {
      external: [
        "@slidev/types",
        "vue",
        "vite-plugin-vue-server-ref/client",
        "@unocss/reset/tailwind.css",
      ],
    },
  },
});
