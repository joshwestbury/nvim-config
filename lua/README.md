# Neovim Lua Configuration

This directory contains the Lua configuration for my Neovim setup, built on top of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) with significant customizations and enhancements.

## Directory Structure

```
lua/
├── core.lua                 # Core Neovim settings and keymaps
├── kickstart/              # Original kickstart.nvim plugins (mostly untouched)
│   ├── health.lua          # Health check diagnostics
│   └── plugins/            # Kickstart plugin configurations
│       ├── autopairs.lua   # ⚠️ DUPLICATE - see TODO.md
│       ├── debug.lua       # DAP debugging setup
│       ├── gitsigns.lua    # Git signs in gutter
│       ├── indent_line.lua # Indentation guides
│       ├── lint.lua        # Linting configuration
│       └── neo-tree.lua    # ⚠️ DUPLICATE - see TODO.md
└── plugins/                # Custom plugin configurations
    ├── completion.lua      # blink.cmp autocompletion
    ├── dashboard.lua       # Dashboard startup screen
    ├── editor.lua          # Editor enhancement plugins
    ├── lsp.lua             # LSP servers and configuration
    ├── neo-tree.lua        # File explorer (main config)
    └── ui.lua              # UI plugins (theme, statusline)
```

## Configuration Philosophy

### Core Settings ([core.lua](core.lua))

The `core.lua` file contains fundamental Neovim settings and keymaps:

- **Leader key**: `<Space>` for both leader and local leader
- **Indentation**: 2-space default (auto-detected per file via guess-indent)
- **UI preferences**: Line numbers, cursor line, sign column always visible
- **Smart search**: Case-insensitive unless uppercase letters present
- **Split behavior**: Open right and below (more intuitive)
- **Custom keymaps**:
  - `jj` → Exit insert mode
  - `<Esc>` → Clear search highlights
  - `<C-hjkl>` → Window navigation

### Plugin Organization

Plugins are organized into logical categories:

#### UI and Appearance ([ui.lua](plugins/ui.lua))

- **which-key**: Shows pending keybindings (instant display with 0ms delay)
- **tokyonight**: Color scheme with customizations (non-italic comments)
- **lualine**: Fast statusline with mode, git branch, diagnostics, file info

#### Completion ([completion.lua](plugins/completion.lua))

- **blink.cmp**: Modern completion engine with:
  - LuaSnip integration for snippets
  - friendly-snippets for pre-made snippet collection
  - lazydev.nvim for Neovim Lua API completions
  - nvim-cmp-style UI for familiarity
  - Default preset keymaps (`<C-y>` to accept)

#### Editor Enhancements ([editor.lua](plugins/editor.lua))

**Core Functionality**:
- **guess-indent**: Auto-detect indentation style per file
- **gitsigns**: Git diff indicators in gutter
- **Telescope**: Fuzzy finder with fzf-native performance
  - Custom keymaps: `<leader>sf` (files), `<leader>sg` (grep), `<leader>sF` (all files including ignored)
- **nvim-treesitter**: Syntax highlighting and code understanding
  - Installed parsers: bash, c, css, html, js, json, lua, markdown, python, tsx, ts, vim

**Git Integration**:
- **vim-fugitive**: Core git commands (`:Git`, `:Gblame`, `:Gdiffsplit`)
  - Keymaps under `<leader>g`: status, push, pull, blame, diff
- **diffview.nvim**: Enhanced diff and history viewer
  - Keymaps under `<leader>gd`: open, close, file history

**Quality of Life**:
- **todo-comments**: Highlight TODO, FIXME, NOTE, etc. in comments
- **Comment.nvim**: Intelligent commenting with TreeSitter context awareness
  - `gcc` → Toggle line comment
  - `gc` → Comment operator (e.g., `gcap` to comment paragraph)
  - Language-aware via ts-context-commentstring
- **nvim-autopairs**: Smart bracket/quote pairing
  - TreeSitter integration for context-aware pairing
  - Custom rules for markdown code blocks and HTML/JSX tags
  - Visual mode wrapping keymaps
- **nvim-ufo**: Advanced folding with LSP/TreeSitter
  - Smart provider selection (LSP → TreeSitter → indent)
  - Peek folded content with `K`
  - Enhanced navigation: `]z`/`[z` for fold jumping
- **toggleterm**: Powerful terminal management
  - Multiple terminal types: floating, horizontal, vertical
  - Pre-configured integrations: lazygit, Python/Node REPL, htop
  - Keymaps under `<leader>t`
- **mini.nvim**: Collection of utilities
  - mini.ai: Better text objects (e.g., `yinq` - yank in next quote)
  - mini.surround: Add/delete/replace surroundings (e.g., `saiw)` - surround word with parens)

#### LSP Configuration ([lsp.lua](plugins/lsp.lua))

**LSP Infrastructure**:
- **nvim-lspconfig**: Core LSP client configuration
- **mason.nvim**: LSP/tool installer and manager
- **mason-lspconfig**: Bridge between Mason and lspconfig
- **mason-tool-installer**: Automatic tool installation
- **fidget.nvim**: LSP progress notifications
- **schemastore.nvim**: JSON schema integration

**Language Servers** (auto-installed via Mason):
- **lua_ls**: Lua with Neovim API support (via lazydev)
- **ts_ls**: TypeScript/JavaScript
- **jsonls**: JSON with SchemaStore integration
- **pylsp**: Python with:
  - pylsp_mypy for type checking
  - rope for auto-imports and completions
  - Formatting/linting disabled (handled by ruff)
- **ruff**: Python linting and formatting
  - Import sorting enabled
  - Line length: 88 (Black-compatible)

**LSP Keymaps** (available when LSP attached):
- `grn` → Rename symbol
- `gra` → Code actions
- `grr` → Find references
- `gri` → Go to implementation
- `grd` → Go to definition
- `grD` → Go to declaration

**Formatting**:
- **conform.nvim**: Formatter runner
  - Format-on-save enabled
  - LSP fallback for unsupported languages
  - Configured formatters per language

#### File Explorer ([neo-tree.lua](plugins/neo-tree.lua))

- **Neo-tree**: Modern file explorer with git integration
- Features:
  - Filesystem, buffers, and git status views
  - Follow current file option
  - Git status indicators
  - Fuzzy finder integration
- Keymaps:
  - `<leader>e` → Toggle Neo-tree
  - `<leader>o` → Focus Neo-tree

#### Dashboard ([dashboard.nvim](plugins/dashboard.nvim))

- **dashboard-nvim**: Startup screen with hyper theme
- Features:
  - Weekly header
  - Quick shortcuts: update, files, config, recent, grep, quit
  - Recent projects and files
  - Plugin count display

## Customizations Beyond Kickstart

### Major Additions

1. **Advanced Git Workflow**
   - vim-fugitive for comprehensive git commands
   - diffview.nvim for visual diff/merge workflows
   - Extensive keymap set under `<leader>g` prefix

2. **Modern Completion Stack**
   - Replaced nvim-cmp with blink.cmp (faster, modern)
   - Integrated friendly-snippets for extensive snippet library
   - Maintained nvim-cmp styling for familiarity

3. **Enhanced Editor Experience**
   - nvim-ufo for intelligent folding (LSP + TreeSitter)
   - toggleterm with pre-configured specialized terminals
   - Comment.nvim with context-aware commenting
   - Comprehensive autopairs with custom rules

4. **Improved Terminal Integration**
   - Floating, horizontal, and vertical terminal layouts
   - Pre-configured tools: lazygit, Python/Node REPL, htop
   - Multiple terminal instances (`<leader>t1-4`)
   - Send code from buffer to terminal

5. **UI Enhancements**
   - dashboard-nvim with hyper theme
   - Instant which-key display (0ms delay)
   - Custom tokyonight configuration
   - todo-comments for highlight annotations

### Python-Specific Setup

Current configuration uses dual LSP approach:
- **pylsp**: Type checking (mypy) + completions + auto-imports
- **ruff**: Linting + formatting (fast!)

See [TODO.md](../TODO.md) Priority 2, Task #3 for planned optimization to basedpyright + ruff.

### TypeScript/JavaScript Setup

- **ts_ls** (TypeScript Language Server)
- TreeSitter parsers for tsx, typescript, javascript
- Format-on-save via conform.nvim

### JSON Schema Integration

- **jsonls** with schemastore.nvim
- Automatic schema detection for package.json, tsconfig.json, etc.
- Validation and completions for common JSON formats

## Key Differences from Kickstart

### Kept from Kickstart
- Core LSP setup pattern (LspAttach autocmd, keymaps)
- Telescope configuration and keybindings
- Basic gitsigns configuration
- Treesitter setup
- Debug adapter (DAP) setup
- Linting configuration (nvim-lint)

### Modified from Kickstart
- **Completion**: Switched to blink.cmp (from nvim-cmp)
- **Autopairs**: Enhanced with custom rules and TreeSitter integration
- **Neo-tree**: Comprehensive configuration (kickstart version is minimal)

### Added Beyond Kickstart
- Git workflow tools (fugitive, diffview)
- Advanced folding (nvim-ufo)
- Terminal management (toggleterm)
- Smart commenting (Comment.nvim)
- Dashboard screen
- Python dual-LSP setup
- JSON schema integration
- Custom text objects (mini.ai, mini.surround)
- todo-comments highlighting

## Known Issues

See [TODO.md](../TODO.md) for a prioritized list of:
1. **Duplicate configurations** (Neo-tree, Autopairs) - needs cleanup
2. **Planned optimizations** (Python LSP, lazy-lock tracking)
3. **Future enhancements** (trouble.nvim, nvim-spectre, etc.)

## Plugin Count

As of last update:
- **Total plugins**: ~30+
- **Lazy-loaded**: Most plugins load on specific events/commands
- **Startup time**: Fast due to lazy loading

## Keybinding Prefixes

- `<leader>s` → **Search** (Telescope pickers)
- `<leader>t` → **Toggle/Terminal** (toggleterm, various toggles)
- `<leader>g` → **Git** (fugitive, diffview, gitsigns)
- `<leader>gd` → **Git Diffview** (diffview commands)
- `<leader>h` → **Git Hunk** (gitsigns hunk operations)
- `<leader>e` → **Explorer** (Neo-tree toggle)
- `<leader>o` → **Open** (Neo-tree focus)
- `<leader>q` → **Quickfix** (diagnostic quickfix list)
- `gr*` → **LSP goto** (references, definition, implementation, etc.)
- `gc*` → **Comment** (Comment.nvim operators)
- `gb*` → **Block comment** (Comment.nvim block operators)
- `sa*`, `sd*`, `sr*` → **Surround** (mini.surround operations)

## Formatting and Linting

### Format-on-Save
- **Enabled**: Yes, via conform.nvim
- **Timeout**: 1000ms (may need increase for large files - see TODO)
- **Fallback**: Uses LSP formatting if no conform formatter available

### Linting
- **Tool**: nvim-lint (from kickstart)
- **Python**: Handled by ruff LSP
- **JavaScript/TypeScript**: Configured via nvim-lint

### Python Formatting
- **ruff_format**: Fast formatting
- **ruff_organize_imports**: Import sorting
- **Compatible**: Black-style with 88 line length

## Performance Considerations

- **Lazy loading**: Plugins load on events, commands, or filetypes
- **TreeSitter**: Incremental parsing for fast syntax highlighting
- **Telescope**: fzf-native for fast fuzzy finding
- **blink.cmp**: Faster than nvim-cmp (Lua implementation)
- **Folding**: Minimal performance impact with nvim-ufo

## Learning Resources

For understanding the configuration:
- `:help` - Built-in Neovim help (excellent!)
- `:Telescope help_tags` - Search all help docs
- `:Telescope keymaps` - See all keybindings
- `:checkhealth` - Diagnose configuration issues
- `:Lazy` - Plugin manager UI
- `:Mason` - LSP/tool installer UI

## Future Direction

See [TODO.md](../TODO.md) for planned improvements organized by priority.

Top priorities:
1. Remove duplicate configurations
2. Optimize Python LSP setup
3. Add trouble.nvim for better diagnostics UI
4. Track lazy-lock.json for reproducibility
