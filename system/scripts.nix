{
  lib,
  pkgs,
  inputs,
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
            inputs.thumbpick.packages.${pkgs.stdenv.hostPlatform.system}.default
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

    (pkgs.writers.writeNuBin "clear-trash"
      {
      }
      /* nu */ ''
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
      /* nu */ ''
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
      name = "nixrice";
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
        	wallpaper="$(thumbpick ~/Pictures/wallpapers --vi-mode)"
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

    (pkgs.makeDesktopItem {
      name = "nixrice";
      desktopName = "NixRice";
      exec = "nixrice";
      icon = "tools-wizard";
      categories = [ "Utility" ];
    })

    (pkgs.writeShellApplication {
      name = "wayshotpick";
      runtimeInputs = with pkgs; [
        wayshot
        slurp
      ];
      text = ''
        case "$(printf "a selected area\\nfull screen\\na selected area (copy)\\nfull screen (copy)" |\
          fuzzel -dp "Screenshot which area?")" in
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
                        wmenu --p "Screenshot which area?")"
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
      name = "fuzzel-run";
      runtimeInputs = with pkgs; [
        fuzzel
        fd
      ];
      text = ''
        IFS=':' read -ra raw_paths <<< "$PATH"
        valid_paths=()
        for dir in "''${raw_paths[@]}"; do
            [[ -d "$dir" ]] && valid_paths+=("$dir")
        done

        fd . "''${valid_paths[@]}" \
          --max-depth 1 \
          --type x \
          --hidden \
          --follow \
          --format "{/}" \
        | sort -u \
        | fuzzel -d \
          --cache "$XDG_CACHE_HOME/fuzzel-run-history" \
          --prompt "Run ➜ " \
          --placeholder "System Binaries..." \
        | xargs -r -I{} setsid -f {}
      '';
    })
    (pkgs.writeShellApplication {
      name = "clipmenu";
      text = ''
        pkill fuzzel || cliphist list | fuzzel -dp "Clipboard History:" | cliphist decode | wl-copy
      '';
    })
    (pkgs.writeShellApplication {
      name = "swappy-clip";
      text = ''
        wl-paste | swappy -f -
      '';
    })
    (pkgs.writeShellApplication {
      name = "sll";
      runtimeInputs = with pkgs; [
        mpv
        sl
      ];
      text = ''
        # very subtle easter egg, turn up the volume and wear headphones to get the best experience
        trap "pkill mpv" EXIT
        if ! [ -e ~/.cache/thomas.mp3 ]; then
            pushd .
            cd ~/.cache/ || exit 1
            wget -q thomasthetankengine.surge.sh/thomas.mp3
            popd || echo "bruh"
        fi

        if pgrep mpv; then
            sl "$@"
            exit
        fi

        mpv ~/.cache/thomas.mp3 &>/dev/null &
        command sl "$@"
      '';
    })
  ];
in
{
  environment.systemPackages = scripts;
}
