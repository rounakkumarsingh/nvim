# My Neovim Configuration

This is a personal Neovim configuration tailored for efficiency and a smooth development workflow. It is built using Lua and managed by the `lazy.nvim` plugin manager.

## Structure

The configuration is organized as follows:

- `init.lua`: The main entry point of the configuration.
- `lua/rounakkumarsingh/`: Core configuration files.
  - `set.lua`: Basic Neovim options (`:set`).
  - `remap.lua`: Global keymappings.
- `lua/config/lazy.lua`: The setup and configuration for the `lazy.nvim` plugin manager.
- `lua/plugins/`: Individual plugin configurations. Each file in this directory corresponds to a plugin or a group of related plugins.

## Features

- **Plugin Management**: Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for fast startup times and easy plugin management.
- **LSP**: Integrated Language Server Protocol support via `nvim-lspconfig`.
- **Completion**: Autocompletion powered by `nvim-cmp`.
- **Fuzzy Finding**: File and text searching with `telescope.nvim`.
- **Git Integration**: Seamless Git integration through `fugitive.lua`.
- **Syntax Highlighting**: Advanced syntax highlighting with `nvim-treesitter`.
- **Formatting**: Code formatting on save using `conform.nvim`.

## Installation

1.  **Prerequisites**:
    -   [Neovim](https://github.com/neovim/neovim) (v0.8.0 or newer is recommended).
    -   `git` for cloning the repository.
    -   A Nerd Font (optional, but recommended for UI icons).

2.  **Backup your existing configuration** (if any):
    ```bash
    # Backup your current nvim config
    mv ~/.config/nvim ~/.config/nvim.bak
    
    # Backup your local nvim data
    mv ~/.local/share/nvim ~/.local/share/nvim.bak
    ```

3.  **Clone the repository**:
    ```bash
    git clone <your-repo-url> ~/.config/nvim
    ```

4.  **Launch Neovim**:
    ```bash
    nvim
    ```
    
    On the first launch, `lazy.nvim` will automatically install all the plugins.

## Plugins Overview

This configuration includes, but is not limited to, the following plugins:

-   **`cmp.lua`**: `nvim-cmp` for completion.
-   **`conform.lua`**: `conform.nvim` for formatting.
-   **`fugitive.lua`**: `vim-fugitive` for Git commands.
-   **`harpoon.lua`**: `ThePrimeagen/harpoon` for quick file navigation.
-   **`lsp.lua`**: `nvim-lspconfig` for LSP setup.
-   **`telescope.lua`**: `telescope.nvim` for fuzzy finding.
-   **`treesitter.lua`**: `nvim-treesitter` for parsing and syntax highlighting.
-   **`undotree.lua`**: `undotree` for visualizing the undo history.
-   **`tools.lua`**: Various development tools and utilities.
