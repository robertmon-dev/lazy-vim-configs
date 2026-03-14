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
              role = "user",
              content = function()
                return [[
You are an expert in the Conventional Commits standard.
Based on the following 'git diff', generate an ideal commit message for me:

```diff
]] .. vim.fn.system("git diff --staged") .. [[
]]
              end,
            },
            {
              role = "system",
              content = [[
You must follow the Conventional Commits standard.
Start the message with the appropriate prefix (feat:, fix:, chore:, refactor:, docs:, style:) based on the provided code.
Return ONLY the commit message text (in English), without any additional comments, introductory text, or markdown formatting.
Keep it concise and professional.
]],
            },
          },
        },
      },
    })
  end,
  keys = {
    { "<leader>ca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
    { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "CodeCompanion Chat" },
    { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "CodeCompanion Add to Chat" },
  },
}
