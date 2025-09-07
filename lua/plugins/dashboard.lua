return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      theme = 'hyper',
      config = {
        week_header = {
          enable = true,
        },
        shortcut = {
          {
            icon = '󰙅 ',
            desc = 'Update',
            group = '@property',
            action = 'Lazy update',
            key = 'u'
          },
          {
            icon = ' ',
            desc = 'Files',
            group = 'Label',
            action = 'Telescope find_files',
            key = 'f'
          },
          {
            icon = ' ',
            desc = 'Config',
            group = 'Number',
            action = 'edit ~/.config/nvim/init.lua',
            key = 'c'
          },
          {
            icon = ' ',
            desc = 'Recent',
            group = 'Constant',
            action = 'Telescope oldfiles',
            key = 'r'
          },
          {
            icon = ' ',
            desc = 'Grep',
            group = 'Statement',
            action = 'Telescope live_grep',
            key = 'g'
          },
          {
            icon = '󰗼 ',
            desc = 'Quit',
            group = 'Error',
            action = 'qa',
            key = 'q'
          }
        },
        packages = { enable = true },
        project = { enable = true, limit = 8, label = 'Recent Projects' },
        mru = { limit = 10, label = 'Recent Files' },
      },
    }
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons' }
}