return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      eruby = { "htmlbeautifier" },
      ruby = { "standardrb" },
      markdown = { "markdownlint" },
      yaml = { "yamlfix" },
      json = { "jq" },

      javascript = { "prettier", stop_after_first = true },
      typescript = { "prettier", stop_after_first = true },
      javascriptreact = { "prettier", stop_after_first = true },
      typescriptreact = { "prettier", stop_after_first = true },

      lua = { "stylua" },
      go = { "goimports", "gofumpt" },
      rust = { "rustfmt" },
      c = { "clang-format" },
      cpp = { "clang-format" },

      ["_"] = { "trim_whitespace" },
    },

    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
  },
}
