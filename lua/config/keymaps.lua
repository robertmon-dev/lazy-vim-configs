local keymap = vim.keymap.set
local git_funcs = require("functions.git.git")
local git_ai_funcs = require("functions.git.git_ai_commit")
local editor_funcs = require("functions.editor")

vim.g.mapleader = " "
vim.o.timeoutlen = 300

local default_opts = { silent = true }

local keymaps = {
  n = {
    { "<Tab>", ">>" },
    { "<S-Tab>", "<<" },

    { "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" } },

    { "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" } },
    { "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" } },

    { "<leader>a", "ggVG", { desc = "Select all text" } },

    { "<leader>d", vim.lsp.buf.definition, { desc = "Go to definition" } },
    { "<leader>r", vim.lsp.buf.references, { desc = "Find references" } },
    { "<leader>h", vim.lsp.buf.hover, { desc = "Show hover info" } },
    { "<leader>D", vim.lsp.buf.declaration, { desc = "Go to declaration" } },
    { "<leader>E", vim.diagnostic.open_float, { desc = "Show line diagnostics" } },

    {
      "[d",
      editor_funcs.diagnostic_goto_prev,
      { desc = "Go to previous diagnostic" },
    },
    { "]d", editor_funcs.diagnostic_goto_next, { desc = "Go to next diagnostic" } },

    { "<C-s>", "<cmd>w<cr>", { desc = "Save file" } },
    { "<leader>q", "<cmd>q<cr>", { desc = "Close window" } },
    {
      "<leader>c",
      "<cmd>bd<cr>",
      { desc = "Close currently open buffer (bd)" },
    },

    {
      "<leader>cn",
      "<cmd>CarbonNow<cr>",
      { desc = "Carbon Now (normal, whole file)" },
    },
    { "<leader>cs", "<cmd>Silicon<cr>", { desc = "Silicon (marked)" } },

    { "<leader>C", editor_funcs.toggle_comment_normal, { desc = "Toggle comment" } },

    { "<A-a>", "<C-w>h", { desc = "Go to left window" } },
    { "<A-s>", "<C-w>j", { desc = "Go to window below" } },
    { "<A-w>", "<C-w>k", { desc = "Go to window above" } },
    { "<A-d>", "<C-w>l", { desc = "Go to right window" } },

    { "<A-Left>", "<C-w>h", { desc = "Go to left window" } },
    { "<A-Down>", "<C-w>j", { desc = "Go to window below" } },
    { "<A-Up>", "<C-w>k", { desc = "Go to window above" } },
    { "<A-Right>", "<C-w>l", { desc = "Go to right window" } },

    { "<leader>gb", git_funcs.create_branch, { desc = "Git create new branch" } },
    { "<leader>gs", "<cmd>G<cr>", { desc = "Git status" } },
    { "<leader>gd", "<cmd>Gdiffsplit<cr>", { desc = "Git diff" } },
    { "<leader>ga", "<cmd>Gwrite<cr>", { desc = "Git add (current buffer)" } },
    { "<leader>gA", "<cmd>G add -A<cr>", { desc = "Git add all of the files" } },
    { "<leader>gc", git_ai_funcs.ai_commit_with_select, { desc = "AI Git commit (Menu)" } },
    {
      "<leader>gC",
      "<cmd>G commit<cr>",
      { desc = "Manual Git commit (Fugitive)" },
    },
    { "<leader>gcc", git_ai_funcs.codecompanion_commit, { desc = "AI Commit (Direct)" } },
    {
      "<leader>gr",
      "<cmd>GDelete<cr>",
      { desc = "Git remove (current file)" },
    },
    { "<leader>gM", "<cmd>G switch main<cr>", { desc = "Git switch main" } },
    { "<leader>gRm", "<cmd>G rebase origin/main<cr>", { desc = "Git rebase main" } },
    { "<leader>gU", "<cmd>G add -u<cr>", { desc = "Git add -u" } },
    {
      "<leader>gu",
      "<cmd>G reset HEAD %<cr>",
      { desc = "Git unstage (current file)" },
    },
    { "<leader>gP", git_funcs.smart_push, { desc = "Git push (Smart Upstream)" } },
    {
      "<leader>gPP",
      "<cmd>G push --force-with-lease<cr>",
      { desc = "Git push force with lease" },
    },
    { "<leader>gPPP", "<cmd>G push --force<cr>", { desc = "Git push with force" } },
    {
      "<leader>go",
      git_funcs.telescope_git_branches,
      { desc = "Git branches list (Telescope)" },
    },
    {
      "<leader>gO",
      git_funcs.telescope_git_switch,
      { desc = "Git switch branch (Telescope)" },
    },
    { "<leader>gL", "<cmd>G pull<cr>", { desc = "Git pull" } },
    { "<leader>gS", "<cmd>G stash<cr>", { desc = "Git stash" } },
    { "<leader>gSp", "<cmd>G stash pop<cr>", { desc = "Git stash pop" } },
    { "<leader>gSa", "<cmd>G stash apply<cr>", { desc = "Git stash apply" } },
    { "<leader>gR", "<cmd>G restore --all<cr>", { desc = "Git restore" } },
    { "<leader>gl", "<cmd>G stash list<cr>", { desc = "Git stash list" } },
    {
      "<leader>gX",
      "<cmd>G reset HEAD~1<cr>",
      { desc = "Git undo last commit (reset HEAD~1)" },
    },
  },

  v = {
    { "<Tab>", ">gv" },
    { "<S-Tab>", "<gv" },

    { "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move block down" } },
    { "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move block up" } },

    { "<leader>C", editor_funcs.toggle_comment_visual, { desc = "Toggle comment" } },
    { "<leader>cn", "<cmd>CarbonNow<cr>", { desc = "Carbon Now (marked)" } },
  },

  i = {
    { "<S-Tab>", "<C-d>" },
    { "<leader>C", editor_funcs.toggle_comment_insert, { desc = "Toggle comment" } },
  },
}

for mode, maps_table in pairs(keymaps) do
  for _, mapping in ipairs(maps_table) do
    local m_opts = vim.tbl_deep_extend("force", default_opts, mapping[3] or {})
    keymap(mode, mapping[1], mapping[2], m_opts)
  end
end

editor_funcs.setup_neovide()
