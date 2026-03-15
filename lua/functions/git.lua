local M = {}

local function get_staged_diff()
  local diff = vim.fn.system("git diff --staged")
  if diff == "" then
    return nil
  end
  return diff
end

local function build_curl_cmd(provider, diff)
  local prompt_template = [[
You are an expert in the Conventional Commits standard.
Based on the following 'git diff', provide exactly 3 concise commit message options.
Return ONLY a list of strings, each on a new line, starting with the conventional commit type.

Diff:
%s
]]
  local prompt = string.format(prompt_template, diff)

  if provider == "anthropic" then
    local api_key = os.getenv("ANTHROPIC_API_KEY")
    if not api_key or api_key == "" then
      return nil, "Missing ANTHROPIC_API_KEY"
    end

    local payload = {
      model = "claude-3-5-sonnet-20240620",
      max_tokens = 1024,
      messages = { { role = "user", content = prompt } },
    }

    return {
      "curl",
      "-s",
      "https://api.anthropic.com/v1/messages",
      "-H",
      "content-type: application/json",
      "-H",
      "x-api-key: " .. api_key,
      "-H",
      "anthropic-version: 2023-06-01",
      "-d",
      vim.fn.json_encode(payload),
    }
  elseif provider == "openai" then
    local api_key = os.getenv("OPENAI_API_KEY")
    if not api_key or api_key == "" then
      return nil, "Missing OPENAI_API_KEY"
    end

    local payload = {
      model = "gpt-4o-mini",
      messages = { { role = "user", content = prompt } },
    }

    return {
      "curl",
      "-s",
      "https://api.openai.com/v1/chat/completions",
      "-H",
      "Content-Type: application/json",
      "-H",
      "Authorization: Bearer " .. api_key,
      "-d",
      vim.fn.json_encode(payload),
    }
  elseif provider == "gemini" then
    local api_key = os.getenv("GEMINI_API_KEY")
    if not api_key or api_key == "" then
      return nil, "Missing GEMINI_API_KEY"
    end

    local payload = {
      contents = { { parts = { { text = prompt } } } },
    }

    local url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key="
      .. api_key

    return {
      "curl",
      "-s",
      url,
      "-H",
      "Content-Type: application/json",
      "-d",
      vim.fn.json_encode(payload),
    }
  end
end

local function parse_api_response(provider, raw_data)
  local status, response = pcall(vim.fn.json_decode, raw_data)
  if not status or type(response) ~= "table" then
    return nil, "Invalid JSON response from server."
  end

  if response.error then
    local err_msg = response.error.message or vim.inspect(response.error)
    return nil, err_msg
  end

  local content = ""
  if provider == "anthropic" and response.content and response.content[1] then
    content = response.content[1].text
  elseif provider == "openai" and response.choices and response.choices[1] then
    content = response.choices[1].message.content
  elseif provider == "gemini" and response.candidates and response.candidates[1] then
    content = response.candidates[1].content.parts[1].text
  else
    return nil, "Unexpected JSON structure."
  end

  local options = {}
  for s in content:gmatch("[^\r\n]+") do
    local cleaned = s:gsub("^%d+%.%s*", ""):gsub("^[%s%-]*", "")

    if cleaned:match("^%w+[^:]*:") then
      table.insert(options, cleaned)
    end
  end

  return #options > 0 and options or nil, "Could not find valid commit messages in the text."
end

local function schedule_ui_and_commit(options)
  vim.schedule(function()
    vim.ui.select(options, {
      prompt = "Select commit message:",
    }, function(choice)
      if choice then
        vim.cmd("G commit --no-gpg-sign")

        local buf = vim.api.nvim_get_current_buf()

        vim.api.nvim_buf_set_lines(buf, 0, 1, false, { choice, "" })
        vim.api.nvim_win_set_cursor(0, { 1, #choice })

        vim.cmd("startinsert!")
      end
    end)
  end)
end

local function run_ai_job(diff, providers, current_index)
  current_index = current_index or 1
  local provider = providers[current_index]

  if not provider then
    return
  end

  local fallback_provider = providers[current_index + 1]
  local cmd, err = build_curl_cmd(provider, diff)

  if not cmd then
    if fallback_provider then
      print(string.format("Provider %s failed (%s). Falling back to %s...", provider, err, fallback_provider))
      run_ai_job(diff, providers, current_index + 1)
    else
      print("Error: " .. (err or "Unknown"))
    end
    return
  end

  print(string.format("Asking %s...", provider:gsub("^%l", string.upper)))

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if not data or data[1] == "" then
        return
      end

      local raw_data = table.concat(data)
      local options = parse_api_response(provider, raw_data)

      if options then
        schedule_ui_and_commit(options)
      else
        if fallback_provider then
          print(string.format("Invalid response from %s. Falling back to %s...", provider, fallback_provider))
          run_ai_job(diff, providers, current_index + 1)
        else
          print("Error: Could not parse AI response from " .. provider .. "\n" .. raw_data)
        end
      end
    end,
    on_stderr = function(_, _) end,
  })
end

function M.ai_commit_with_select()
  local diff = get_staged_diff()
  if not diff then
    print("No staged changes found.")
    return
  end

  run_ai_job(diff, { "gemini" })
end

return M
