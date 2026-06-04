local M = {}

function M.apply_buffer_keymaps(keymaps_table, bufnr)
  local default_opts = { silent = true }
  for _, mapping in ipairs(keymaps_table) do
    local m_opts = vim.tbl_deep_extend("force", default_opts, mapping[3] or {}, { buffer = bufnr })
    vim.keymap.set("n", mapping[1], mapping[2], m_opts)
  end
end

function M.apply_keymaps(keymaps, default_opts, keymap)
  for mode, maps_table in pairs(keymaps) do
    for _, mapping in ipairs(maps_table) do
      local m_opts = vim.tbl_deep_extend("force", default_opts, mapping[3] or {})
      keymap(mode, mapping[1], mapping[2], m_opts)
    end
  end
end

function M.apply_common_autocmds(autocmds, my_group)
  for _, au in ipairs(autocmds) do
    local event = au[1]
    local opts = vim.tbl_deep_extend("force", { group = my_group }, au[2] or {})

    vim.api.nvim_create_autocmd(event, opts)
  end
end

return M
