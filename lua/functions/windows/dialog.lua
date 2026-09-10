local M = {}

function M.ask(prompt, default_no)
  local default_choice = (default_no == false) and 1 or 2
  local choice = vim.fn.confirm(prompt, "&Yes\n&No", default_choice)

  return choice == 1
end

return M
