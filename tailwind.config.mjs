import starlightPlugin from '@astrojs/starlight-tailwind';
import { fuThemePreset, accent, gray } from '@fuww/starlight-plugin-theme/tailwind-preset';
import typography from '@tailwindcss/typography';
import animate from 'tailwindcss-animate';

/** @type {import('tailwindcss').Config} */
export default {
	presets: [fuThemePreset],
	content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
	plugins: [
		starlightPlugin({
			colors: { accent, gray }
		}),
		typography,
		animate,
	],
}
