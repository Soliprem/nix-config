_: {
  files.".config/thumbpick/config.toml".text = ''
    vi_mode = true

    # Default start directory
    dir_path = "."
    thumb_size = 200

    [keys]
    up = "k"
    left = "h"
    down = "j"
    right = "l"

    quit = "Escape"
    search = "slash"
    select = "Return"
    go_top = "g"       # Press twice to go to top
    go_bottom = "G"
  '';
}
