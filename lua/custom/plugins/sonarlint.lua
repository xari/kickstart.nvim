return {
  'https://gitlab.com/schrieveslaach/sonarlint.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'neovim/nvim-lspconfig',
    'mfussenegger/nvim-jdtls',
  },
  ft = { 'java', 'python' },
  opts = {
    server = {
      cmd = {
        'java',
        '--enable-final-field-mutation=ALL-UNNAMED',
        '-jar',
        vim.fn.stdpath 'data' .. '/mason/packages/sonarlint-language-server/extension/server/sonarlint-ls.jar',
        '-stdio',
        '-analyzers',
        vim.fn.stdpath 'data' .. '/mason/share/sonarlint-analyzers/sonarjava.jar',
        vim.fn.stdpath 'data' .. '/mason/share/sonarlint-analyzers/sonarpython.jar',
      },
    },
    filetypes = {
      'java',
      'python',
    },
    resolve_gradle_paths = {
      enabled = true,
    },
  },
  config = function(_, opts)
    require('sonarlint').setup(opts)
  end,
}
