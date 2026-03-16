local commit_funcs = require("functions.commitlint")

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "mason-org/mason.nvim",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, commit_funcs.tools)
      end,
    },
  },
  opts = {
    servers = {
      efm = commit_funcs.get_efm_config(),
    },
  },
}
