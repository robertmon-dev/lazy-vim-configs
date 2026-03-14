local map = vim.keymap.set

vim.g.mapleader = " "
vim.o.timeoutlen = 300

local default_opts = { silent = true }

local keymaps = {
  n = {
    { "<Tab>", ">>" },
    { "<S-Tab>", "<<" },

    { "<leader>a", "ggVG" },

    { "<leader>d", vim.lsp.buf.definition, { desc = "Go to definition" } },
    { "<leader>r", vim.lsp.buf.references, { desc = "Find references" } },
    { "<leader>h", vim.lsp.buf.hover, { desc = "Show hover info" } },
    { "<leader>D", vim.lsp.buf.declaration, { desc = "Go to declaration" } },
    { "<leader>E", vim.diagnostic.open_float, { desc = "Show line diagnostics" } },

    { "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" } },
    { "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" } },

    { "<C-s>", "<cmd>w<cr>", { desc = "Save file" } },
    { "<leader>q", "<cmd>q<cr>", { desc = "Close window" } },
    { "<leader>c", "<cmd>bd<cr>", { desc = "Close currently open buffer (bd)" } },

    { "<leader>cn", "<cmd>CarbonNow<cr>", { desc = "Carbon Now (normal, whole file)" } },
    { "<leader>cs", "<cmd>Silicon<cr>", { desc = "Silicon (marked)" } },

    {
      "<leader>C",
      function()
        require("Comment.api").toggle.blockwise.current()
      end,
      { desc = "Toggle comment" },
    },

    { "<A-a>", "<C-w>h", { desc = "Go to left window" } },
    { "<A-s>", "<C-w>j", { desc = "Go to window below" } },
    { "<A-w>", "<C-w>k", { desc = "Go to window above" } },
    { "<A-d>", "<C-w>l", { desc = "Go to right window" } },

    { "<A-Left>", "<C-w>h", { desc = "Go to left window" } },
    { "<A-Down>", "<C-w>j", { desc = "Go to window below" } },
    { "<A-Up>", "<C-w>k", { desc = "Go to window above" } },
    { "<A-Right>", "<C-w>l", { desc = "Go to right window" } },

    {
      "<leader>gb",
      function()
        vim.ui.input({ prompt = "New branch name: " }, function(branch)
          if branch and branch ~= "" then
            vim.cmd("G checkout -b " .. branch)
          end
        end)
      end,
      { desc = "Git create new branch" },
    },
    { "<leader>gs", "<cmd>G<cr>", { desc = "Git status" } },
    { "<leader>gd", "<cmd>Gdiffsplit<cr>", { desc = "Git diff" } },
    { "<leader>ga", "<cmd>Gwrite<cr>", { desc = "Git add (current buffer)" } },
    { "<leader>gc", "<cmd>G commit<cr>", { desc = "Git commit" } },
    { "<leader>gA", "<cmd>G add --all<cr>", { desc = "Git add all" } },
    { "<leader>gr", "<cmd>GDelete<cr>", { desc = "Git remove (current file)" } },
    { "<leader>gM", "<cmd>G switch main<cr>", { desc = "Git switch main" } },
    { "<leader>gRm", "<cmd>G rebase origin/main<cr>", { desc = "Git rebase main" } },
    { "<leader>gU", "<cmd>G add -u<cr>", { desc = "Git add -u" } },
    { "<leader>gu", "<cmd>G reset HEAD %<cr>", { desc = "Git unstage (current file)" } },
    { "<leader>gP", "<cmd>G push<cr>", { desc = "Git push" } },
    { "<leader>gPP", "<cmd>G push --force-with-lease<cr>", { desc = "Git push force with lease" } },
    { "<leader>gPPP", "<cmd>G push --force<cr>", { desc = "Git push with force" } },

    { "<leader>go", ":G checkout ", { desc = "Git checkout (existing)", silent = false } },

    { "<leader>gL", "<cmd>G pull<cr>", { desc = "Git pull" } },
    { "<leader>gS", "<cmd>G stash<cr>", { desc = "Git stash" } },
    { "<leader>gSp", "<cmd>G stash pop<cr>", { desc = "Git stash pop" } },
    { "<leader>gSa", "<cmd>G stash apply<cr>", { desc = "Git stash apply" } },
    { "<leader>gR", "<cmd>G restore --all<cr>", { desc = "Git restore" } },
    { "<leader>gl", "<cmd>G stash list<cr>", { desc = "Git stash list" } },
    { "<leader>gX", "<cmd>G reset HEAD~1<cr>", { desc = "Git undo last commit (reset HEAD~1)" } },
  },

  v = {
    { "<Tab>", ">gv" },
    { "<S-Tab>", "<gv" },
    {
      "<leader>C",
      "<esc><cmd>lua require('Comment.api').toggle.blockwise(vim.fn.visualmode())<CR>",
      { desc = "Toggle comment" },
    },
    { "<leader>cn", "<cmd>CarbonNow<cr>", { desc = "Carbon Now (marked)" } },
  },

  i = {
    { "<S-Tab>", "<C-d>" },
    {
      "<leader>C",
      "<Esc><cmd>lua require('Comment.api').toggle.blockwise.current()<CR>a",
      { desc = "Toggle comment" },
    },
  },
}

for mode, maps_table in pairs(keymaps) do
  for _, mapping in ipairs(maps_table) do
    local m_opts = vim.tbl_extend("force", default_opts, mapping[3] or {})
    map(mode, mapping[1], mapping[2], m_opts)
  end
end

if vim.g.neovide then
  local function zoom(factor)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * factor
  end

  local mappings = {
    ["<C-=>"] = function()
      zoom(1.1)
    end,
    ["<C-+>"] = function()
      zoom(1.1)
    end,
    ["<C-->"] = function()
      zoom(1 / 1.1)
    end,
    ["<C-0>"] = function()
      vim.g.neovide_scale_factor = 1
    end,
  }

  for key, func in pairs(mappings) do
    vim.keymap.set({ "n", "v" }, key, func)
  end
end
