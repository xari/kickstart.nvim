return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    return require('nvim-tree').setup {
      filters = {
        dotfiles = false,
      },
      update_focused_file = {
        enable = true,
      },
      view = { adaptive_size = true },
    }
  end,
}
