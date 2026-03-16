local M = {}
local prompts = require("functions.ai.prompts")
local requests = require("functions.ai.requests")

local request_builders = {
  anthropic = requests.get_anthropic_request,
  openai = requests.get_openai_request,
  gemini = requests.get_gemini_request,
}

local content_extractors = {
  anthropic = function(res)
    return res.content[1].text
  end,
  openai = function(res)
    return res.choices[1].message.content
  end,
  gemini = function(res)
    return res.candidates[1].content.parts[1].text
  end,
}

local function get_staged_diff()
  local diff = vim.fn.system("git diff --staged")
  return (diff ~= "") and diff or nil
end

local function build_curl_cmd(provider, diff)
  local full_prompt = prompts.conventional_commit_rules
    .. "\n"
    .. prompts.additional_selection_rules
    .. "\nDiff:\n"
    .. diff

  local builder = request_builders[provider]
  if builder then
    return builder(full_prompt)
  end
  return nil, "Unknown provider: " .. tostring(provider)
end

local function parse_api_response(provider, raw_data)
  local status, response = pcall(vim.fn.json_decode, raw_data)
  if not status or type(response) ~= "table" then
    return nil, "Invalid JSON response from server."
  end

  if response.error then
    return nil, response.error.message or vim.inspect(response.error)
  end

  local extractor = content_extractors[provider]
  if not extractor then
    return nil, "No extractor for provider: " .. provider
  end

  local ok, content = pcall(extractor, response)
  if not ok or not content then
    return nil, "Unexpected JSON structure for " .. provider
  end

  local options = {}
  local separator = "===OPTION==="
  for opt in (content .. separator):gmatch("(.-)" .. separator) do
    local trimmed = vim.trim(opt)
    if trimmed ~= "" then
      table.insert(options, trimmed)
    end
  end

  return #options > 0 and options or nil, "Could not find valid commit messages."
end

local function schedule_ui_and_commit(options)
  local display_items = {}
  for i, opt in ipairs(options) do
    table.insert(display_items, string.format("%d: %s", i, opt:match("([^\r\n]+)")))
  end

  vim.schedule(function()
    vim.ui.select(display_items, { prompt = "Select commit message:" }, function(choice, idx)
      if choice and idx then
        vim.cmd("G commit")
        local buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_lines(buf, 0, 1, false, vim.split(options[idx], "\n"))
        vim.api.nvim_win_set_cursor(0, { #vim.split(options[idx], "\n"), 0 })
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

  local cmd, err = build_curl_cmd(provider, diff)
  if not cmd then
    if providers[current_index + 1] then
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
      local options = parse_api_response(provider, table.concat(data))
      if options then
        schedule_ui_and_commit(options)
      elseif providers[current_index + 1] then
        run_ai_job(diff, providers, current_index + 1)
      else
        print("AI Error: " .. (options or "Failed to parse"))
      end
    end,
  })
end

function M.ai_commit_with_select()
  local diff = get_staged_diff()
  if diff then
    run_ai_job(diff, { "gemini" })
  else
    print("No staged changes found.")
  end
end

function M.codecompanion_commit()
  require("codecompanion").prompt("commit")
end

return M
