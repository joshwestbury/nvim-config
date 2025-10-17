return {
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sF', function()
        builtin.find_files { hidden = true, no_ignore = true, no_ignore_parent = true }
      end, { desc = '[S]earch [F]iles (all, incl. ignored)' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files (\".\" for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'bash', 'c', 'css', 'diff', 'html', 'javascript', 'json', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'python', 'query', 'tsx', 'typescript', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      -- Prevent installation conflicts
      sync_install = false,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  -- Git integration with vim-fugitive
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'Gstatus', 'Gblame', 'Gpush', 'Gpull' },
    config = function()
      -- Key mappings for vim-fugitive
      vim.keymap.set('n', '<leader>gs', '<cmd>Git<cr>', { desc = '[G]it [S]tatus' })
      vim.keymap.set('n', '<leader>gp', '<cmd>Git push<cr>', { desc = '[G]it [P]ush' })
      vim.keymap.set('n', '<leader>gP', '<cmd>Git pull<cr>', { desc = '[G]it [P]ull' })
      vim.keymap.set('n', '<leader>gb', '<cmd>Git blame<cr>', { desc = '[G]it [B]lame' })
      vim.keymap.set('n', '<leader>gd', '<cmd>Gdiffsplit<cr>', { desc = '[G]it [D]iff split' })
      vim.keymap.set('n', '<leader>gh', '<cmd>diffget //2<cr>', { desc = '[G]it diff get [H]EAD (left)' })
      vim.keymap.set('n', '<leader>gl', '<cmd>diffget //3<cr>', { desc = '[G]it diff get [L]ocal (right)' })
      vim.keymap.set('n', '<leader>gw', '<cmd>Gwrite<cr>', { desc = '[G]it [W]rite (stage file)' })
      vim.keymap.set('n', '<leader>gco', '<cmd>Git checkout<space>', { desc = '[G]it [C]heck[o]ut' })
      vim.keymap.set('n', '<leader>gcb', '<cmd>Git checkout -b<space>', { desc = '[G]it [C]reate [B]ranch' })
      vim.keymap.set('n', '<leader>gc', '<cmd>Git commit<cr>', { desc = '[G]it [C]ommit' })
      vim.keymap.set('n', '<leader>gL', '<cmd>Git log --oneline<cr>', { desc = '[G]it [L]og' })
    end,
  },

  -- Enhanced Git diff and history viewer
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewRefresh', 'DiffviewFileHistory' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('diffview').setup({
        diff_binaries = false,
        enhanced_diff_hl = true,
        git_cmd = { 'git' },
        hg_cmd = { 'hg' },
        use_icons = vim.g.have_nerd_font,
        show_help_hints = true,
        watch_index = true,
        icons = {
          folder_closed = '',
          folder_open = '',
        },
        signs = {
          fold_closed = '',
          fold_open = '',
          done = '✓',
        },
        view = {
          default = {
            layout = 'diff2_horizontal',
            disable_diagnostics = false,
            winbar_info = false,
          },
          merge_tool = {
            layout = 'diff3_horizontal',
            disable_diagnostics = true,
            winbar_info = true,
          },
          file_history = {
            layout = 'diff2_horizontal',
            disable_diagnostics = false,
            winbar_info = false,
          },
        },
        file_panel = {
          listing_style = 'tree',
          tree_options = {
            flatten_dirs = true,
            folder_statuses = 'only_folded',
          },
          win_config = {
            position = 'left',
            width = 35,
            win_opts = {}
          },
        },
        file_history_panel = {
          log_options = {
            git = {
              single_file = {
                diff_merges = 'combined',
              },
              multi_file = {
                diff_merges = 'first-parent',
              },
            },
          },
          win_config = {
            position = 'bottom',
            height = 16,
            win_opts = {}
          },
        },
        commit_log_panel = {
          win_config = {
            position = 'bottom',
            height = 16,
            win_opts = {}
          }
        },
        default_args = {
          DiffviewOpen = {},
          DiffviewFileHistory = {},
        },
        hooks = {},
        keymaps = {
          disable_defaults = false,
          view = {
            {
              'n',
              '<tab>',
              function()
                require('diffview.actions').select_next_entry()
              end,
              { desc = 'Open the diff for the next file' }
            },
            {
              'n',
              '<s-tab>',
              function()
                require('diffview.actions').select_prev_entry()
              end,
              { desc = 'Open the diff for the previous file' }
            },
            {
              'n',
              'gf',
              function()
                require('diffview.actions').goto_file()
              end,
              { desc = 'Open the file in the previous tabpage' }
            },
            {
              'n',
              '<C-w><C-f>',
              function()
                require('diffview.actions').goto_file_split()
              end,
              { desc = 'Open the file in a new split' }
            },
            {
              'n',
              '<C-w>gf',
              function()
                require('diffview.actions').goto_file_tab()
              end,
              { desc = 'Open the file in a new tabpage' }
            },
            {
              'n',
              '<leader>e',
              function()
                require('diffview.actions').toggle_files()
              end,
              { desc = 'Toggle the file panel.' }
            },
            {
              'n',
              '<leader>b',
              function()
                require('diffview.actions').toggle_files()
              end,
              { desc = 'Toggle the file panel' }
            },
            {
              'n',
              'g<C-x>',
              function()
                require('diffview.actions').cycle_layout()
              end,
              { desc = 'Cycle through available layouts.' }
            },
            {
              'n',
              '[x',
              function()
                require('diffview.actions').prev_conflict()
              end,
              { desc = 'In the merge-tool: jump to the previous conflict' }
            },
            {
              'n',
              ']x',
              function()
                require('diffview.actions').next_conflict()
              end,
              { desc = 'In the merge-tool: jump to the next conflict' }
            },
            {
              'n',
              '<leader>co',
              function()
                require('diffview.actions').conflict_choose('ours')
              end,
              { desc = 'Choose the OURS version of a conflict' }
            },
            {
              'n',
              '<leader>ct',
              function()
                require('diffview.actions').conflict_choose('theirs')
              end,
              { desc = 'Choose the THEIRS version of a conflict' }
            },
            {
              'n',
              '<leader>cb',
              function()
                require('diffview.actions').conflict_choose('base')
              end,
              { desc = 'Choose the BASE version of a conflict' }
            },
            {
              'n',
              '<leader>ca',
              function()
                require('diffview.actions').conflict_choose('all')
              end,
              { desc = 'Choose all the versions of a conflict' }
            },
            {
              'n',
              'dx',
              function()
                require('diffview.actions').conflict_choose('none')
              end,
              { desc = 'Delete the conflict region' }
            },
          },
          file_panel = {
            {
              'n',
              'j',
              function()
                require('diffview.actions').next_entry()
              end,
              { desc = 'Bring the cursor to the next file entry' }
            },
            {
              'n',
              '<down>',
              function()
                require('diffview.actions').next_entry()
              end,
              { desc = 'Bring the cursor to the next file entry' }
            },
            {
              'n',
              'k',
              function()
                require('diffview.actions').prev_entry()
              end,
              { desc = 'Bring the cursor to the previous file entry.' }
            },
            {
              'n',
              '<up>',
              function()
                require('diffview.actions').prev_entry()
              end,
              { desc = 'Bring the cursor to the previous file entry.' }
            },
            {
              'n',
              '<cr>',
              function()
                require('diffview.actions').select_entry()
              end,
              { desc = 'Open the diff for the selected entry.' }
            },
            {
              'n',
              'o',
              function()
                require('diffview.actions').select_entry()
              end,
              { desc = 'Open the diff for the selected entry.' }
            },
            {
              'n',
              '<2-LeftMouse>',
              function()
                require('diffview.actions').select_entry()
              end,
              { desc = 'Open the diff for the selected entry.' }
            },
            {
              'n',
              '-',
              function()
                require('diffview.actions').toggle_stage_entry()
              end,
              { desc = 'Stage / unstage the selected entry.' }
            },
            {
              'n',
              'S',
              function()
                require('diffview.actions').stage_all()
              end,
              { desc = 'Stage all entries.' }
            },
            {
              'n',
              'U',
              function()
                require('diffview.actions').unstage_all()
              end,
              { desc = 'Unstage all entries.' }
            },
            {
              'n',
              'X',
              function()
                require('diffview.actions').restore_entry()
              end,
              { desc = 'Restore entry to the state on the left side.' }
            },
            {
              'n',
              'L',
              function()
                require('diffview.actions').open_commit_log()
              end,
              { desc = 'Open the commit log panel.' }
            },
            {
              'n',
              'zo',
              function()
                require('diffview.actions').open_fold()
              end,
              { desc = 'Expand fold' }
            },
            {
              'n',
              'zc',
              function()
                require('diffview.actions').close_fold()
              end,
              { desc = 'Collapse fold' }
            },
            {
              'n',
              'za',
              function()
                require('diffview.actions').toggle_fold()
              end,
              { desc = 'Toggle fold' }
            },
            {
              'n',
              'zR',
              function()
                require('diffview.actions').open_all_folds()
              end,
              { desc = 'Expand all folds' }
            },
            {
              'n',
              'zM',
              function()
                require('diffview.actions').close_all_folds()
              end,
              { desc = 'Collapse all folds' }
            },
            {
              'n',
              '<c-b>',
              function()
                require('diffview.actions').scroll_view(-0.25)
              end,
              { desc = 'Scroll the view up' }
            },
            {
              'n',
              '<c-f>',
              function()
                require('diffview.actions').scroll_view(0.25)
              end,
              { desc = 'Scroll the view down' }
            },
            {
              'n',
              '<tab>',
              function()
                require('diffview.actions').select_next_entry()
              end,
              { desc = 'Open the diff for the next file' }
            },
            {
              'n',
              '<s-tab>',
              function()
                require('diffview.actions').select_prev_entry()
              end,
              { desc = 'Open the diff for the previous file' }
            },
            {
              'n',
              'gf',
              function()
                require('diffview.actions').goto_file()
              end,
              { desc = 'Open the file in the previous tabpage' }
            },
            {
              'n',
              '<C-w><C-f>',
              function()
                require('diffview.actions').goto_file_split()
              end,
              { desc = 'Open the file in a new split' }
            },
            {
              'n',
              '<C-w>gf',
              function()
                require('diffview.actions').goto_file_tab()
              end,
              { desc = 'Open the file in a new tabpage' }
            },
            {
              'n',
              'i',
              function()
                require('diffview.actions').listing_style()
              end,
              { desc = 'Toggle between \'list\' and \'tree\' views' }
            },
            {
              'n',
              'f',
              function()
                require('diffview.actions').toggle_flatten_dirs()
              end,
              { desc = 'Flatten empty subdirectories in tree listing style.' }
            },
            {
              'n',
              'R',
              function()
                require('diffview.actions').refresh_files()
              end,
              { desc = 'Update stats and entries in the file list.' }
            },
            {
              'n',
              '<leader>e',
              function()
                require('diffview.actions').toggle_files()
              end,
              { desc = 'Toggle the file panel' }
            },
            {
              'n',
              '<leader>b',
              function()
                require('diffview.actions').toggle_files()
              end,
              { desc = 'Toggle the file panel' }
            },
            {
              'n',
              'g<C-x>',
              function()
                require('diffview.actions').cycle_layout()
              end,
              { desc = 'Cycle through available layouts' }
            },
            {
              'n',
              '[x',
              function()
                require('diffview.actions').prev_conflict()
              end,
              { desc = 'In the merge-tool: jump to the previous conflict' }
            },
            {
              'n',
              ']x',
              function()
                require('diffview.actions').next_conflict()
              end,
              { desc = 'In the merge-tool: jump to the next conflict' }
            },
          },
          file_history_panel = {
            {
              'n',
              'g!',
              function()
                require('diffview.actions').options()
              end,
              { desc = 'Open the option panel' }
            },
            {
              'n',
              '<C-A-d>',
              function()
                require('diffview.actions').open_in_diffview()
              end,
              { desc = 'Open the entry under the cursor in a diffview' }
            },
            {
              'n',
              'y',
              function()
                require('diffview.actions').copy_hash()
              end,
              { desc = 'Copy the commit hash of the entry under the cursor' }
            },
            {
              'n',
              'L',
              function()
                require('diffview.actions').open_commit_log()
              end,
              { desc = 'Show commit details' }
            },
            {
              'n',
              'zR',
              function()
                require('diffview.actions').open_all_folds()
              end,
              { desc = 'Expand all folds' }
            },
            {
              'n',
              'zM',
              function()
                require('diffview.actions').close_all_folds()
              end,
              { desc = 'Collapse all folds' }
            },
            {
              'n',
              'j',
              function()
                require('diffview.actions').next_entry()
              end,
              { desc = 'Bring the cursor to the next file entry' }
            },
            {
              'n',
              '<down>',
              function()
                require('diffview.actions').next_entry()
              end,
              { desc = 'Bring the cursor to the next file entry' }
            },
            {
              'n',
              'k',
              function()
                require('diffview.actions').prev_entry()
              end,
              { desc = 'Bring the cursor to the previous file entry.' }
            },
            {
              'n',
              '<up>',
              function()
                require('diffview.actions').prev_entry()
              end,
              { desc = 'Bring the cursor to the previous file entry.' }
            },
            {
              'n',
              '<cr>',
              function()
                require('diffview.actions').select_entry()
              end,
              { desc = 'Open the diff for the selected entry.' }
            },
            {
              'n',
              'o',
              function()
                require('diffview.actions').select_entry()
              end,
              { desc = 'Open the diff for the selected entry.' }
            },
            {
              'n',
              '<2-LeftMouse>',
              function()
                require('diffview.actions').select_entry()
              end,
              { desc = 'Open the diff for the selected entry.' }
            },
            {
              'n',
              '<c-b>',
              function()
                require('diffview.actions').scroll_view(-0.25)
              end,
              { desc = 'Scroll the view up' }
            },
            {
              'n',
              '<c-f>',
              function()
                require('diffview.actions').scroll_view(0.25)
              end,
              { desc = 'Scroll the view down' }
            },
            {
              'n',
              '<tab>',
              function()
                require('diffview.actions').select_next_entry()
              end,
              { desc = 'Open the diff for the next file' }
            },
            {
              'n',
              '<s-tab>',
              function()
                require('diffview.actions').select_prev_entry()
              end,
              { desc = 'Open the diff for the previous file' }
            },
            {
              'n',
              'gf',
              function()
                require('diffview.actions').goto_file()
              end,
              { desc = 'Open the file in the previous tabpage' }
            },
            {
              'n',
              '<C-w><C-f>',
              function()
                require('diffview.actions').goto_file_split()
              end,
              { desc = 'Open the file in a new split' }
            },
            {
              'n',
              '<C-w>gf',
              function()
                require('diffview.actions').goto_file_tab()
              end,
              { desc = 'Open the file in a new tabpage' }
            },
            {
              'n',
              '<leader>e',
              function()
                require('diffview.actions').toggle_files()
              end,
              { desc = 'Toggle the file panel' }
            },
            {
              'n',
              '<leader>b',
              function()
                require('diffview.actions').toggle_files()
              end,
              { desc = 'Toggle the file panel' }
            },
            {
              'n',
              'g<C-x>',
              function()
                require('diffview.actions').cycle_layout()
              end,
              { desc = 'Cycle through available layouts' }
            },
          },
          option_panel = {
            {
              'n',
              '<tab>',
              function()
                require('diffview.actions').select_entry()
              end,
              { desc = 'Change the current option' }
            },
            {
              'n',
              'q',
              function()
                require('diffview.actions').close()
              end,
              { desc = 'Close the diffview' }
            },
          },
          help_panel = {
            {
              'n',
              'q',
              function()
                require('diffview.actions').close()
              end,
              { desc = 'Close help menu' }
            },
          },
        },
      })

      -- Key mappings for diffview
      vim.keymap.set('n', '<leader>gdo', '<cmd>DiffviewOpen<cr>', { desc = '[G]it [D]iffview [O]pen' })
      vim.keymap.set('n', '<leader>gdc', '<cmd>DiffviewClose<cr>', { desc = '[G]it [D]iffview [C]lose' })
      vim.keymap.set('n', '<leader>gdh', '<cmd>DiffviewFileHistory<cr>', { desc = '[G]it [D]iffview File [H]istory' })
      vim.keymap.set('n', '<leader>gdH', '<cmd>DiffviewFileHistory %<cr>', { desc = '[G]it [D]iffview Current File [H]istory' })
      vim.keymap.set('n', '<leader>gdt', '<cmd>DiffviewToggleFiles<cr>', { desc = '[G]it [D]iffview [T]oggle Files' })
      vim.keymap.set('n', '<leader>gdr', '<cmd>DiffviewRefresh<cr>', { desc = '[G]it [D]iffview [R]efresh' })
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  -- Smart and powerful comment plugin
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      -- Enable Comment.nvim
      require('Comment').setup({
        -- Add a space b/w comment and the line
        padding = true,
        -- Whether the cursor should stay at its position
        sticky = true,
        -- Lines to be ignored while (un)comment
        ignore = nil,
        -- LHS of toggle mappings in NORMAL mode
        toggler = {
          -- Line-comment toggle keymap
          line = 'gcc',
          -- Block-comment toggle keymap
          block = 'gbc',
        },
        -- LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
          -- Line-comment keymap
          line = 'gc',
          -- Block-comment keymap
          block = 'gb',
        },
        -- LHS of extra mappings
        extra = {
          -- Add comment on the line above
          above = 'gcO',
          -- Add comment on the line below
          below = 'gco',
          -- Add comment at the end of line
          eol = 'gcA',
        },
        -- Enable keybindings
        -- NOTE: If given `false` then the plugin won't create any mappings
        mappings = {
          -- Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
          basic = true,
          -- Extra mapping; `gco`, `gcO`, `gcA`
          extra = true,
        },
        -- Function to call before (un)comment
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        -- Function to call after (un)comment
        post_hook = nil,
      })
    end,
  },

  -- Auto-close brackets, quotes, and parentheses
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    dependencies = { 'saghen/blink.cmp' },
    config = function()
      require('nvim-autopairs').setup({
        check_ts = true,
        ts_config = {
          lua = { 'string', 'source' },
          javascript = { 'string', 'template_string' },
          typescript = { 'string', 'template_string' },
          java = false,
        },
        disable_filetype = { 'TelescopePrompt', 'spectre_panel' },
        disable_in_macro = true,
        disable_in_visualblock = false,
        disable_in_replace_mode = true,
        ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
        enable_moveright = true,
        enable_afterquote = true,
        enable_check_bracket_line = true,
        enable_bracket_in_quote = true,
        enable_abbr = false,
        break_undo = true,
        check_comma = true,
        map_cr = true,
        map_bs = true,
        map_c_h = false,
        map_c_w = false,
      })

      -- Note: blink.cmp integration is handled differently than nvim-cmp
      -- blink.cmp has built-in autopairs support, so we don't need manual integration

      -- Custom rules for specific languages
      local Rule = require('nvim-autopairs.rule')
      local npairs = require('nvim-autopairs')

      -- Add spaces inside parentheses for function calls
      npairs.add_rule(Rule('( ', ' )')
        :with_pair(function(opts)
          local pair = opts.line:sub(opts.col - 1, opts.col)
          return vim.tbl_contains({ '()', '[]', '{}' }, pair)
        end)
        :with_move(function(opts)
          return opts.next_char == ')'
        end)
        :with_cr(function(opts)
          local pair = opts.line:sub(opts.col - 1, opts.col)
          return vim.tbl_contains({ '()', '[]', '{}' }, pair)
        end))

      -- Add rule for markdown code blocks
      npairs.add_rule(Rule('```', '```', 'markdown'))

      -- Add rule for HTML/JSX tags
      npairs.add_rule(Rule('<', '>', { 'html', 'javascriptreact', 'typescriptreact' })
        :with_pair(function(opts)
          -- Only pair if it looks like a tag
          local line = opts.line
          local col = opts.col
          local before = line:sub(1, col - 1)
          local after = line:sub(col)
          
          -- Don't pair for comparison operators
          if before:match('%s*[<>=]$') or after:match('^[>=]') then
            return false
          end
          
          return true
        end))

      -- Custom key mappings for enhanced functionality
      vim.keymap.set('i', '<C-h>', '<BS>', { desc = 'Delete pair backwards' })
      
      -- Fast wrap for visual selections
      vim.keymap.set('v', '(', '<ESC>`>a)<ESC>`<i(<ESC>', { desc = 'Wrap selection in parentheses' })
      vim.keymap.set('v', '[', '<ESC>`>a]<ESC>`<i[<ESC>', { desc = 'Wrap selection in brackets' })
      vim.keymap.set('v', '{', '<ESC>`>a}<ESC>`<i{<ESC>', { desc = 'Wrap selection in braces' })
      vim.keymap.set('v', '"', '<ESC>`>a"<ESC>`<i"<ESC>', { desc = 'Wrap selection in double quotes' })
      vim.keymap.set('v', "'", "<ESC>`>a'<ESC>`<i'<ESC>", { desc = 'Wrap selection in single quotes' })
      vim.keymap.set('v', '`', '<ESC>`>a`<ESC>`<i`<ESC>', { desc = 'Wrap selection in backticks' })
    end,
  },

  -- Modern folding with treesitter and LSP support
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async',
      'nvim-treesitter/nvim-treesitter',
    },
    event = 'BufRead',
    config = function()
      -- Configure fold options
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Custom fold text function for better display
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, {suffix, 'MoreMsg'})
        return newVirtText
      end

      -- Provider priority and configuration
      require('ufo').setup({
        fold_virt_text_handler = handler,
        provider_selector = function(bufnr, filetype, buftype)
          -- Use LSP folding for supported languages, fallback to treesitter
          local lsp_clients = vim.lsp.get_clients({ bufnr = bufnr })
          local has_lsp_folding = false
          
          for _, client in ipairs(lsp_clients) do
            if client.server_capabilities.foldingRangeProvider then
              has_lsp_folding = true
              break
            end
          end
          
          if has_lsp_folding then
            return {'lsp', 'indent'}
          else
            return {'treesitter', 'indent'}
          end
        end,
        open_fold_hl_timeout = 150,
        close_fold_kinds_for_ft = {
          default = {'imports', 'comment'},
          json = {'array'},
          c = {'comment', 'region'},
          cpp = {'comment', 'region'},
          python = {'imports'},
          javascript = {'imports', 'comment'},
          typescript = {'imports', 'comment'},
          javascriptreact = {'imports', 'comment'},
          typescriptreact = {'imports', 'comment'},
        },
        preview = {
          win_config = {
            border = {'', '─', '', '', '', '─', '', ''},
            winhighlight = 'Normal:Folded',
            winblend = 0
          },
          mappings = {
            scrollU = '<C-u>',
            scrollD = '<C-d>',
            jumpTop = '[',
            jumpBot = ']'
          }
        }
      })

      -- Enhanced key mappings for folding
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
      vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = 'Open folds except kinds' })
      vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, { desc = 'Close folds with' })
      
      -- Peek folded lines
      vim.keymap.set('n', 'K', function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
          -- Use LSP hover if no fold is found
          vim.lsp.buf.hover()
        end
      end, { desc = 'Peek Fold or Hover' })

      -- Advanced fold navigation
      vim.keymap.set('n', ']z', function()
        require('ufo').goNextClosedFold()
      end, { desc = 'Go to next closed fold' })

      vim.keymap.set('n', '[z', function()
        require('ufo').goPreviousClosedFold()
      end, { desc = 'Go to previous closed fold' })

      -- Toggle fold under cursor
      vim.keymap.set('n', '<space>z', function()
        local ufo = require('ufo')
        local lnum = vim.fn.line('.')
        local folded = vim.fn.foldclosed(lnum) ~= -1
        
        if folded then
          ufo.openFoldsExceptKinds()
        else
          ufo.closeFoldsWith()
        end
      end, { desc = 'Toggle fold under cursor' })

      -- Language-specific fold configurations
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'python' },
        callback = function()
          -- For Python, prefer folding by indentation for classes/functions
          require('ufo').setFoldVirtTextHandler(vim.api.nvim_get_current_buf(), handler)
        end,
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'json', 'jsonc' },
        callback = function()
          -- For JSON, fold arrays and objects
          vim.wo.foldmethod = 'syntax'
        end,
      })

      -- Auto-save folds
      vim.api.nvim_create_autocmd('BufWinLeave', {
        pattern = '*',
        callback = function()
          if vim.bo.filetype ~= '' and vim.bo.buftype == '' then
            vim.cmd('silent! mkview')
          end
        end,
      })

      vim.api.nvim_create_autocmd('BufWinEnter', {
        pattern = '*',
        callback = function()
          if vim.bo.filetype ~= '' and vim.bo.buftype == '' then
            vim.cmd('silent! loadview')
          end
        end,
      })

      -- Fold statistics in statusline (optional integration)
      local function fold_stats()
        local ok, ufo = pcall(require, 'ufo')
        if not ok then
          return ''
        end
        
        local foldlevel = vim.wo.foldlevel
        local folds = vim.fn.foldlevel(vim.fn.line('.'))
        
        if folds > 0 then
          return string.format(' 󰁂 %d/%d', folds, foldlevel)
        else
          return ''
        end
      end

      -- Add fold info to your statusline if desired
      -- You can integrate this with lualine by adding it to a section
    end,
  },

  -- Better terminal management with floating and split terminals
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    cmd = { 'ToggleTerm', 'TermExec' },
    keys = {
      { '<leader>tt', '<cmd>ToggleTerm<cr>', desc = '[T]oggle [T]erminal' },
      { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', desc = '[T]oggle [F]loating Terminal' },
      { '<leader>th', '<cmd>ToggleTerm direction=horizontal<cr>', desc = '[T]oggle [H]orizontal Terminal' },
      { '<leader>tv', '<cmd>ToggleTerm direction=vertical<cr>', desc = '[T]oggle [V]ertical Terminal' },
    },
    config = function()
      require('toggleterm').setup({
        size = function(term)
          if term.direction == 'horizontal' then
            return 15
          elseif term.direction == 'vertical' then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<c-\>]],
        on_create = function(term)
          -- Set local options for terminal buffers
          vim.opt_local.foldcolumn = '0'
          vim.opt_local.signcolumn = 'no'
          
          -- Create buffer-local keymaps for terminal
          local opts = { buffer = term.bufnr, noremap = true, silent = true }
          
          -- Easy escape from terminal mode
          vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
          vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
          vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
          vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
          vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
          vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
          vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
        end,
        on_open = function(term)
          -- Automatically enter insert mode when opening terminal
          vim.cmd('startinsert!')
          
          -- Set buffer-local settings
          vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
        end,
        on_close = function(term)
          -- Optional: Clean up when terminal closes
        end,
        hide_numbers = true,
        shade_filetypes = {},
        autochdir = false,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        persist_mode = true,
        direction = 'float',
        close_on_exit = true,
        shell = vim.o.shell,
        auto_scroll = true,
        float_opts = {
          border = 'curved',
          width = function()
            return math.floor(vim.o.columns * 0.8)
          end,
          height = function()
            return math.floor(vim.o.lines * 0.8)
          end,
          winblend = 0,
          highlights = {
            border = 'Normal',
            background = 'Normal',
          },
        },
        winbar = {
          enabled = false,
          name_formatter = function(term)
            return term.name
          end
        },
      })

      -- Custom terminal functions for specific use cases
      local Terminal = require('toggleterm.terminal').Terminal

      -- Lazygit integration
      local lazygit = Terminal:new({
        cmd = 'lazygit',
        dir = 'git_dir',
        direction = 'float',
        float_opts = {
          border = 'double',
          width = function()
            return math.floor(vim.o.columns * 0.9)
          end,
          height = function()
            return math.floor(vim.o.lines * 0.9)
          end,
        },
        on_open = function(term)
          vim.cmd('startinsert!')
          vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
        end,
        on_close = function(term)
          vim.cmd('startinsert!')
        end,
      })

      -- Python REPL
      local python = Terminal:new({
        cmd = 'python3',
        direction = 'float',
        float_opts = {
          border = 'double',
        },
      })

      -- Node.js REPL
      local node = Terminal:new({
        cmd = 'node',
        direction = 'float',
        float_opts = {
          border = 'double',
        },
      })

      -- htop system monitor
      local htop = Terminal:new({
        cmd = 'htop',
        direction = 'float',
        float_opts = {
          border = 'double',
          width = function()
            return math.floor(vim.o.columns * 0.9)
          end,
          height = function()
            return math.floor(vim.o.lines * 0.9)
          end,
        },
      })

      -- Custom keymaps for specialized terminals
      vim.keymap.set('n', '<leader>tg', function()
        lazygit:toggle()
      end, { desc = '[T]oggle Lazy[g]it' })

      vim.keymap.set('n', '<leader>tp', function()
        python:toggle()
      end, { desc = '[T]oggle [P]ython REPL' })

      vim.keymap.set('n', '<leader>tn', function()
        node:toggle()
      end, { desc = '[T]oggle [N]ode.js REPL' })

      vim.keymap.set('n', '<leader>tm', function()
        htop:toggle()
      end, { desc = '[T]oggle [M]onitor (htop)' })

      -- Quick terminal commands
      vim.keymap.set('n', '<leader>tr', function()
        vim.cmd('TermExec cmd="npm run dev"')
      end, { desc = '[T]erminal [R]un dev server' })

      vim.keymap.set('n', '<leader>tb', function()
        vim.cmd('TermExec cmd="npm run build"')
      end, { desc = '[T]erminal [B]uild project' })

      vim.keymap.set('n', '<leader>ts', function()
        vim.cmd('TermExec cmd="npm start"')
      end, { desc = '[T]erminal [S]tart project' })

      vim.keymap.set('n', '<leader>tc', function()
        vim.cmd('TermExec cmd="clear"')
      end, { desc = '[T]erminal [C]lear' })

      -- Send current line or selection to terminal
      vim.keymap.set('n', '<leader>tl', function()
        local line = vim.api.nvim_get_current_line()
        vim.cmd('TermExec cmd="' .. line .. '"')
      end, { desc = '[T]erminal send [L]ine' })

      vim.keymap.set('v', '<leader>ts', function()
        -- Get the visually selected text
        local start_pos = vim.fn.getpos("'<")
        local end_pos = vim.fn.getpos("'>")
        local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
        
        if #lines > 0 then
          -- Join lines and send to terminal
          local selection = table.concat(lines, '\n')
          vim.cmd('TermExec cmd="' .. selection .. '"')
        end
      end, { desc = '[T]erminal [S]end selection' })

      -- Multiple terminal management
      vim.keymap.set('n', '<leader>t1', '<cmd>1ToggleTerm<cr>', { desc = 'Toggle Terminal 1' })
      vim.keymap.set('n', '<leader>t2', '<cmd>2ToggleTerm<cr>', { desc = 'Toggle Terminal 2' })
      vim.keymap.set('n', '<leader>t3', '<cmd>3ToggleTerm<cr>', { desc = 'Toggle Terminal 3' })
      vim.keymap.set('n', '<leader>t4', '<cmd>4ToggleTerm<cr>', { desc = 'Toggle Terminal 4' })

      -- Terminal navigation in normal mode
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], { desc = 'Move to left window from terminal' })
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], { desc = 'Move to bottom window from terminal' })
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], { desc = 'Move to top window from terminal' })
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], { desc = 'Move to right window from terminal' })

      -- Resize terminals
      vim.keymap.set('t', '<C-Up>', [[<Cmd>resize +2<CR>]], { desc = 'Increase terminal height' })
      vim.keymap.set('t', '<C-Down>', [[<Cmd>resize -2<CR>]], { desc = 'Decrease terminal height' })
      vim.keymap.set('t', '<C-Left>', [[<Cmd>vertical resize -2<CR>]], { desc = 'Decrease terminal width' })
      vim.keymap.set('t', '<C-Right>', [[<Cmd>vertical resize +2<CR>]], { desc = 'Increase terminal width' })
    end,
  },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()
    end,
  },

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
}