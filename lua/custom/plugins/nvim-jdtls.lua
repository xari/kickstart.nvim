return {
  'mfussenegger/nvim-jdtls',
  ft = { 'java' }, -- Load only for Java files
  dependencies = {
    'williamboman/mason.nvim', -- Ensure Mason is a dependency
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
          -- sources = {
          --   organizeImports = {
          --     importOrder = '/Users/harry.anderson/Projects/sonar-developer-toolset/eclipse/sonar.importorder',
          --   },
          -- },
          format = {
            settings = {
              url = vim.fn.expand '~/Projects/sonar-developer-toolset/eclipse/sonar-formatter.xml',
              -- profile = 'SonarQube',
            },
            -- options = {
            --   tabSize = 2,
            --   insertSpaces = true,
            --   trimTrailingWhitespace = true,
            -- },
          },
          -- completion = {
          --   importOrder = '/Users/harry.anderson/Projects/sonar-developer-toolset/eclipse/sonar.importorder',
          -- },
          completion = {
            importOrder = {
              '', -- regular imports first
              '#', -- static imports second
            },
          },
        },
      },

      init_options = {
        -- settings = {
        --   ['java.completion.importOrder'] = '/Users/harry.anderson/Projects/sonar-developer-toolset/eclipse/sonar.importorder',
        -- },
        extendedClientCapabilities = {
          classFileContentsSupport = true,
          -- generateToStringPromptSupport = true,
          -- hashCodeEqualsPromptSupport = true,
          -- advancedExtractRefactoringSupport = true,
          advancedOrganizeImportsSupport = true, -- This might help with import ordering!
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
