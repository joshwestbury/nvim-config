# Neovim Configuration Cleanup TODO

## Priority Structure

### 🔴 **Priority 1: Critical (Do Immediately)**
Fix configuration issues that cause conflicts or confusion:
- **#1**: Remove duplicate Neo-tree configuration
- **#2**: Remove duplicate Autopairs configuration

### 🟠 **Priority 2: High Impact (Do Soon)**
Improvements that significantly enhance workflow:
- **#3**: Optimize Python LSP (replace pylsp with basedpyright + ruff)
- **#4**: Track lazy-lock.json for reproducibility
- **#5**: Add trouble.nvim for better diagnostics UI

### 🟡 **Priority 3: Quality of Life (Do When Ready)**
Useful enhancements that improve daily workflow:
- **#6**: Add nvim-spectre for project-wide search/replace
- **#7**: Improve format-on-save for large files

### 🟢 **Priority 4: Nice to Have (Optional)**
Features that are helpful but not essential:
- **#8**: Add persistence.nvim for session management
- **#9**: Add additional Telescope pickers

---

## Priority 1: Critical Issues

## 1. Resolve Duplicate Neo-tree Configuration

### Problem
Neo-tree is defined in two locations with different configurations:
- `lua/kickstart/plugins/neo-tree.lua` - Simple config with `\` keybinding
- `lua/plugins/neo-tree.lua` - Comprehensive config with `<leader>e` and `<leader>o` keybindings

This causes conflicts and confusion about which configuration is active.

### Recommendation
Keep the comprehensive version in `lua/plugins/neo-tree.lua` and remove the kickstart version.

### Steps to Implement

1. **Review current Neo-tree behavior**
   - Test `\` keybinding to confirm kickstart version is loading
   - Test `<leader>e` and `<leader>o` keybindings
   - Verify which configuration is actually active

2. **Backup (optional)**
   - If you want to preserve the `\` keybinding, note it down
   - Consider if any settings from kickstart version should be merged

3. **Remove duplicate configuration**
   - Delete `lua/kickstart/plugins/neo-tree.lua`
   - Command: `rm lua/kickstart/plugins/neo-tree.lua`

4. **Optional: Add backslash keybinding to main config**
   - If you prefer `\` over `<leader>e`, add this to the keys section in `lua/plugins/neo-tree.lua`:
     ```lua
     { "\\", ":Neotree reveal<CR>", desc = "Reveal in Neo-tree" },
     ```

5. **Test the changes**
   - Restart Neovim
   - Verify `<leader>e` toggles Neo-tree
   - Verify `<leader>o` focuses Neo-tree
   - Test other Neo-tree functionality (git status, file operations, etc.)

6. **Commit the change**
   - Stage and commit the deletion
   - Example message: "Remove duplicate Neo-tree configuration from kickstart"

### Expected Outcome
- Single source of truth for Neo-tree configuration
- No conflicts between competing configurations
- More efficient lazy loading with `cmd = "Neotree"`
- Comprehensive feature set from main config

---

## 2. Resolve Duplicate Autopairs Configuration

### Problem
Autopairs is defined in two locations with different configurations:
- `lua/kickstart/plugins/autopairs.lua` - Minimal config with default options
- `lua/plugins/editor.lua` - Comprehensive config with TreeSitter integration and blink.cmp dependency

The kickstart version provides no customization and may conflict with the feature-rich version.

### Recommendation
Keep the comprehensive version in `lua/plugins/editor.lua` and remove the kickstart version.

### Steps to Implement

1. **Review current autopairs behavior**
   - Test autopairs functionality in different file types (Lua, JS, TS, etc.)
   - Verify TreeSitter-aware pairing is working
   - Confirm integration with blink.cmp completion

2. **Compare configurations**
   - Kickstart version: Uses default `opts = {}`
   - Editor.lua version: Has extensive settings including:
     - TreeSitter integration (`check_ts = true`)
     - Language-specific configs
     - Filetype exclusions (TelescopePrompt, spectre_panel)
     - Smart bracket/quote behavior
     - blink.cmp integration

3. **Remove duplicate configuration**
   - Delete `lua/kickstart/plugins/autopairs.lua`
   - Command: `rm lua/kickstart/plugins/autopairs.lua`

4. **Test the changes**
   - Restart Neovim
   - Test autopairs in insert mode:
     - Type `(` and verify `)` is inserted
     - Type `"` and verify closing quote behavior
     - Test in different file types (Lua, JS, TS)
   - Verify it doesn't trigger in TelescopePrompt
   - Test integration with completion (blink.cmp)

5. **Commit the change**
   - Stage and commit the deletion
   - Example message: "Remove duplicate autopairs configuration from kickstart"

### Expected Outcome
- Single source of truth for autopairs configuration
- No conflicts between competing configurations
- Full TreeSitter integration for language-aware pairing
- Proper blink.cmp integration
- Smart behavior for brackets, quotes, and special cases

---

## Priority 2: High Impact Improvements

## 3. Optimize Python LSP Configuration

### Problem
Currently running both `pylsp` and `ruff` LSP servers for Python, which have overlapping functionality:
- `pylsp`: Provides completions, navigation, refactoring, and type checking (via pylsp_mypy)
- `ruff`: Provides linting and formatting
- While you've disabled conflicting plugins in pylsp, there's still redundancy in completions and overhead from running pylsp's plugin ecosystem

### Current Configuration
In `lua/plugins/lsp.lua`:
- **pylsp** with:
  - `pylsp_mypy` enabled for type checking
  - `rope_autoimport` and `rope_completion` enabled
  - All linting plugins disabled (good!)
  - All formatting plugins disabled (good!)
- **ruff** with:
  - Linting enabled with import sorting
  - Formatting enabled with line-length 88

### Recommendation
Replace `pylsp` with `basedpyright` for a cleaner, faster setup:
- **basedpyright**: Modern, fast type checker (maintained fork of pyright) + excellent IntelliSense
- **ruff-lsp**: Keep for lightning-fast linting and formatting

### Benefits of basedpyright + ruff
1. **Faster**: basedpyright is faster than mypy for type checking
2. **Better completions**: More intelligent IntelliSense than pylsp
3. **Simpler**: No plugin ecosystem to configure, just works
4. **Modern**: Actively maintained, follows latest Python standards
5. **Less overhead**: Two focused LSPs instead of pylsp's multi-plugin architecture

### Steps to Implement

1. **Backup current configuration**
   - Copy the current `pylsp` config block as a comment
   - Note any custom settings you want to preserve

2. **Update LSP configuration in `lua/plugins/lsp.lua`**
   - Remove the entire `pylsp` configuration block (lines ~367-388)
   - Add `basedpyright` configuration:
     ```lua
     -- Python type checking and IntelliSense
     basedpyright = {
       settings = {
         basedpyright = {
           analysis = {
             autoSearchPaths = true,
             diagnosticMode = "openFilesOnly",
             useLibraryCodeForTypes = true,
             typeCheckingMode = "basic", -- or "standard", "strict"
           },
         },
       },
     },
     ```
   - Keep the existing `ruff` configuration (it's already good)

3. **Update Mason ensure_installed list**
   - Find the `ensure_installed` section in `lua/plugins/lsp.lua`
   - Remove: `'python-lsp-server'` (if present)
   - Add: `'basedpyright'`
   - Keep: `'ruff'` and `'ruff-lsp'`

4. **Update conform.nvim configuration**
   - Verify `ruff_format` and `ruff_organize_imports` are still configured
   - Should already be set up correctly for Python

5. **Install new LSP**
   - Open Neovim
   - Run `:Mason` to open Mason UI
   - Uninstall `python-lsp-server` (if installed)
   - Install `basedpyright` (Mason will handle it automatically via ensure_installed)
   - Verify `ruff-lsp` is installed

6. **Test the new setup**
   - Open a Python file
   - Run `:LspInfo` to verify basedpyright and ruff are attached
   - Test type checking:
     - Write code with type errors and verify diagnostics appear
     - Hover over functions to see type hints
   - Test completions:
     - Type hints and IntelliSense work
     - Auto-imports work
   - Test formatting:
     - Format the file and verify ruff formatting works
     - Check import organization
   - Test linting:
     - Verify ruff lint diagnostics appear

7. **Commit the changes**
   - Stage and commit the LSP configuration changes
   - Example message: "Replace pylsp with basedpyright for Python LSP"

### Expected Outcome
- Faster Python language server startup and response times
- Better type checking with basedpyright (more modern than mypy)
- Superior IntelliSense and completions
- Cleaner configuration with fewer moving parts
- Maintained linting/formatting performance with ruff
- Reduced memory footprint (two focused LSPs vs pylsp plugin ecosystem)

### Alternative Configuration Options

**If you want stricter type checking:**
```lua
typeCheckingMode = "standard"  -- or "strict"
```

**If you want type checking for entire workspace:**
```lua
diagnosticMode = "workspace"  -- instead of "openFilesOnly"
```

**If you need specific Python version:**
```lua
pythonVersion = "3.11"  -- or your target version
```

---

## 4. Track lazy-lock.json in Git

### Problem
Currently `lazy-lock.json` is in `.gitignore`, which means:
- Plugin versions aren't tracked in version control
- Setting up config on new machines gets latest (potentially breaking) versions
- No reproducibility or version history for plugins
- Difficult to rollback to known-working plugin versions

### Current Situation
The `.gitignore` file includes `lazy-lock.json`, but the Lazy.nvim documentation recommends tracking it for reproducibility.

### Recommendation
**Remove `lazy-lock.json` from `.gitignore` and commit it to the repository.**

### Benefits of Tracking lazy-lock.json

1. **Reproducibility**: Anyone cloning your config gets exact plugin versions
2. **Stability**: Prevents breaking changes when setting up on new machines
3. **Version Control**: Full history of plugin version changes
4. **Easy Rollback**: Can git revert if an update breaks something
5. **Consistency**: All your machines use identical plugin versions
6. **Debugging**: Others can reproduce your exact environment when helping

### Analogy
This is the same principle as:
- `package-lock.json` in Node.js
- `Cargo.lock` in Rust
- `Gemfile.lock` in Ruby
- Community consensus: track lock files for reproducibility

### Steps to Implement

1. **Verify lazy-lock.json exists**
   - Check if `lazy-lock.json` file is present in your nvim config directory
   - Command: `ls -la lazy-lock.json`

2. **Update .gitignore**
   - Open `.gitignore` file
   - Remove the line containing `lazy-lock.json`
   - Save the file

3. **Stage and commit .gitignore change**
   - Command: `git add .gitignore`
   - Commit with message explaining the change

4. **Add lazy-lock.json to git**
   - Command: `git add lazy-lock.json`
   - This file was previously ignored, now it will be tracked

5. **Commit lazy-lock.json**
   - Commit with message: "Track lazy-lock.json for plugin version reproducibility"
   - This captures your current working plugin versions

6. **Going forward - Update workflow**
   - When updating plugins: Run `:Lazy update` in Neovim
   - Test that everything works
   - Commit the updated `lazy-lock.json`: "Update plugin versions"
   - This creates a history of plugin version changes

### Expected Outcome
- `lazy-lock.json` is tracked in git
- Plugin versions are reproducible across machines
- Easy to rollback to previous working versions
- Consistent development environment
- Better collaboration if sharing config with others

### Note
If you prefer bleeding-edge updates and are the sole user, you could keep ignoring it. However, tracking it is considered best practice and recommended by Lazy.nvim's documentation.

---

## 5. Add trouble.nvim for Better Diagnostics UI

### Problem
Current LSP diagnostic viewing is limited:
- Inline diagnostics show one error at a time (no overview)
- `:copen` quickfix list is clunky and outdated
- No good way to see ALL project errors/warnings in one place
- Difficult to systematically work through errors
- Hard to filter by severity or file
- Telescope diagnostics is good for searching but not browsing

### What is trouble.nvim?

A beautiful, modern diagnostics list that:
- Aggregates all LSP diagnostics into one organized view
- Shows errors, warnings, hints across entire workspace
- Provides quick navigation and filtering
- Groups diagnostics by file for better organization
- Supports quickfix, location list, and LSP references
- By Folke (author of lazy.nvim) - exceptional quality

### Why This is High Priority

1. **Core workflow**: Dealing with errors/warnings is daily development work
2. **Massive UX improvement**: Night and day difference from quickfix
3. **Time saver**: Systematically fix all errors instead of hunting them down
4. **Essential for LSP**: You have LSP setup, now make diagnostics usable
5. **Low overhead**: Lazy loads on command, no performance impact
6. **Proven plugin**: Industry standard, by Folke

### Real-World Use Cases

1. **After refactoring**: See all type errors that resulted from changes
2. **Before commits**: Review all diagnostics across the project
3. **TypeScript/Python work**: Navigate through type errors efficiently
4. **Linting cleanup**: Browse and fix all warnings systematically
5. **Learning codebases**: Understand what's broken or needs attention
6. **Code reviews**: Check diagnostic status before pushing

### Steps to Implement

1. **Add plugin to `lua/plugins/lsp.lua` or `lua/plugins/editor.lua`**
   - Add the following plugin spec to the return table:
     ```lua
     -- Better diagnostics list with modern UI
     {
       'folke/trouble.nvim',
       cmd = 'Trouble',
       dependencies = { 'nvim-tree/nvim-web-devicons' },
       opts = {
         focus = true, -- Focus the window when opened
       },
       keys = {
         { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
         { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
         { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
         { '<leader>xl', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
         { '<leader>xr', '<cmd>Trouble lsp_references toggle<cr>', desc = 'LSP References (Trouble)' },
       },
     },
     ```

2. **Restart Neovim**
   - Lazy.nvim will automatically install the plugin
   - Or manually run `:Lazy install`

3. **Test the plugin**
   - Open a project with some LSP diagnostics (errors/warnings)
   - Press `<leader>xx` to open Trouble
   - Navigate with `j`/`k`, press `<CR>` to jump to diagnostic
   - Press `q` to close Trouble window

4. **Learn the keybindings**
   - `<leader>xx`: Show all diagnostics (entire workspace)
   - `<leader>xX`: Show diagnostics for current buffer only
   - `<leader>xq`: Show quickfix list in Trouble
   - `<leader>xl`: Show location list in Trouble
   - `<leader>xr`: Show LSP references in Trouble

5. **Inside Trouble window:**
   - `<CR>`: Jump to diagnostic location
   - `q`: Close Trouble
   - `o`: Jump and keep Trouble open
   - `P`: Toggle preview
   - `[q` / `]q`: Previous/next item
   - `?`: Show help for all keybindings

6. **Integrate into workflow**
   - Before commits: `<leader>xx` to review all diagnostics
   - When LSP shows errors: `<leader>xx` to see them all
   - After refactoring: Check all resulting errors at once
   - Use with `:grep` or Telescope: Results show in Trouble

7. **Commit the changes**
   - Stage and commit the plugin addition
   - Example message: "Add trouble.nvim for better diagnostics UI"

### Keybindings Explained

- `<leader>x` prefix: "diagnostics/errors" (x marks the spot)
- `<leader>xx`: All workspace diagnostics (most common)
- `<leader>xX`: Current file only (capital X = narrower scope)
- `<leader>xq`/`xl`: Quickfix/location list (traditional vim lists)
- `<leader>xr`: References (find all usages)

### Expected Outcome
- Beautiful, organized view of all project diagnostics
- Faster error fixing workflow (see all, fix systematically)
- Better understanding of project health
- Complementary to Telescope (different use case)
- Modern alternative to outdated quickfix list
- Essential tool for LSP-heavy development

### Integration with Your Config

Trouble works seamlessly with your existing setup:
- **LSP servers**: pylsp, ruff, ts_ls, jsonls, lua_ls
- **Telescope**: Use both (Telescope for search, Trouble for browsing)
- **Conform.nvim**: See formatting issues in Trouble
- **No conflicts**: Pure enhancement to diagnostic viewing

### Optional Configuration

For more customization:
```lua
opts = {
  focus = true,
  auto_close = true, -- Auto close when no more items
  icons = {
    indent = {
      fold_open = " ",
      fold_closed = " ",
    },
  },
  modes = {
    diagnostics = {
      auto_refresh = true, -- Auto refresh on diagnostic changes
    },
  },
},
```

---

## Priority 3: Quality of Life Enhancements

## 6. Add nvim-spectre for Advanced Search/Replace

### Problem
Currently, project-wide search and replace requires either:
- Clunky Vim commands like `:bufdo %s/old/new/g` with no preview
- Switching to command-line tools like `sed` or `rg --replace`
- Telescope provides searching but not replacing

There's no visual, interactive way to search and replace across the entire project.

### What is nvim-spectre?

A powerful search and replace plugin that provides:
- Visual interface showing all matches before replacing
- Preview of changes before applying them
- Support for regex patterns
- File type filtering
- Project-wide or directory-specific operations
- Diff-like view of what will change

### Why Add It?

**Real-World Use Cases:**
1. **Refactoring**: Rename functions/variables across entire codebase
2. **API migrations**: Update old API calls to new ones
3. **Configuration updates**: Change settings across multiple files
4. **Typo fixes**: Fix misspelled names project-wide
5. **Dependency updates**: Update import paths after restructuring

**Benefits:**
- Visual confirmation before applying changes
- Safer than blind search/replace
- Faster than manual file-by-file editing
- More user-friendly than command-line tools
- Integrates seamlessly with Neovim workflow

### Steps to Implement

1. **Add plugin to `lua/plugins/editor.lua`**
   - Add the following plugin spec to the return table:
     ```lua
     {
       'nvim-pack/nvim-spectre',
       dependencies = {
         'nvim-lua/plenary.nvim',
       },
       keys = {
         { '<leader>S', function() require('spectre').open() end, desc = 'Open Spectre (Search/Replace)' },
         { '<leader>sw', function() require('spectre').open_visual({select_word=true}) end, desc = 'Search current word' },
         { '<leader>sp', function() require('spectre').open_file_search({select_word=true}) end, desc = 'Search in current file' },
       },
     },
     ```

2. **Install dependencies (if not already installed)**
   - Spectre requires `ripgrep` (rg) and `sed` on your system
   - Check: `which rg` and `which sed`
   - Install if needed:
     - macOS: `brew install ripgrep`
     - Linux: `sudo apt install ripgrep` or equivalent

3. **Restart Neovim**
   - Lazy.nvim will automatically install the plugin on next startup
   - Or manually run `:Lazy install`

4. **Test the plugin**
   - Press `<leader>S` to open Spectre
   - Try a simple search to see the interface
   - Test the workflow:
     1. Enter search term
     2. Enter replacement term
     3. Review matches
     4. Optionally filter by file type
     5. Press enter to apply changes (or `<leader>rc` to replace all)

5. **Learn the keybindings**
   - Inside Spectre window:
     - `<leader>rc`: Replace all
     - `<leader>o`: Show options
     - `dd`: Delete a result line (exclude from replace)
     - Press `?` for help with all keybindings

6. **Commit the changes**
   - Stage and commit the plugin addition
   - Example message: "Add nvim-spectre for project-wide search and replace"

### Keybindings Explained

- `<leader>S`: Open Spectre for project-wide search/replace
  - Capital S suggests "big Search" (complements `<leader>s` for Telescope)
- `<leader>sw`: Search current word under cursor
- `<leader>sp`: Search/replace in current file only

### Expected Outcome
- Powerful visual search and replace across entire project
- Safe refactoring with preview before applying changes
- Faster workflow for renaming and updating code
- Better than command-line tools for interactive use
- Complements Telescope (which is search-only)

### Optional Configuration

If you want to customize Spectre further, you can add a `config` function:
```lua
config = function()
  require('spectre').setup({
    highlight = {
      ui = "String",
      search = "DiffChange",
      replace = "DiffDelete"
    },
    mapping = {
      ['send_to_qf'] = {
        map = "<leader>q",
        cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
        desc = "send all items to quickfix"
      },
    },
  })
end,
```

---

## Priority 4: Nice to Have (Optional)

## 8. Add Session Management with persistence.nvim

### Problem
When working on multiple projects or switching contexts:
- Need to manually reopen files when returning to a project
- Lose window layout and cursor positions between sessions
- Time wasted recreating your workspace setup
- Difficult to recover after crashes or unexpected exits

### What is persistence.nvim?

A lightweight session management plugin that:
- Automatically saves your session per directory
- Stores open files, window layouts, cursor positions, etc.
- Restores your exact workspace when you return
- By Folke (author of lazy.nvim) - well-maintained and integrated

### When This is Useful

**Great for:**
1. **Multiple projects**: Switch between projects and resume exactly where you left off
2. **Context switching**: Jump back into complex codebases with all files open
3. **Crash recovery**: Restore workspace after unexpected exits
4. **Deep work**: Feature development across many files and splits

**Example Workflow:**
- Working on feature with 10 files open across 3 splits
- Close Neovim to switch projects
- Return later, press `<leader>qs`
- All 10 files and splits restored instantly

**Less useful if:**
- You work on only one project at a time
- You use tmux/zellij for terminal session management
- You prefer fresh starts each session
- You rarely have complex multi-file workspaces

### Steps to Implement

1. **Add plugin to `lua/plugins/editor.lua`**
   - Add the following plugin spec to the return table:
     ```lua
     {
       'folke/persistence.nvim',
       event = 'BufReadPre',
       opts = {},
       keys = {
         { '<leader>qs', function() require('persistence').load() end, desc = 'Restore Session' },
         { '<leader>ql', function() require('persistence').load({ last = true }) end, desc = 'Restore Last Session' },
         { '<leader>qd', function() require('persistence').stop() end, desc = "Don't Save Current Session" },
       },
     },
     ```

2. **Restart Neovim**
   - Lazy.nvim will automatically install the plugin
   - Or manually run `:Lazy install`

3. **Test the plugin**
   - Open several files in your project
   - Create some splits/windows
   - Close Neovim completely
   - Reopen Neovim in the same directory
   - Press `<leader>qs` to restore your session
   - Verify all files and layout are restored

4. **Understand the keybindings**
   - `<leader>qs`: Restore session for current directory
   - `<leader>ql`: Restore last session (regardless of directory)
   - `<leader>qd`: Don't save current session (for messy workspaces)

5. **Optional: Configure session behavior**
   - By default, persistence saves sessions automatically
   - You can customize what gets saved:
     ```lua
     opts = {
       options = { 'buffers', 'curdir', 'tabpages', 'winsize' }, -- session data to save
       pre_save = nil, -- function to call before saving
       save_empty = false, -- don't save empty sessions
     },
     ```

6. **Commit the changes**
   - Stage and commit the plugin addition
   - Example message: "Add persistence.nvim for session management"

### Expected Outcome
- Automatic session saving per project directory
- Quick restoration of complex workspaces
- Time saved not manually reopening files
- Better context preservation between sessions
- Optional - only restore when you want to

### Why Low Priority?

This is marked as low priority because:
- It's a nice-to-have, not essential for functionality
- Depends on your workflow (some people don't need it)
- Terminal multiplexers (tmux/zellij) can provide similar functionality
- Works best when you have established project workflows

Try the higher priority tasks first, then add this if you find yourself wanting session restoration.

---

## 7. Improve Format-on-Save for conform.nvim (Normal Priority)

### Problem
Current format-on-save configuration may have issues:
- No protection against formatting huge files (can freeze editor)
- Default timeout (1000ms) may be too short for large files
- No way to disable formatting for specific filetypes
- Formatter failures can be frustrating without proper handling

### What This Improves

Enhanced `format_on_save` function that:
- Skips formatting for very large files (performance)
- Increases timeout for reliability
- Allows disabling specific filetypes
- Uses LSP as fallback if no conform formatter available
- Provides user feedback when skipping

### Benefits

1. **Better performance**: Won't freeze on huge files (minified JS, data dumps, etc.)
2. **More reliable**: Longer timeout prevents failures on larger files
3. **Flexible**: Can disable formatting per-filetype if needed
4. **User-friendly**: Notifications when skipping format
5. **Robust**: Falls back to LSP formatting when appropriate

### When This is Useful

**Helps with:**
- Opening large generated files (minified code, build artifacts)
- Working with slow formatters (like `black` for Python)
- Projects with mixed formatting standards
- Preventing editor freezes on save

**Less critical if:**
- You only work with small-to-medium files
- Current formatting never times out
- All your formatters are fast

### Steps to Implement

1. **Locate your conform.nvim configuration**
   - Should be in `lua/plugins/lsp.lua` or similar
   - Look for the `conform.nvim` setup block

2. **Find the current format_on_save configuration**
   - Might look like: `format_on_save = { timeout_ms = 500, lsp_format = "fallback" }`
   - Or could be a simple boolean: `format_on_save = true`

3. **Replace with enhanced function**
   - Replace the current `format_on_save` value with:
     ```lua
     format_on_save = function(bufnr)
       -- Disable auto-format for very large files (performance)
       if vim.api.nvim_buf_line_count(bufnr) > 10000 then
         vim.notify("File too large, skipping auto-format", vim.log.levels.WARN)
         return nil
       end

       -- Disable for specific filetypes if needed
       -- Only add filetypes you actually want to skip!
       local disable_filetypes = {
         -- c = true,      -- Uncomment if you don't want C formatting
         -- cpp = true,    -- Uncomment if you don't want C++ formatting
         -- markdown = true,  -- Uncomment if markdown formatting is annoying
       }
       if disable_filetypes[vim.bo[bufnr].filetype] then
         return nil
       end

       return {
         timeout_ms = 3000,        -- 3 second timeout (up from default 1s)
         lsp_format = 'fallback',  -- Use LSP formatting if no conform formatter
       }
     end,
     ```

4. **Customize for your needs**
   - Adjust line count threshold (10000 is reasonable)
   - Add filetypes to disable list if you have specific cases
   - Adjust timeout if you have particularly slow formatters
   - Consider 5000ms for Python with `black`, or 2000ms if all formatters are fast

5. **Test the changes**
   - Open a normal file and save - should format as usual
   - Create a test file with 15000+ lines - should skip with notification
   - Test with different filetypes you configured
   - Verify timeout works by saving larger files

6. **Monitor for issues**
   - Watch for timeout warnings
   - Adjust thresholds based on your experience
   - Remove filetype exclusions if unnecessary

7. **Commit the changes**
   - Stage and commit the configuration update
   - Example message: "Enhance format-on-save with large file handling and increased timeout"

### Configuration Explained

**Line count check:**
```lua
if vim.api.nvim_buf_line_count(bufnr) > 10000 then
```
- Skips formatting if file has more than 10,000 lines
- Prevents freezing on huge files
- Shows notification so you know why it skipped

**Filetype exclusions:**
```lua
local disable_filetypes = { c = true, cpp = true }
```
- Opt-out list for specific languages
- Useful for legacy codebases or non-standard formatting
- Keep this list minimal - only add what you need

**Timeout increase:**
```lua
timeout_ms = 3000,
```
- Default is usually 1000ms (1 second)
- 3000ms (3 seconds) gives more time for large files
- Prevents "formatter timed out" errors

**LSP fallback:**
```lua
lsp_format = 'fallback',
```
- Tries conform formatters first
- Falls back to LSP formatting if no conform formatter configured
- Best of both worlds approach

### Expected Outcome
- More reliable formatting on large files
- No more editor freezes on huge files
- Flexibility to disable problematic filetypes
- Better user experience with notifications
- Reduced formatter timeout errors

### Optional Enhancements

**Add manual format command for large files:**
```lua
vim.keymap.set('n', '<leader>cf', function()
  require('conform').format({ timeout_ms = 10000, lsp_format = 'fallback' })
end, { desc = 'Format current buffer (force)' })
```

**Different thresholds per formatter:**
```lua
format_on_save = function(bufnr)
  local max_lines = 10000

  -- Python's black is slower, use lower threshold
  if vim.bo[bufnr].filetype == 'python' then
    max_lines = 5000
  end

  if vim.api.nvim_buf_line_count(bufnr) > max_lines then
    return nil
  end

  return { timeout_ms = 3000, lsp_format = 'fallback' }
end,
```

---

## 9. Add Additional Telescope Pickers

### Problem
Telescope is already configured with the most common pickers (files, grep, buffers, help), but some useful pickers are missing:
- No easy way to search through available commands
- Can't browse keymaps interactively
- Missing some discovery/exploration features

### What This Adds

Additional Telescope pickers for exploring your Neovim environment:
- **Commands**: Search and execute all available Ex commands
- **Keymaps**: Find what keys are mapped to what actions
- **Marks**: Jump to marks interactively
- **Vim Options**: Browse and search `:set` options

### Why Low Priority

These are nice-to-have features for discovery and exploration, but not essential for daily work:
- You already have the most important pickers (files, grep, help)
- These are used occasionally, not daily
- Alternative workflows exist (`:command`, `:map`, etc.)

### When This is Useful

**Good for:**
- Discovering commands in new plugins
- Finding forgotten keybindings
- Learning what options are available
- Exploring your configuration

**Less critical for:**
- Daily coding workflow
- Essential navigation
- Core productivity

### Steps to Implement

1. **Locate your Telescope keymaps**
   - Should be in `lua/plugins/editor.lua` or wherever Telescope is configured
   - Look for existing Telescope keybindings like `<leader>sf`, `<leader>sg`, etc.

2. **Add new keybindings**
   - Add these keymaps alongside your existing Telescope bindings:
     ```lua
     -- Additional useful Telescope pickers
     vim.keymap.set('n', '<leader>sC', function()
       require('telescope.builtin').commands()
     end, { desc = '[S]earch [C]ommands' })

     vim.keymap.set('n', '<leader>sk', function()
       require('telescope.builtin').keymaps()
     end, { desc = '[S]earch [K]eymaps' })

     vim.keymap.set('n', '<leader>sm', function()
       require('telescope.builtin').marks()
     end, { desc = '[S]earch [M]arks' })

     vim.keymap.set('n', '<leader>so', function()
       require('telescope.builtin').vim_options()
     end, { desc = '[S]earch [O]ptions' })
     ```

3. **Alternative: Add only the most useful ones**
   - If you want to keep it minimal, just add commands and keymaps:
     ```lua
     -- Minimal additional Telescope pickers
     vim.keymap.set('n', '<leader>sC', function()
       require('telescope.builtin').commands()
     end, { desc = '[S]earch [C]ommands' })

     vim.keymap.set('n', '<leader>sk', function()
       require('telescope.builtin').keymaps()
     end, { desc = '[S]earch [K]eymaps' })
     ```

4. **Restart Neovim or reload config**
   - Keymaps should be available immediately
   - Test each new keybinding

5. **Test the new pickers**
   - `<leader>sC`: Browse all available commands
   - `<leader>sk`: Find your keybindings
   - `<leader>sm`: Jump to marks (if added)
   - `<leader>so`: Browse vim options (if added)

6. **Commit the changes**
   - Stage and commit the keybinding additions
   - Example message: "Add additional Telescope pickers for commands and keymaps"

### Keybindings Explained

- `<leader>sC`: **[S]earch [C]ommands** - Browse all Ex commands
  - Useful for discovering plugin commands
  - More interactive than `:command`

- `<leader>sk`: **[S]earch [K]eymaps** - Browse all key mappings
  - Find what a key does
  - Discover keybindings you forgot
  - Most useful of the bunch

- `<leader>sm`: **[S]earch [M]arks** - Jump to marks
  - Interactive mark navigation
  - Better than `:marks`

- `<leader>so`: **[S]earch [O]ptions** - Browse vim options
  - Explore `:set` options
  - Learn what settings are available

### Expected Outcome
- More discoverable Neovim features
- Interactive exploration of commands and keybindings
- Consistent Telescope-based interface for everything
- Better learning/discovery experience

### Note on Highlights Picker

The original suggestion included `<leader>sH` for searching highlights, but this is very niche:
- Only useful when customizing themes
- Most users never need it
- Can add later if needed: `require('telescope.builtin').highlights()`

### Recommendation

Start with just **commands** and **keymaps** - these are the most practical:
```lua
vim.keymap.set('n', '<leader>sC', function()
  require('telescope.builtin').commands()
end, { desc = '[S]earch [C]ommands' })

vim.keymap.set('n', '<leader>sk', function()
  require('telescope.builtin').keymaps()
end, { desc = '[S]earch [K]eymaps' })
```

Add marks and options later if you find yourself wanting them.

---

## Summary

Your Neovim configuration has **9 tasks** organized by priority:

- **Priority 1 (Critical)**: 2 tasks - Fix duplicate configurations
- **Priority 2 (High Impact)**: 3 tasks - Python LSP, lazy-lock, trouble.nvim
- **Priority 3 (Quality of Life)**: 2 tasks - Spectre, format-on-save
- **Priority 4 (Nice to Have)**: 2 tasks - Sessions, Telescope pickers

**Recommended approach:**
1. Start with Priority 1 (quick wins, fixes conflicts)
2. Move to Priority 2 (significant improvements)
3. Add Priority 3 as time permits
4. Priority 4 is completely optional

---

## Future Enhancement Tasks

(Additional enhancement tasks will be added here as identified)
