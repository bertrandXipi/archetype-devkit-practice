#!/usr/bin/env bash
set -e

# --- Configuration (Read from the environment, with default values) ---

COMPONENTS_DIR="${DEVKIT_COMPONENTS_DIR:-./reference-components}"
THEME_DIR="${DEVKIT_THEME_DIR:-./reference-theme}"


SHOPIFY_THEME_NAME="${DEVKIT_SHOPIFY_THEME_NAME:?Error: DEVKIT_SHOPIFY_THEME_NAME not defined}"
SHOPIFY_STORE="${DEVKIT_SHOPIFY_STORE:?Error: DEVKIT_SHOPIFY_STORE not defined}"

# --- End Configuration ---

# Checks if a component name was provided as an argument
if [ -z "$1" ]; then
  echo "Error: You must specify the name of the component to update."
  echo "Usage: ./update-component.sh <component-name>"
  exit 1
fi

COMPONENT_NAME="$1"
echo ">>> Updating component '$COMPONENT_NAME' in theme '$SHOPIFY_THEME_NAME'..."


echo "--- Mapping and copying from $COMPONENTS_DIR ---"
pushd "$COMPONENTS_DIR" > /dev/null

shopify theme component map "$THEME_DIR" "$COMPONENT_NAME"
shopify theme component copy "$THEME_DIR" "$COMPONENT_NAME"
popd > /dev/null

echo "--- Generating Import Map in $THEME_DIR ---"
pushd "$THEME_DIR" > /dev/null
shopify theme generate import-map .
echo "--- Pushing theme to Shopify ($SHOPIFY_THEME_NAME on $SHOPIFY_STORE) ---"
shopify theme push --theme "$SHOPIFY_THEME_NAME" --store "$SHOPIFY_STORE"
popd > /dev/null

echo ">>> Update completed for component '$COMPONENT_NAME'." 