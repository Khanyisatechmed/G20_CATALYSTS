import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./lib/**/*.{js,ts,jsx,tsx,mdx}",
    "./stores/**/*.{js,ts,jsx,tsx,mdx}"
  ],
  theme: {
    extend: {
      colors: {
        brand: {
          forest: "#315D42",
          deep: "#254D38",
          ivory: "#F8F5EC",
          terracotta: "#C8754B",
          sand: "#D9B77B",
          sage: "#A8BDA0"
        },
        earth: {
          950: "#130d08",
          900: "#1b120c",
          800: "#2b1a10",
          700: "#4a2b1a"
        },
        terracotta: {
          300: "#d9895f",
          500: "#b85f3c",
          700: "#7f3b25"
        },
        darkGold: "#d6a646",
        glowBlue: "#47d7ff",
        timber: "#6f482c"
      },
      boxShadow: {
        glow: "0 0 40px rgba(71, 215, 255, 0.24)",
        ember: "0 28px 70px rgba(78, 35, 15, 0.55)"
      }
    }
  },
  plugins: []
};

export default config;
