{
  lib,
  pkgs,
  ...
}:
let
  scripts = [
    (pkgs.writers.writeNuBin "update-openrgb-color"
      {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [
            pkgs.waypaper
            pkgs.swww
          ]}"
        ];
      }
      /* nu */ ''
        let accent_color = (caelestia scheme get | lines | get 6 | parse "{foo}: {bar}" | get bar | get 0 | ansi strip)
        echo $accent_color
        openrgb --color $accent_color
      ''
    )

    (pkgs.writers.writeNuBin "nixrice"
      {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [
            pkgs.waypaper
            pkgs.swww
          ]}"
        ];
      }
      /* nu */''
        let path_list = waypaper | parse "Selected file: {path}" | get path
        let path = $path_list | last
        wallpaper-to-rice-nix $path
      ''
    )

    (pkgs.writers.writeNuBin "clear-trash"
      {
      }
      /*nu*/''
        rm -rp ~/.local/share/Trash/*
      ''
    )

    (pkgs.writers.writeNuBin "dm-expand"
      {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [ pkgs.fuzzel ]}"
        ];
      }
      /*nu*/''
        let expansions = [
        [key value];
        ["mdash" —]
        ["name" "Francesco Prem Solidoro"]
        ["sign" "Kindest Regards,\nFrancesco Prem Solidoro"]
        ]
        let chosen_key = $expansions.key | to text | fuzzel --dmenu
        wtype ($expansions | where key == $chosen_key | get value.0)
      ''
    )

    (pkgs.writeShellApplication {
      name = "wallpaper-to-rice-nix";
      runtimeInputs = with pkgs; [
        yad
        libnotify
        matugen
        swww
      ];
      text = ''
        if [[ ''${1:-} ]]; then
        	wallpaper="$1"
                cp "$wallpaper" ~/.config/bg
                cp "$wallpaper" ~/.config/nix-config/assets/bg
        else
        	cd "$HOME"/Pictures/wallpapers || return 1
        	wallpaper="$(yad --width 1200 --height 800 --file --add-preview --large-preview --title='Choose wallpaper')"
        fi

        if [[ $wallpaper ]]; then
                matugen image "$wallpaper"
                cp "$wallpaper" ~/.config/bg
                cp "$wallpaper" ~/.config/nix-config/assets/bg
        else
        	echo "no wallpaper selected"
        fi
      '';
    })

    (pkgs.writeShellApplication {
      name = "wayshotpick";
      runtimeInputs = with pkgs; [
        wayshot
        slurp
      ];
      text = ''
        case "$(printf "a selected area\\nfull screen\\na selected area (copy)\\nfull screen (copy)" |\
          wmenu -ip "Screenshot which area?")" in
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
      runtimeInputs = with pkgs; [
        grim
        slurp
        swappy
      ];
      text = ''
                if [[ ''${1:-} ]]; then
                  mode="$1"
                else
                  mode="$(printf "region\\n\\nall" |\
                        wmenu -ip "Screenshot which area?")"
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
      name = "greeting";
      text = ''
        hour=$(date "+%H")

        if [ "$hour" -ge 5 ] && [ "$hour" -lt 12 ]; then
                greeting="Good Morning"
        elif [ "$hour" -ge 12 ] && [ "$hour" -lt 17 ]; then
                greeting="Good Day"
        elif [ "$hour" -ge 17 ] && [ "$hour" -lt 20 ]; then
                greeting="Good Afternoon"
        elif [ "$hour" -ge 20 ] && [ "$hour" -lt 23 ]; then
                greeting="Good Evening"
        else
                greeting="Good Night"
        fi

        # fastfetch --data-raw "$(cowsay -f elephant "$greeting, Soli" | dotacat)"

        ele=$(cat << EOF
        $greeting, Soli!
             \\/
              ,  __
              '.'°()--.
                ', . ,|'
                 /_)-_!
        EOF
        )

        fastfetch --data-raw "$(dotacat <<< "$ele")" --logo-position right --logo-padding-top 3
      '';
    })
    (pkgs.writeShellApplication {
      name = "clipmenu";
      text = ''
        pkill fuzzel || cliphist list | fuzzel --dmenu | cliphist decode | wl-copy
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
      nu  rm ~/.config/fuzzel/fuzzel.ini
      '';
    })
  ];
in
{
  environment.systemPackages = scripts;
}
