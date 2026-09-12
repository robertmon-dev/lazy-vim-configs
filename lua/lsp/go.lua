return {
  "neovim/nvim-lspconfig",
  init_options = {
    command = {
      "golangci-lint",
      "run",
      "--output.json.path=stdout",
      "--path-mode=abs",
      "--allow-parallel-runners",
    },
  },
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
      golangci_lint_ls = {
        cmd = { "golangci-lint-langserver" },
        filetypes = { "go" },
        flags = {
          debounce_text_changes = 1000,
        },
        init_options = {
          command = {
            "golangci-lint",
            "run",
            "--output.json.path=stdout",
            "--path-mode=abs",
          },
        },
      },
    },
  },
}
