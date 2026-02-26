import starlightPlugin from '@astrojs/starlight-tailwind';
import { fuThemePreset, accent, gray } from '@fashionunited/starlight-plugin-theme/tailwind-preset';

/** @type {import('tailwindcss').Config} */
export default {
	presets: [fuThemePreset],
	content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
	plugins: [
		starlightPlugin({
			colors: { accent, gray }
		}),
		require("@tailwindcss/typography"),
		require("tailwindcss-animate"),
	],
}
