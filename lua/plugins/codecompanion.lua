return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    "stevearc/dressing.nvim",
  },

  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = { adapter = "anthropic" },
        inline = { adapter = "anthropic" },
        agent = { adapter = "anthropic" },
      },

      prompts = {
        ["Commit Message"] = {
          strategy = "chat",
          description = "Generates a commit message based on git diff",
          opts = {
            index = 1,
            is_default = true,
            is_slash_cmd = true,
            short_name = "commit",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = [[
You are an expert developer strictly adhering to the Conventional Commits specification.
Your task is to generate a git commit message based on the provided git diff.

RULES:
1. Format MUST be: `<type>[optional scope][optional !]: <description>`
2. `type` MUST be one of: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert.
   - Use `feat` for new features.
   - Use `fix` for bug fixes.
3. `scope` is OPTIONAL. If used, it MUST be a noun describing a section of the codebase surrounded by parenthesis, e.g., `fix(parser):`.
4. `description` MUST immediately follow the colon and space. It MUST be a short summary of the code changes.
5. A longer `body` MAY be provided. If provided, it MUST begin exactly one blank line after the description.
6. One or more `footers` MAY be provided. If provided, they MUST begin exactly one blank line after the body (or after the description if there is no body).
7. A footer token MUST use `-` in place of whitespace (e.g., `Resolves-issue: #123`), except for the `BREAKING CHANGE` token.
8. BREAKING CHANGES MUST be indicated by either a `!` immediately before the `:` in the prefix (e.g., `feat(api)!:`), OR by a footer starting with `BREAKING CHANGE: `.

CONSTRAINTS:
- Return ONLY the raw commit message text.
- DO NOT wrap the response in markdown blocks (e.g., ```).
- DO NOT add any introductory or concluding comments.
- Keep the description concise and professional.
]],
            },
            {
              role = "user",
              content = function()
                local diff = vim.fn.system("git diff --staged")
                if diff == "" then
                  return "There are no staged changes. Please reply with: No staged changes found."
                end
                return [[
Based on the following 'git diff', generate an ideal commit message for me:

]] .. diff
              end,
            },
          },
        },
      },
    })
  end,
  keys = {
    {
      "<leader>ca",
      "<cmd>CodeCompanionActions<cr>",
      mode = { "n", "v" },
      desc = "CodeCompanion Actions",
    },
    {
      "<leader>cc",
      "<cmd>CodeCompanionChat Toggle<cr>",
      mode = { "n", "v" },
      desc = "CodeCompanion Chat",
    },
    {
      "ga",
      "<cmd>CodeCompanionChat Add<cr>",
      mode = "v",
      desc = "CodeCompanion Add to Chat",
    },
    {
      "<leader>gcc",
      "<cmd>lua require('codecompanion').prompt('commit')<cr>",
      mode = "n",
      desc = "AI Git Commit",
    },
  },
}
