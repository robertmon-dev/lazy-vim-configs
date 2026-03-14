local p = require("config.palette")

return {
  "ellisonleao/carbon-now.nvim",
  lazy = true,
  cmd = "CarbonNow",
  opts = {
    open_cmd = "xdg-open",
    options = {
      bg = p.bg_night,

      theme = "night-owl",

      font_family = "JetBrains Mono",
      font_size = "18px",
      line_numbers = true,

      watermark = false,

      window_theme = "none",

      width_adjustment = true,
      padding_vertical = "56px",
      padding_horizontal = "56px",

      drop_shadow = true,
      drop_shadow_blur_radius = "68px",
      drop_shadow_offset_y = "20px",
      drop_shadow_color = "rgba(0, 0, 0, 0.55)",
    },
  },
}
