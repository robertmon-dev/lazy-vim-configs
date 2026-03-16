local editor_funcs = require("functions.editor")

return {
  "amitds1997/remote-nvim.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("remote-nvim").setup({
      client_callback = editor_funcs.remote_nvim_callback,
    })
  end,
  keys = {
    { "<leader>rs", "<cmd>RemoteStart<cr>", desc = "Remote SSH: Start" },
    { "<leader>ri", "<cmd>RemoteInfo<cr>", desc = "Remote SSH: Info" },
    { "<leader>rc", "<cmd>RemoteCleanup<cr>", desc = "Remote SSH: Cleanup Server" },
  },
}
