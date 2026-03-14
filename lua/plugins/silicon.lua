local p = require("config.palette")

return {
  "michaelrommel/nvim-silicon",
  lazy = true,
  cmd = "Silicon",
  opts = {
    font = "JetBrains Mono=18",

    theme = "auto",
    background = p.bg_night,

    no_window_controls = true,
    pad_horiz = 56,
    pad_vert = 56,

    drop_shadow = true,
    shadow_blur_radius = 68,
    shadow_offset_y = 20,
    shadow_color = "#000000",

    to_clipboard = true,

    watermark_text = "",
  },
}
