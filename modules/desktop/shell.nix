{inputs, ...}: {
  flake.modules.nixos.desktop-shell = {
    config,
    lib,
    pkgs,
    system,
    ...
  }: let
    gsettingsSchemaPath = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}";
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
        runtimeEnv.NIXRICE_GSETTINGS_SCHEMA_PATH = gsettingsSchemaPath;
        text = builtins.readFile ../../scripts/toggle-polarity.sh;
      })
      (pkgs.writeShellApplication {
        name = "battery-monitor";
        runtimeInputs = with pkgs; [
          libnotify
          findutils
          systemd
          gnugrep
          gawk
        ];
        text = builtins.readFile ../../scripts/battery-monitor.sh;
      })
      (pkgs.writers.writeNuBin "notify-battery" {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [
            pkgs.libnotify
            pkgs.nushell
          ]}"
        ];
      } (builtins.readFile ../../scripts/notify-battery.nu))
      # FIXME: change this to use matugen
      (pkgs.writers.writeNuBin "update-openrgb-color" {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [
            inputs.thumbpick.packages.${system}.default
            pkgs.awww
          ]}"
        ];
      } (builtins.readFile ../../scripts/update-openrgb-color.nu))
      (pkgs.writers.writeNuBin "clear-trash" {} (builtins.readFile ../../scripts/clear-trash.nu))
      (pkgs.writers.writeNuBin "dm-expand" {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [pkgs.fuzzel]}"
        ];
      } (builtins.readFile ../../scripts/dm-expand.nu))
      (pkgs.writeShellApplication {
        name = "color-mode";
        runtimeInputs = with pkgs; [
          fuzzel
          matugen
          glib
          gsettings-desktop-schemas
        ];
        runtimeEnv.NIXRICE_GSETTINGS_SCHEMA_PATH = gsettingsSchemaPath;
        text = builtins.readFile ../../scripts/color-mode.sh;
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
        runtimeEnv.NIXRICE_GSETTINGS_SCHEMA_PATH = gsettingsSchemaPath;
        text = builtins.readFile ../../scripts/nixrice.sh;
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
        text = builtins.readFile ../../scripts/wayshotpick.sh;
      })
      (pkgs.writeShellApplication {
        name = "grimpick";
        runtimeInputs = with pkgs; [
          grim
          slurp
          satty
        ];
        text = builtins.readFile ../../scripts/grimpick.sh;
      })
      (pkgs.writeShellApplication {
        name = "fuzzel-run";
        runtimeInputs = with pkgs; [
          fuzzel
          fd
        ];
        text = builtins.readFile ../../scripts/fuzzel-run.sh;
      })
      (pkgs.writeShellApplication {
        name = "clipmenu";
        text = builtins.readFile ../../scripts/clipmenu.sh;
      })
      (pkgs.writeShellApplication {
        name = "notify-time";
        runtimeInputs = with pkgs; [coreutils libnotify];
        text = builtins.readFile ../../scripts/notify-time.sh;
      })
      (pkgs.writeShellApplication {
        name = "satty-clip";
        text = builtins.readFile ../../scripts/satty-clip.sh;
      })
      (pkgs.writeShellApplication {
        name = "sll";
        runtimeInputs = with pkgs; [
          mpv
          sl
        ];
        text = builtins.readFile ../../scripts/sll.sh;
      })
    ];
  in {
    imports = [
      inputs.dm-scripts.nixosModules.default
    ];
    programs.dmscripts = {
      enable = true;
      displayServer = "wayland";
      manPages = true;
      scripts = [
        "dm-kill"
        "dm-hub"
        "dm-confedit"
        "dm-wifi"
        "dm-websearch"
        "dm-spam"
        "dm-dictionary"
        "dm-spellcheck"
        "dm-documents"
        "dm-dragdir"
        "dm-dragdrop"
        "dm-sunsetr"
        "dm-notes"
      ];
    };
    programs.gnupg.agent.pinentryPackage = pkgs.pinentry-all;
    services.keyd = {
      enable = true;
      keyboards.default = {
        ids = ["*"];
        settings = {
          global.overload_tap_timeout = 200;
          main = {
            altgr = "overload(altgr, capslock)";
            capslock = "overload(control,esc)";
            leftshift = "overload(shift, S-9)";
            rightshift = "overload(shift, S-0)";
          };
        };
      };
    };
    services = {
      # displayManager.ly.enable = true;
      displayManager.noctalia-greeter.enable = true;
      earlyoom = {
        enable = true;
        enableNotifications = true;
      };
      kmscon = {
        enable = true;
        config.fonts-name = builtins.head config.fonts.fontconfig.defaultFonts.monospace;
      };
      logind.settings.Login.HandlePowerKey = "ignore";
      pulseaudio.enable = false;
      udev.packages = with pkgs; [
        via
        vial
        qmk-udev-rules
      ];
      xserver.xkb = {
        layout = "eu";
        options = "caps:swapescape";
      };
      gvfs.enable = true;
      udisks2.enable = true;
      gnome.gnome-keyring.enable = true;
    };
    environment.systemPackages =
      scripts
      ++ (with pkgs; [
        inputs.thumbpick.packages.${system}.default
        stash-clipboard
        brightnessctl
        fuzzel
        gammastep
        glib
        kanshi
        kdePackages.polkit-kde-agent-1
        satty
        tofi
        tray-tui
        wayneko
        wtype
        wlogout
        libnotify
        yad
        sunsetr
        (runCommand "stash-symlinks" {} ''
          mkdir -p $out/bin
          for bin in stash-copy stash-paste wl-copy wl-paste; do
            ln -s ${lib.getExe stash-clipboard} $out/bin/$bin
          done
        '')
      ]);
    hardware.keyboard.qmk.enable = true;
    security = {
      pam.services = {
        soliprem.enableGnomeKeyring = true;
        sddm.enableGnomeKeyring = true;
      };
      pki.certificateFiles = [../../assets/almawifi.cer];
      polkit = {
        enable = true;
        enablePkexecWrapper = true;
      };
    };
    systemd = {
      user.services = {
        polkit-kde-authentication-agent-1 = {
          description = "polkit-kde-authentication-agent-1";
          wantedBy = ["graphical-session.target"];
          wants = ["graphical-session.target"];
          after = ["graphical-session.target"];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1 ";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
      };
    };
    xdg.mime = {
      enable = true;
      defaultApplications = {
        "text/html" = ["zen-beta.desktop" "org.qutebrowser.qutebrowser.desktop"];
        "x-scheme-handler/http" = ["zen-beta.desktop" "org.qutebrowser.qutebrowser.desktop"];
        "x-scheme-handler/https" = ["zen-beta.desktop" "org.qutebrowser.qutebrowser.desktop"];
        "x-scheme-handler/about" = ["zen-beta.desktop" "org.qutebrowser.qutebrowser.desktop"];
        "x-scheme-handler/unknown" = ["zen-beta.desktop" "org.qutebrowser.qutebrowser.desktop"];
        "x-scheme-handler/nxm" = "vortex-downloads-handler.desktop";
        "x-scheme-handler/nxm-protocol" = "vortex-downloads-handler.desktop";
        "video/mp2t" = "mpv.desktop";
        "video/vnd.avi" = "mpv.desktop";
        "video/quicktime" = "mpv.desktop";
        "video/x-flv" = "mpv.desktop";
        "video/vnd.mpegurl" = "mpv.desktop";
        "video/mpeg" = "mpv.desktop";
        "video/dv" = "mpv.desktop";
        "video/x-flic" = "mpv.desktop";
        "video/vnd.rn-realvideo" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/mp4" = "mpv.desktop";
        "video/3gpp2" = "mpv.desktop";
      };
    };
    hjem.users.soliprem = {fontProfiles, ...}: {
      files = {
        ".config/tofi/config".text = ''
          include = matugen
          anchor = top
          width = 100%
          height = 24
          horizontal = true
          font = ${fontProfiles.mono}
          font-size = 11
          prompt-text = ""
          padding-top = 2
          padding-bottom = 0
          padding-left = 0
          padding-right = 0
          text-cursor = true
          outline-width = 0
          border-width = 0
          result-spacing = 10
          min-input-width = 80
          require-match = false
        '';
        ".config/fuzzel/fuzzel.ini".text = ''
          font=${fontProfiles.ui}:size=17
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
        ".config/bwm/config.ini".text = ''
          [dmenu]
          dmenu_command=fuzzel --dmenu

          [dmenu_passphrase]
          obscure=True
          obscure_color=#222222

          [vault]
          server_1=vw.soliprem.eu
          email_1=accounts@soliprem.eu
          password_cmd_1=cat /run/agenix/bitwarden_password
          twofactor_1=0
          session_timeout_min=360
          autotype_default={USERNAME}{TAB}{PASSWORD}{ENTER}
        '';
        ".config/kanshi/config".text = ''
          # Profile 1: Desk (AOC Main + HDMI Side)
          # HDMI offset 2560 implies it sits right of the AOC (2560px wide)
          profile {
              output "AOC Q27G3XMN 1APQ7JA005710" mode 2560x1440@180.002 position 0,0
              output "HDMI-A-1" mode 1920x1080@120 position 2560,0
          }

          # Profile 2: Projector Presentation
          profile {
              output "eDP-1" enable mode 1920x1200@60 position 0,0 scale 1.2
              output "Seiko Epson Corporation EPSON PJ 0x01010101" mode 4096x2160@60 scale 2 position 1920,0
          }

          # Profile 3: Laptop Only (Fallback)
          profile {
              output "eDP-1" enable mode 1920x1200@60 scale 1
          }

          profile {
              output "eDP-1" enable mode 1920x1200@60 scale 1
              output "*" enable scale 1
          }
        '';
        ".config/swaylock/config".text = ''
          daemonize
          ignore-empty-password
          screenshot
          font=${fontProfiles.ui}
          font-size=23

          clock
          timestr=%R
          grace=15
          #datestr=%a, %e of %B

          color=000000dd

          fade-in=0.1
          effect-blur=20x2
          #effect-greyscale
          #effect-scale=0.3

          indicator
          indicator-radius=80
          indicator-thickness=10
          indicator-caps-lock

          key-hl-color=d4d4d4
          caps-lock-key-hl-color=d4d4d4

          separator-color=00000000

          inside-color=000000ff
          inside-clear-color=00000099
          inside-caps-lock-color=00000099
          inside-ver-color=00000099
          inside-wrong-color=00000099

          ring-color=1c1c1c
          ring-clear-color=1c1c1c
          ring-caps-lock-color=1c1c1c
          ring-ver-color=1c1c1c
          ring-wrong-color=400000

          line-color=00000000
          line-clear-color=d4d4d4
          line-caps-lock-color=d4d4d4
          line-ver-color=d9d8d8FF
          line-wrong-color=ee2e24FF

          text-color=c9c9c9
          text-clear-color=c9c9c9
          text-ver-color=c9c9c9
          text-wrong-color=c9c9c9

          bs-hl-color=470400
          caps-lock-bs-hl-color=470400
          # caps-lock-key-hl-color=ffd204FF
          # caps-lock-bs-hl-color=ee2e24FF
          # disable-caps-lock-text
          text-caps-lock-color=d4d4d4
        '';
        ".config/wlogout/layout".text = ''
          {
              "label" : "lock",
              "action" : "rice-lock",
              "text" : "lock",
              "keybind" : "l"
          }
          {
              "label" : "hibernate",
              "action" : "systemctl hibernate",
              "text" : "save",
              "keybind" : "h"
          }
          {
              "label" : "logout",
              "action" : "killall Hyprland",
              "text" : "logout",
              "keybind" : "e"
          }
          {
              "label" : "shutdown",
              "action" : "systemctl poweroff",
              "text" : "shutdown",
              "keybind" : "s"
          }
          {
              "label" : "suspend",
              "action" : "systemctl suspend",
              "text" : "bedtime",
              "keybind" : "u"
          }
          {
              "label" : "reboot",
              "action" : "systemctl reboot",
              "text" : "reboot",
              "keybind" : "r"
          }

        '';
        ".config/wlogout/style.css".text = ''
          @import './colors.css';

          window {
              font-family: ${fontProfiles.ui};
              font-size: 16pt;
              color: @foreground;
              background-color: rgba(24, 27, 32, 0.2);
          }

          button {
              background-repeat: no-repeat;
              background-position: center;
              background-size: 20%;
              background-color: transparent;
              animation: gradient_f 20s ease-in infinite;
              transition: all 0.3s ease-in;
              box-shadow: 0 0 10px 2px transparent;
              border-radius: 36px;
              margin: 10px;
          }

          button:focus {
              box-shadow: none;
              background-size: 20%;
          }

          button:hover {
              background-size: 50%;
              box-shadow: 0 0 10px 3px rgba(0, 0, 0, .4);
              background-color: @primary;
              color: transparent;
              transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.5s ease-in;
          }

          #shutdown {
              background-image: image(url("${../../assets/wlogout/power.png}"));
          }

          #shutdown:hover {
              background-image: image(url("${../../assets/wlogout/power-hover.png}"));
          }

          #logout {
              background-image: image(url("${../../assets/wlogout/logout.png}"));
          }

          #logout:hover {
              background-image: image(url("${../../assets/wlogout/logout-hover.png}"));
          }

          #reboot {
              background-image: image(url("${../../assets/wlogout/restart.png}"));
          }

          #reboot:hover {
              background-image: image(url("${../../assets/wlogout/restart-hover.png}"));
          }

          #lock {
              background-image: image(url("${../../assets/wlogout/lock.png}"));
          }

          #lock:hover {
              background-image: image(url("${../../assets/wlogout/lock-hover.png}"));
          }

          #hibernate {
              background-image: image(url("${../../assets/wlogout/hibernate.png}"));
          }

          #hibernate:hover {
              background-image: image(url("${../../assets/wlogout/hibernate-hover.png}"));
          }

          #suspend {
              background-image: image(url("${../../assets/wlogout/sleep.png}"));
          }

          #suspend:hover {
              background-image: image(url("${../../assets/wlogout/sleep-hover.png}"));
          }
        '';
        ".config/dmscripts/config".text =
          /*
          bash
          */
          ''
            #!/usr/bin/env bash
            # shellcheck disable=SC2034

            # --- Main Program Definitions ---

            # DMENU variable
            DMENU="fuzzel --cache "$XDG_CACHE_HOME/fuzzel-dmscripts-history" -dp"

            # Fallback/Alternative Menus (defaults preserved)
            RMENU="rofi -dmenu -i -p"
            FMENU="fzf --bind=enter:replace-query+print-query --border=rounded --margin=5% --color=dark --height 100% --reverse --header=$(basename "$0") --info=hidden --header-first --prompt"

            # Applications
            PDF_VIEWER="zathura"
            DMBROWSER="zen-beta"
            DMTERM="ghostty -e"
            DMEDITOR="''${DMTERM} nvim"
            DMLOCKER="swaylock"

            # --- Script Specific Configurations ---

            # dm-bookman
            bookman_show_source=1

            # dm-sounds
            sounds_dir="''${HOME}/.config/dmscripts/dmsounds"

            # dm-setbg
            setbg_dir="''${HOME}/.local/src/wallpapers"
            use_imv=0

            # dm-maim
            maim_dir="''${HOME}/Screenshots"
            maim_file_prefix="maim"

            # dm-note
            note_dir="''${HOME}/.config/dmscripts/dmnote"

            # --- Lists and Arrays (Note: All must use -g flag now) ---

            # dm-confedit config
            declare -Ag confedit_list
            confedit_list[confedit]="$HOME/.config/dmscripts/config"
            confedit_list[dwm]="$HOME/.local/src/suckless/dwm/config.h"
            confedit_list[alacritty]="$HOME/.config/alacritty/alacritty.yml"
            confedit_list[awesome]="$HOME/.config/awesome/rc.lua"
            confedit_list[bash]="$HOME/.bashrc"
            confedit_list[broot]="$HOME/.config/broot/conf.toml"
            confedit_list[bspwm]="$HOME/.config/bspwm/bspwmrc"
            confedit_list[doom emacs config.el]="$HOME/.config/doom/config.el"
            confedit_list[doom emacs config.org]="$HOME/.config/doom/config.org"
            confedit_list[doom emacs init.el]="$HOME/.config/doom/init.el"
            confedit_list[doom emacs packages.el]="$HOME/.config/doom/packages.el"
            confedit_list[dunst]="$HOME/.config/dunst/dunstrc"
            confedit_list[fish]="$HOME/.config/fish/config.fish"
            confedit_list[herbstluftwm]="$HOME/.config/herbstluftwm/autostart"
            confedit_list[i3]="$HOME/.config/i3/config"
            confedit_list[ncmpcpp]="$HOME/.config/ncmpcpp/config"
            confedit_list[neovim]="$HOME/.config/nvim/init.vim"
            confedit_list[picom]="$HOME/.config/picom/picom.conf"
            confedit_list[polybar]="$HOME/.config/polybar/config"
            confedit_list[qtile]="$HOME/.config/qtile/config.py"
            confedit_list[qutebrowser bookmarks]="$HOME/.config/qutebrowser/bookmarks/urls"
            confedit_list[qutebrowser quickmarks]="$HOME/.config/qutebrowser/quickmarks"
            confedit_list[qutebrowser config.py]="$HOME/.config/qutebrowser/config.py"
            confedit_list[spectrwm]="$HOME/.spectrwm.conf"
            confedit_list[ssh]="$HOME/.ssh/config"
            confedit_list[st]="$HOME/st-distrotube/config.def.h"
            confedit_list[stumpwm]="$HOME/.config/stumpwm/config"
            confedit_list[surf]="$HOME/surf-distrotube/config.def.h"
            confedit_list[sxhkd]="$HOME/.config/sxhkd/sxhkdrc"
            confedit_list[tabbed]="$HOME/tabbed-distrotube/config.def.h"
            confedit_list[vifm]="$HOME/.config/vifm/vifmrc"
            confedit_list[vim]="$HOME/.vimrc"
            confedit_list[xmobar mon1]="$HOME/.config/xmobar/xmobarrc0"
            confedit_list[xmobar mon2]="$HOME/.config/xmobar/xmobarrc1"
            confedit_list[xmobar mon3]="$HOME/.config/xmobar/xmobarrc2"
            confedit_list[xmonad]="$HOME/.xmonad/README.org"
            confedit_list[xinitrc]="$HOME/.xinitrc"
            confedit_list[xresources]="$HOME/.Xresources"
            confedit_list[zsh]="$HOME/.zshrc"

            # dm-websearch config
            declare -Ag websearch
            # Search Engines
            websearch[bing]="https://www.bing.com/search?q="
            websearch[brave]="https://search.brave.com/search?q="
            websearch[duckduckgo]="https://duckduckgo.com/?q="
            websearch[gemini search \(https\)]="https://portal.mozz.us/gemini/geminispace.info/search%3F"
            websearch[google]="https://www.google.com/search?q="
            websearch[qwant]="https://www.qwant.com/?q="
            websearch[swisscows]="https://swisscows.com/web?query="
            websearch[yandex]="https://yandex.com/search/?text="
            # Information/News
            websearch[bbcnews]="https://www.bbc.co.uk/search?q="
            websearch[cnn]="https://www.cnn.com/search?q="
            websearch[googlenews]="https://news.google.com/search?q="
            websearch[wikipedia]="https://en.wikipedia.org/w/index.php?search="
            websearch[wiktionary]="https://en.wiktionary.org/w/index.php?search="
            # Social Media
            websearch[reddit]="https://www.reddit.com/search/?q="
            websearch[odysee]="https://odysee.com/$/search?q="
            websearch[youtube]="https://www.youtube.com/results?search_query="
            # Online Shopping
            websearch[amazon]="https://www.amazon.com/s?k="
            websearch[craigslist]="https://www.craigslist.org/search/sss?query="
            websearch[ebay]="https://www.ebay.com/sch/i.html?&_nkw="
            websearch[gumtree]="https://www.gumtree.com/search?search_category=all&q="
            # Linux
            websearch[archaur]="https://aur.archlinux.org/packages/?O=0&K="
            websearch[archpkg]="https://archlinux.org/packages/?sort=&q="
            websearch[archwiki]="https://wiki.archlinux.org/index.php?search="
            websearch[debianpkg]="https://packages.debian.org/search?suite=default&section=all&arch=any&searchon=names&keywords="
            # Development
            websearch[github]="https://github.com/search?q="
            websearch[gitlab]="https://gitlab.com/search?search="
            websearch[googleOpenSource]="https://opensource.google/projects/search?q="
            websearch[sourceforge]="https://sourceforge.net/directory/?q="
            websearch[stackoverflow]="https://stackoverflow.com/search?q="

            # dm-youtube config
            declare -Ag youtube_channels
            youtube_channels[distrotube]="https://www.youtube.com/c/DistroTube/featured"

            # dm-radio config
            DMRADIOVOLUME="100"
            declare -Ag radio_stations
            radio_stations[50s Rewind]="https://zeno.fm/radio/50s-rewind/"
            radio_stations[60s Rewind]="https://zeno.fm/radio/60s-rewind/"
            radio_stations[70s Rewind]="https://zeno.fm/radio/70s-rewind/"
            radio_stations[80s Rewind]="https://zeno.fm/radio/80s-rewind/"
            radio_stations[90s Rock]="https://zeno.fm/radio/90s-rock/"
            radio_stations[The 2000s]="https://zeno.fm/radio/the-2000s/"
            radio_stations[Classical Radio]="https://zeno.fm/radio/classical-radio/"
            radio_stations[Classical Relaxation]="https://zeno.fm/radio/radio-christmas-non-stop-classical/"
            radio_stations[Classic Rock]="https://zeno.fm/radio/classic-rockdnb2sav8qs8uv/"
            radio_stations[Gangsta49]="https://zeno.fm/radio/gangsta49/"
            radio_stations[HipHop49]="https://zeno.fm/radio/hiphop49/"
            radio_stations[Madhouse Country Radio]="https://zeno.fm/radio/madhouse-country-radio/"
            radio_stations[PopMusic]="https://zeno.fm/radio/popmusic74vyurvmug0uv/"
            radio_stations[PopStars]="https://zeno.fm/radio/popstars/"
            radio_stations[RadioMetal]="https://zeno.fm/radio/radio-metal/"
            radio_stations[RocknRoll Radio]="https://zeno.fm/radio/rocknroll-radio994c7517qs8uv/"

            # dm-colpick config
            declare -Ag colpick_list
            colpick_list[black]="#282a36"
            colpick_list[red]="#ff5555"
            colpick_list[green]="#5af78e"
            colpick_list[yellow]="#f1fa8c"
            colpick_list[blue]="#57c7ff"
            colpick_list[magenta]="#ff6ac1"
            colpick_list[cyan]="#8be9fd"
            colpick_list[white]="#f1f1f0"
            colpick_list[orange]="#ffb86c"
            colpick_list[purple]="#bd9cf9"

            # dm-reddit config
            declare -ag reddit_list=(
                "r/archlinux"
                "r/bash"
                "r/commandline"
                "r/emacs"
                "r/freesoftware"
                "r/linux"
                "r/linux4noobs"
                "r/linuxmasterrace"
                "r/linuxquestions"
                "r/suckless"
                "r/Ubuntu"
                "r/unixporn"
                "r/vim"
            )

            # dm-weather config
            # Note: Old 'declare -A' style is no longer supported. Use the string format below.
            # Example: weather_locations="New York, United States\nLondon, United Kingdom"
            weather_locations=""
            weather_opts=""

            # current revision (do not touch unless you know what you're doing)
            _revision=27

          '';
        ".config/sunsetr/sunsetr.toml".text =
          /*
          toml
          */
          '''';
        ".config/sunsetr/presets/day/sunsetr.toml".text =
          /*
          toml
          */
          ''
            #[Backend]
            backend = "auto"
            transition_mode = "static" # No time-based transitions

            #[Smoothing]
            smoothing = true
            startup_duration = 0.5     # Quick fade-in
            shutdown_duration = 0.5    # Instant shutdown
            adaptive_interval = 1

            #[Static configuration]
            static_temp = 6500         # Neutral daylight
            static_gamma = 100         # Full brightness
          '';
        ".config/sunsetr/presets/gaming/sunsetr.toml".text =
          /*
          toml
          */
          ''
            #[Backend]
            backend = "auto"
            transition_mode = "static"

            #[Smoothing]
            smoothing = true
            startup_duration = 0.5
            shutdown_duration = 0.5
            adaptive_interval = 1

            #[Static configuration]
            static_temp = 6500           # Accurate colors
            static_gamma = 115           # Slightly boosted brightness

          '';
        ".config/sunsetr/presets/reading/sunsetr.toml".text =
          /*
          toml
          */
          ''
            #[Backend]
            backend = "auto"
            transition_mode = "static"

            #[Smoothing]
            smoothing = true
            startup_duration = 0.5       # Slow transition
            shutdown_duration = 0.5
            adaptive_interval = 1

            #[Static configuration]
            static_temp = 2333           # Very warm
            static_gamma = 75            # Quite dim
          '';
        ".config/sunsetr/presets/no-blue/sunsetr.toml".text =
          /*
          toml
          */
          ''
            #[Backend]
            backend = "auto"
            transition_mode = "static"

            #[Smoothing]
            smoothing = true
            startup_duration = 0.5
            shutdown_duration = 0.5
            adaptive_interval = 1

            #[Static configuration]
            static_temp = 1000           # Extreme warmth
            static_gamma = 70            # Reduced brightness
          '';
        ".config/thumbpick/config.toml".text = ''
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
      };
    };
  };
}
