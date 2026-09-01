local crates = require("crates")
local utils = require("functions.utils")
local editor_funcs = require("functions.editor")
local rust_funcs = require("functions.rust_actions")
local window_funcs = require("functions.windows.pin")

local my_group = vim.api.nvim_create_augroup("MyAutocmds", { clear = true })

local autocmds = {
  {
    { "FocusGained", "TermClose", "TermLeave" },
    {
      command = "checktime",
      desc = "Check if buffers changed on disk",
    },
  },
  {
    "BufWritePre",
    {
      callback = editor_funcs.trim_whitespace,
      desc = "Trim trailing whitespace on save",
    },
  },
  {
    "BufReadPost",
    {
      pattern = "*",
      callback = editor_funcs.check_readonly,
      desc = "Show warning for readonly files",
    },
  },
  {
    "FileType",
    {
      pattern = "gitcommit",
      desc = "Pin commit window to fixed floating position",
      callback = window_funcs.pin_gitcommit_window,
    },
  },
  {
    "FileType",
    {
      pattern = "rust",
      desc = "Rustaceanvim specific keymaps",
      callback = function(event)
        local keymaps = {
          { "<leader>h", rust_funcs.hover_actions, { desc = "Rust Hover Actions" } },
          { "<leader>ca", rust_funcs.code_action, { desc = "Rust Code Action" } },
          { "<leader>cE", rust_funcs.explain_error, { desc = "Rust Explain Error" } },
          { "<leader>rr", rust_funcs.runnables, { desc = "Rust Run target" } },
          { "<leader>dr", rust_funcs.debuggables, { desc = "Rust Debug target" } },
          { "<leader>cM", rust_funcs.expand_macro, { desc = "Rust Expand Macro" } },
        }

        utils.apply_buffer_keymaps(keymaps, event.buf)
      end,
    },
  },
  {
    { "BufRead", "BufNewFile" },
    {
      pattern = "Cargo.toml",
      desc = "Crates.nvim specific keymaps",
      callback = function(event)
        local keymaps = {
          { "<leader>cv", crates.show_versions_popup, { desc = "Crates: Show versions" } },
          { "<leader>cf", crates.show_features_popup, { desc = "Crates: Show flags (features)" } },
          { "<leader>cd", crates.show_dependencies_popup, { desc = "Crates: Show dependencies" } },
          { "<leader>cu", crates.update_crate, { desc = "Crates: Update them all" } },
          { "<leader>ca", crates.update_all_crates, { desc = "Crates: Update all" } },
          { "<leader>cU", crates.upgrade_crate, { desc = "Crates: Bump crate (upgrade)" } },
          { "<leader>cH", crates.open_homepage, { desc = "Crates: Show www of crate" } },
          { "<leader>cD", crates.open_documentation, { desc = "Crates: Show docs.rs" } },
          { "<leader>cR", crates.open_repository, { desc = "Crates: Show github of the crate" } },
        }

        utils.apply_buffer_keymaps(keymaps, event.buf)
      end,
    },
  },
}

utils.apply_common_autocmds(autocmds, my_group)
