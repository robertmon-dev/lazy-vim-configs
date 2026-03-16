local M = {}

M.endpoints = {
  anthropic = "https://api.anthropic.com/v1/messages",
  openai = "https://api.openai.com/v1/chat/completions",
  gemini = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent",
}

function M.get_anthropic_request(prompt)
  local api_key = os.getenv("ANTHROPIC_API_KEY")
  if not api_key or api_key == "" then
    return nil, "Missing ANTHROPIC_API_KEY"
  end

  local payload = {
    model = "claude-3-5-sonnet-20241022",
    max_tokens = 1024,
    messages = { { role = "user", content = prompt } },
  }

  return {
    "curl",
    "-s",
    M.endpoints.anthropic,
    "-H",
    "content-type: application/json",
    "-H",
    "x-api-key: " .. api_key,
    "-H",
    "anthropic-version: 2023-06-01",
    "-d",
    vim.fn.json_encode(payload),
  }
end

function M.get_openai_request(prompt)
  local api_key = os.getenv("OPENAI_API_KEY")
  if not api_key or api_key == "" then
    return nil, "Missing OPENAI_API_KEY"
  end

  local payload = {
    model = "gpt-4o",
    messages = { { role = "user", content = prompt } },
  }

  return {
    "curl",
    "-s",
    M.endpoints.openai,
    "-H",
    "Content-Type: application/json",
    "-H",
    "Authorization: Bearer " .. api_key,
    "-d",
    vim.fn.json_encode(payload),
  }
end

function M.get_gemini_request(prompt)
  local api_key = os.getenv("GEMINI_API_KEY")
  if not api_key or api_key == "" then
    return nil, "Missing GEMINI_API_KEY"
  end

  local payload = { contents = { { parts = { { text = prompt } } } } }
  local url = M.endpoints.gemini .. "?key=" .. api_key

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

return M
