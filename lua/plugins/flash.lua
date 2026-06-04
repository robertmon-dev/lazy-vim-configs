local editor_funcs = require("functions.editor")

return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, editor_funcs.flash_jump, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, editor_funcs.flash_treesitter, desc = "Flash Treesitter" },
      { "r", mode = "o", editor_funcs.flash_remote, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, editor_funcs.flash_treesitter_search, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, editor_funcs.flash_toggle, desc = "Toggle Flash Search" },
    },
  },
}
