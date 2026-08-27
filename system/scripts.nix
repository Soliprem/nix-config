{
  lib,
  pkgs,
  inputs,
  ...
}: let
  cyberarchShell = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.cyberarch-shell;
  qt5Kvantum = pkgs.libsForQt5."qtstyleplugin-kvantum";
  qt6Kvantum = pkgs.kdePackages."qtstyleplugin-kvantum";
  scripts = [
    (pkgs.writeShellApplication {
      name = "cyberarch-ctl";
      runtimeInputs = [pkgs.coreutils pkgs.socat];
      text = ''
        if [ "$#" -eq 0 ]; then
          printf 'usage: %s REQUEST\n' "$0" >&2
          exit 2
        fi

        socket="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/astal/cyberpunk.sock"
        if [ ! -S "$socket" ]; then
          printf 'cyberarch-ctl: shell socket is unavailable\n' >&2
          exit 1
        fi

        printf '%s' "$*" | socat - "UNIX-CONNECT:$socket" >/dev/null
      '';
    })
    (pkgs.writeShellApplication {
      name = "rice-lock";
      runtimeInputs = [cyberarchShell pkgs.hyprlock pkgs.procps pkgs.swaylock-effects];
      text = ''
        state_file="''${XDG_STATE_HOME:-$HOME/.local/state}/nixrice/style"
        style="$(cat "$state_file" 2>/dev/null || printf 'material\n')"

        if [ "$style" = cyberpunk ] && [ -n "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
          exec cyberarch-lock
        elif [ -n "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
          pidof hyprlock >/dev/null || exec hyprlock
        else
          pidof swaylock >/dev/null || exec swaylock
        fi
      '';
    })
    (pkgs.writeShellApplication {
      name = "rice-style";
      runtimeInputs = [
        cyberarchShell
        pkgs.awww
        pkgs.coreutils
        pkgs.glib
        pkgs.gsettings-desktop-schemas
        pkgs.gnused
        pkgs.hyprland
        pkgs.quickshell
        pkgs.systemd
      ];
      text = ''
        # This service starts with systemd's deliberately minimal PATH, but
        # desktop entries expect the same profile commands as the session.
        export PATH="$HOME/.local/bin:/run/wrappers/bin:$HOME/.nix-profile/bin:/nix/profile/bin:$HOME/.local/state/nix/profile/bin:/etc/profiles/per-user/$USER/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH"
        export XDG_DATA_DIRS="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"

        state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/nixrice"
        state_file="$state_dir/style"
        material_wallpaper_file="$state_dir/material-wallpaper"
        cyberpunk_wallpaper="${cyberarchShell}/share/assets/img/lucy_wallpaper.png"
        default_style="material"

        apply_app_theme() {
          style="$1"
          profile_dir="$HOME/.config/nixrice/themes/$style"
          theme_dir="$state_dir/app-theme"
          kvantum_config="$HOME/.config/Kvantum/kvantum.kvconfig"
          kvantum_saved="$theme_dir/kvantum.kvconfig.material"
          kvantum_saved_marker="$theme_dir/kvantum-config-saved"
          mkdir -p "$theme_dir" "$HOME/.config/Kvantum"

          for version in 3.0 4.0; do
            ln -sfn "$profile_dir/gtk-settings.ini" "$HOME/.config/gtk-$version/settings.ini"
            ln -sfn "$profile_dir/gtk.css" "$HOME/.config/gtk-$version/rice.css"
          done

          if [ "$style" = cyberpunk ]; then
            for key in icon-theme cursor-theme color-scheme; do
              saved="$theme_dir/gsettings-$key"
              if [ ! -s "$saved" ]; then
                value="$(gsettings get org.gnome.desktop.interface "$key")"
                printf '%s\n' "$value" > "$saved"
              fi
            done

            if [ ! -e "$kvantum_saved_marker" ]; then
              if [ -e "$kvantum_config" ] || [ -L "$kvantum_config" ]; then
                cp -a "$kvantum_config" "$kvantum_saved"
              fi
              touch "$kvantum_saved_marker"
            fi
            ln -sfn "$profile_dir/kvantum.kvconfig" "$kvantum_config"

            gsettings set org.gnome.desktop.interface icon-theme CyberArch
            gsettings set org.gnome.desktop.interface cursor-theme CyberArch-cursors
            gsettings set org.gnome.desktop.interface color-scheme prefer-dark

            unset GTK_THEME
            systemctl --user unset-environment GTK_THEME
            export XCURSOR_THEME=CyberArch-cursors XCURSOR_SIZE=48
            export QT_STYLE_OVERRIDE=kvantum
            export QT_PLUGIN_PATH="${qt6Kvantum}/lib/qt-6/plugins:${qt5Kvantum}/lib/qt-5.15.19/plugins''${QT_PLUGIN_PATH:+:$QT_PLUGIN_PATH}"
            systemctl --user set-environment \
              XCURSOR_THEME=CyberArch-cursors XCURSOR_SIZE=48 \
              QT_STYLE_OVERRIDE=kvantum \
              QT_PLUGIN_PATH="$QT_PLUGIN_PATH"
            if [ -n "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
              hyprctl eval '
                hl.env("GTK_THEME", "")
                hl.env("HYPRCURSOR_THEME", "")
                hl.env("HYPRCURSOR_SIZE", "")
                hl.env("XCURSOR_THEME", "CyberArch-cursors")
                hl.env("XCURSOR_SIZE", "48")
                hl.env("QT_STYLE_OVERRIDE", "kvantum")
                hl.env("QT_PLUGIN_PATH", os.getenv("QT_PLUGIN_PATH") or "")
              ' >/dev/null || true
              hyprctl setcursor CyberArch-cursors 48 >/dev/null || true
            fi
          else
            if [ -L "$kvantum_config" ] \
              && [ "$(readlink "$kvantum_config")" = "$HOME/.config/nixrice/themes/cyberpunk/kvantum.kvconfig" ]; then
              rm "$kvantum_config"
            fi
            if [ -e "$kvantum_saved" ] || [ -L "$kvantum_saved" ]; then
              mv "$kvantum_saved" "$kvantum_config"
            fi
            rm -f "$kvantum_saved_marker"

            for key in icon-theme cursor-theme color-scheme; do
              saved="$theme_dir/gsettings-$key"
              if [ -s "$saved" ]; then
                gsettings set org.gnome.desktop.interface "$key" "$(cat "$saved")"
              fi
            done

            unset GTK_THEME XCURSOR_THEME XCURSOR_SIZE QT_STYLE_OVERRIDE QT_PLUGIN_PATH
            systemctl --user unset-environment \
              GTK_THEME XCURSOR_THEME XCURSOR_SIZE QT_STYLE_OVERRIDE QT_PLUGIN_PATH
            if [ -n "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
              hyprctl eval '
                hl.env("GTK_THEME", "")
                hl.env("XCURSOR_THEME", "")
                hl.env("XCURSOR_SIZE", "")
                hl.env("HYPRCURSOR_THEME", "Hypr-Bibata-Modern-Ice")
                hl.env("HYPRCURSOR_SIZE", "24")
                hl.env("QT_STYLE_OVERRIDE", "")
                hl.env("QT_PLUGIN_PATH", "")
              ' >/dev/null || true
              hyprctl setcursor Hypr-Bibata-Modern-Ice 24 >/dev/null || true
            fi

            rm -f \
              "$theme_dir/gsettings-gtk-theme" \
              "$theme_dir/gsettings-icon-theme" \
              "$theme_dir/gsettings-cursor-theme" \
              "$theme_dir/gsettings-color-scheme"
          fi
        }

        mkdir -p "$state_dir"
        current_style="$(cat "$state_file" 2>/dev/null || printf '%s\n' "$default_style")"
        case "$current_style" in
          material|cyberpunk) ;;
          *) current_style="$default_style" ;;
        esac

        restart_shell() {
          systemctl --user unset-environment \
            WAYLAND_DISPLAY DISPLAY HYPRLAND_INSTANCE_SIGNATURE \
            XDG_CURRENT_DESKTOP XDG_SESSION_TYPE
          systemctl --user import-environment \
            WAYLAND_DISPLAY DISPLAY HYPRLAND_INSTANCE_SIGNATURE \
            XDG_CURRENT_DESKTOP XDG_SESSION_TYPE 2>/dev/null || true
          systemctl --user restart rice-shell.service
          if [ -n "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
            hyprctl reload >/dev/null
          fi
        }

        active_wallpaper() {
          awww query 2>/dev/null \
            | sed -n 's/.*currently displaying: image: //p' \
            | head -n 1
        }

        set_wallpaper() {
          style="$1"
          if [ "$style" = "cyberpunk" ]; then
            active="$(active_wallpaper || true)"
            if [ -n "$active" ] && [ "$active" != "$cyberpunk_wallpaper" ] && [ -r "$active" ]; then
              printf '%s\n' "$active" > "$material_wallpaper_file"
            fi
            wallpaper="$cyberpunk_wallpaper"
          else
            wallpaper="$(cat "$material_wallpaper_file" 2>/dev/null || true)"
            if [ ! -r "$wallpaper" ]; then
              wallpaper="$(cat "$HOME/.cache/bgpath" 2>/dev/null || true)"
            fi
          fi

          if [ -r "''${wallpaper:-}" ]; then
            for _ in 1 2 3 4 5; do
              if awww img --transition-type random --transition-step 4 --transition-fps 120 "$wallpaper" 2>/dev/null; then
                return
              fi
              sleep 0.2
            done
          fi
        }

        case "''${1:-current}" in
          current|get|print)
            printf '%s\n' "$current_style"
            ;;
          material|cyberpunk)
            printf '%s\n' "$1" > "$state_file"
            restart_shell
            ;;
          toggle)
            if [ "$current_style" = "material" ]; then
              next_style="cyberpunk"
            else
              next_style="material"
            fi
            printf '%s\n' "$next_style" > "$state_file"
            restart_shell
            printf '%s\n' "$next_style"
            ;;
          apply)
            restart_shell
            ;;
          wallpaper)
            set_wallpaper "$current_style"
            ;;
          run)
            effective_style="$current_style"
            if [ "$effective_style" = "cyberpunk" ] && [ -z "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
              effective_style="material"
            fi
            apply_app_theme "$effective_style"
            set_wallpaper "$effective_style"
            if [ "$effective_style" = "cyberpunk" ]; then
              exec cyberarch-shell
            fi
            if [ "$current_style" = "cyberpunk" ]; then
              printf '%s\n' "rice-style: CyberArch currently requires Hyprland; starting Material shell" >&2
            fi
            exec quickshell --no-duplicate
            ;;
          *)
            printf 'usage: %s [current|material|cyberpunk|toggle|apply|wallpaper]\n' "$0" >&2
            exit 2
            ;;
        esac
      '';
    })
    (pkgs.writeShellApplication {
      name = "toggle-polarity";
      runtimeInputs = with pkgs; [
        matugen
        coreutils
        glib
        gsettings-desktop-schemas
        awww
      ];
      text =
        /*
        bash
        */
        ''
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
      text =
        /*
        bash
        */
        ''
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
    (
      pkgs.writers.writeNuBin "notify-battery"
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
      /*
      nu
      */
      ''
        let bat_dirs = (ls /sys/class/power_supply | where name =~ "BAT")
        if ($bat_dirs | length) == 0 { exit 0 }
        let bat_dir = ($bat_dirs | get 0 | get name)
        let BATTERY_LEVEL = (open $"($bat_dir)/capacity" | into int)
        swayosd-client --custom-progress=($BATTERY_LEVEL / 100) --custom-progress-text=$"($BATTERY_LEVEL)%" --custom-icon=battery
      ''
    )
    # FIXME: change this to use matugen
    (
      pkgs.writers.writeNuBin "update-openrgb-color"
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
      /*
      nu
      */
      ''
        let accent_color = (caelestia scheme get | lines | get 6 | parse "{foo}: {bar}" | get bar | get 0 | ansi strip)
        echo $accent_color
        openrgb --color $accent_color
      ''
    )

    (
      pkgs.writers.writeNuBin "clear-trash"
      {
      }
      /*
      nu
      */
      ''
        rm -rp ~/.local/share/Trash/*
      ''
    )

    (
      pkgs.writers.writeNuBin "dm-expand"
      {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [pkgs.fuzzel]}"
        ];
      }
      /*
      nu
      */
      ''
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
                cp "$wallpaper" ~/.local/src/nix-config/assets/bg
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
      categories = ["Utility"];
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
        satty
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
                        grim -g "$(slurp)" - | satty -f -
                        ;;
                    "all")
                        grim - | satty -f -
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

      runtimeInputs = with pkgs; [
        coreutils
        gawk
        ncurses
        microfetch
        dotacat
      ];

      text = ''
        printf -v hour '%(%H)T' -1

        if ((10#$hour < 5)); then
          greeting="Good Night"
        elif ((10#$hour < 12)); then
          greeting="Good Morning"
        elif ((10#$hour < 17)); then
          greeting="Good Day"
        elif ((10#$hour < 20)); then
          greeting="Good Afternoon"
        elif ((10#$hour < 23)); then
          greeting="Good Evening"
        else
          greeting="Good Night"
        fi

        elephant() {
          printf '%s%s\n' "$1" "$greeting, Soli!"
          printf '%s%s\n' "$1" '     \/'
          printf '%s%s\n' "$1" '      ,  __'
          printf '%s%s\n' "$1" "      '.'°()--."
          printf '%s%s\n' "$1" "        ', . ,|'"
          printf '%s%s\n' "$1" '         /_)-_!'
        }

        cols=$(tput cols)
        min_inline_cols=100

        case "''${1:-}" in
          --hide)
            narrow_mode=hide
            ;;
          --stack|"")
            narrow_mode=stack
            ;;
          *)
            printf 'Usage: greeting [--hide|--stack]\n' >&2
            exit 2
            ;;
        esac

        if ((cols < min_inline_cols)); then
          microfetch

          if [[ $narrow_mode == stack ]]; then
            printf '\n'
            elephant '    ' | dotacat
          fi

          exit 0
        fi

        # 21 columns for the elephant and a 2-column right margin.
        width=$((cols - 23))

        paste -d '\0' \
          <(
            microfetch |
              awk -v width="$width" '
                {
                  plain = $0
                  gsub(/\033\[[0-9;]*m/, "", plain)

                  padding = width - length(plain)

                  if (padding < 0) {
                    padding = 0
                  }

                  printf "%s%*s\n", $0, padding, ""
                }
              '
          ) \
          <(
            {
              printf '\n\n\n\n\n'
              elephant "" | dotacat
            }
          )
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
      name = "satty-clip";
      text = ''
        wl-paste | satty -f -
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
in {
  environment.systemPackages = scripts;
}
