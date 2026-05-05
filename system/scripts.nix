{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  scripts = [

    (pkgs.writeShellApplication {
      name = "toggle-polarity";
      runtimeInputs = with pkgs; [
        matugen
        coreutils
        glib
        gsettings-desktop-schemas
        awww
      ];
      text = /* bash */ ''
        export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:$XDG_DATA_DIRS
        mode="''${1:-toggle}"

        case "$mode" in
          dark)
            next_mode="dark"
            color_scheme="prefer-dark"
            ;;
          light)
            next_mode="light"
            color_scheme="prefer-light"
            ;;
          toggle)
            current_scheme="$(gsettings get org.gnome.desktop.interface color-scheme)"
            current_scheme="''${current_scheme#\'}"
            current_scheme="''${current_scheme%\'}"

            if [ "$current_scheme" = "prefer-dark" ]; then
              next_mode="light"
              color_scheme="prefer-light"
            elif [ "$current_scheme" = "prefer-light" ]; then
              next_mode="dark"
              color_scheme="prefer-dark"
            else
            printf '%s\n' \
              "toggle-polarity: refusing to toggle because org.gnome.desktop.interface color-scheme is '$current_scheme'." \
              "Run 'toggle-polarity dark' or 'toggle-polarity light' once to establish an explicit state." \
              >&2
            exit 1
            fi
            ;;
          *)
            printf 'usage: %s [dark|light|toggle]\n' "$0" >&2
            exit 1
            ;;
        esac

        read -r wallpaper < "$HOME/.cache/bgpath"
        matugen image "$wallpaper" -m "$next_mode" --source-color-index 0
        gsettings set org.gnome.desktop.interface color-scheme "$color_scheme"
      '';
    })
    (pkgs.writeShellApplication {
      name = "battery-monitor";
      runtimeInputs = with pkgs; [
        libnotify
        swayosd
        findutils
        systemd
        gnugrep
        gawk
      ];
      text = /* bash */ ''
        BAT_DIR="$(find -L /sys/class/power_supply -maxdepth 1 -type d -name 'BAT*' -print -quit)"
        if [ -z "$BAT_DIR" ]; then
            exit 0
        fi

        last_notified_level=0

        while true; do
            props="$(udevadm info -q property -p "$BAT_DIR")"
            capacity="$(printf '%s\n' "$props" | awk -F= '/^POWER_SUPPLY_CAPACITY=/{print $2; exit}')"
            status="$(printf '%s\n' "$props" | awk -F= '/^POWER_SUPPLY_STATUS=/{print $2; exit}')"

            if [ -z "$capacity" ] || [ -z "$status" ]; then
                udevadm monitor --subsystem-match=power_supply --property | grep -m 1 "POWER_SUPPLY_CAPACITY=" >/dev/null
                continue
            fi

            if [ "$status" = "Discharging" ]; then
                if [ "$capacity" != "$last_notified_level" ]; then
                    
                    # 15% - Low Battery
                    if [ "$capacity" -le 15 ] && [ "$capacity" -gt 5 ]; then
                        if [ "$capacity" -eq 15 ] || [ "$last_notified_level" -gt 15 ]; then
                             notify-battery
                             swayosd-client --custom-text="Battery low ($capacity)"  --custom-icon=battery
                        fi

                    # 5% - Critical
                    elif [ "$capacity" -le 5 ] && [ "$capacity" -gt 2 ]; then
                        if [ "$capacity" -eq 5 ] || [ "$last_notified_level" -gt 5 ]; then
                             notify-send -u critical "Battery Critical" "Level is at ''${capacity}%. Connect charger!"
                             swayosd-client --custom-text="Battery Critical ($capacity)"  --custom-icon=battery
                        fi

                    # 2% - Sleep
                    elif [ "$capacity" -le 2 ]; then
                        notify-send -u critical "Battery Dying" "Suspending system now..."
                        sleep 2
                        systemctl suspend
                    fi
                    
                    last_notified_level=$capacity
                fi
            else
                last_notified_level=100
            fi

            udevadm monitor --subsystem-match=power_supply --property | grep -m 1 "POWER_SUPPLY_CAPACITY=" >/dev/null
        done
      '';
    })
    (pkgs.writers.writeNuBin "notify-battery"
      {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [
            pkgs.libnotify
            pkgs.nushell
            pkgs.swayosd
          ]}"
        ];
      }
      /* nu */ ''
        let bat_dirs = (ls /sys/class/power_supply | where name =~ "BAT")
        if ($bat_dirs | length) == 0 { exit 0 }
        let bat_dir = ($bat_dirs | get 0 | get name)
        let BATTERY_LEVEL = (open $"($bat_dir)/capacity" | into int)
        swayosd-client --custom-progress=($BATTERY_LEVEL / 100) --custom-progress-text=$"($BATTERY_LEVEL)%" --custom-icon=battery
      ''
    )
    (pkgs.writers.writeNuBin "update-openrgb-color"
      {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [
            inputs.thumbpick.packages.${pkgs.stdenv.hostPlatform.system}.default
            pkgs.awww
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
        if ($chosen_key | is-empty) { exit 0 }

        let chosen_value = ($expansions | where key == $chosen_key | get value.0)
        let lines = ($chosen_value | lines)

        for line in $lines {
          wtype $line
          if $line != ($lines | last) {
            wtype -k Return
          }
        }
      ''
    )

    (pkgs.writeShellApplication {
      name = "color-mode";
      runtimeInputs = with pkgs; [
        fuzzel
        matugen
        glib
        gsettings-desktop-schemas
      ];
      text = ''
        export XDG_DATA_DIRS="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:$XDG_DATA_DIRS"
        state_file="''${XDG_STATE_HOME:-$HOME/.local/state}/nixrice/type"
        default_type="scheme-expressive"
        types="scheme-content
        scheme-expressive
        scheme-fidelity
        scheme-fruit-salad
        scheme-monochrome
        scheme-neutral
        scheme-rainbow
        scheme-tonal-spot
        scheme-vibrant"

        mkdir -p "$(dirname "$state_file")"
        current_type="$(cat "$state_file" 2>/dev/null || printf '%s\n' "$default_type")"

        case "''${1:-pick}" in
          pick)
            type="$(printf '%s\n' "$types" | fuzzel --dmenu --prompt "Matugen type > " --placeholder "$current_type")"
            [ -n "$type" ] || exit 0
            ;;
          current|get|print)
            printf '%s\n' "$current_type"
            exit 0
            ;;
          list)
            printf '%s\n' "$types"
            exit 0
            ;;
          toggle)
            if [ "$current_type" = "scheme-expressive" ]; then
              type="scheme-vibrant"
            else
              type="scheme-expressive"
            fi
            ;;
          *)
            type="$1"
            ;;
        esac

        printf '%s\n' "$types" | grep -qxF "$type" || {
          printf 'change-mode: unsupported type: %s\n' "$type" >&2
          exit 1
        }

        printf '%s\n' "$type" > "$state_file"

        read -r wallpaper < "$HOME/.cache/bgpath"

        if [ -r "''${wallpaper:-}" ]; then
          theme_mode="$(gsettings get org.gnome.desktop.interface color-scheme)"
          theme_mode="''${theme_mode%\'}"
          theme_mode="''${theme_mode#\'}"
          [ "$theme_mode" = "prefer-dark" ] && mode="dark" || mode="light"
          matugen image "$wallpaper" -m "$mode" -t "$type" --source-color-index 0
        fi
      '';
    })

    (pkgs.writeShellApplication {
      name = "nixrice";
      runtimeInputs = with pkgs; [
        yad
        libnotify
        matugen
        awww
        glib
      ];
      text = ''
        export XDG_DATA_DIRS="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:$XDG_DATA_DIRS"
        NIXRICE_STATE_DIR="''${XDG_STATE_HOME:-$HOME/.local/state}/nixrice"
        NIXRICE_TYPE_FILE="$NIXRICE_STATE_DIR/type"
        DEFAULT_MATUGEN_TYPE="scheme-tonal-spot"
        THEME_MODE=$(gsettings get org.gnome.desktop.interface color-scheme)

        # Clean up quotes (returns 'prefer-dark' or 'default')
        THEME_MODE="''${THEME_MODE%\'}"
        THEME_MODE="''${THEME_MODE#\'}"

        if [[ "$THEME_MODE" == "prefer-dark" ]]; then
            MATUGEN_MODE="dark"
        else
            MATUGEN_MODE="light"
        fi

        mkdir -p "$NIXRICE_STATE_DIR"
        if [ -r "$NIXRICE_TYPE_FILE" ]; then
          MATUGEN_TYPE="$(tr -d '\n' < "$NIXRICE_TYPE_FILE")"
        else
          MATUGEN_TYPE="$DEFAULT_MATUGEN_TYPE"
        fi

        case "$MATUGEN_TYPE" in
          scheme-content|scheme-expressive|scheme-fidelity|scheme-fruit-salad|scheme-monochrome|scheme-neutral|scheme-rainbow|scheme-tonal-spot|scheme-vibrant)
            ;;
          *)
            MATUGEN_TYPE="$DEFAULT_MATUGEN_TYPE"
            ;;
        esac

        if [[ ''${1:-} ]]; then
        	wallpaper="$(realpath "$1")"
        else
        	cd "$HOME"/Pictures/wallpapers || return 1
        	wallpaper="$(thumbpick ~/Pictures/wallpapers)"
                if [[ $wallpaper ]]; then
                  wallpaper="$(realpath "$wallpaper")"
                fi
        fi

        if [[ $wallpaper ]]; then
                printf '%s\n' "$wallpaper" > "$HOME/.cache/bgpath"
                matugen image "$wallpaper" -m "$MATUGEN_MODE" -t "$MATUGEN_TYPE" --source-color-index 0
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
        pkill fuzzel || stash list | fuzzel -dp "Clipboard History:" | stash decode | wl-copy
      '';
    })
    (pkgs.writeShellApplication {
      name = "notify-time";
      text = ''
        swayosd-client --custom-message=" - $(date +"%T - %d, %B %4Y") - " --custom-icon=clock
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
    (pkgs.writeShellApplication {
      name = "bw-export-session";
      runtimeInputs = with pkgs; [
        bitwarden-cli
        coreutils
      ];
      text = ''
        if [ ! -r /run/agenix/bitwarden_clientid ] \
          || [ ! -r /run/agenix/bitwarden_clientsecret ] \
          || [ ! -r /run/agenix/bitwarden_password ]; then
          exit 0
        fi

        BW_CLIENTID="$(tr -d '\n' < /run/agenix/bitwarden_clientid)"
        BW_CLIENTSECRET="$(tr -d '\n' < /run/agenix/bitwarden_clientsecret)"
        BW_PASSWORD="$(tr -d '\n' < /run/agenix/bitwarden_password)"
        export BW_CLIENTID BW_CLIENTSECRET BW_PASSWORD

        bw_status="$(bw status 2>/dev/null || true)"

        case "$bw_status" in
          *'"status":"unauthenticated"'* | *'"status": "unauthenticated"'*)
            bw login --apikey --nointeraction >/dev/null 2>&1 || exit 0
            bw_status="$(bw status 2>/dev/null || true)"
            ;;
        esac

        case "$bw_status" in
          *'"status":"unlocked"'* | *'"status": "unlocked"'*)
            if [ -n "''${BW_SESSION:-}" ]; then
              printf '%s\n' "$BW_SESSION"
            fi
            ;;
          *'"status":"locked"'* | *'"status": "locked"'* | *'"status":"unauthenticated"'* | *'"status": "unauthenticated"'*)
            bw_session="$(bw unlock --passwordenv BW_PASSWORD --raw 2>/dev/null || true)"
            if [ -n "$bw_session" ]; then
              printf '%s\n' "$bw_session"
            fi
            ;;
        esac
      '';
    })
  ];
in
{
  environment.systemPackages = scripts;
}
