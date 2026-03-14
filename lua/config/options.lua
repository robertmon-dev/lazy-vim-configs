local p = require("config.palette")

vim.opt.shortmess:append("IA")
vim.opt.swapfile = false

vim.o.shell = "fish"

local font_name = "JetBrainsMonoNL Nerd Font"
local font_size = ":h12"

if vim.fn.has("gui_running") then
  vim.opt.guifont = font_name .. font_size
end

vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})

if vim.g.neovide then
  local pad = 25
  vim.g.neovide_scale_factor = 1.0
  vim.g.neovide_padding_top = pad
  vim.g.neovide_padding_bottom = pad
  vim.g.neovide_padding_left = pad
  vim.g.neovide_padding_right = pad

  vim.g.neovide_opacity = 0.78
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_cursor_animation_length = 0.06
  vim.g.neovide_cursor_trail_size = 0.4
  vim.g.neovide_cursor_vfx_mode = "railgun"
  vim.g.neovide_cursor_vfx_opacity = 200.0

  local bg_hex = p.bg_night

  vim.api.nvim_set_hl(0, "Normal", { bg = bg_hex })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = bg_hex })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = bg_hex })
  vim.api.nvim_set_hl(0, "LineNr", { bg = bg_hex, fg = p.slate })

  vim.api.nvim_set_hl(0, "Cursor", { bg = p.info, fg = p.bg_night })

  vim.g.neovide_remember_window_size = true
  vim.o.winblend = 0
  vim.o.pumblend = 0
  vim.g.neovide_window_blurred = false
  vim.g.neovide_floating_shadow = false
end
