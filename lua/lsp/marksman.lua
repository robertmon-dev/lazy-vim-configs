return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
    opts = {},
    ft = { "markdown" },
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/notes/*.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/notes/*.md",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "~/notes",
        },
      },
    },
  },
}
