# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the FashionUnited Developer Portal - a documentation site built with [Astro](https://astro.build/) and [Starlight](https://starlight.astro.build/). It provides API documentation, guides, and resources for developers integrating with FashionUnited's services (Marketplace GraphQL API, Jobs, News embedding, etc.).

## Common Development Commands

### Development
```bash
bun dev           # Start dev server (default: http://localhost:4321)
bun start         # Run production server
```

### Building
```bash
bun run build     # Run type checking and build for production
astro check       # Type check without building
```

### Testing
```bash
bun test:e2e      # Run Playwright E2E tests
```

### Preview
```bash
bun run preview   # Preview production build locally
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
- **Deployment**: Google Cloud Run (see Dockerfile)

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
- **Runtime**: Bun in Alpine Linux container
- **Port**: 8080 (configured in Dockerfile)

## Key Configuration Files

- `astro.config.mjs`: Astro configuration with Starlight, Tailwind, React, Partytown, vtbot integrations
- `tailwind.config.mjs`: Tailwind with Starlight plugin, custom blue theme, shadcn/ui setup
- `tsconfig.json`: TypeScript config with `@/*` path alias for `./src/*`
- `playwright.config.ts`: E2E tests run against preview server on port 4321
- `Dockerfile`: Multi-stage Bun build with vips-dev for Sharp image processing

## Package Manager

- **Bun** is used as the package manager and JavaScript runtime
- Install dependencies with `bun install`

## Development Environment

This project supports multiple development environments:
- **Nix**: `nix develop` for reproducible environment (see flake.nix)
- **devenv**: Alternative Nix-based development environment
- **Docker**: For containerized builds
- **Standard Bun**: Install Bun from https://bun.sh

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

## Issue Tracking with Beads

This project uses [Beads](https://github.com/steveyegge/beads) by Steve Yegge for issue tracking. Beads is a distributed, Git-backed issue tracker designed specifically for AI coding agents.

### Installation

```bash
# macOS/Linux
curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash

# or via Homebrew
brew install steveyegge/beads/bd

# or via npm
npm install -g @beads/bd
```

### Usage

```bash
bd init                              # Initialize beads in project (run once)
bd create "Issue title" -p 1         # Create new issue (priority 1-5)
bd list                              # Show all issues
bd ready                             # Display unblocked tasks ready for work
bd show <id>                         # View issue details
bd update <id> --status in_progress  # Update status
bd close <id> --reason "Completed"   # Close finished work
bd sync                              # Force sync to Git
```

### Key Principles

- **Always use `bd` for task tracking** - File issues for incomplete work, track progress with status updates
- **Include issue IDs in commits** - Use format like `"Fix bug (bd-abc)"` in commit messages
- **Never use `bd edit`** - Use `bd update` with flags instead (it requires an interactive editor)
- **Run `bd sync` before ending sessions** - Ensures all changes are pushed to Git
- **Work is NOT complete until `git push` succeeds** - Always push before finishing

### Beads Configuration

The `.beads/` directory contains:
- `issues.jsonl` - Git-tracked issues in JSONL format
- `beads.db` - Local SQLite cache (gitignored)

### Claude Code Integration

When using Claude Code with this project, the agent should:
1. Check `bd ready` at session start to see pending tasks
2. Create issues for any discovered work with `bd create`
3. Update issue status as work progresses
4. Close completed issues with `bd close`
5. Run `bd sync` and `git push` before ending sessions
