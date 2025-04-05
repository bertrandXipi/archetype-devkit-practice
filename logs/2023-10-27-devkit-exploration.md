# Logbook Entry - 2023-10-27.

## Topic: Archetype Devkit Initial Exploration & Setup

This documents the initial steps taken to set up the development environment, understand the workflow, and overcome initial challenges while learning the Archetype Devkit.

### 1. Initial Setup & Plugin Installation:

*   **Objective:** Set up the basic project structure and install the necessary Shopify CLI plugin for Devkit.
*   **Actions Taken:**
    *   Initialized a local Git repository (`archetype-devkit-practice`).
    *   Created a corresponding repository on GitHub (`bertrandXipi/archetype-devkit-practice`).
    *   Created a `.gitignore` file with standard exclusions for Shopify/Node.js projects (e.g., `node_modules/`, `.shopify/`, `.env`) to prevent tracking unnecessary or sensitive files.
    *   Attempted to install the Devkit plugin using `shopify theme component plugin install`, which failed (command not found).
    *   Successfully installed the required plugin using the correct command: `shopify plugins install plugin-devkit` (or `plugin-devkit@shopify/cli`). Verified installation.
    *   Linked the local repository to the remote GitHub repository using `git remote add origin https://github.com/bertrandXipi/archetype-devkit-practice.git`.
    *   Resolved an initial `git push` failure (`src refspec main does not match any`) by pulling the remote `main` branch first (`git pull origin main`), likely created empty on GitHub, to establish the local branch history.

### 2. Fundamental Devkit Workflow Understanding:

*   **Objective:** Grasp the core concept of how components and themes interact within the Devkit architecture.
*   **Outcome:** Clarified that the primary development of reusable **components** (their logic, base styles, structure) occurs within the `reference-components` repository (or a fork). These developed components are then **installed** or **integrated** into a specific theme repository (like `reference-theme` or a custom client theme) using Devkit commands, allowing for separation of concerns.

### 3. Overcoming Component Installation Challenges & Discovering the Manual Workflow:

*   **Objective:** Install the reference components into the reference theme using the documented command.
*   **Challenge:** The documented command `shopify theme component install --components-path="../reference-components"` consistently failed with a `Nonexistent flag: --components-path` error, indicating the documentation was out of sync with the installed plugin version.
*   **Troubleshooting & Discovery:**
    *   Analyzing the help output (`--help`) for `install`, `map`, and `copy` revealed their actual arguments and lack of a `--components-path` flag.
    *   Experimentation showed that `map` and `copy` sub-commands (used internally by `install`) expected to be run from the *source* (`reference-components`) directory when determining component files, while `clean` and `generate import-map` expected to be run from the *theme* (`reference-theme`) directory. This explained why `install` failed regardless of the execution directory.
    *   **Solution Found:** A working **manual sequence** was established to replicate the `install` process correctly:
        1.  `cd path/to/reference-components`
        2.  `shopify theme component map ../reference-theme [component-name]` (Maps component(s) to the theme manifest; component name is optional for `map`)
        3.  `shopify theme component copy ../reference-theme` (Copies files based on manifest; does NOT take component name argument)
        4.  `cd path/to/reference-theme`
        5.  `shopify theme component clean .` (Optional, cleans unused files in the theme)
        6.  `shopify theme generate import-map .` (Generates JS import map in the theme)
*   **Outcome:** Successfully installed the components into the local `reference-theme` using this manual workflow.

### 4. Mastering Git Forks & Remote Management:

*   **Objective:** Enable pushing local changes to personal copies of the Devkit repositories on GitHub.
*   **Challenge:** Encountered `403 Forbidden` errors when attempting to `git push` changes from local clones of `reference-theme` and `reference-components`.
*   **Diagnosis:** Realized pushes were directed towards the original Archetype Themes repositories, where write permissions were denied.
*   **Solution:**
    *   **Forked** both `archetype-themes/reference-theme` and `archetype-themes/reference-components` repositories on GitHub under the personal account (`bertrandXipi`).
    *   **Reconfigured local remotes:** Used `git remote set-url origin <URL_of_personal_fork>` in both the `reference-theme` and `reference-components` local directories to point `origin` to the corresponding personal forks on GitHub.
    *   Corrected the `origin` remote URL for the `archetype-devkit-practice` repository itself, which had been mistakenly pointed elsewhere during troubleshooting.
*   **Outcome:** Successfully configured all three local repositories (`practice`, `theme` fork, `components` fork) to push to their respective correct remote repositories on the `bertrandXipi` GitHub account.

### 5. Workflow Automation & Scripting:

*   **Objective:** Automate the repetitive manual component update workflow (map, copy, generate, push).
*   **Action Taken:** Created a Bash script (`update-component.sh`) to execute the required sequence of commands.
*   **Refinement & Debugging:**
    *   Granted execution permissions using `chmod +x update-component.sh`.
    *   Corrected relative path issues encountered when the script changed directories (using `../` explicitly when running `map`/`copy` from the components directory).
    *   Fixed the script to remove the invalid component name argument from the `shopify theme component copy` command line.
    *   Implemented secure handling of sensitive/environment-specific configuration (Shopify store URL, target theme name) using **environment variables** loaded from an untracked `.env` file (using `set -a && source .env && set +a`), preventing credentials from being committed to Git.
*   **Outcome:** Developed a functional and reusable script to update a specific component in the theme and push the changes to Shopify with a single command (`./update-component.sh <component-name>`).

### 6. Exploring Development Environments & CSS Strategy:

*   **Objective:** Understand the different ways to view component changes and how CSS should be managed.
*   **Exploration:**
    *   Used the **Component Explorer** via `shopify theme component dev` (run from `reference-components`). Acknowledged its benefit for **rapid, isolated component development** and testing component logic/settings.
    *   Identified the Component Explorer's key limitation: it **lacks the global CSS context** (variables, base styles, overrides) of the main theme, leading to visual discrepancies.
    *   Used the **Theme Development Server** via `shopify theme dev` (run from `reference-theme`) and `shopify theme push` to view components **within the full theme context**, confirming visual integration.
*   **Clarified CSS Strategy:**
    *   **Component Level (`reference-components`):** CSS should define the component's **base structure, internal layout, and essential functional styles**. It **must use global CSS variables/tokens** (e.g., `var(--color-text)`) for themable properties (colors, fonts, spacing) rather than hardcoding values. The goal is a *generic, adaptable, functionally sound* component.
    *   **Theme Level (`reference-theme` / Client Theme):** CSS here is responsible for **defining the actual values of the global CSS variables/tokens** (branding), providing **theme-specific overrides** to fine-tune component appearance, and managing **layout/spacing *between* components/sections**.
