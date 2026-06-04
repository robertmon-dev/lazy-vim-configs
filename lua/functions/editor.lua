local M = {}
local Tele = _G.Tele or require("functions.logger")

function M.diagnostic_goto_prev()
  vim.diagnostic.jump({ count = -1, float = true })
end

function M.diagnostic_goto_next()
  vim.diagnostic.jump({ count = 1, float = true })
end

function M.toggle_comment_normal()
  require("Comment.api").toggle.blockwise.current()
end

function M.toggle_comment_visual()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "nx", false)
  require("Comment.api").toggle.blockwise(vim.fn.visualmode())
end

function M.toggle_comment_insert()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "nx", false)
  require("Comment.api").toggle.blockwise.current()
  vim.api.nvim_feedkeys("a", "nx", false)
end

function M.setup_neovide()
  if not vim.g.neovide then
    return
  end

  local function zoom(factor)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * factor
  end

  local mappings = {
    ["<C-=>"] = function()
      zoom(1.1)
    end,
    ["<C-+>"] = function()
      zoom(1.1)
    end,
    ["<C-->"] = function()
      zoom(1 / 1.1)
    end,
    ["<C-0>"] = function()
      vim.g.neovide_scale_factor = 1
    end,
  }

  for key, func in pairs(mappings) do
    vim.keymap.set({ "n", "v" }, key, func)
  end

  Tele.info("Neovide GUI features initialized.", "GUI")
end

function M.trim_whitespace()
  vim.cmd([[%s/\s\+$//e]])
  Tele.debug("Trailing whitespace trimmed.", "Editor")
end

function M.format_lsp(args)
  require("conform").format({ bufnr = args.buf, lsp_format = "fallback" })
end

function M.check_readonly()
  if vim.bo.readonly then
    vim.defer_fn(function()
      Tele.warn("File is READONLY! Sudo/Password required to save.", "File System")
    end, 500)
  end
end

function M.remote_nvim_callback(port, _)
  local cmd = ("nvim --server localhost:%s --remote-ui"):format(port)

  Tele.info("Connecting to remote server on port " .. port, "Remote SSH")

  vim.fn.jobstart(cmd, {
    detach = true,
    on_exit = function()
      Tele.info("Disconnected from remote server.", "Remote SSH")
    end,
  })
end

function M.flash_jump()
  require("flash").jump()
  Tele.debug("Flash jump executed.", "Editor")
end

function M.flash_search_forward()
  require("flash").jump({
    search = { forward = true, wrap = false, multi_window = false },
  })
end

function M.flash_search_backward()
  require("flash").jump({
    search = { forward = false, wrap = false, multi_window = false },
  })
end

function M.flash_treesitter()
  require("flash").treesitter()
end

function M.flash_remote()
  require("flash").remote()
end

function M.flash_treesitter_search()
  require("flash").treesitter_search()
end

function M.flash_toggle()
  require("flash").toggle()
end

return M
