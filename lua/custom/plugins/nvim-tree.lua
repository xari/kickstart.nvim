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
      view = {
        -- adaptive_size = true,
        float = {
          enable = true,
          open_win_config = function()
            local scr_w = vim.opt.columns:get()
            local scr_h = vim.opt.lines:get()
            local tree_w = 80
            local tree_h = math.floor(tree_w * scr_h / scr_w)

            return {
              border = 'double',
              relative = 'editor',
              width = tree_w,
              height = tree_h,
              col = (scr_w - tree_w) / 2,
              row = (scr_h - tree_h) / 2,
            }
          end,
        },
      },
    }
  end,
}
