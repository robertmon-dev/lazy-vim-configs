return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      vtsls = {
        settings = {
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
              completion = {
                enableServerSideFuzzyMatch = true,
                entriesLimit = 50,
              },
            },
            tsserver = {
              maxTsServerMemory = 8192,
              globalPlugins = {},
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              completeFunctionCalls = true,
              autoImports = true,
            },
            validate = { enable = true },
            tsserver = {
              watchOptions = {
                watchFile = "useFsEvents",
                watchDirectory = "useFsEvents",
                fallbackPolling = "dynamicPriority",
                synchronousWatchDirectory = false,
                excludeDirectories = {
                  "**/node_modules",
                  "**/.git",
                  "**/dist",
                  "**/build",
                  "**/.next",
                  "**/coverage",
                },
              },
            },
            inlayHints = {
              enumMemberValues = { enabled = false },
              functionLikeReturnTypes = { enabled = false },
              parameterNames = { enabled = "none" },
              parameterTypes = { enabled = false },
              propertyDeclarationTypes = { enabled = false },
              variableTypes = { enabled = false },
            },
          },
          javascript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = { completeFunctionCalls = true },
            inlayHints = {
              parameterNames = { enabled = "none" },
              variableTypes = { enabled = false },
            },
          },
        },
      },
    },
  },
}
