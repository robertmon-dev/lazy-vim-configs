local editor_funcs = require("functions.editor")
local rust_funcs = require("functions.rust_actions")

local my_group = vim.api.nvim_create_augroup("MyAutocmds", { clear = true })

local autocmds = {
  {
    { "FocusGained", "TermClose", "TermLeave" },
    {
      command = "checktime",
      desc = "Check if buffers changed on disk",
    },
  },
  {
    "BufWritePre",
    {
      callback = editor_funcs.trim_whitespace,
      desc = "Trim trailing whitespace on save",
    },
  },
  {
    "BufWritePost",
    {
      callback = editor_funcs.format_lsp,
      desc = "Format with LSP after save",
    },
  },
  {
    "BufReadPost",
    {
      pattern = "*",
      callback = editor_funcs.check_readonly,
      desc = "Show warning for readonly files",
    },
  },
  {
    "FileType",
    {
      pattern = "rust",
      desc = "Rustaceanvim specific keymaps",
      callback = function(event)
        local rust_keymaps = {
          { "<leader>h", rust_funcs.hover_actions, { desc = "Rust Hover Actions" } },
          { "<leader>ca", rust_funcs.code_action, { desc = "Rust Code Action" } },
          { "<leader>cE", rust_funcs.explain_error, { desc = "Rust Explain Error" } },
          { "<leader>rr", rust_funcs.runnables, { desc = "Rust Run target" } },
          { "<leader>dr", rust_funcs.debuggables, { desc = "Rust Debug target" } },
          { "<leader>cM", rust_funcs.expand_macro, { desc = "Rust Expand Macro" } },
        }

        local default_opts = { silent = true }
        for _, mapping in ipairs(rust_keymaps) do
          local m_opts = vim.tbl_deep_extend("force", default_opts, mapping[3] or {}, { buffer = event.buf })
          vim.keymap.set("n", mapping[1], mapping[2], m_opts)
        end
      end,
    },
  },
}

for _, au in ipairs(autocmds) do
  local event = au[1]
  local opts = vim.tbl_deep_extend("force", { group = my_group }, au[2] or {})

  vim.api.nvim_create_autocmd(event, opts)
end
