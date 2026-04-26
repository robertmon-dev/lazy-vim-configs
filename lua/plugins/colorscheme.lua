return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "dark"

      local c = require("vscode.colors").get_colors()
      require("vscode").setup({
        transparent = true,
        italic_comments = true,
        italic_inlayhints = true,
        underline_links = true,
        disable_nvimtree_bg = true,
        terminal_colors = true,

        color_overrides = {
          vscLineNumber = "#888888",
        },

        group_overrides = {
          Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
        },
      })
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = not vim.g.neovide,
      on_highlights = function(hl)
        local p = require("config.palette")

        local my_bg = vim.g.neovide and p.bg_night or p.none

        hl.Normal = { bg = my_bg }
        hl.NormalNC = { bg = my_bg }
        hl.SignColumn = { bg = my_bg }
        hl.EndOfBuffer = { bg = my_bg, fg = my_bg }
        hl.NormalFloat = { bg = my_bg }
        hl.FloatBorder = { bg = my_bg, fg = p.primary }

        hl.NeoTreeNormal = { bg = my_bg }
        hl.NeoTreeNormalNC = { bg = my_bg }
        hl.NeoTreeEndOfBuffer = { bg = my_bg, fg = my_bg }
        hl.NeoTreeWinSeparator = { fg = p.storm, bg = p.none }
        hl.WinSeparator = { fg = p.storm, bg = p.none }

        hl.TelescopeNormal = { bg = my_bg }
        hl.TelescopeBorder = { bg = my_bg, fg = p.primary }
        hl.TelescopePromptNormal = { bg = my_bg }
        hl.TelescopePromptBorder = { bg = my_bg, fg = p.highlight }
        hl.TelescopeTitle = { bg = p.primary, fg = p.bg_night }

        hl.Cursor = { bg = p.info, fg = p.bg_night }
        hl.TermCursor = { bg = p.info, fg = p.bg_night }
        hl.Visual = { bg = p.secondary, fg = p.white }
        hl.LineNr = { fg = p.slate, bg = my_bg }
        hl.CursorLineNr = { fg = p.primary, bold = true }

        hl.Keyword = { fg = p.token.keyword, italic = true }
        hl.Function = { fg = p.token.function_ }
        hl.String = { fg = p.token.string }
        hl.Number = { fg = p.token.number }
        hl.Comment = { fg = p.token.comment, italic = true }
        hl.Operator = { fg = p.token.operator }
        hl.Type = { fg = p.token.class }
        hl.Identifier = { fg = p.token.variable }
        hl.Tag = { fg = p.token.tag }
        hl.Delimiter = { fg = p.token.punctuation }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
