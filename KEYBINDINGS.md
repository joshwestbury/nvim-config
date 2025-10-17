# Neovim Keybindings Cheatsheet

**Leader Key:** `<Space>`
**Note:** All keybindings are case-sensitive. `<leader>` refers to the Space key.

---

## Core Navigation & Editing

### Basic Movement
- **`<C-h>`** - Move focus to the left window/split
- **`<C-l>`** - Move focus to the right window/split
- **`<C-j>`** - Move focus to the lower window/split
- **`<C-k>`** - Move focus to the upper window/split

### Mode Switching
- **`jj`** (in Insert mode) - Exit insert mode and return to normal mode (alternative to Esc)
- **`<Esc><Esc>`** (in Terminal mode) - Exit terminal mode

### Search & Highlights
- **`<Esc>`** (in Normal mode) - Clear search highlights from the buffer

---

## File Explorer (Neo-tree)

- **`<leader>e`** - Toggle Neo-tree file explorer (show/hide sidebar)
- **`<leader>o`** - Focus Neo-tree (switch focus to the file explorer if it's open)

**Inside Neo-tree:**
- `<CR>` or `o` - Open file/folder
- `a` - Add new file/folder
- `d` - Delete file/folder
- `r` - Rename file/folder
- `c` - Copy file/folder
- `x` - Cut file/folder
- `p` - Paste file/folder
- `H` - Toggle hidden files
- `?` - Show help/all keybindings

---

## Fuzzy Finding (Telescope)

### File & Text Search
- **`<leader>sf`** - **Search Files** - Find files by name in the current directory
- **`<leader>sF`** - **Search Files (all)** - Find all files including hidden and ignored files
- **`<leader>sg`** - **Search by Grep** - Live grep search across all files (search file contents)
- **`<leader>sw`** - **Search Word** - Search for the word currently under the cursor
- **`<leader>s.`** - **Search Recent Files** - Browse recently opened files (oldfiles)
- **`<leader><leader>`** - **Find Buffers** - List and switch between open buffers

### Documentation & Help
- **`<leader>sh`** - **Search Help** - Search through Neovim help documentation
- **`<leader>sk`** - **Search Keymaps** - Browse all configured keybindings interactively
- **`<leader>sC`** - **Search Commands** - Browse and execute all available Ex commands
- **`<leader>ss`** - **Search Select Telescope** - Open Telescope picker selector (meta-picker)

### Advanced Search
- **`<leader>/`** - **Fuzzy search in current buffer** - Search text within the currently open file
- **`<leader>s/`** - **Search in Open Files** - Live grep only within currently open buffers
- **`<leader>sn`** - **Search Neovim files** - Find files in your Neovim configuration directory
- **`<leader>sd`** - **Search Diagnostics** - Browse LSP diagnostics (errors/warnings) across workspace
- **`<leader>sr`** - **Search Resume** - Resume the last Telescope picker session

**Inside Telescope:**
- `<C-n>`/`<C-p>` or Arrow keys - Navigate results
- `<CR>` - Open selected item
- `<C-x>` - Open in horizontal split
- `<C-v>` - Open in vertical split
- `<C-t>` - Open in new tab
- `<C-/>` or `?` - Show keybindings help

---

## Project-Wide Search & Replace (Spectre)

- **`<leader>S`** - **Open Spectre** - Open project-wide search and replace interface with visual preview
- **`<leader>sw`** (Normal mode) - **Search current word** - Open Spectre with the word under cursor pre-filled
- **`<leader>sw`** (Visual mode) - **Search selection** - Open Spectre with the selected text pre-filled
- **`<leader>sp`** - **Search in current file** - Open Spectre limited to the current file only

**Inside Spectre:**
- Enter search term and replacement term in the input fields
- Review all matches with file context
- `<CR>` - Replace current match
- `<leader>rc` - Replace all matches
- `dd` - Exclude a result from replacement
- `?` - Show help

---

## LSP (Language Server Protocol)

### Code Navigation
- **`gd`** - **Go to Definition** - Jump to where a symbol is defined
- **`grd`** - **Go to Definition (Telescope)** - Same as gd but uses Telescope picker
- **`gD`** - **Go to Declaration** - Jump to the declaration of a symbol (e.g., C header file)
- **`grD`** - **Go to Declaration (Telescope)** - Same as gD but uses Telescope picker
- **`gi`** - **Go to Implementation** - Jump to the implementation of an interface/abstract method
- **`gri`** - **Go to Implementation (Telescope)** - Same as gi but uses Telescope picker
- **`gr`** - **Go to References** - List all references to the symbol under cursor
- **`grr`** - **Go to References (Telescope)** - Same as gr but uses Telescope picker
- **`grt`** - **Go to Type Definition** - Jump to the type definition of the symbol
- **`<space>D`** - **Type Definition** - Alternative keybinding for type definition

### Symbol Search
- **`gO`** - **Open Document Symbols** - Browse all symbols (functions, variables, etc.) in current file
- **`gW`** - **Open Workspace Symbols** - Browse all symbols across the entire project

### Code Actions & Refactoring
- **`<space>ca`** or **`gra`** - **Code Action** - Show available code actions (fixes, refactorings) at cursor position
- **`<space>rn`** or **`grn`** - **Rename** - Rename the symbol under cursor across entire project
- **`K`** - **Hover Documentation** - Show documentation/type information for symbol under cursor
- **`<C-k>`** - **Signature Help** - Show function signature help (parameter hints)

### Workspace Management
- **`<space>wa`** - **Workspace Add Folder** - Add a folder to the workspace
- **`<space>wr`** - **Workspace Remove Folder** - Remove a folder from the workspace
- **`<space>wl`** - **Workspace List Folders** - List all folders in the workspace

### Formatting
- **`<space>f`** or **`<leader>f`** - **Format buffer** - Format the current file using LSP or configured formatter

### Python-Specific (only in Python files)
- **`<leader>oi`** - **Organize Imports** - Sort and organize import statements
- **`<leader>ai`** - **Add missing Import** - Auto-import the symbol under cursor
- **`<leader>em`** - **Extract Method** - Extract selected code into a new method/function

### TypeScript/JavaScript-Specific (only in TS/JS files)
- **`<leader>oi`** - **Organize Imports** - Sort and organize import statements
- **`<leader>ai`** - **Add missing Imports** - Auto-import missing symbols
- **`<leader>ru`** - **Remove Unused imports** - Remove all unused imports
- **`<leader>fa`** - **Fix All** - Auto-fix all fixable problems in the file
- **`<leader>ec`** - **Extract Constant** - Extract selected value to a constant
- **`<leader>ef`** - **Extract Function** - Extract selected code into a new function

### Inlay Hints
- **`<leader>th`** - **Toggle Inlay Hints** - Show/hide type hints inline in the code

---

## Diagnostics (Trouble.nvim)

- **`<leader>xx`** - **Diagnostics (Trouble)** - Show all LSP diagnostics (errors/warnings) across the workspace in a organized list
- **`<leader>xX`** - **Buffer Diagnostics** - Show diagnostics only for the current buffer
- **`<leader>xq`** - **Quickfix List** - Show quickfix list in Trouble interface
- **`<leader>xl`** - **Location List** - Show location list in Trouble interface
- **`<leader>xr`** - **LSP References** - Show all references to symbol in Trouble interface
- **`<leader>q`** - **Open diagnostic Quickfix list** - Open diagnostics in vim's native quickfix window

**Inside Trouble:**
- `<CR>` - Jump to diagnostic location
- `q` - Close Trouble window
- `o` - Jump to location and keep Trouble open
- `P` - Toggle preview
- `[q` / `]q` - Navigate to previous/next item
- `?` - Show help

---

## Git Integration

### Vim Fugitive
- **`<leader>gs`** - **Git Status** - Open Git status window
- **`<leader>gc`** - **Git Commit** - Open commit interface
- **`<leader>gp`** - **Git Push** - Push commits to remote
- **`<leader>gP`** - **Git Pull** - Pull changes from remote
- **`<leader>gb`** - **Git Blame** - Show git blame for current file
- **`<leader>gd`** - **Git Diff split** - Open diff view in split
- **`<leader>gw`** - **Git Write** - Stage the current file (equivalent to `git add`)
- **`<leader>gco`** - **Git Checkout** - Prompt for branch to checkout
- **`<leader>gcb`** - **Git Create Branch** - Create and checkout new branch
- **`<leader>gL`** - **Git Log** - Show git log in oneline format
- **`<leader>gh`** - **Git diff get HEAD** - During merge conflict, accept changes from HEAD (left side)
- **`<leader>gl`** - **Git diff get Local** - During merge conflict, accept local changes (right side)

### Diffview
- **`<leader>gdo`** - **Diffview Open** - Open enhanced diff view
- **`<leader>gdc`** - **Diffview Close** - Close diff view
- **`<leader>gdh`** - **Diffview File History** - Show file history for entire project
- **`<leader>gdH`** - **Diffview Current File History** - Show file history for current file only
- **`<leader>gdt`** - **Diffview Toggle Files** - Toggle file panel in diff view
- **`<leader>gdr`** - **Diffview Refresh** - Refresh diff view

**Inside Diffview:**
- `<Tab>` - Next file
- `<S-Tab>` - Previous file
- `gf` - Go to file
- `[x` / `]x` - Previous/next conflict (in merge tool)
- `<leader>co` - Choose OURS in conflict
- `<leader>ct` - Choose THEIRS in conflict
- `<leader>cb` - Choose BASE in conflict
- `<leader>ca` - Choose ALL versions in conflict

### Gitsigns (Inline Git)
Git signs appear in the sign column (gutter) showing added, modified, and deleted lines.
- Lines with `+` - Added lines
- Lines with `~` - Modified lines
- Lines with `_` - Deleted lines

---

## Terminal (ToggleTerm)

### Opening Terminals
- **`<leader>tt`** - **Toggle Terminal** - Open/close floating terminal
- **`<leader>tf`** - **Toggle Floating Terminal** - Open floating terminal
- **`<leader>th`** - **Toggle Horizontal Terminal** - Open terminal in horizontal split
- **`<leader>tv`** - **Toggle Vertical Terminal** - Open terminal in vertical split
- **`<C-\>`** - Quick toggle terminal (built-in binding)

### Multiple Terminals
- **`<leader>t1`** - Toggle Terminal 1
- **`<leader>t2`** - Toggle Terminal 2
- **`<leader>t3`** - Toggle Terminal 3
- **`<leader>t4`** - Toggle Terminal 4

### Specialized Terminals
- **`<leader>tg`** - **Toggle Lazygit** - Open Lazygit in floating terminal (interactive Git UI)
- **`<leader>tp`** - **Toggle Python REPL** - Open Python interactive shell
- **`<leader>tn`** - **Toggle Node.js REPL** - Open Node.js interactive shell
- **`<leader>tm`** - **Toggle Monitor (htop)** - Open htop system monitor

### Quick Terminal Commands
- **`<leader>tr`** - **Terminal Run dev server** - Execute `npm run dev`
- **`<leader>tb`** - **Terminal Build project** - Execute `npm run build`
- **`<leader>ts`** - **Terminal Start project** - Execute `npm start`
- **`<leader>tc`** - **Terminal Clear** - Clear terminal screen

### Send Code to Terminal
- **`<leader>tl`** (Normal mode) - **Terminal send Line** - Send current line to terminal
- **`<leader>ts`** (Visual mode) - **Terminal Send selection** - Send selected text to terminal

**Inside Terminal:**
- `<Esc>` or `jk` - Exit terminal mode to normal mode
- `<C-h/j/k/l>` - Navigate between windows (same as normal mode)
- `<C-w>` - Window command prefix
- `<C-Up/Down>` - Resize terminal height
- `<C-Left/Right>` - Resize terminal width
- `q` (in normal mode) - Close terminal

---

## Code Folding (nvim-ufo)

### Fold Operations
- **`zR`** - **Open all folds** - Unfold everything in the buffer
- **`zM`** - **Close all folds** - Fold everything in the buffer
- **`zr`** - **Open folds except kinds** - Open folds selectively
- **`zm`** - **Close folds with** - Close folds selectively
- **`za`** - Toggle fold under cursor (vim standard)
- **`zo`** - Open fold under cursor (vim standard)
- **`zc`** - Close fold under cursor (vim standard)
- **`<space>z`** - **Toggle fold under cursor** - Smart toggle for current fold

### Fold Navigation
- **`]z`** - **Go to next closed fold** - Jump to the next folded section
- **`[z`** - **Go to previous closed fold** - Jump to the previous folded section
- **`K`** (on fold) - **Peek Fold** - Preview folded content without opening (falls back to LSP hover if not on fold)

---

## Comments (Comment.nvim)

### Line Comments
- **`gcc`** - **Toggle line comment** - Comment/uncomment current line
- **`gc{motion}`** - **Comment motion** - Comment based on motion (e.g., `gcap` comments a paragraph)
- **`gc`** (Visual mode) - Comment selected lines

### Block Comments
- **`gbc`** - **Toggle block comment** - Comment/uncomment current line as block comment
- **`gb{motion}`** - **Block comment motion** - Block comment based on motion
- **`gb`** (Visual mode) - Block comment selected lines

### Extra Comment Operations
- **`gcO`** - **Comment line above** - Add comment on the line above cursor
- **`gco`** - **Comment line below** - Add comment on the line below cursor
- **`gcA`** - **Comment at end of line** - Add comment at the end of current line

---

## Text Objects & Surround (mini.nvim)

### Text Objects (mini.ai)
Enhanced text objects that work with `d`, `c`, `v`, `y`, etc.

Examples:
- `va)` - Visually select around parentheses
- `ci'` - Change inside single quotes
- `da"` - Delete around double quotes
- `yinq` - Yank inside next quote

### Surround Operations (mini.surround)
- **`saiw)`** - **Surround add** - Surround inner word with parentheses (example: `saiw)` on "hello" → "(hello)")
- **`sd'`** - **Surround delete** - Delete surrounding single quotes
- **`sr)'`** - **Surround replace** - Replace surrounding parentheses with single quotes
- **`sf'`** - **Surround find** - Find next surrounding quotes (moves cursor)
- **`sF'`** - **Surround find previous** - Find previous surrounding quotes

General pattern:
- `sa{motion}{char}` - Add surround
- `sd{char}` - Delete surround
- `sr{old}{new}` - Replace surround

---

## Auto-pairs (nvim-autopairs)

Automatically inserts closing brackets, quotes, and parentheses.

### Visual Mode Wrapping
When text is selected in visual mode:
- **`(`** - Wrap selection in parentheses
- **`[`** - Wrap selection in brackets
- **`{`** - Wrap selection in braces
- **`"`** - Wrap selection in double quotes
- **`'`** - Wrap selection in single quotes
- **`` ` ``** - Wrap selection in backticks

### Insert Mode
- Type opening character (`(`, `[`, `{`, `"`, `'`) - Auto-inserts closing character
- `<CR>` between pairs - Smart newline with indentation
- `<BS>` between pairs - Deletes both characters
- `<C-h>` - Alternative to backspace for deleting pairs

---

## Session Management (persistence.nvim)

- **`<leader>qs`** - **Restore Session** - Restore the saved session for the current directory (reopen all files, splits, and window layouts)
- **`<leader>ql`** - **Restore Last Session** - Restore the most recent session regardless of directory
- **`<leader>qd`** - **Don't Save Current Session** - Stop saving the current session (use when workspace is messy)

Sessions are automatically saved when you exit Neovim. Use these keybindings to restore your workspace when returning to a project.

---

## Completion (blink.cmp)

**In Insert Mode:**
- `<C-Space>` - Manually trigger completion menu
- `<C-n>` - Next completion item
- `<C-p>` - Previous completion item
- `<C-y>` - Accept/confirm selected completion
- `<C-e>` - Cancel completion menu
- `<CR>` - Accept completion (if menu is open)
- `<Tab>` - Navigate to next item or expand snippet
- `<S-Tab>` - Navigate to previous item

Completion sources include:
- LSP (code completions from language servers)
- Buffer (words from open buffers)
- Path (file system paths)
- Snippets

---

## Dashboard (Alpha)

When you open Neovim without a file, you'll see a dashboard with quick actions:

- `f` - Find file (opens Telescope file picker)
- `n` - New file
- `r` - Recent files
- `g` - Find text (grep)
- `c` - Config (open Neovim config)
- `q` - Quit

---

## Miscellaneous

### UI & Display
- **`:Lazy`** - Open plugin manager UI (manage/update/install plugins)
- **`:Mason`** - Open LSP/tool installer UI (manage language servers, formatters, linters)
- **`:ConformInfo`** - Show formatting configuration for current buffer
- **`:LspInfo`** - Show LSP client status and attached servers
- **`:checkhealth`** - Run health checks for Neovim and plugins

### Which-key
Which-key automatically shows available keybindings when you pause after pressing a prefix key (like `<leader>`). Just wait ~300ms after pressing a key prefix to see available options.

---

## Quick Reference by Category

### Most Used Keybindings
- `<leader>e` - Toggle file explorer
- `<leader>sf` - Find files
- `<leader>sg` - Search in files (grep)
- `<leader>xx` - Show all diagnostics
- `gd` - Go to definition
- `K` - Hover documentation
- `<leader>f` - Format file
- `<leader>tt` - Toggle terminal
- `gcc` - Toggle comment
- `<leader>qs` - Restore session

### Leader Key Prefixes
- `<leader>s*` - **Search** operations (Telescope)
- `<leader>g*` - **Git** operations
- `<leader>t*` - **Terminal** operations
- `<leader>x*` - **Diagnostics** (Trouble)
- `<leader>q*` - **Session** management (quit/restore)
- `<leader>o*` - **Organize** (imports, etc.)
- `<leader>a*` - **Add** (imports, etc.)
- `<leader>e*` - **Extract** (refactoring)

### `g` Prefix (Go to)
- `gd` / `gD` - Go to definition/declaration
- `gr` / `gi` - Go to references/implementation
- `grt` - Go to type definition
- `gO` / `gW` - Document/workspace symbols
- `gcc` / `gbc` - Comment operations

---

## Tips for LLM Assistants

When a user asks about keybindings:

1. **Check the mode** - Many bindings work differently in Normal, Insert, Visual, or Terminal mode
2. **Explain the mnemonic** - Most bindings follow patterns (e.g., `<leader>s` = Search, `<leader>g` = Git)
3. **Mention alternatives** - Some actions have multiple keybindings (e.g., `gd` and `grd` both go to definition)
4. **Context matters** - Some bindings are filetype-specific (Python vs TypeScript) or location-specific (inside Telescope, inside Trouble, etc.)
5. **Leader = Space** - Always clarify that `<leader>` means the Space key
6. **Suggest related bindings** - If user asks about one binding, mention related ones in the same category

Example response format:
> To search for files, use `<leader>sf` (Space + s + f, mnemonic: Search Files). This opens Telescope's file finder. Related bindings: `<leader>sg` for grep search and `<leader>sw` to search for the word under cursor.
