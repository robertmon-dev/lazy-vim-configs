local editor_funcs = require("functions.editor")
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
}

for _, au in ipairs(autocmds) do
  local event = au[1]
  local opts = vim.tbl_deep_extend("force", { group = my_group }, au[2] or {})

  vim.api.nvim_create_autocmd(event, opts)
end
