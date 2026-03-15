local M = {}

function M.ai_commit_with_select()
  local diff = vim.fn.system("git diff --staged")
  if diff == "" then
    print("No staged changes found.")
    return
  end

  print("Claude is thinking...")

  local prompt_template = [[
You are an expert in the Conventional Commits standard.
Based on the following 'git diff', provide exactly 3 concise commit message options.
Return ONLY a JSON array of strings, nothing else.

Diff:
%s
]]
  local prompt = string.format(prompt_template, diff)
  local api_key = os.getenv("ANTHROPIC_API_KEY")

  local command = string.format(
    [[curl -s https://api.anthropic.com/v1/messages \
      -H "content-type: application/json" \
      -H "x-api-key: %s" \
      -H "anthropic-version: 2023-06-01" \
      -d '{
        "model": "claude-3-5-sonnet-20240620",
        "max_tokens": 1024,
        "messages": [{"role": "user", "content": %s}]
      }']],
    api_key,
    vim.fn.json_encode(prompt)
  )

  vim.fn.jobstart(command, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if not data or data[1] == "" then
        return
      end

      local status, response = pcall(vim.fn.json_decode, table.concat(data))
      if not status or not response.content then
        print("Error: Could not parse AI response")
        return
      end

      local content = response.content[1].text
      local options = {}

      for s in content:gmatch("[^\r\n]+") do
        local cleaned = s:gsub("^%d+%.%s*", ""):gsub("^[%s%-]*", "")
        if cleaned:match("^%w+:") then
          table.insert(options, cleaned)
        end
      end

      vim.schedule(function()
        vim.ui.select(options, {
          prompt = "Select commit message:",
        }, function(choice)
          if choice then
            vim.cmd("G commit")

            local buf = vim.api.nvim_get_current_buf()

            vim.api.nvim_buf_set_lines(buf, 0, 1, false, { choice, "" })
            vim.api.nvim_win_set_cursor(0, { 1, #choice })

            vim.cmd("startinsert!")
          end
        end)
      end)
    end,
    on_stderr = function(_, data)
      if data and data[1] ~= "" then
        print("Error: " .. table.concat(data))
      end
    end,
  })
end

return M
