local M = {}
local logger = require("functions.logger")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

function M.telescope_git_branches()
  require("telescope.builtin").git_branches()
end

function M.switch_branch(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  if not selection then
    return
  end
  actions.close(prompt_bufnr)
  local branch = selection.value
  if branch:match("^origin/") then
    branch = branch:gsub("^origin/", "")
  elseif branch:match("^remotes/[^/]+/") then
    branch = branch:gsub("^remotes/[^/]+/", "")
  end
  vim.cmd("G switch " .. branch)
end

function M.telescope_git_switch()
  require("telescope.builtin").git_branches({
    attach_mappings = function(prompt_bufnr, map)
      map("i", "<CR>", function()
        M.switch_branch(prompt_bufnr)
      end)

      map("n", "<CR>", function()
        M.switch_branch(prompt_bufnr)
      end)

      return true
    end,
  })
end

function M.create_branch()
  vim.ui.input({ prompt = "New branch name: " }, function(branch)
    if branch and branch ~= "" then
      vim.cmd("G checkout -b " .. branch)
    end
  end)
end

function M.smart_push()
  local branch = vim.fn.system("git branch --show-current"):gsub("%s+", "")
  local has_upstream = os.execute("git rev-parse --abbrev-ref @{u} >/dev/null 2>&1")

  if has_upstream ~= 0 then
    local cmd = "git push --set-upstream origin " .. branch

    vim.fn.setreg("+", cmd)
    logger.warn("No upstream set! Command copied to clipboard:\n" .. cmd, "Warning")
  else
    vim.cmd("G push")
  end
end

return M
