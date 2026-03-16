local dashboard_funcs = require("functions.dashboard")

return {
  {
    "snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          pick = function(cmd, opts)
            return LazyVim.pick(cmd, opts)()
          end,
          header = dashboard_funcs.get_dashboard_header(),
          keys = dashboard_funcs.get_dashboard_keys(),
        },
      },
    },
  },
}
