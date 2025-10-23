#!/usr/bin/env bash

# Link monorepo packages for local development
#
# Usage:
#   ./scripts/link-packages.sh [monorepo-path] [package-names...]
#
# Examples:
#   # Link all packages (using default monorepo path)
#   ./scripts/link-packages.sh
#
#   # Link all packages (custom monorepo path)
#   ./scripts/link-packages.sh ../my-monorepo
#
#   # Link specific packages
#   ./scripts/link-packages.sh ../modern-monorepo @workspace/ui @workspace/products-frontend

# ============================================================================
# CONFIGURATION
# ============================================================================

# Default monorepo path (relative to project root)
DEFAULT_MONOREPO_PATH="../modern-monorepo"

# All linkable packages (frontend packages that external projects might use)
# Add or remove packages here as needed
ALL_PACKAGES=(
  "@workspace/ui"
  "@workspace/products-frontend"
  "@workspace/frontend-testing"
  "@workspace/typescript-config"
  "@workspace/eslint-config"
)

# ============================================================================
# SCRIPT LOGIC (no need to edit below this line)
# ============================================================================

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Determine monorepo path
if [[ "$1" != @* ]] && [ -n "$1" ]; then
  MONOREPO_PATH="$1"
  shift
else
  MONOREPO_PATH="$DEFAULT_MONOREPO_PATH"
fi

# Resolve to absolute path
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MONOREPO_ROOT="$(cd "$PROJECT_ROOT/$MONOREPO_PATH" 2>/dev/null && pwd)"

# Check if monorepo exists
if [ -z "$MONOREPO_ROOT" ] || [ ! -d "$MONOREPO_ROOT" ]; then
  echo -e "${RED}Error: Monorepo not found at: $PROJECT_ROOT/$MONOREPO_PATH${NC}"
  echo "Usage: $0 [monorepo-path] [package-names...]"
  exit 1
fi

echo -e "${BLUE}Linking monorepo packages from: $MONOREPO_ROOT${NC}"
echo ""

# Determine which packages to link
if [ $# -eq 0 ]; then
  PACKAGES_TO_LINK=("${ALL_PACKAGES[@]}")
  echo -e "${YELLOW}Linking all packages${NC}"
else
  PACKAGES_TO_LINK=("$@")
  echo -e "${YELLOW}Linking specified packages${NC}"
fi
echo ""

# Link each package
LINKED_COUNT=0
SKIPPED_COUNT=0

for PACKAGE_NAME in "${PACKAGES_TO_LINK[@]}"; do
  echo -e "${BLUE}Linking $PACKAGE_NAME...${NC}"
  
  # Discover package path using pnpm
  PACKAGE_PATH=$(cd "$MONOREPO_ROOT" && pnpm list -r --depth -1 --long 2>/dev/null | grep "^${PACKAGE_NAME}@" | awk '{print $2}')
  
  if [ -z "$PACKAGE_PATH" ]; then
    echo -e "${RED}✗ Not found in monorepo${NC}"
    ((SKIPPED_COUNT++))
  elif pnpm link "$PACKAGE_PATH" 2>&1 | grep -q "ERROR"; then
    echo -e "${RED}✗ Failed to link${NC}"
    ((SKIPPED_COUNT++))
  else
    echo -e "${GREEN}✓ Linked${NC}"
    ((LINKED_COUNT++))
  fi
  
  echo ""
done

# Summary
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Linked: $LINKED_COUNT packages${NC}"
if [ $SKIPPED_COUNT -gt 0 ]; then
  echo -e "${RED}✗ Skipped: $SKIPPED_COUNT packages${NC}"
fi
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Next steps
if [ $LINKED_COUNT -gt 0 ]; then
  echo -e "${YELLOW}Next steps:${NC}"
  echo ""
  echo "1. Ensure your Next.js config includes:"
  echo -e "   ${BLUE}transpilePackages: [\"@workspace/ui\", ...]${NC}"
  echo ""
  echo "2. For Next.js 16 (Turbopack), add:"
  echo -e "   ${BLUE}turbopack: { root: join(__dirname, \"..\") }${NC}"
  echo ""
  echo "3. Start your dev server:"
  echo -e "   ${BLUE}pnpm dev${NC}"
  echo ""
  echo -e "See: ${BLUE}$MONOREPO_ROOT/specs/TURBOPACK_SYMLINK_FIX.md${NC} for details"
  echo ""
fi
