{fontProfiles, ...}: {
  files.".config/beer/beer.toml".text = ''
    [main]
    title = "beer"
    font = ${builtins.toJSON fontProfiles.mono}
    # Foot uses points; Beer uses integer pixels (14 pt * 96 / 72).
    font-size = 19
    adjust-cell-width = 1
    ligatures = false
    pad-x = 2
    pad-y = 2

    [colors]
    alpha = 0.64
    bold-as-bright = false
    cursor = "#e7e0e5"

    [cursor]
    style = "beam"

    [scrollback]
    lines = 10000

    [url]
    launch = ["xdg-open"]

    [key-bindings]
    "Page_Up" = "scrollback-up"
    "Page_Down" = "scrollback-down"
    "Ctrl+Shift+C" = "copy"
    "Ctrl+Shift+V" = "paste"
    "Ctrl+/" = "search"
  '';
}
