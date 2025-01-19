_: {
  hjem.users.soliprem.files = {
    ".config/fuzzel/fuzzel.ini" = ''
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
