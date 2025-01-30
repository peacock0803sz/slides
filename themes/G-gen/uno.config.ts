import { defineConfig, presetUno } from "unocss";

export default defineConfig({
  theme: {
    colors: {
      ggen: {
        black: "#2a2a2a",
        white: "#ffffff",
        gray1: "#595959",
        gray2: "#dcdddd",
        primary: "#3553a2",
        sub: "#009bdd",
        turquoise: "#66bdb2",
        yellow: "#f6b665",
        orange: "#ed6d06",
      },
    },
  },
  presets: [presetUno()],
});
