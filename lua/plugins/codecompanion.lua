local ai_funcs = require("functions.codecompanion_actions")

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
              content = ai_funcs.commit_system_prompt,
            },
            {
              role = "user",
              content = ai_funcs.get_staged_diff,
            },
          },
        },
      },
    })
  end,
  keys = {
    { "<leader>ca", ai_funcs.open_actions, mode = { "n", "v" }, desc = "CodeCompanion Actions" },
    { "<leader>cc", ai_funcs.toggle_chat, mode = { "n", "v" }, desc = "CodeCompanion Chat" },
    { "ga", ai_funcs.add_to_chat, mode = "v", desc = "CodeCompanion Add to Chat" },
    { "<leader>gcc", ai_funcs.ai_commit, mode = "n", desc = "AI Git Commit" },
  },
}
