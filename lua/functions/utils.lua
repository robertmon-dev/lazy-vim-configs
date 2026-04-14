local M = {}

function M.apply_buffer_keymaps(keymaps_table, bufnr)
  local default_opts = { silent = true }
  for _, mapping in ipairs(keymaps_table) do
    local m_opts = vim.tbl_deep_extend("force", default_opts, mapping[3] or {}, { buffer = bufnr })
    vim.keymap.set("n", mapping[1], mapping[2], m_opts)
  end
end

return M
