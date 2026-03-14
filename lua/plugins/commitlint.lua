return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "mason-org/mason.nvim",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { "efm", "commitlint" })
      end,
    },
  },
  opts = {
    servers = {
      efm = {
        filetypes = { "gitcommit" },

        root_dir = function(fname)
          return require("lspconfig.util").root_pattern(".git")(fname) or vim.fn.getcwd()
        end,

        init_options = {
          documentFormatting = false,
          documentRangeFormatting = false,
        },

        settings = {
          languages = {
            gitcommit = {
              {
                lintCommand = "sh -c 'awk \"/^#/ {exit} {print}\" | smart-commitlint --color=false'",
                lintStdin = true,
                lintFormats = { "%m" },
              },
            },
          },
        },
      },
    },
  },
}
