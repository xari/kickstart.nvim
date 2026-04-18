return {
  'mfussenegger/nvim-jdtls',
  ft = { 'java' }, -- Load only for Java files
  dependencies = {
    'mason-org/mason.nvim',
  },
  config = function()
    local workspace_dir = vim.fn.stdpath 'data' .. '/jdtls-workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

    local config = {
      cmd = {
        -- 💀
        vim.fn.exepath 'java',

        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens',
        'java.base/java.util=ALL-UNNAMED',
        '--add-opens',
        'java.base/java.lang=ALL-UNNAMED',

        -- 💀
        '-jar',
        vim.fn.glob(vim.fn.expand '$MASON/share/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),

        -- 💀
        '-configuration',
        vim.fn.expand '$MASON/share/jdtls/config',

        -- 💀
        '-data',
        workspace_dir,
      },

      root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew' }),

      settings = {
        java = {
          -- Use the Sonar Eclipse formatter if present; otherwise omit the
          -- setting and let jdtls fall back to its built-in default formatter.
          format = (function()
            local formatter = vim.fn.expand '~/Projects/sonar-developer-toolset/eclipse/sonar-formatter.xml'
            if vim.uv.fs_stat(formatter) then
              return { settings = { url = formatter } }
            end
          end)(),
          completion = {
            importOrder = {
              '', -- regular imports first
              '#', -- static imports second
            },
          },
        },
      },

      init_options = {
        extendedClientCapabilities = {
          classFileContentsSupport = true,
          advancedOrganizeImportsSupport = true,
        },
      },

      timeout_ms = 10000,
    }

    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*.java',
      callback = function()
        vim.lsp.buf.code_action {
          context = { only = { 'source.organizeImports' } },
          apply = true,
        }
      end,
    })

    require('jdtls').start_or_attach(config)
  end,
}
