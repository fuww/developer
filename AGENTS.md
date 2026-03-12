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

## Commit Messages and PR Titles

No prefixes (`feat:`, `fix:`, `[codex]`, etc.). Start with capital letter, imperative mood, include GitHub issue number. Example: `Add job count for locales #123`. PR titles follow the same rules.

## Issue Tracking with br (beads_rust)

This project uses `br` ([beads_rust](https://github.com/steveyegge/beads_rust)) for issue tracking. beads_rust is a distributed, Git-backed issue tracker designed specifically for AI coding agents.

**Note:** `br` is non-invasive and never executes git commands. After `br sync --flush-only`, describe the change with `jj describe`.

### Usage

```bash
br init                              # Initialize beads in project (run once)
br create "Issue title" -p 1         # Create new issue (priority 1-5)
br list                              # Show all issues
br ready                             # Display unblocked tasks ready for work
br show <id>                         # View issue details
br update <id> --status in_progress  # Update status
br close <id> --reason "Completed"   # Close finished work
br sync --flush-only                 # Flush pending changes (does not touch git)
```

### Key Principles

- **Always use `br` for task tracking** - File issues for incomplete work, track progress with status updates
- **`br` is non-invasive** - It never executes git commands; use `jj` for all version control operations
- **Include issue IDs in commits** - Use format like `"Fix bug (br-abc)"` in commit messages
- **Never use `br edit`** - Use `br update` with flags instead (it requires an interactive editor)
- **Run `br sync --flush-only` before ending sessions** - Then describe the change with `jj describe`

### Beads Configuration

The `.beads/` directory contains:
- `issues.jsonl` - Git-tracked issues in JSONL format
- `beads.db` - Local SQLite cache (gitignored)

### Claude Code Integration

When using Claude Code with this project, the agent should:
1. Check `br ready` at session start to see pending tasks
2. Create issues for any discovered work with `br create`
3. Update issue status as work progresses
4. Close completed issues with `br close`
5. Run `br sync --flush-only` and then `jj describe -m "sync beads"` before ending sessions
