local M = {}

M.levels = {
  DEBUG = vim.log.levels.DEBUG,
  INFO = vim.log.levels.INFO,
  WARN = vim.log.levels.WARN,
  ERROR = vim.log.levels.ERROR,
}

M.icons = {
  [M.levels.DEBUG] = " ",
  [M.levels.INFO] = " ",
  [M.levels.WARN] = " ",
  [M.levels.ERROR] = " ",
}

local log_file_path = vim.fn.stdpath("cache") .. "/telemetry.log"

local function append_to_file(msg, level_name, title)
  local fp = io.open(log_file_path, "a")
  if not fp then
    return
  end

  local timestamp = os.date("%Y-%m-%d %H:%M:%S")
  local formatted_msg = string.format("[%s] [%s] [%s]: %s\n", timestamp, level_name, title, msg)

  fp:write(formatted_msg)
  fp:close()
end

function M.log(msg, level, title)
  level = level or M.levels.INFO
  title = title or "Telemetry"

  local output = (type(msg) == "table") and vim.inspect(msg) or tostring(msg)

  vim.notify(output, level, {
    title = title,
    icon = M.icons[level] or "󰋽 ",
  })

  local level_name = "INFO"
  for k, v in pairs(M.levels) do
    if v == level then
      level_name = k
      break
    end
  end
  append_to_file(output, level_name, title)
end

function M.debug(msg, title)
  M.log(msg, M.levels.DEBUG, title or "Debug")
end

function M.info(msg, title)
  M.log(msg, M.levels.INFO, title or "Info")
end

function M.warn(msg, title)
  M.log(msg, M.levels.WARN, title or "Warning")
end

function M.error(msg, title)
  M.log(msg, M.levels.ERROR, title or "Error")
end

return M
