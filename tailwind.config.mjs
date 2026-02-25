const { fontFamily } = require('tailwindcss/defaultTheme')
import starlightPlugin from '@astrojs/starlight-tailwind';
const colors = require('tailwindcss/colors')

// Generated color palettes
// https://starlight.astro.build/guides/css-and-tailwind/#color-theme-editor
// Sophisticated blue palette inspired by Solid.js
const accent = {
  200: '#93c5fd',
  600: '#2563eb',
  900: '#1e3a8a',
  950: '#172554'
};
const gray = {
  100: '#f5f6f8',
  200: '#eceef2',
  300: '#c0c2c7',
  400: '#888b96',
  500: '#545861',
  700: '#353841',
  800: '#24272f',
  900: '#17181c'
};

/** @type {import('tailwindcss').Config} */
export default {
	darkMode: ["class"],
	content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
	plugins: [
		starlightPlugin({
			colors: {
				accent,
				gray,
			}
		}),
		require("@tailwindcss/typography"),
		require("tailwindcss-animate"),
	],
	theme: {
		container: {
			center: true,
			padding: "2rem",
			screens: {
			  "2xl": "1400px",
			},
	  },
	  letterSpacing: {
		tight: '-0.015em',
	  },
	  colors: {
		accent,
		gray,
		white: colors.white,
		dark: "#111",
	  },
	  extend: {
		fontFamily: {
		  sans: [
			"Inter Variable",
			"Inter",
			...fontFamily.sans,
		  ],
		},
		colors: {
		  border: "hsl(var(--border))",
		  input: "hsl(var(--input))",
		  ring: "hsl(var(--ring))",
		  background: "hsl(var(--background))",
		  foreground: "hsl(var(--foreground))",
		  primary: {
			DEFAULT: "hsl(var(--primary))",
			foreground: "hsl(var(--primary-foreground))",
		  },
		  secondary: {
			DEFAULT: "hsl(var(--secondary))",
			foreground: "hsl(var(--secondary-foreground))",
		  },
		  destructive: {
			DEFAULT: "hsl(var(--destructive))",
			foreground: "hsl(var(--destructive-foreground))",
		  },
		  muted: {
			DEFAULT: "hsl(var(--muted))",
			foreground: "hsl(var(--muted-foreground))",
		  },
		  accent: {
			DEFAULT: "hsl(var(--accent))",
			foreground: "hsl(var(--accent-foreground))",
		  },
		  popover: {
			DEFAULT: "hsl(var(--popover))",
			foreground: "hsl(var(--popover-foreground))",
		  },
		  card: {
			DEFAULT: "hsl(var(--card))",
			foreground: "hsl(var(--card-foreground))",
		  },
		  // Sophisticated blue palette
		  blue: {
			50: '#eff6ff',
			100: '#dbeafe',
			200: '#bfdbfe',
			300: '#93c5fd',
			400: '#60a5fa',
			500: '#3b82f6',
			600: '#2563eb',
			700: '#1d4ed8',
			800: '#1e40af',
			900: '#1e3a8a',
			950: '#172554',
		  },
		},
		backgroundImage: {
		  'gradient-blue-light': 'linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%)',
		  'gradient-blue': 'linear-gradient(135deg, #3b82f6 0%, #2563eb 100%)',
		  'gradient-blue-hero': 'linear-gradient(135deg, #eff6ff 0%, #dbeafe 25%, #bfdbfe 50%, #93c5fd 100%)',
		  'gradient-blue-dark': 'linear-gradient(135deg, #2563eb 0%, #1e40af 50%, #1e3a8a 100%)',
		  'gradient-blue-sidebar': 'linear-gradient(180deg, #eff6ff 0%, #dbeafe 100%)',
		},
		borderRadius: {
		  lg: "var(--radius)",
		  md: "calc(var(--radius) - 2px)",
		  sm: "calc(var(--radius) - 4px)",
		},
		keyframes: {
		  "accordion-down": {
			from: { height: "0" },
			to: { height: "var(--radix-accordion-content-height)" },
		  },
		  "accordion-up": {
			from: { height: "var(--radix-accordion-content-height)" },
			to: { height: "0" },
		  },
		},
		animation: {
		  "accordion-down": "accordion-down 0.2s ease-out",
		  "accordion-up": "accordion-up 0.2s ease-out",
		},
	  },
	},
  }
