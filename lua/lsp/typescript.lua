local root_markers = {
  "pnpm-workspace.yaml",
  "turbo.json",
  "nx.json",
  "lerna.json",
  ".git",
}

local function monorepo_root_dir(bufnr, on_dir)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  on_dir(vim.fs.root(fname, root_markers))
end

local watch_options = {
  watchFile = "useFsEventsOnParentDirectory",
  watchDirectory = "useFsEvents",
  fallbackPolling = "dynamicPriority",
  synchronousWatchDirectory = false,
  excludeDirectories = {
    "**/node_modules",
    "**/.git",
    "**/dist",
    "**/build",
    "**/.next",
    "**/coverage",
  },
}

local inlay_hints_off = {
  enumMemberValues = { enabled = false },
  functionLikeReturnTypes = { enabled = false },
  parameterNames = { enabled = "none" },
  parameterTypes = { enabled = false },
  propertyDeclarationTypes = { enabled = false },
  variableTypes = { enabled = false },
}

local vtsls_settings = {
  enableMoveToFileCodeAction = true,
  autoUseWorkspaceTsdk = true,
  experimental = {
    completion = {
      enableServerSideFuzzyMatch = true,
      entriesLimit = 50,
    },
  },
  tsserver = {
    globalPlugins = {},
  },
}

local typescript_settings = {
  preferences = {
    includePackageJsonAutoImports = "auto",
    importModuleSpecifier = "non-relative",
    preferTypeOnlyAutoImports = true,
  },
  disableAutomaticTypeAcquisition = true,
  updateImportsOnFileMove = { enabled = "always" },
  suggest = {
    completeFunctionCalls = true,
    autoImports = true,
  },
  validate = { enable = true },
  tsserver = {
    maxTsServerMemory = 8192,
    watchOptions = watch_options,
  },
  inlayHints = inlay_hints_off,
}

local javascript_settings = {
  updateImportsOnFileMove = { enabled = "always" },
  suggest = { completeFunctionCalls = true },
  inlayHints = inlay_hints_off,
}

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      vtsls = {
        root_dir = monorepo_root_dir,
        settings = {
          complete_function_calls = true,
          vtsls = vtsls_settings,
          typescript = typescript_settings,
          javascript = javascript_settings,
        },
      },
    },
  },
}
