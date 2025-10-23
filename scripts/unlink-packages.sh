#!/usr/bin/env bash

# Unlink monorepo packages
#
# Usage:
#   ./scripts/unlink-packages.sh [package-names...]
#
# Examples:
#   # Unlink all packages
#   ./scripts/unlink-packages.sh
#
#   # Unlink specific packages
#   ./scripts/unlink-packages.sh @workspace/ui

set -e

# ============================================================================
# CONFIGURATION
# ============================================================================

# All linkable packages (should match link-packages.sh)
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

echo -e "${BLUE}Unlinking monorepo packages...${NC}"
echo ""

# Determine which packages to unlink
if [ $# -eq 0 ]; then
  # No specific packages provided, unlink all
  PACKAGES_TO_UNLINK=("${ALL_PACKAGES[@]}")
  echo -e "${YELLOW}No packages specified, unlinking all frontend packages${NC}"
else
  # Specific packages provided
  PACKAGES_TO_UNLINK=("$@")
  echo -e "${YELLOW}Unlinking specified packages${NC}"
fi

echo ""

# Unlink each package
UNLINKED_COUNT=0
SKIPPED_COUNT=0

for PACKAGE_NAME in "${PACKAGES_TO_UNLINK[@]}"; do
  echo -e "${BLUE}Unlinking $PACKAGE_NAME...${NC}"
  
  if pnpm unlink "$PACKAGE_NAME" 2>&1 | grep -q "Nothing to unlink"; then
    echo -e "${YELLOW}⊘ Not linked: $PACKAGE_NAME${NC}"
    ((SKIPPED_COUNT++))
  else
    echo -e "${GREEN}✓ Unlinked $PACKAGE_NAME${NC}"
    ((UNLINKED_COUNT++))
  fi
  
  echo ""
done

# Summary
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Unlinked: $UNLINKED_COUNT packages${NC}"
if [ $SKIPPED_COUNT -gt 0 ]; then
  echo -e "${YELLOW}⊘ Not linked: $SKIPPED_COUNT packages${NC}"
fi
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ $UNLINKED_COUNT -gt 0 ]; then
  echo -e "${YELLOW}Note: Reinstall dependencies to get packages from registry:${NC}"
  echo "  ${BLUE}pnpm install${NC}"
  echo ""
fi
