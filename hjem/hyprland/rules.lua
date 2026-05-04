local function window_rule(match, effects)
  effects.match = match
  hl.window_rule(effects)
end

window_rule({ title = "^(Julia|flame|script-fu|org.gtk_rs.HelloWorld2)$" }, { float = true })
window_rule({ title = "^(Picture-in-Picture)$" }, { float = true })
window_rule({ title = "^(Open File|Select a File|Choose wallpaper|Open Folder|Save As|Library)(.*)$" }, { float = true })
window_rule({ class = "^(org.kde.polkit-kde-authentication-agent-1)$" }, { float = true })
window_rule({ class = "^(protonvpn-app)$" }, { float = true })
window_rule({ class = "^(eu.soliprem.thumbpick)$" }, { float = true })

window_rule({ title = "^(Picture-in-Picture)$" }, { move = { 1275, 45 } })
window_rule({ title = "^(flame|script-fu)$" }, { move = { 700, 250 } })

window_rule({ class = "^(mpv|steam_app)(.*)$" }, { opacity = "1 override 1 override" })
window_rule({ title = "^(.*.)(YouTube|Invidious)(.*)$" }, { opacity = "1 override 1 override" })

window_rule({ title = "^(Firefox — Sharing Indicator|zen — Sharing Indicator)$" }, { workspace = "special" })

window_rule(
  {
    class = "^(firefox)$",
    title = "negative:^(Enter name of file to save to…|Save)",
  },
  {
    fullscreen_state = "-1 2",
  }
)

hl.layer_rule({ match = { namespace = "quickshell-sidebar" }, blur = true, ignore_alpha = 0.2 })
hl.layer_rule({ match = { namespace = "quantum-notification-popups" }, blur = true, ignore_alpha = 0.01 })
hl.layer_rule({ match = { namespace = "logout_dialog" }, blur = true, ignore_alpha = 0.01 })


