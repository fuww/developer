import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import starlightLlmsTxt from 'starlight-llms-txt';
import starlightThemeNext from 'starlight-theme-next';
import tailwind from "@astrojs/tailwind";
import partytown from "@astrojs/partytown";
import vtbot from "astro-vtbot";
import node from "@astrojs/node";

import react from "@astrojs/react";

// https://astro.build/config
export default defineConfig({
  image: {
    domains: ["fashionunited.com", "storage.cloud.google.com"],
    remotePatterns: [{
      protocol: "https"
    }]
  },
  site: 'https://developer.fashionunited.com',
  integrations: [starlight({
    components: {
      Head: "./src/components/starlight/Head.astro"
    },
    title: 'FashionUnited Docs',
    customCss: ['./src/styles/custom.css', '@fontsource/ibm-plex-mono/400.css', '@fontsource/ibm-plex-mono/600.css', '@fontsource-variable/inter', '@fontsource-variable/lora'],
    social: [
      {
        label: 'GitHub',
        href: 'https://github.com/fuww/developer.fashionunited.com',
        icon: 'github'
      }
    ],
    plugins: [starlightLlmsTxt(), starlightThemeNext()],
    head: [{
      tag: "script",
      attrs: {
        type: "text/partytown",
        src: "https://plausible.io/js/script.js",
        "data-domain": "developer.fashionunited.com",
        defer: true
      }
    }],
    sidebar: [
      {
        label: 'Getting Started',
        items: [
          { label: 'Introduction', link: '/docs/introduction/' },
          { label: 'Logging In', link: '/docs/getting-started/login/' },
          { label: 'Dashboard Overview', link: '/docs/getting-started/dashboard-overview/' },
        ],
      },
      {
        label: 'Jobs',
        items: [
          { label: 'Posting a Job', link: '/docs/dashboard-jobs/posting-a-job/' },
          { label: 'Managing Applications', link: '/docs/dashboard-jobs/managing-applications/' },
          { label: 'Job Analytics', link: '/docs/dashboard-jobs/job-analytics/' },
        ],
      },
      {
        label: 'Company Profile',
        items: [
          { label: 'Editing Your Profile', link: '/docs/company-profile/editing-your-profile/' },
        ],
      },
      {
        label: 'Credits & Billing',
        items: [
          { label: 'Credits and Billing', link: '/docs/billing/credits-and-billing/' },
        ],
      },
      {
        label: 'Advertising',
        items: [
          { label: 'Advertising', link: '/docs/advertising/' },
        ],
      },
      {
        label: 'Editorial',
        items: [
          { label: 'Editorial Cheat Sheet', link: '/docs/editorial-cheat-sheet/' },
          { label: 'Editorial Style Guide', link: '/docs/editorial-style-guide/' },
        ],
      },
      {
        label: 'Integration',
        items: [
          { label: 'FashionUnited for Websites', link: '/docs/fashionunited-for-websites/' },
          { label: 'Jobs Feed (JSON/XML)', link: '/docs/jobs/' },
        ],
      },
      {
        label: 'Brand Assets',
        items: [
          { label: 'Header Image Requirements', link: '/docs/header/' },
          { label: 'Logo', link: '/docs/logo/' },
        ],
      },
      {
        label: 'Marketplace',
        autogenerate: { directory: 'docs/marketplace' },
      },
      {
        label: 'Reference',
        items: [
          { label: 'System Requirements and Browsers', link: '/docs/system-requirements-and-browsers/' },
          { label: 'Style Guide', link: '/docs/style-guide/' },
        ],
      },
      {
        label: 'Help',
        items: [
          { label: 'FAQ', link: '/docs/faq/' },
        ],
      },
    ]
  }), tailwind({
    // Disable the default base styles:
    applyBaseStyles: false
  }), partytown(), vtbot(), react()],
  output: "server",
  adapter: node({
    mode: "standalone"
  })
});