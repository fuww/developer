# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the FashionUnited Developer Portal - a documentation site built with [Astro](https://astro.build/) and [Starlight](https://starlight.astro.build/). It provides API documentation, guides, and resources for developers integrating with FashionUnited's services (Marketplace GraphQL API, Jobs, News embedding, etc.).

## Common Development Commands

### Development
```bash
pnpm dev          # Start dev server (default: http://localhost:4321)
pnpm start        # Alias for pnpm dev
```

### Building
```bash
pnpm build        # Run type checking and build for production
astro check       # Type check without building
```

### Testing
```bash
pnpm test:e2e     # Run Playwright E2E tests
```

### Preview
```bash
pnpm preview      # Preview production build locally
```

### Docker
```bash
# Build and push to Google Cloud Artifact Registry
docker build -t europe-west1-docker.pkg.dev/developers-fashionunited-com/developersite/ssrastrofrontend:latest . && docker push europe-west1-docker.pkg.dev/developers-fashionunited-com/developersite/ssrastrofrontend:latest
```

## High-Level Architecture

### Tech Stack
- **Framework**: Astro 5+ with SSR/SSG hybrid rendering
- **UI Library**: Starlight (Astro's documentation template)
- **Styling**: Tailwind CSS with custom blue-themed design system
- **React Components**: UI components using shadcn/ui patterns (button, card, input, label, separator, vortex)
- **Animations**: Framer Motion for interactive elements, astro-vtbot for page transitions
- **Testing**: Playwright for E2E testing
- **Analytics**: Plausible (loaded via Partytown)
- **Deployment**: Google Cloud Run (see cloudbuild.yaml)

### Project Structure

```
src/
├── components/
│   ├── starlight/Head.astro        # Custom Starlight head component
│   └── ui/                         # shadcn/ui-style React components
├── content/
│   └── docs/                       # Markdown documentation files
│       ├── docs/                   # Main documentation
│       │   ├── marketplace/        # Marketplace API docs
│       │   ├── jobs/
│       │   ├── editorial-*/
│       │   └── *.md
│       └── posts/                  # Blog posts
├── layouts/Layout.astro            # Base layout
├── pages/
│   ├── vortex.astro               # Demo page with vortex effect
│   └── register.astro             # Registration page
├── lib/utils.ts                   # Utility functions
└── styles/custom.css              # Custom CSS overrides
```

### Content Management

- Documentation lives in `src/content/docs/` as Markdown/MDX files
- Starlight automatically generates navigation from the sidebar config in `astro.config.mjs`
- The `docs` collection uses Starlight's schema (defined in `src/content/config.ts`)

### Styling System

- **Tailwind Config**: Custom blue-themed palette inspired by Solid.js (`tailwind.config.mjs`)
- **Color System**: Sophisticated blue gradients (50-950 scale) with custom gradient utilities
- **Fonts**: Inter Variable (sans), Lora Variable (serif), IBM Plex Mono (code)
- **Starlight Theme**: Custom accent and gray colors defined in Tailwind plugin

### Build & Deployment

- **Output Mode**: Static site generation with optional Node.js middleware adapter
- **Docker**: Multi-stage build with Sharp support for image optimization
- **Cloud Build**: Automated builds using Google Cloud Build with buildpacks
- **Runtime**: Node.js LTS in Alpine Linux container
- **Port**: 8080 (configured in Dockerfile)

## Key Configuration Files

- `astro.config.mjs`: Astro configuration with Starlight, Tailwind, React, Partytown, vtbot integrations
- `tailwind.config.mjs`: Tailwind with Starlight plugin, custom blue theme, shadcn/ui setup
- `tsconfig.json`: TypeScript config with `@/*` path alias for `./src/*`
- `playwright.config.ts`: E2E tests run against preview server on port 4321
- `cloudbuild.yaml`: Google Cloud Build configuration for Cloud Run deployment
- `Dockerfile`: Multi-stage Node.js build with vips-dev for Sharp image processing

## Package Manager

- **pnpm** is required (enforced via preinstall script)
- Version: 10.13.1 (managed via corepack)

## Development Environment

This project supports multiple development environments:
- **Nix**: `nix develop` for reproducible environment (see flake.nix)
- **devenv**: Alternative Nix-based development environment
- **Docker**: For containerized builds
- **Standard Node.js**: With pnpm 10.13.1

## Important Patterns

### Adding New Documentation
1. Create `.md` or `.mdx` file in `src/content/docs/docs/`
2. Add frontmatter with `title` and optionally `comments`, `toc`, `images`
3. Update sidebar in `astro.config.mjs` if needed (or use `autogenerate`)

### Creating React Components
- Use TypeScript (`.tsx` extension)
- Place in `src/components/ui/` for reusable UI components
- Follow shadcn/ui patterns (class-variance-authority, Radix UI primitives)
- Import with `@/components/ui/*` alias

### Starlight Customization
- Override Starlight components by creating files in `src/components/starlight/`
- Custom head component already exists at `src/components/starlight/Head.astro`

### GraphQL API Documentation
The primary use case for this site is documenting the FashionUnited GraphQL API:
- Endpoint: `https://fashionunited.com/graphql/`
- Playground: `https://fashionunited.com/graphiql/`
- Marketplace queries support pagination, locales, and brand filtering