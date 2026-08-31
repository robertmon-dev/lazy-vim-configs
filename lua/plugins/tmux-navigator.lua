return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
  },
  keys = {
    { "<M-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Window Left" },
    { "<M-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Window Down" },
    { "<M-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Window Up" },
    { "<M-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Window Right" },
  },
}
