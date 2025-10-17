# Personal Neovim Configuration

My personal Neovim configuration, built on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) with extensive customizations for modern development workflows.

## Overview

This configuration provides a fast, IDE-like experience with:

- **LSP**: Language servers for Python, TypeScript/JavaScript, Lua, JSON
- **Completion**: Modern completion with blink.cmp and snippet support
- **Git Integration**: fugitive, diffview, gitsigns for comprehensive git workflows
- **Fuzzy Finding**: Telescope with fzf-native for blazing fast file/content search
- **Terminal Management**: toggleterm with pre-configured specialized terminals (lazygit, REPL, htop)
- **Smart Folding**: nvim-ufo with LSP and TreeSitter integration
- **And much more**: See [lua/README.md](lua/README.md) for complete documentation

## Quick Start

### Prerequisites

- **Neovim**: v0.9.0+ (stable or nightly recommended)
- **Git**: For plugin management
- **A Nerd Font**: For icons (set `vim.g.have_nerd_font = true` in [lua/core.lua](lua/core.lua))
- **ripgrep**: For Telescope live grep (`brew install ripgrep` on macOS)
- **fd**: Optional, for faster file finding (`brew install fd` on macOS)

### Installation

1. **Backup your existing Neovim config** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   mv ~/.local/share/nvim ~/.local/share/nvim.backup
   ```

2. **Clone this repository**:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

3. **Start Neovim**:
   ```bash
   nvim
   ```

   Lazy.nvim will automatically install all plugins on first launch.

4. **Install language servers**:
   - Open `:Mason` and ensure required LSPs are installed
   - Or wait for automatic installation via `mason-tool-installer`

5. **Check health**:
   ```vim
   :checkhealth
   ```

### Language-Specific Setup

#### Python
Install Python tooling:
```bash
# Via Mason (recommended - automatic)
# Or manually:
pip install python-lsp-server pylsp-mypy python-lsp-ruff ruff
```

#### TypeScript/JavaScript
```bash
npm install -g typescript typescript-language-server
```

#### Lua
Lua LSP (lua_ls) is auto-installed via Mason with Neovim API support.

## Configuration Structure

```
.
├── init.lua                 # Entry point, loads lazy.nvim and plugins
├── lua/
│   ├── README.md           # Detailed configuration documentation
│   ├── core.lua            # Core settings and keymaps
│   ├── kickstart/          # Original kickstart plugins
│   └── plugins/            # Custom plugin configurations
│       ├── completion.lua  # blink.cmp setup
│       ├── dashboard.lua   # Startup screen
│       ├── editor.lua      # Editor enhancements
│       ├── lsp.lua         # LSP configuration
│       ├── neo-tree.lua    # File explorer
│       └── ui.lua          # Theme and statusline
└── TODO.md                 # Planned improvements
```

**For detailed documentation**, see [lua/README.md](lua/README.md).

## Key Features

### Keybinding Philosophy

Leader key is `<Space>`. Keybindings are organized by prefix:

- `<leader>s*` → **Search** (Telescope)
- `<leader>g*` → **Git** (fugitive, diffview, gitsigns)
- `<leader>t*` → **Terminal/Toggle** (toggleterm)
- `<leader>e` → **Explorer** (Neo-tree)
- `gr*` → **LSP goto** (references, definition, etc.)
- `gc*` / `gb*` → **Comment** (line/block)
- `sa*` / `sd*` / `sr*` → **Surround** (add/delete/replace)

See `:Telescope keymaps` for a complete list.

### Essential Keybindings

**General**:
- `jj` → Exit insert mode
- `<Esc>` → Clear search highlights
- `<C-hjkl>` → Navigate between windows

**File Navigation**:
- `<leader>sf` → Search files
- `<leader>sF` → Search ALL files (including ignored)
- `<leader>sg` → Live grep
- `<leader>e` → Toggle file explorer

**Git**:
- `<leader>gs` → Git status
- `<leader>gdo` → Open diffview
- `<leader>tg` → Toggle lazygit

**Terminal**:
- `<leader>tt` → Toggle terminal
- `<leader>tf` → Floating terminal
- `<leader>tp` → Python REPL
- `<C-\>` → Quick toggle terminal

**LSP** (when attached):
- `grn` → Rename symbol
- `gra` → Code actions
- `grd` → Go to definition
- `grr` → Find references
- `K` → Hover documentation or peek fold

## Customizations Beyond Kickstart

This configuration extends kickstart.nvim with:

1. **Advanced Git Workflow**
   - vim-fugitive for git commands
   - diffview.nvim for visual diff/merge
   - Extensive git keymaps

2. **Modern Completion**
   - blink.cmp (faster than nvim-cmp)
   - friendly-snippets integration
   - LuaSnip snippet engine

3. **Enhanced Editor Features**
   - nvim-ufo for intelligent folding
   - toggleterm with specialized terminals
   - Comment.nvim with TreeSitter awareness
   - mini.ai and mini.surround for text objects

4. **UI Improvements**
   - dashboard-nvim startup screen
   - Instant which-key (0ms delay)
   - todo-comments highlighting

5. **Python Development**
   - Dual LSP (pylsp + ruff)
   - Type checking with mypy
   - Fast linting/formatting with ruff

See [lua/README.md](lua/README.md) for complete details.

## Maintenance

### Updating Plugins

```vim
:Lazy update
```

### Updating Language Servers

```vim
:Mason
" Then use 'U' to update all
```

### Checking Configuration Health

```vim
:checkhealth
```


## Acknowledgments

- **[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)**: Foundation and excellent starting point
- **[lazy.nvim](https://github.com/folke/lazy.nvim)**: Plugin manager by @folke
- **Neovim community**: For amazing plugins and documentation

## License

This configuration is based on kickstart.nvim (MIT License). My customizations are provided as-is for personal use.

## Documentation

- [📋 Full Keybindings Reference](KEYBINDINGS.md) - Complete keybinding cheatsheet
- [🔧 Detailed Configuration Guide](lua/README.md) - In-depth documentation

## Getting Help

- `:help` - Neovim's built-in help (excellent!)
- `:Telescope help_tags` - Search all help documentation
- `:checkhealth` - Diagnose configuration issues
- [lua/README.md](lua/README.md) - Detailed configuration docs
