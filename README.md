# External Integration Project

This guide shows how to link monorepo packages to external integration projects for local development using `pnpm link`.

## Purpose

This is a Next.js 16 application that demonstrates how packages from the modern-monorepo example can be used in external projects via `pnpm link` for local development and testing.

**Use this when you want to:**

- Test monorepo packages before publishing to npm
- Develop across monorepo and external projects simultaneously
- Validate package exports and configurations work correctly
- Debug issues with package consumption

## Prerequisites

Clone both repositories as siblings:

```bash
cd ~/projects
git clone <modern-monorepo-url> modern-monorepo
git clone <external-project-url> external-integration

# Directory structure:
# ~/projects/
#   ├── modern-monorepo/
#   └── external-integration/
```

## Setup

### 1. Install Dependencies

```bash
cd external-integration
pnpm install
```

### 2. Link Monorepo Packages

```bash
# Using npm scripts (recommended)
pnpm monorepo:link                                    # Link all packages (uses default monorepo path)
pnpm monorepo:link @workspace/ui @workspace/products-frontend  # Link specific packages

# Or run script directly
./scripts/link-packages.sh                            # Uses default path (../modern-monorepo)
./scripts/link-packages.sh ../my-monorepo             # Custom monorepo path
./scripts/link-packages.sh ../modern-monorepo @workspace/ui  # Custom path + specific packages
```

### 3. Start Dev Server

```bash
pnpm dev
```

Visit http://localhost:3000 to see the linked Card components.

### 4. Test Hot Reload

1. Keep the dev server running
2. Edit `../modern-monorepo/packages/ui/src/components/card.tsx`
3. Changes should appear immediately in the browser

## Configuration

### Next.js Config (Required for Next.js 16+)

The `next.config.ts` includes critical configuration for Turbopack:

```typescript
import type { NextConfig } from "next";
import { join } from "path";

const nextConfig: NextConfig = {
  // Tell Next.js to transpile linked workspace packages
  transpilePackages: ["@workspace/ui", "@workspace/products-frontend"],

  // Tell Turbopack to allow access to symlinked packages outside project root
  turbopack: {
    root: join(__dirname, ".."),
  },
};

export default nextConfig;
```

**Why `turbopack.root` is needed:**

Turbopack (Next.js 16 default) auto-detects the project root by finding lock files. It finds `external-integration/pnpm-lock.yaml` and blocks access to `../modern-monorepo/`. Setting `turbopack.root: join(__dirname, "..")` allows access to both directories.

**Reference:** [Next.js Issue #77562](https://github.com/vercel/next.js/issues/77562)

## Scripts

### `pnpm monorepo:link`

Links monorepo packages to this project for local development.

**Usage:**

```bash
# Via npm script (uses default monorepo path: ../modern-monorepo)
pnpm monorepo:link                                    # Link all packages
pnpm monorepo:link @workspace/ui                      # Link specific package

# Via script directly (allows custom monorepo path)
./scripts/link-packages.sh                   # Link all (default path)
./scripts/link-packages.sh ../my-monorepo    # Link all (custom path)
./scripts/link-packages.sh ../modern-monorepo @workspace/ui  # Custom path + specific packages
```

**Configuring the default monorepo path:**

Edit `scripts/link-packages.sh` and update the `DEFAULT_MONOREPO_PATH` variable:

```bash
# Default monorepo path (relative to project root)
DEFAULT_MONOREPO_PATH="../modern-monorepo"  # Change this to your monorepo location
```

**Available packages:**

- `@workspace/ui` - Design system components
- `@workspace/products-frontend` - Products feature
- `@workspace/frontend-testing` - Shared Vitest config
- `@workspace/typescript-config` - Shared TypeScript configs
- `@workspace/eslint-config` - Shared ESLint configs

### `pnpm monorepo:unlink`

Unlinks monorepo packages from this project.

**Usage:**

```bash
# Via npm script
pnpm monorepo:unlink

# Via script directly
./scripts/unlink-packages.sh                 # Unlink all packages
./scripts/unlink-packages.sh @workspace/ui   # Unlink specific packages
```

## Using Linked Packages

### Import Components

```tsx
import { Card, CardHeader, CardTitle } from "@workspace/ui/components/card";
import { ProductCard } from "@workspace/products-frontend/components/product-card";
```

### Import Styles

```tsx
import "@workspace/ui/globals.css";
```

## Package Scripts

- `pnpm dev` - Start dev server with Turbopack (default)
- `pnpm dev:webpack` - Start dev server with Webpack (fallback)
- `pnpm build` - Production build
- `pnpm start` - Start production server
- `pnpm lint` - Run ESLint

## Troubleshooting

### Module Not Found Error

**Error:** `Module not found: Can't resolve '@workspace/ui/...'`

**Solution:** Ensure `turbopack.root` is configured in `next.config.ts` (see Configuration section above).

### TypeScript Errors

**Error:** Types not found for `@workspace/ui`

**Solution:**

1. Check symlink exists: `ls -la node_modules/@workspace/ui`
2. Re-link if needed: `pnpm monorepo:link @workspace/ui`

### Styles Not Applied

**Error:** Components render but have no styling

**Solution:**

1. Verify CSS import in `app/layout.tsx`: `import "@workspace/ui/globals.css"`
2. Check `packages/ui/package.json` exports include: `"./globals.css": "./src/styles/globals.css"`

### Webpack Fallback

If you encounter Turbopack issues, use Webpack instead:

```bash
pnpm dev:webpack
```

This runs `next dev --webpack` which resolves symlinked packages without additional configuration.

## References

- [Next.js transpilePackages](https://nextjs.org/docs/app/api-reference/config/next-config-js/transpilePackages)
- [Turbopack Configuration](https://nextjs.org/docs/app/api-reference/config/next-config-js/turbopack)
- [pnpm link](https://pnpm.io/cli/link)
