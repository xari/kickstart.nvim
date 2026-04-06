return {
  'https://gitlab.com/schrieveslaach/sonarlint.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- For better syntax parsing
    'neovim/nvim-lspconfig', -- Required for LSP setup
    'mfussenegger/nvim-jdtls', -- Highly recommended for Java projects with SonarLint
  },
  ft = { 'java' }, -- Only load for Java files
  opts = {
    server = {
      connected = {
        -- client_id is the ID of the Sonar LSP
        -- url is the url it wants to connect to
        get_credentials = function(client_id, url)
          if url == 'https://next.sonarqube.com/sonarqube' then
            return vim.fn.getenv 'SONARQUBE_TOKEN'
          elseif url == 'EU_sonarsource' then
            return vim.fn.getenv 'SONARCLOUD_TOKEN'
          end
        end,
      },
      cmd = {
        'sonarlint-language-server',
        '-stdio',
        '-analyzers',
        -- vim.fn.expand '~/.local/share/nvim/mason/packages/sonarlint-language-server/extension/analyzers/sonarjava.jar',
        vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarjava.jar',
      },
      settings = {
        sonarlint = {
          connectedMode = {
            connections = {
              sonarqube = {
                {
                  connectionId = 'next',
                  -- this is the url that will go into get_credentials
                  serverUrl = 'https://next.sonarqube.com/sonarqube',
                  disableNotifications = false,
                },
              },
              -- sonarcloud = {
              --   {
              --     connectionId = 'sonarcloud.io',
              --     region = 'EU', -- or US
              --     organizationKey = 'sonarsource',
              --     disableNotifications = false,
              --   },
              -- },
            },
          },
        },
      },

      before_init = function(params, config)
        -- Your personal configuration needs to provide a mapping of root folders and project keys
        --
        -- In the future a integration with https://github.com/folke/neoconf.nvim or some similar
        -- plugin, might be worthwhile.
        local project_root_and_ids = {
          ['~/Projects/sonar-enterprise/'] = 'SonarSource_sonar-enterprise',
          ['~/Projects/sonarqube-fix-suggestions/'] = 'SonarSource_sonarqube-fix-suggestions',
          ['~/Projects/sonarcloud-fix-suggestions/'] = 'SonarSource_sonarcloud-fix-suggestions',
          -- … further mappings …
        }

        config.settings.sonarlint.connectedMode.project = {
          connectionId = 'next',
          projectKey = project_root_and_ids[params.rootPath],
        }
      end,
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
    -- require('mason-lspconfig').setup {
    --   handlers = {
    --     -- ... existing handlers ...
    --     function(server_name)
    --       if server_name == 'sonarlint' then
    --         -- Mason-lspconfig will recognize "sonarlint" as corresponding to
    --         -- the installed "sonarlint-language-server".
    --         -- The sonarlint.nvim plugin typically handles its setup directly,
    --         -- so you might not need a full lspconfig.sonarlint.setup here.
    --         -- Just ensuring this handler path exists is often enough.
    --         return
    --       end
    --       -- ... default handler ...
    --     end,
    --   },
    -- }
  end,
}
