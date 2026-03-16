return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gopls = {
        settings = {
          gopls = {
            gofumpt = true,

            staticcheck = true,
            completeUnimported = true,
            usePlaceholders = true,

            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },

            analyses = {
              fieldalignment = true,
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },

            codelenses = {
              generate = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
            },
          },
        },
      },
    },
  },
}
