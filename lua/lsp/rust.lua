return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = {
                  enable = true,
                },
              },
              procMacro = {
                enable = true,
              },
              inlayHints = {
                lifetimeElisionHints = {
                  enable = "always",
                  useParameterNames = true,
                },
                closureReturnTypeHints = { enable = "always" },
              },
            },
          },
        },
      }
    end,
  },
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup({})
    end,
  },
}
