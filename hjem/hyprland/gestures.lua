-- Gestures
hl.gesture({ fingers = 3, direction = "down", mods = "SUPER", action = "close" })
hl.gesture({ fingers = 3, direction = "up", mods = "SUPER", scale = 1.5, action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })
hl.gesture({
  fingers = 3,
  direction = "left",
  action = function()
    hl.dispatch(hl.dsp.layout("move +col"))
  end,
})
hl.gesture({
  fingers = 3,
  direction = "right",
  action = function()
    hl.dispatch(hl.dsp.layout("move -col"))
  end,
})
hl.gesture({ fingers = 4, direction = "vertical", action = "special", workspace_name = "special" })
