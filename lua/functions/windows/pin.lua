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

local function do_pin(buf)
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
    vim.api.nvim_win_close(state.win, false)
  end

  vim.api.nvim_win_set_config(win, geometry)
  vim.api.nvim_set_current_win(win)
  state.win = win

  vim.wo[state.win].winblend = 0
  vim.bo[buf].bufhidden = "wipe"
end

local schedule_pin = vim.schedule_wrap(do_pin)

function M.pin_gitcommit_window(event)
  local buf = event and event.buf or vim.api.nvim_get_current_buf()
  schedule_pin(buf)
end

return M
