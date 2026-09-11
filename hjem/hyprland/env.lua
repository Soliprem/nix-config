local H = require("helpers")

hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
hl.env("GLFW_IM_MODULE", "ibus")
hl.env("INPUT_METHOD", "fcitx")

if H.cyberpunk then
  hl.env("HYPRCURSOR_THEME", "")
  hl.env("HYPRCURSOR_SIZE", "")
  hl.env("XCURSOR_THEME", "CyberArch-cursors")
  hl.env("XCURSOR_SIZE", "48")
else
  hl.env("XCURSOR_THEME", "")
  hl.env("XCURSOR_SIZE", "24")
  hl.env("HYPRCURSOR_THEME", "Hypr-Bibata-Modern-Ice")
  hl.env("HYPRCURSOR_SIZE", "24")
end
