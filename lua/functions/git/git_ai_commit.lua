local M = {}
local bridge = require("functions.ai.bridge")

function M.ai_commit_with_select()
  local diff = vim.fn.system("git diff --staged")
  if diff == "" then
    Tele.warn("No staged changes found.", "Git AI")
    return
  end

  local id = bridge.ensure_engine()
  if id > 0 then
    vim.rpcnotify(id, "submit_task", {
      id = "commit_" .. os.time(),
      action = "commit",
      payload = diff,
    })
  end
end

function M.codecompanion_commit()
  require("codecompanion").prompt("commit")
end

return M
