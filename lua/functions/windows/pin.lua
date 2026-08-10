local M = {}
local state = { win = nil }

local function get_float_geometry()
  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(ui.width * 0.6)
  local height = math.floor(ui.height * 0.4)
  return {
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
end

function M.pin_gitcommit_window(event)
  local buf = event and event.buf or vim.api.nvim_get_current_buf()

  vim.schedule(function()
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end
    if vim.bo[buf].filetype ~= "gitcommit" then
      return
    end

    local win = vim.fn.bufwinid(buf)
    if win == -1 then
      return
    end
    if win == state.win then
      return
    end

    local geometry = get_float_geometry()

    if state.win and vim.api.nvim_win_is_valid(state.win) then
      vim.api.nvim_win_close(win, false)
      vim.api.nvim_win_set_buf(state.win, buf)
      vim.api.nvim_win_set_config(state.win, geometry)
      vim.api.nvim_set_current_win(state.win)
    else
      vim.api.nvim_win_close(win, false)
      state.win = vim.api.nvim_open_win(buf, true, geometry)
    end

    vim.wo[state.win].winblend = 0
    vim.bo[buf].bufhidden = "wipe"
  end)
end

return M
