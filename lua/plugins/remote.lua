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

      client_callback = function(port, _)
        local cmd = ("nvim --server localhost:%s --remote-ui"):format(port)
        vim.fn.jobstart(cmd, {
          detach = true,
          on_exit = function(_, _, _)
            print("Disconnected with remote server.")
          end,
        })
      end,
    })
  end,
  keys = {
    { "<leader>rs", "<cmd>RemoteStart<cr>", mode = "n", desc = "Remote SSH: Start" },
    { "<leader>ri", "<cmd>RemoteInfo<cr>", mode = "n", desc = "Remote SSH: Info" },
    { "<leader>rc", "<cmd>RemoteCleanup<cr>", mode = "n", desc = "Remote SSH: Cleanup Server" },
  },
}
