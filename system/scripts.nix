{
  lib,
  pkgs,
  ...
}: let
  scripts = [
    (
      pkgs.writers.writeNuBin "nixrice" {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [pkgs.waypaper pkgs.swww]}"
        ];
      }
      ''
        let path_list = waypaper | parse "Selected file: {path}" | get path
        let path = $path_list | last
        wallpaper-to-rice-nix $path
      ''
    )

    (pkgs.writers.writeNuBin "dm-expand" {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [pkgs.fuzzel]}"
        ];
      }
      ''
        let expansions = [
        [key value];
        ["mdash" —]
        ["name" "Francesco Prem Solidoro"]
        ["sign" "Kindest Regards,\nFrancesco Prem Solidoro"]
        ]
        let chosen_key = $expansions.key | to text | fuzzel --dmenu
        wtype ($expansions | where key == $chosen_key | get value.0)
      '')

    (pkgs.writeShellApplication {
      name = "wallpaper-to-rice-nix";
      runtimeInputs = with pkgs; [yad libnotify];
      text = ''
        if [[ ''${1:-} ]]; then
        	wallpaper="$1"
                cp "$wallpaper" ~/.config/bg
        else
        	cd "$HOME"/Pictures/wallpapers || return 1
        	wallpaper="$(yad --width 1200 --height 800 --file --add-preview --large-preview --title='Choose wallpaper')"
        fi

        if [[ $wallpaper ]]; then
          matugen image "$wallpaper"
          # astal -i sash -q; sash
          niri msg do-screen-transition
          ka way-edges
          way-edges
          cp "$wallpaper" ~/.config/bg
        else
        	echo "no wallpaper selected"
        fi
      '';
    })

    (pkgs.writeShellApplication {
      name = "wayshotpick";
      runtimeInputs = with pkgs; [wayshot slurp];
      text = ''
        case "$(printf "a selected area\\nfull screen\\na selected area (copy)\\nfull screen (copy)" |\
          fuzzel --dmenu -l 6 -i -p "Screenshot which area?")" in
            "a selected area") wayshot -s "$(slurp -f '%x %y %w %h')" -f\
              ~/Pictures/wayshot/sel-area-"$(date '+%y%m%d-%H%M-%S').png" ;;
            "full screen") wayshot -f ~/Pictures/wayshot/pic-full-"$(date '+%y%m%d-%H%M-%S').png" ;;
            "a selected area (copy)") wayshot -s "$(slurp -f '%x %y %w %h')" --stdout | wl-copy ;;
            "full screen (copy)") wayshot --stdout | wl-copy ;;
        esac
      '';
    })
    (pkgs.writeShellApplication {
      name = "grimpick";
      runtimeInputs = with pkgs; [grim slurp swappy];
      text = ''
        if [[ ''${1:-} ]]; then
          mode="$1"
        else
          mode="$(printf "region\\n\\nall" |\
                fuzzel --dmenu -l 6 -i -p "Screenshot which area?")"
        fi

        case $mode in
            "region")
                grim -g "$(slurp)" - | swappy -f -
                ;;
            "all")
                grim - | swappy -f -
                ;;
            *)
                echo >&2 "unsupported command \"$mode\""
                echo >&2 "Usage:"
                echo >&2 "grimpick <region|all>"
                exit 1
esac

      '';
    })
    (pkgs.writeShellApplication {
      name = "remove-hjem-dangles";
      text = ''
        rm ~/.config/gtk-3.0/settings.ini
        rm ~/.config/gtk-3.0/gtk.css
        rm ~/.config/gtk-4.0/settings.ini
        rm ~/.config/gtk-4.0/gtk.css
        rm ~/.config/helix/config.toml
        rm ~/.config/hypr/hypridle.conf
        rm ~/.config/hypr/hyprlock.conf
        rm ~/.config/matugen/config.toml
        rm ~/.config/nushell/config.nu
        rm ~/.config/nushell/env.nu
        rm ~/.config/qt5ct/qt5ct.conf
        rm ~/.config/qt6ct/qt6ct.conf
        rm ~/.config/ghostty/config
        rm ~/.config/fuzzel/fuzzel.ini
      '';
    })
  ];
in {
  environment.systemPackages = scripts;
}
