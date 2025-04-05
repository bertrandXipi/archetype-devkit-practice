#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
# Reads component and theme directory paths from environment variables, using defaults if not set.
# Ensure required variables (SHOPIFY_THEME_NAME, SHOPIFY_STORE) are exported before running.
COMPONENTS_DIR="${DEVKIT_COMPONENTS_DIR:-./reference-components}"
THEME_DIR="${DEVKIT_THEME_DIR:-./reference-theme}"
# Required: Export these environment variables (e.g., from your .env file using 'source .env' or 'export $(...)')
SHOPIFY_THEME_NAME="${DEVKIT_SHOPIFY_THEME_NAME:?Error: DEVKIT_SHOPIFY_THEME_NAME environment variable is not set}"
SHOPIFY_STORE="${DEVKIT_SHOPIFY_STORE:?Error: DEVKIT_SHOPIFY_STORE environment variable is not set}"
# --- End Configuration ---

# Check if the component name argument was provided
if [ -z "$1" ]; then
  echo "Error: Component name argument is required."
  echo "Usage: $0 <component-name>" # Use $0 for the script name itself
  exit 1
fi

COMPONENT_NAME="$1"

echo ">>> Updating component '$COMPONENT_NAME' in theme '$SHOPIFY_THEME_NAME'..."

# Step 1 & 2: Navigate to components directory, map the specific component, and copy updates
echo "--- Mapping component '$COMPONENT_NAME' and copying updates from $COMPONENTS_DIR ---"
pushd "$COMPONENTS_DIR" > /dev/null
# Map the specified component to update the manifest in the theme directory
shopify theme component map "../${THEME_DIR#./}" "$COMPONENT_NAME"
# Copy all files based on the updated manifest (effectively copying the changes for $COMPONENT_NAME)
shopify theme component copy "../${THEME_DIR#./}"
popd > /dev/null

# Step 3 & 4: Navigate to theme directory and generate the import map
echo "--- Generating Import Map in $THEME_DIR ---"
pushd "$THEME_DIR" > /dev/null
# Optional: Clean unused component files (uncomment if needed)
# shopify theme component clean .
shopify theme generate import-map .

# Step 5: Push theme changes to the specified Shopify theme (always run from theme directory)
echo "--- Pushing theme '$SHOPIFY_THEME_NAME' to Shopify store '$SHOPIFY_STORE' ---"
shopify theme push --theme "$SHOPIFY_THEME_NAME" --store "$SHOPIFY_STORE"

popd > /dev/null # Return to the original directory where the script was called

echo ">>> Component '$COMPONENT_NAME' update process finished for theme '$SHOPIFY_THEME_NAME'."