local M = {}

M.tools = { "efm", "commitlint" }

local commit_lint_cmd = "sh -c 'awk \"/^#/ {exit} {print}\" | smart-commitlint --color=false'"

function M.get_efm_config()
  return {
    filetypes = { "gitcommit" },
    root_dir = function(fname)
      return require("lspconfig.util").root_pattern(".git")(fname) or vim.fn.getcwd()
    end,
    init_options = {
      documentFormatting = false,
      documentRangeFormatting = false,
    },
    settings = {
      languages = {
        gitcommit = {
          {
            lintCommand = commit_lint_cmd,
            lintStdin = true,
            lintFormats = { "%m" },
          },
        },
      },
    },
  }
end

return M
