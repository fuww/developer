# Plan: Shared Starlight Theme Package

## Problem

The `developer` and `about` repos are both Astro Starlight sites with the same FashionUnited blue theme, and maintaining them in both places is wasteful. When you change a color, a Starlight override, or a UI component, you have to do it twice.

## What's Actually Duplicated

### Identical (copy-paste)
| File | Notes |
|---|---|
| `src/lib/utils.ts` | `cn()` helper — byte-for-byte identical |
| `src/components/constants.ts` | `PAGE_TITLE_ID` — byte-for-byte identical |
| `src/components/starlight/PageTitle.astro` | Nearly identical (about has 2 extra comment lines) |
| `src/components/ui/card.tsx` | Nearly identical (about uses `<div>` instead of `<h3>/<p>` for title/description) |

### Same intent, minor drift
| File | developer | about | Drift |
|---|---|---|---|
| `tailwind.config.mjs` | Missing `gray.50`, no `data-theme` dark mode selector | Has `gray.50`, adds `[data-theme="dark"]`, has blue palette in `extend` not top-level | Structural ordering, `about` is slightly more complete |
| `src/styles/globals.css` | HSL values differ slightly (e.g. `foreground: 222.2 47.4% 11.2%` vs `222.2 84% 4.9%`) | Different dark mode values too | Probably accidental drift — should pick one |
| `src/components/ui/button.tsx` | Uses `Slot` (asChild works) | Commented out `Slot`, hardcoded `<button>`, exports `buttonVariants` | about regressed — should use developer's version |
| `src/styles/custom.css` / `src/tailwind.css` | 47-line base theme CSS | Same 54 lines + 1343 lines of prompt system CSS | First ~54 lines are the shared base theme |
| `src/components/starlight/Head.astro` | Clean: just vtbot + loading indicator | Adds PostHog, OG images, service worker, prompt scripts | about extends; core vtbot setup is shared |
| `src/layouts/Layout.astro` | Minimal (no title, no PostHog) | Adds title prop + PostHog | Same skeleton |

### Not duplicated (site-specific)
- about: `PageSidebar.astro`, `NavLink.astro`, `PostHog.astro`, tools system, videos system, `ApplicationButtons.tsx`, prompt CSS, middleware, content schema extensions, RSS
- developer: `vortex.tsx`, `input.tsx`, `label.tsx`, register page

## Options

### Option A: Shared npm package (`@fashionunited/starlight-theme`)

Create a new repo (or a directory in the org workspace) that publishes an npm package containing:

```
@fashionunited/starlight-theme/
  tailwind.config.mjs      # The base config (colors, fonts, gradients, plugins)
  tailwind-preset.mjs       # Tailwind preset (importable, mergeable)
  styles/
    base.css                # The shared ~55 lines (dark mode fix, gradients, sidebar active)
    globals.css             # shadcn CSS variables
  components/
    starlight/
      Head.astro            # Base vtbot setup (sites extend via slots/composition)
      PageTitle.astro       # Copy-page dropdown
    ui/
      button.tsx
      card.tsx
    constants.ts
  lib/
    utils.ts                # cn() helper
  package.json
```

**Consumer usage:**

```js
// tailwind.config.mjs
import { fuThemePreset } from '@fashionunited/starlight-theme/tailwind-preset';
export default {
  presets: [fuThemePreset],
  // site-specific overrides here
};
```

```js
// astro.config.mjs
import { starlightConfig } from '@fashionunited/starlight-theme';
export default defineConfig({
  integrations: [
    starlight({
      ...starlightConfig,
      // site-specific sidebar, title, etc.
      components: {
        ...starlightConfig.components,
        // override further if needed
      },
    }),
  ],
});
```

**Pros:**
- Clean versioning — pin versions, upgrade intentionally
- Works with any future Starlight site in the org
- Standard npm workflow

**Cons:**
- Overhead: separate repo, publish pipeline, version bumps
- Astro component sharing via npm is possible but not as smooth as JS — `.astro` files need to be distributed as source, not compiled
- Two levels of indirection when debugging

### Option B: Starlight plugin

Starlight has a [plugin API](https://starlight.astro.build/reference/plugins/) that can inject CSS, components, and configuration. This is what `starlight-theme-next` already does for you.

Create `@fashionunited/starlight-plugin-theme`:

```ts
// index.ts
import type { StarlightPlugin } from '@astrojs/starlight/types';

export default function fashionunitedTheme(): StarlightPlugin {
  return {
    name: 'fashionunited-theme',
    hooks: {
      setup({ config, updateConfig, addIntegration }) {
        updateConfig({
          customCss: [
            '@fashionunited/starlight-plugin-theme/styles/base.css',
            '@fashionunited/starlight-plugin-theme/styles/globals.css',
            ...config.customCss,
          ],
          components: {
            Head: '@fashionunited/starlight-plugin-theme/components/Head.astro',
            PageTitle: '@fashionunited/starlight-plugin-theme/components/PageTitle.astro',
            ...config.components, // consumer overrides win
          },
        });
      },
    },
  };
}
```

**Consumer usage:**

```js
// astro.config.mjs
import fashionunitedTheme from '@fashionunited/starlight-plugin-theme';

starlight({
  plugins: [fashionunitedTheme(), starlightLlmsTxt(), starlightThemeNext()],
  // everything else is site-specific
})
```

**Pros:**
- First-class Starlight integration — components, CSS, config all injected properly
- Consumer can still override any component
- Single plugin call replaces scattered config
- Tailwind preset can be bundled alongside

**Cons:**
- Same publish overhead as Option A
- Plugin API surface is still evolving (but stable enough for this)

### Option C: Git submodule / symlinks (low-tech)

Put shared files in a `shared/` repo and symlink or submodule them into both sites.

**Pros:**
- No publish step, changes are immediate
- Simple mental model

**Cons:**
- Symlinks break in Docker builds, CI, and some editors
- Git submodules are notoriously annoying
- No versioning — both sites always get latest (can be a pro or con)
- Doesn't scale to a third site

### Option D: Monorepo (move both sites into one repo)

```
fashionunited-sites/
  packages/
    theme/          # shared theme code
    developer/      # developer site
    about/          # about site
```

**Pros:**
- Single PR can update theme + both consumers
- No publish step — workspace dependencies
- Atomic changes

**Cons:**
- Big migration effort
- Different deploy pipelines need merging
- These repos have separate teams/cadences — coupling them may create friction

## Recommendation

**Option B (Starlight plugin)** is the best fit:

1. It's the idiomatic Starlight approach — you're already using `starlight-theme-next` and `starlight-llms-txt` as plugins, so this fits the existing pattern.
2. It cleanly separates "FashionUnited brand theme" from "site-specific content."
3. Low maintenance — publish once to npm (or a private registry / GitHub Packages), bump when needed.
4. If a third Starlight site appears, it's a one-line addition.

The Tailwind preset can ship alongside the plugin as a separate export. The shadcn/ui components (`button.tsx`, `card.tsx`) and `utils.ts` can also live in the package.

## Implementation Steps

### Phase 1: Extract shared theme (new package)

1. Create `@fashionunited/starlight-plugin-theme` repo (or `/theme` in the org workspace)
2. Move into it:
   - `styles/base.css` — the shared ~55 lines from custom.css / tailwind.css (dark mode fix, hero gradient, site-title gradient, button gradients, sidebar active state)
   - `styles/globals.css` — the shadcn CSS variable system (pick one source of truth, reconcile the HSL drift)
   - `tailwind-preset.mjs` — shared color palette, fonts, gradients, animations, border-radius, container config
   - `components/starlight/Head.astro` — vtbot page transitions + loading indicator (no PostHog, no site-specific scripts)
   - `components/starlight/PageTitle.astro` — copy-page dropdown
   - `components/ui/button.tsx`, `card.tsx`
   - `components/constants.ts`
   - `lib/utils.ts`
3. Create the Starlight plugin entry point (`index.ts`)
4. Publish to npm or GitHub Packages

### Phase 2: Migrate developer site

1. `bun add @fashionunited/starlight-plugin-theme`
2. Replace `tailwind.config.mjs` with preset import + site-specific overrides only
3. Replace `custom.css` with an import of the shared base (or let the plugin inject it)
4. Remove `globals.css`, `utils.ts`, `constants.ts`, `button.tsx`, `card.tsx`, `PageTitle.astro` (now from package)
5. Keep `Head.astro` override only if it needs site-specific additions (currently it doesn't)
6. Verify with `bun dev` and `bun test:e2e`

### Phase 3: Migrate about site

1. `bun add @fashionunited/starlight-plugin-theme`
2. Replace shared portions of `tailwind.config.mjs` with preset
3. Split `src/tailwind.css` — shared base moves to package, prompt system CSS stays local
4. Remove duplicated files
5. Keep site-specific overrides: `Head.astro` (PostHog, OG images, service worker), `PageSidebar.astro`, `NavLink.astro`
6. Verify with `bun dev` and `bun test:e2e`

### Phase 4: Reconcile drift

1. Fix `globals.css` HSL values — pick developer's or about's, make one canonical set
2. Fix `button.tsx` — use the developer version with proper `Slot` support
3. Add `gray.50` to the shared palette
4. Add `[data-theme="dark"]` to the shared dark mode selector

## What Stays Site-Specific

| developer | about |
|---|---|
| Sidebar config | Sidebar config |
| `vortex.tsx`, `input.tsx`, `label.tsx` | `PageSidebar.astro`, `NavLink.astro`, `PostHog.astro` |
| Register page | Tools system, videos system, `ApplicationButtons.tsx` |
| Plausible analytics config | PostHog analytics config |
| Markdown endpoint route | Prompt system (CSS + scripts) |
| Docker/deploy config | Print stylesheet, middleware (CSP) |
| | Content schema extensions (maintainers, needsReview, ogImage) |

## Open Questions

1. **Private vs public npm package?** If other orgs won't use it, GitHub Packages with org scope is simplest. If you want it public (portfolio/open-source), regular npm works.
2. **Where does the package repo live?** New repo (`starlight-theme`) in the fashionunited org, or a `packages/theme` dir in the org workspace?
3. **Tailwind 4 migration timing?** Both repos use Tailwind 3. If a Tailwind 4 upgrade is planned, do that first (or at the same time) to avoid migrating the preset twice.
4. **Do you want the Head.astro base component to be extensible** (e.g. via slots for additional scripts) or should each site fully override it?
