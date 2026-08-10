local M = {}

function M.pin_gitcommit_window()
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()

  if vim.api.nvim_win_get_config(win).relative ~= "" then
    return
  end

  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(ui.width * 0.6)
  local height = math.floor(ui.height * 0.4)

  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = ui.height - height - 3,
    col = ui.width - width - 2,
    style = "minimal",
    border = "rounded",
    title = " Commit message ",
    title_pos = "center",
  }

  vim.api.nvim_win_close(win, false)
  local new_win = vim.api.nvim_open_win(buf, true, opts)

  vim.wo[new_win].winblend = 0
  vim.bo[buf].bufhidden = "wipe"
end

return M
