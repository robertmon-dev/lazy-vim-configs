local M = {}
local logger = require("functions.logger")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

function M.telescope_git_commits()
  require("telescope.builtin").git_commits()
end

function M.telescope_git_bcommits()
  require("telescope.builtin").git_bcommits()
end

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

function M.copy_branch_name()
  local branch = vim.fn.system("git branch --show-current"):gsub("%s+", "")

  if branch and branch ~= "" then
    vim.fn.setreg("+", branch)
    logger.info("Current branch name copied to clipboard", "Git")
  else
    logger.warn("You are not in a Git repository", "Warning")
  end
end

function M.pick_commits(callback)
  require("telescope.builtin").git_bcommits({
    attach_mappings = function(prompt_bufnr, map)
      local function confirm()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local selections = picker:get_multi_selection()
        if vim.tbl_isempty(selections) then
          selections = { action_state.get_selected_entry() }
        end
        actions.close(prompt_bufnr)

        local shas = {}
        for _, entry in ipairs(selections) do
          table.insert(shas, entry.value)
        end
        table.sort(shas, function(a, b)
          return tonumber(vim.fn.system("git show -s --format=%ct " .. a))
            < tonumber(vim.fn.system("git show -s --format=%ct " .. b))
        end)

        callback(shas)
      end
      map("i", "<CR>", confirm)
      map("n", "<CR>", confirm)
      return true
    end,
  })
end

function M.move_commits_to_branch()
  local current_branch = vim.fn.system("git branch --show-current"):gsub("%s+", "")
  local all_branches = vim.fn.systemlist("git branch --format='%(refname:short)'")
  local targets = vim.tbl_filter(function(b)
    return b ~= current_branch
  end, all_branches)

  vim.ui.select(targets, { prompt = "Move commits to branch:" }, function(target)
    if not target then
      return
    end

    M.pick_commits(function(shas)
      M.perform_move(shas, current_branch, target)
    end)
  end)
end

function M.perform_move(shas, source_branch, target_branch)
  vim.cmd("G checkout " .. target_branch)
  for _, sha in ipairs(shas) do
    local result = vim.fn.system("git cherry-pick " .. sha)
    if vim.v.shell_error ~= 0 then
      logger.warn("Cherry-pick failed on " .. sha .. ":\n" .. result, "Git move")
      vim.cmd("G checkout " .. source_branch)
      return
    end
  end
  vim.cmd("G checkout " .. source_branch)

  local choice = vim.fn.confirm("Drop these commits from " .. source_branch .. "?", "&Yes\n&No", 2)
  if choice == 1 then
    M.drop_commits(shas, source_branch)
  else
    logger.info("Copied to " .. target_branch .. ", originals kept on " .. source_branch, "Git move")
  end
end

function M.drop_commits(shas, source_branch)
  local short_shas = {}
  for _, sha in ipairs(shas) do
    table.insert(short_shas, sha:sub(1, 7))
  end

  local sed_parts = { "sed", "-i" }
  for _, sha in ipairs(short_shas) do
    table.insert(sed_parts, "-e")
    table.insert(sed_parts, "'/^pick " .. sha .. "/s/^pick/drop/'")
  end
  local sequence_editor = table.concat(sed_parts, " ")

  local base = vim.fn.system("git rev-parse " .. shas[1] .. "^"):gsub("%s+", "")
  local cmd = 'GIT_SEQUENCE_EDITOR="' .. sequence_editor .. '" git rebase -i ' .. base

  local result = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    logger.warn("Rebase (drop) failed:\n" .. result, "Git move")
  else
    logger.info("Commits dropped from " .. source_branch, "Git move")
  end
end

function M.delete_commits()
  local current_branch = vim.fn.system("git branch --show-current"):gsub("%s+", "")

  M.pick_commits(function(shas)
    local choice = vim.fn.confirm("Delete " .. #shas .. " commit(s) from " .. current_branch .. "?", "&Yes\n&No", 2)

    if choice == 1 then
      M.drop_commits(shas, current_branch)
    end
  end)
end

return M
