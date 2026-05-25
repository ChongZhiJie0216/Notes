// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	site: 'https://ChongZhiJie0216.github.io',
	base: '/Notes',
	integrations: [
		starlight({
			title: 'Notes',
			customCss: [
				'./src/styles/custom.css',
			],
			components: {
				Footer: './src/components/Footer.astro',
			},
			sidebar: [
				{ autogenerate: { directory: '' } }
			],
		}),
	],
});
