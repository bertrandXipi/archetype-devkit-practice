      
#!/usr/bin/env bash

set -e

# --- Configuration ---
COMPONENTS_DIR="${DEVKIT_COMPONENTS_DIR:-./reference-components}"
THEME_DIR="${DEVKIT_THEME_DIR:-./reference-theme}" 
SHOPIFY_THEME_NAME="${DEVKIT_SHOPIFY_THEME_NAME:?Erreur: DEVKIT_SHOPIFY_THEME_NAME non définie}"
SHOPIFY_STORE="${DEVKIT_SHOPIFY_STORE:?Erreur: DEVKIT_SHOPIFY_STORE non définie}"
# --- Fin Configuration ---

if [ -z "$1" ]; then
  echo "Erreur : Vous devez spécifier le nom du composant à mettre à jour."
  echo "Usage: ./update-component.sh <nom-du-composant>"
  exit 1
fi

COMPONENT_NAME="$1"

echo ">>> Mise à jour du composant '$COMPONENT_NAME' dans le thème '$SHOPIFY_THEME_NAME'..."

# Étape 1 & 2: Aller dans le dossier composants, mapper et copier
echo "--- Mapping et copie depuis $COMPONENTS_DIR ---"
pushd "$COMPONENTS_DIR" > /dev/null
# CORRECTION ICI AUSSI pour le chemin de destination de copy
shopify theme component map "../${THEME_DIR#./}" "$COMPONENT_NAME" 
# CORRECTION ICI : Supprimer $COMPONENT_NAME de la commande copy
shopify theme component copy "../${THEME_DIR#./}" 
popd > /dev/null

# Étape 3 & 4: Aller dans le dossier thème et générer l'import map
echo "--- Génération Import Map dans $THEME_DIR ---"
pushd "$THEME_DIR" > /dev/null
shopify theme generate import-map .

# Étape 5: Pousser les changements vers Shopify (toujours depuis le dossier thème)
echo "--- Poussée du thème vers Shopify ($SHOPIFY_THEME_NAME sur $SHOPIFY_STORE) ---"
shopify theme push --theme "$SHOPIFY_THEME_NAME" --store "$SHOPIFY_STORE"

popd > /dev/null

echo ">>> Mise à jour terminée pour le composant '$COMPONENT_NAME'."

    