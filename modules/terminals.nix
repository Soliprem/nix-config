{inputs, ...}: {
  flake.modules.nixos.terminals = {pkgs, ...}: let
    sys = pkgs.stdenv.hostPlatform.system;
  in {
    environment = {
      sessionVariables.BEER_CONFIG = "$HOME/.config/beer/themes/matugen.toml:$HOME/.config/beer/beer.toml";
      systemPackages = with pkgs; [
        ghostty
        foot
        cool-retro-term
        inputs.beer.packages.${sys}.default
      ];
    };
    hjem.users.soliprem = {
      fontProfiles,
      pkgs,
      ...
    }: {
      files = {
        ".config/ghostty/config".text = ''
          command = ${pkgs.fish}/bin/fish
          background-opacity = 0.64
          gtk-single-instance = true
          gtk-titlebar = false
          quit-after-last-window-closed = false
          theme = matugen
        '';
        ".config/foot/foot.ini".text =
          /*
          ini
          */
          ''
            shell=fish
            include=~/.config/foot/themes/matugen.ini
            title=foot
            font=${fontProfiles.mono}:size=14
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
            blur=true

            [colors-light]
            alpha=0.64
            cursor=111012 e7e0e5
            blur=true

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
        ".config/beer/beer.toml".text = ''
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
      };
    };
  };
}
