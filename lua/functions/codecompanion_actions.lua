local M = {}
local prompts = require("functions.ai.prompts")

M.commit_system_prompt = prompts.conventional_commit_rules

function M.get_staged_diff()
  local diff = vim.fn.system("git diff --staged")
  if diff == "" then
    return "No staged changes found."
  end
  return "Based on the following 'git diff', generate an ideal commit message:\n\n" .. diff
end

function M.toggle_chat()
  vim.cmd("CodeCompanionChat Toggle")
end

function M.add_to_chat()
  vim.cmd("CodeCompanionChat Add")
end

function M.open_actions()
  vim.cmd("CodeCompanionActions")
end

function M.ai_commit()
  require("codecompanion").prompt("commit")
end

return M
