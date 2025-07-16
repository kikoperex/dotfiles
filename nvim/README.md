# My Neovim Configuration

Welcome to my new, organized Neovim configuration! This `README.md` serves as a comprehensive guide to understanding, installing, and customizing my Neovim setup. Whether you're new to Neovim or just looking to understand this specific configuration, this document will walk you through everything.

## Table of Contents

1.  [What is Neovim?](#what-is-neovim)
2.  [My Configuration Philosophy](#my-configuration-philosophy)
3.  [Prerequisites](#prerequisites)
4.  [Installation Guide](#installation-guide)
    *   [Step 1: Getting My Configuration](#step-1-getting-my-configuration)
    *   [Step 2: Install Packer (My Plugin Manager)](#step-2-install-packer-my-plugin-manager)
    *   [Step 3: Install My Plugins](#step-3-install-my-plugins)
    *   [Step 4: Install Treesitter Parsers](#step-4-install-treesitter-parsers)
5.  [Understanding My Configuration Structure](#understanding-my-configuration-structure)
    *   [`init.lua`](#initlua)
    *   [`lua/user/options.lua`](#luauseroptionslua)
    *   [`lua/user/keymaps.lua`](#luauserkeymapslua)
    *   [`lua/user/plugins.lua`](#luauserpluginslua)
    *   [`lua/user/colors.lua`](#luausercolorslua)
    *   [`lua/user/treesitter.lua`](#luausertreesitterlua)
    *   [`lua/user/autocmds.lua`](#luauserautocmdslua)
6.  [Key Components Explained](#key-components-explained)
    *   [Lua: My Configuration Language](#lua-my-configuration-language)
    *   [Packer: My Plugin Manager](#packer-my-plugin-manager)
    *   [Treesitter: Advanced Syntax Highlighting and Text Objects](#treesitter-advanced-syntax-highlighting-and-text-objects)
    *   [Pywal Integration: Dynamic Theming](#pywal-integration-dynamic-theming)
    *   [Autocommands: Automating My Tasks](#autocommands-automating-my-tasks)
7.  [Customization Guide](#customization-guide)
    *   [Changing My Options](#changing-my-options)
    *   [Modifying My Keybindings](#modifying-my-keybindings)
    *   [Adding/Removing My Plugins](#addingremoving-my-plugins)
    *   [Adjusting My Colors](#adjusting-my-colors)
    *   [Treesitter Customization](#treesitter-customization)
8.  [Troubleshooting and FAQ](#troubleshooting-and-faq)

---

## 1. What is Neovim?

Neovim is a modern, extensible Vim-based text editor. It's built for speed, efficiency, and extensibility, allowing users to customize almost every aspect of their editing experience. Unlike traditional IDEs, Neovim is primarily keyboard-driven, which can significantly speed up your workflow once you learn its commands and shortcuts.

My configuration leverages Neovim's Lua scripting capabilities to provide a clean, modular, and powerful editing environment.

## 2. My Configuration Philosophy

The goal of my configuration is to provide a well-structured, understandable, and easily extensible Neovim setup. I follow a modular approach, where different aspects of the configuration (options, keymaps, plugins, colors, etc.) are separated into their own files. This makes it easier for me to:

*   **Understand**: Each file has a clear purpose.
*   **Maintain**: Changes in one area are less likely to affect others.
*   **Extend**: I can easily add new features or modify existing ones without cluttering a single large file.

## 3. Prerequisites

Before you begin, ensure you have the following installed on your system:

*   **Neovim**: Version 0.7.0 or higher is recommended. You can download it from the [Neovim GitHub releases page](https://github.com/neovim/neovim/releases) or install it via your system's package manager.
*   **Git**: Used for cloning this repository and managing plugins.
*   **`unzip`**: Required by Packer for some plugin installations.
*   **A C compiler (like GCC) and Make**: Required for Treesitter to compile parsers.
*   **Node.js and npm (or yarn)**: Required for some language servers (e.g., `tsserver` for TypeScript) and autocompletion plugins.
*   **Python 3 and `pip`**: Required for some language servers (e.g., `pyright` for Python).

## 4. Installation Guide

Follow these steps to get my Neovim configuration up and running.

### Step 1: Getting My Configuration

First, ensure your existing Neovim configuration (if any) is backed up or removed from `~/.config/nvim/`. Since I wanted a fresh start, I assumed `~/.config/nvim/` was empty or could be overwritten.

```bash
# Ensure the target directory is clean (use with caution!)
rm -rf ~/.config/nvim

# Create the directory
mkdir -p ~/.config/nvim

# Copy the configuration files into the new directory
# (Assuming you are in the directory where the agent created the files, e.g., /home/patitomora/.config/nvim)
# If you are in your home directory, you would copy from .config/nvim.bak to .config/nvim
# For this specific scenario, the agent has already written the files directly to ~/.config/nvim/
# So, this step is more for future reference if you were to clone a repo.
```

**Note**: The agent has already written the files directly to `~/.config/nvim/` for me, so I didn't need to manually copy them. This step is primarily for future reference if I were to clone this configuration from a Git repository.

### Step 2: Install Packer (My Plugin Manager)

Packer is my Neovim plugin manager written in Lua. It's responsible for downloading and managing all the additional features (plugins) that extend Neovim's functionality.

Open Neovim for the first time with my new configuration:

```bash
nvim
```

You should see some messages indicating that Packer is being installed. If not, you might need to manually bootstrap it. My `lua/user/plugins.lua` file contains a bootstrap function that should handle this automatically.

### Step 3: Install My Plugins

Once Packer is installed, I need to tell it to install all the plugins defined in my configuration.

While inside Neovim, run the following command:

```vim
:PackerSync
```

This command will:
*   Download and install all the plugins listed in `lua/user/plugins.lua`.
*   Compile any necessary components for the plugins.

You might see some output in a new window showing the installation progress. Wait for it to complete.

### Step 4: Install Treesitter Parsers

Treesitter requires language parsers to function correctly. These are installed separately.

While inside Neovim, run:

```vim
:TSUpdate
```

This command will download and compile the necessary parsers for the languages specified in `lua/user/treesitter.lua`.

After these steps, restart Neovim to ensure all changes take effect:

```bash
nvim
```

## 5. Understanding My Configuration Structure

My Neovim configuration is organized into a modular structure within the `~/.config/nvim/` directory. Here's a breakdown of each file and its purpose:

```
~/.config/nvim/
├── init.lua
└── lua/
    └── user/
        ├── autocmds.lua
        ├── colors.lua
        ├── keymaps.lua
        ├── options.lua
        ├── plugins.lua
        └── treesitter.lua
```

### `init.lua`

This is the main entry point for my Neovim configuration. When Neovim starts, it first loads this file. Its primary role is to:

*   Set global Neovim variables (like `mapleader`).
*   Load all other configuration modules from the `lua/user/` directory using `require()`.

**What it does:** It acts as the central hub, orchestrating the loading of all other configuration pieces.

### `lua/user/options.lua`

This file is dedicated to setting Neovim's global and window-specific options. These options control various aspects of Neovim's behavior, appearance, and editing features.

**What it does:**
*   `vim.opt.number = true`: Displays line numbers.
*   `vim.wo.relativenumber = true`: Displays relative line numbers (e.g., `1` for the current line, `2` for the line above/below).
*   `vim.opt.signcolumn = "no"`: Prevents a sign column from appearing (where diagnostic signs or git signs might show).
*   `vim.opt.cursorline = false`: Disables highlighting the current line.
*   `vim.opt.ignorecase = true`: Makes searches case-insensitive.
*   `vim.opt.smartcase = true`: If `ignorecase` is true, but my search pattern contains uppercase characters, the search becomes case-sensitive.
*   `vim.opt.hlsearch = false`: Disables highlighting all matches after a search.
*   `vim.opt.swapfile = false`: Prevents Neovim from creating swap files.
*   `vim.opt.undofile = true`: Enables persistent undo, allowing me to undo changes even after closing and reopening a file.
*   `vim.opt.autoread = true`: Automatically reloads files if they are changed outside Neovim.
*   `vim.opt.scrolloff = 8`: Keeps 8 lines of context above and below the cursor when scrolling.
*   `vim.opt.colorcolumn = "80"`: Displays a vertical line at column 80, often used as a visual guide for line length.
*   `vim.opt.smartindent = true`: Automatically indents new lines.
*   `vim.cmd('filetype plugin indent on')`: Enables filetype-specific plugins and indentation.

### `lua/user/keymaps.lua`

This file defines all my custom keybindings (shortcuts) for Neovim. Keybindings allow me to execute commands or perform actions with a simple key combination.

**What it does:**
*   `vim.keymap.set()`: This function is used to define key mappings.
    *   The first argument (`'n'`, `'v'`, `'o'`, `'x'`) specifies the mode in which the keymap is active (normal, visual, operator-pending, visual block).
    *   The second argument is the key combination I want to map (e.g., `<leader>f`, `<C-d>`).
    *   The third argument is the action to perform (e.g., `vim.cmd.Ex`, `builtin.find_files`).
    *   The optional fourth argument is a table for options like `silent = true` (prevents command from being echoed) and `desc` (a description for `:h keymap-list`).
*   **`<leader>` key**: My `mapleader` is set to `<Space>` (the spacebar) in `init.lua`. This means `<leader>pf` translates to `<Space>pf`.
*   **Telescope mappings**: Shortcuts for `Telescope`, a fuzzy finder plugin.
*   **Movement remapping**: My custom remapping of `h`, `j`, `k`, `l` to `j`, `k`, `l`, `ñ` (and their uppercase versions) for movement, and `K`, `L` in visual mode for moving selected lines.
*   **Centering cursor**: Remaps `Ctrl-d` and `Ctrl-u` to center the cursor after half-page scrolls.
*   **Search result centering**: Remaps `n` and `N` to center the cursor after jumping to the next/previous search result.
*   **Paste without clobbering register**: A useful mapping for pasting without overwriting my default register.

### `lua/user/plugins.lua`

This file is where I declare and configure all the plugins I want to use in Neovim. It uses `Packer`, a plugin manager, to handle the installation and loading of these plugins.

**What it does:**
*   `ensure_packer()`: A bootstrap function that checks if Packer itself is installed. If not, it clones the Packer repository.
*   `require('packer').startup(function(use)...end)`: This block defines all my plugins.
    *   `use 'owner/repo'`: This is how I specify a plugin from GitHub.
    *   `tag = '...'` or `branch = '...'`: Specifies a particular version or branch of the plugin.
    *   `requires = { ... }`: Declares dependencies for a plugin.
    *   `run = function()...end`: Executes a command after the plugin is installed or updated (e.g., for Treesitter).
    *   `config = function()...end`: Runs Lua code after the plugin is loaded, allowing for plugin-specific configuration.

**Plugins included:**
*   `wbthomason/packer.nvim`: The plugin manager itself.
*   `nvim-telescope/telescope.nvim`: A highly extensible fuzzy finder.
*   `nvim-treesitter/nvim-treesitter`: Provides advanced syntax highlighting and parsing.
*   `nvim-treesitter/nvim-treesitter-textobjects`: Extends Treesitter to define "text objects" (e.g., functions, classes) for easier selection and manipulation.
*   `ThePrimeagen/vim-be-good`: A plugin for practicing Vim motions.
*   `szymonwilczek/vim-be-better`: Another plugin for Vim practice.
*   `neovim/nvim-lspconfig`: Provides configurations for various Language Servers (LSP).
*   `lervag/vimtex`: A comprehensive plugin for LaTeX editing.

### `lua/user/colors.lua`

This file handles the integration with `pywal`, a tool that generates a color scheme from my wallpaper and applies it to my terminal and applications. This file ensures that Neovim also uses these dynamic colors.

**What it does:**
*   `apply_wal_colors()`: This function is responsible for:
    *   Sourcing `~/.cache/wal/colors-wal.vim`: This file is generated by `pywal` and contains Vim variables with my current color scheme.
    *   Extracting colors: It reads the color values from the sourced Vim variables.
    *   Setting Neovim highlights: It uses `vim.api.nvim_set_hl()` to apply these colors to various Neovim UI elements and Treesitter highlight groups. This ensures my Neovim theme matches my system's `pywal` theme.
*   Initial call to `apply_wal_colors()`: Ensures colors are applied when Neovim starts.

### `lua/user/treesitter.lua`

This file configures `nvim-treesitter`, a powerful plugin that uses tree-sitter parsers to provide more accurate syntax highlighting, indentation, and define "text objects" based on the code's structure.

**What it does:**
*   `require('nvim-treesitter.configs').setup({...})`: This is the main setup function for Treesitter.
    *   `ensure_installed`: A list of languages for which Treesitter parsers should be installed.
    *   `sync_install`: Whether to install parsers synchronously.
    *   `auto_install`: Automatically installs missing parsers when I open a file of that type.
    *   `highlight.enable = true`: Enables Treesitter-based syntax highlighting.
    *   `indent.enable = true`: Enables Treesitter-based indentation.
    *   `textobjects`: Configures Treesitter text objects, which allow me to select, delete, or change code blocks based on their semantic meaning (e.g., a function, a class, a loop).

### `lua/user/autocmds.lua`

This file defines "autocommands" (short for automatic commands). Autocommands are events that trigger specific actions in Neovim. They are useful for automating tasks based on certain conditions or events.

**What it does:**
*   `vim.api.nvim_create_autocmd("ColorScheme", {...})`: This autocommand listens for the `ColorScheme` event.
    *   `pattern = "*"`: Means it triggers for any colorscheme change.
    *   `callback = function()...end`: The function that runs when the event occurs. In this case, it calls `apply_wal_colors` from `lua/user/colors.lua` after a small delay. This ensures that if my `pywal` theme changes (and thus the colorscheme is reloaded), Neovim's highlights are updated accordingly.

## 6. Key Components Explained

### Lua: My Configuration Language

Neovim's configuration is primarily written in Lua, a lightweight, powerful, and fast scripting language. Using Lua allows for more programmatic and flexible configurations compared to traditional Vimscript.

*   **`vim.opt`**: This is a Lua table that provides access to Neovim's options. I can set options like `vim.opt.number = true` or `vim.opt.tabstop = 4`.
*   **`vim.cmd()`**: Allows me to execute Vimscript commands directly from Lua. For example, `vim.cmd('colorscheme default')`.
*   **`vim.api.nvim_set_keymap()` / `vim.keymap.set()`**: Functions for defining keybindings.
*   **`require('module_name')`**: This is how Lua modules are loaded. When I see `require('user.options')`, it means Neovim is looking for a file named `options.lua` inside the `lua/user/` directory.

### Packer: My Plugin Manager

Packer is a modern, fast, and easy-to-use plugin manager for Neovim, written in Lua. It simplifies the process of adding, updating, and removing plugins.

**Why use a plugin manager?**
*   **Easy Installation**: No manual cloning or path management.
*   **Dependency Management**: Handles plugins that depend on other plugins.
*   **Lazy Loading**: Can load plugins only when they are needed, speeding up Neovim's startup time.
*   **Updates**: Simplifies updating all my plugins with a single command (`:PackerSync`).

### Treesitter: Advanced Syntax Highlighting and Text Objects

Treesitter is a parsing framework that builds a concrete syntax tree for my code. Unlike traditional regex-based syntax highlighting, Treesitter understands the *structure* of my code.

**Benefits:**
*   **Accurate Highlighting**: More precise and robust syntax highlighting, especially for complex languages or nested structures.
*   **Better Indentation**: Improves automatic indentation based on the code's actual structure.
*   **Text Objects**: Enables powerful text objects (e.g., selecting an entire function, a class, or a loop) that are semantically aware, making code manipulation much more efficient.

### Pywal Integration: Dynamic Theming

`pywal` is a tool that generates a color scheme from an image (my wallpaper) and applies it system-wide to my terminal, applications, and even Neovim.

**How it works here:**
1.  I run `wal -i /path/to/my/wallpaper.jpg` in my terminal.
2.  `pywal` generates a `colors-wal.vim` file in `~/.cache/wal/`.
3.  My Neovim configuration sources this file and then uses the colors defined within it to set Neovim's highlight groups, ensuring my editor's theme matches my system's theme.
4.  The `ColorScheme` autocommand ensures that if my `pywal` theme changes while Neovim is open, the colors are reloaded.

### Autocommands: Automating My Tasks

Autocommands are a powerful feature in Neovim that allow me to execute commands automatically when certain events occur.

**Example:**
The `ColorScheme` autocommand in `lua/user/autocmds.lua` ensures that my `pywal` colors are reapplied whenever the colorscheme changes in Neovim. This is crucial for dynamic theming.

## 7. Customization Guide

This section will guide you on how to personalize my Neovim configuration.

### Changing My Options

To modify Neovim options, edit `~/.config/nvim/lua/user/options.lua`.

*   **Example: Change `scrolloff`**:
    ```lua
    -- Before
    opt.scrolloff = 8
    -- After (e.g., to keep 5 lines of context)
    opt.scrolloff = 5
    ```
*   **Example: Enable `relativenumber` only when in normal mode**:
    ```lua
    -- In options.lua, remove:
    -- opt.relativenumber = true

    -- Add this to lua/user/autocmds.lua
    vim.api.nvim_create_autocmd({"InsertLeave", "WinEnter"}, {
      callback = function()
        if vim.wo.number and vim.opt.relativenumber:get() then
          vim.wo.relativenumber = true
        end
      end
    })
    vim.api.nvim_create_autocmd({"InsertEnter", "WinLeave"}, {
      callback = function()
        vim.wo.relativenumber = false
      end
    })
    ```

### Modifying My Keybindings

To change or add keybindings, edit `~/.config/nvim/lua/user/keymaps.lua`.

*   **Example: Change Telescope find files keybinding**:
    ```lua
    -- Before
    map('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
    -- After (e.g., to use <leader>ff)
    map('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    ```
*   **Example: Add a new keybinding to save a file**:
    ```lua
    map('n', '<leader>w', vim.cmd.write, { desc = 'Save current file' })
    ```

### Adding/Removing My Plugins

To manage plugins, edit `~/.config/nvim/lua/user/plugins.lua`.

*   **Adding a new plugin**:
    1.  Find the plugin's GitHub repository (e.g., `github.com/user/my-plugin`).
    2.  Add a `use 'user/my-plugin'` line within the `packer.startup(function(use)...end)` block.
    3.  Save the file.
    4.  Open Neovim and run `:PackerSync`.

    ```lua
    -- Example: Adding a new plugin
    use 'tpope/vim-fugitive' -- A Git wrapper for Vim
    ```

*   **Removing a plugin**:
    1.  Remove the corresponding `use 'user/my-plugin'` line from `lua/user/plugins.lua`.
    2.  Save the file.
    3.  Open Neovim and run `:PackerClean` (to remove unused plugins) and then `:PackerSync`.

### Adjusting My Colors

My colors are dynamically loaded from `pywal`. If I want to change the base colors, I need to:

1.  Change my system wallpaper.
2.  Run `wal -i /path/to/new/wallpaper.jpg` in my terminal.
3.  Restart Neovim, or if Neovim is open, run `:colorscheme default` (or any other colorscheme) to trigger the `ColorScheme` autocommand and reload the `pywal` colors.

If I want to manually override specific highlight groups, I can do so in `lua/user/colors.lua` after the `apply_wal_colors()` function has been called.

### Treesitter Customization

To adjust Treesitter settings, edit `~/.config/nvim/lua/user/treesitter.lua`.

*   **Adding more languages**: Add the language name to the `ensure_installed` table.
    ```lua
    ensure_installed = {"c", "cpp", "python", "lua", "vim", "javascript", "go"}, -- Added "go"
    ```
    After adding, run `:TSUpdate` in Neovim.
*   **Disabling highlighting for a specific language**: Add the language name to the `highlight.disable` table.
    ```lua
    highlight = {
      enable = true,
      disable = { "latex", "markdown" }, -- Disabled markdown highlighting
    },
    ```
*   **Customizing text objects**: Modify the `textobjects` table to change or add new text object mappings.

## 8. Troubleshooting and FAQ

*   **Plugins not loading/working**:
    *   Ensure I ran `:PackerSync` after adding/modifying plugins.
    *   Check Neovim's messages (`:messages`) for any errors during startup or plugin loading.
    *   Verify that the plugin's name in `plugins.lua` matches its GitHub repository name exactly (e.g., `owner/repo`).
*   **Treesitter highlighting/indentation issues**:
    *   Ensure I ran `:TSUpdate` to install the necessary parsers.
    *   Check if the language is listed in `ensure_installed` in `treesitter.lua`.
    *   Verify that the language is not in the `highlight.disable` list.
*   **Colors not applying correctly**:
    *   Ensure `pywal` has generated `~/.cache/wal/colors-wal.vim`.
    *   Check if the `ColorScheme` autocommand is correctly defined in `autocmds.lua`.
    *   Try running `:source ~/.cache/wal/colors-wal.vim` and then `:lua require('user.colors').apply_wal_colors()` manually in Neovim to debug.
*   **Neovim starts slowly**:
    *   Consider lazy-loading plugins. Packer supports this by adding `event = '...'` or `ft = '...'` to my `use` statements in `plugins.lua`. For example, `use 'lervag/vimtex', ft = 'tex'` will only load `vimtex` when I open a `.tex` file.
*   **Where are my `init.vim` settings?**:
    *   This configuration uses Lua for everything. Most Vimscript settings have a direct Lua equivalent using `vim.opt`. If I have old Vimscript snippets, I'll need to translate them to Lua.

If you encounter any issues not covered here, feel free to consult the Neovim documentation (`:help`) or the documentation for specific plugins.

Happy Neovimming!