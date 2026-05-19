return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
    { "<leader>EE", "<cmd>Neotree toggle reveal=true<cr>", desc = "Toggle & Reveal current file" },
  },
  opts = {
    enable_git_status = true,
    filesystem = {
      filtered_state = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      hijack_netrw_behavior = "open_current",
    },
    window = {
      position = "left",
      width = 30,
    },
  },
}
