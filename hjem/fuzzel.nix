_: {
  files = {
    ".config/fuzzel/fuzzel.ini".text = ''
      font=Inconsolata Nerd Font:size=17
      lines=15
      width=60
      dpi-aware=no
      inner-pad=10
      horizontal-pad=40
      placeholder=" :3"
      vertical-pad=15
      match-counter=yes
      include=~/.config/fuzzel/colors.ini
      terminal=ghostty
      prompt=">>  "
      layer=overlay

      [border]
      radius=17
      width=1

      [dmenu]
      exit-immediately-if-empty=yes
    '';
  };
}
