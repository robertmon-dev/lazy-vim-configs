local M = {}
local Tele = _G.Tele or require("functions.logger")

function M.hover_actions()
  vim.cmd.RustLsp({ "hover", "actions" })
  Tele.debug("Rust: Hover actions triggered", "RustLsp")
end

function M.code_action()
  vim.cmd.RustLsp("codeAction")
end

function M.explain_error()
  vim.cmd.RustLsp("explainError")
end

function M.runnables()
  vim.cmd.RustLsp("runnables")
  Tele.info("Rust: Fetching runnables...", "RustLsp")
end

function M.debuggables()
  vim.cmd.RustLsp("debuggables")
  Tele.info("Rust: Fetching debuggables...", "RustLsp")
end

function M.expand_macro()
  vim.cmd.RustLsp("expandMacro")
end

return M
