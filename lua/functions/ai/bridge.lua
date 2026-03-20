local M = {}
local job_id = 0
local bin_path = vim.g.ai_engine_bin_path or vim.fn.expand("~/.config/nvim/bin/nvim-ai-engine")

local Tele = _G.Tele or require("functions.logger")

function M.ensure_engine()
  if job_id > 0 and vim.fn.jobwait({ job_id }, 0)[1] == -1 then
    return job_id
  end

  job_id = vim.fn.jobstart({ bin_path }, {
    rpc = true,
    on_stderr = function(_, data)
      local msg = table.concat(data, "\n"):gsub("^%s*(.-)%s*$", "%1")
      if msg == "" then
        return
      end

      if msg:sub(1, 1) == "{" then
        return
      end

      Tele.error("Engine Runtime: " .. msg, "AI Bridge")
    end,
    on_exit = function(_, code)
      job_id = 0
      if code ~= 0 and code ~= 141 then
        Tele.warn("Engine stopped unexpectedly with code " .. code, "AI Bridge")
      end
    end,
  })

  return job_id
end

local levels = { DEBUG = 0, INFO = 1, WARN = 2, ERROR = 3 }

_G.NvimEngineLog = function(msg, lvl_str, sys)
  vim.schedule(function()
    local l = levels[lvl_str] or 1
    if l >= levels.INFO then
      Tele.log(msg, l, sys or "Go-Engine")
    end
  end)
end

_G.on_ai_result = function(res)
  if not res then
    Tele.error("Received empty result from AI Engine", "AI Bridge")
    return
  end

  vim.schedule(function()
    if res.error and res.error ~= "" then
      Tele.error(res.error, "AI Engine")
      return
    end

    if not res.data or #res.data == 0 then
      Tele.warn("AI returned no results.", "AI Engine")
      return
    end

    vim.ui.select(res.data, {
      prompt = "Select commit message:",
      kind = "ai_commit_picker",
    }, function(choice)
      if choice then
        vim.cmd("G commit")
        vim.defer_fn(function()
          vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(choice, "\n"))
        end, 50)
      end
    end)
  end)
end

return M
