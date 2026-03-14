local my_autocmds = vim.api.nvim_create_augroup("MyAutocmds", { clear = true })

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = my_autocmds,
  command = "checktime",
  desc = "Check if buffers changed on disk",
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = my_autocmds,
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
  desc = "Trim trailing whitespace on save",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = my_autocmds,
  callback = function(args)
    vim.lsp.buf.format({ bufnr = args.buf, timeout_ms = 1000 })
  end,
  desc = "Trim trailing whitespace on save",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = my_autocmds,
  callback = function(args)
    vim.lsp.buf.format({ bufnr = args.buf, timeout_ms = 1000 })
  end,
  desc = "Format with LSP after save",
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = "*",
  callback = function()
    if vim.bo.readonly then
      vim.defer_fn(function()
        vim.api.nvim_echo({
          { " ⚠️  WARNING: As this file is READONLY! \n", "WarningMsg" },
          { " You can save changes only after password provided.\n", "Normal" },
        }, true, {})
      end, 500)
    end
  end,
})
