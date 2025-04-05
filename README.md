# archetype-devkit-practice

A practice repository for learning and experimenting with the Archetype Devkit for Shopify theme development.

## Purpose

This repository serves as a personal learning space to explore the features and capabilities of the Archetype Devkit. The goal is to gain practical experience in building and modifying Shopify themes using the Devkit's component-based approach.

## Contents

This repository may contain:

*   Custom theme components built using the Devkit.
*   Modifications and customizations made to the Archetype Reference Theme and Reference Components.
*   Experiments with different Devkit features and workflows.
*   Notes and documentation of the learning process.

## Getting Started

To get started with this repository and the Archetype Devkit:

1.  **Prerequisites:** Ensure you have Git, Node.js, npm, and the latest Shopify CLI installed.
2.  **Clone necessary repositories:**
    *   Clone this practice repository: `git clone https://github.com/yourgithubusername/archetype-devkit-practice.git` (Replace `yourgithubusername` with your actual GitHub username)
    *   Clone the official Devkit repositories, ideally placing them alongside this practice repo:
        *   `git clone https://github.com/archetype-themes/reference-theme.git`
        *   `git clone https://github.com/archetype-themes/reference-components.git`
3.  **Follow the Archetype Devkit documentation:** Refer to the official [Archetype Devkit documentation](https://github.com/archetype-themes/devkit) for detailed setup instructions (like installing the `plugin-devkit` via `shopify plugins install plugin-devkit`) and usage guidelines.
4.  **Set up a Shopify development store:** You will need a Shopify development store to preview and test your themes and components. Follow the instructions in the Devkit documentation for setting this up and configuring your environment (e.g., `.env` files if applicable).
5.  **Install Components into the Reference Theme (Important Workflow Note):**
    *   The documented `shopify theme component install` command with the `--components-path` flag may not work as expected or the flag might be non-existent in current plugin versions.
    *   **Use the following manual sequence to correctly install components:**

    ```bash
    # Navigate to the component source directory
    cd ../reference-components 
    # (Adjust path if your structure differs)

    # 1. Map components to the theme destination
    shopify theme component map ../reference-theme 

    # 2. Copy mapped components to the theme destination
    shopify theme component copy ../reference-theme

    # Navigate back to the theme destination directory
    cd ../reference-theme
    # (Adjust path if your structure differs)

    # 3. Clean unused component files within the theme
    shopify theme component clean .

    # 4. Generate the import map within the theme
    shopify theme generate import-map . 
    ```
    *   This sequence ensures each step is executed from the correct directory context required by the plugin.

6.  **Start experimenting:** Once components are installed, begin exploring the `reference-theme`, try modifying existing components in `reference-components`, or create your own following the guides in the "Getting Started" section of the Devkit documentation.

## Contributing

As this is a personal practice repository, contributions are not expected. However, if you have any suggestions or feedback, feel free to open an issue.

## License

MIT License

## Contact

Bertrand Vernot
bertrand@xipirons.com