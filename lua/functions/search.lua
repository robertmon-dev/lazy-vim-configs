local M = {}

function M.search_visual_selection()
  local builtin = require("telescope.builtin")
  vim.cmd('noau normal! "vy')
  local text = vim.fn.getreg("v")

  text = text:gsub("\n", " ")
  text = vim.trim(text)

  if text ~= "" then
    builtin.live_grep({ default_text = text })
  end
end

return M
