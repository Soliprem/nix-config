_: {
  files = {
    ".config/foot/config.ini".text =
      /*
      ini
      */
      ''
        shell=fish
        title=foot
        font=Inconsolata Nerd Font:size=14
        letter-spacing=1
        dpi-aware=no

        pad=2x2

        bold-text-in-bright=no

        [scrollback]
        lines=10000

        [url]
        launch=xdg-open ''${url}

        [cursor]
        style=beam
        beam-thickness=1.5


        [colors-dark]
        alpha=0.64
        cursor=111012 e7e0e5

        [colors-light]
        alpha=0.64
        cursor=111012 e7e0e5

        [key-bindings]
        scrollback-up-page=Page_Up
        scrollback-down-page=Page_Down
        clipboard-copy=Control+Shift+c
        clipboard-paste=Control+Shift+v
        search-start=Control+slash

        [search-bindings]
        cancel=Escape
        find-prev=Shift+F3
        find-next=F3 Control+G
      '';
  };
}
