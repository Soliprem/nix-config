{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  # inherit (config.lib.stylix) colors;
  gamemode = pkgs.writeShellApplication {
    name = "gamemode";
    text = ''
      HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
      if [ "$HYPRGAMEMODE" = 1 ] ; then
          hyprctl --batch "\
              keyword animations:enabled 0;\
              keyword decoration:drop_shadow 0;\
              keyword decoration:blur:enabled 0;\
              # keyword general:gaps_in 0;\
              keyword general:gaps_out 0;\
              keyword general:border_size 1;\
              keyword decoration:rounding 0"
          exit
      fi
      hyprctl reload
    '';
  };
in {
  imports = [
    inputs.hyprland.nixosModules.default
  ];
  programs = {
    hyprland = {
      topPrefixes = [
        "$"
        "bezier"
        "source"
      ];
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      # make sure to also set the portal package, so that they are in sync
      settings = {
        source = "~/.config/hypr/colors.conf";
        "$mod" = "SUPER";
        "$term" = "ghostty";
        "$editor" = "nvim";
        "$browser" = "zen";

        experimental = {
          # wide_color_gamut = true;
          # xx_color_management_v4 = true;
          # hdr = true;
        };

        decoration = {
          rounding = 20;

          blur = {
            enabled = true;
          };
          # Shadow
          # Shader
          # screen_shader = ~/.config/hypr/shaders/nothing.frag
          # screen_shader = ~/.config/hypr/shaders/vibrance.frag
          # screen_shader = ~/.config/hypr/shaders/extradark.frag

          # Dim
          dim_inactive = false;
          dim_strength = 0.1;
          dim_special = 0;
        };

        env = [
          "QT_IM_MODULE, fcitx"
          "XMODIFIERS, @im=fcitx"
          # env = GTK_IM_MODULE, wayland   # Crashes electron apps in xwayland
          # env = GTK_IM_MODULE, fcitx     # My Gtk apps no longer require this to work with fcitx5 hmm
          "SDL_IM_MODULE, fcitx"
          "GLFW_IM_MODULE, ibus"
          "INPUT_METHOD, fcitx"
          "HYPRCURSOR_THEME,Hypr-Bibata-Modern-Ice"
          "HYPRCURSOR_SIZE,24"
          # "XCURSOR_THEME,Bibata-Modern-Ice"
          # "XCURSOR_SIZE,24"

          # ############ Themes #############
          # "QT_QPA_PLATFORM, wayland"
          # "QT_QPA_PLATFORMTHEME, qt5ct"
          # env = QT_STYLE_OVERRIDE,kvantum
          "WLR_NO_HARDWARE_CURSORS, 1"
        ];

        animations = {
          enabled = true;
        };
        # Animation curves
        bezier = [
          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92 "
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "fluent_decel, 0, 1, 0, 1"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        # Animation configs
        animation = [
          # "windows, 1, 3, md3_decel, popin 60%"
          # "border, 1, 10, default"
          # "fade, 1, 2.5, md3_decel"
          # "workspaces, 1, 7, fluent_decel, slidevert"
          # "specialWorkspace, 1, 3, md3_decel"
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];

        misc = {
          vfr = 0;
          vrr = 1;
          # layers_hog_mouse_focus = true
          focus_on_activate = true;
          animate_manual_resizes = false;
          animate_mouse_windowdragging = false;

          disable_hyprland_logo = true;
          force_default_wallpaper = 0;
          # new_window_takes_over_fullscreen = 2;

          enable_swallow = true;
          swallow_regex = "^(com.mitchellh.ghostty|kitty|foot)$";
          swallow_exception_regex = "^(nvim|v|vi|wev|R|glxgears|julia)\b.*$";
        };

        debug = {
          full_cm_proto = 1;
          # overlay = true
          # damage_tracking = 0
          # damage_blink = yes
        };

        # Window and layer rules
        layerrule = [
          # "noanim, selection"
        ];

        windowrule = [
          #"opacity 0.89 override 0.89 override, .* # Applies transparency to EVERY WINDOW"
          "match:title Julia, float on"
          "match:title org.kde.polkit-kde-authentication-agent-1, float on"
          "match:title ^(Picture-in-Picture)$, float on"
          "move 1275 45,match:title ^(Picture-in-Picture)$"
          # --------- FOR GIMP ---------
          "match:title ^(flame)$, float on"
          "move 700 250,match:title ^(flame)$"
          "match:title ^(script-fu)$, float on"
          "move 700 250,match:title ^(script-fu)$"
          "match:title ^(org.gtk_rs.HelloWorld2)$, float on"

          # Dialogs
          "match:title ^(Open File)(.*)$, float on"
          "match:title ^(Select a File)(.*)$, float on"
          "match:title ^(Choose wallpaper)(.*)$, float on"
          "match:title ^(Open Folder)(.*)$, float on"
          "match:title ^(Save As)(.*)$, float on"
          "match:title ^(Library)(.*)$ , float on"

          "rounding 20, match:workspace 1"
          "opacity 1 override 1 override, match:class  ^(mpv|steam_app)(.*)$"
          "opacity 1 override 1 override, match:title  ^(.*.)(YouTube|Invidious)(.*)$"
          "fullscreen_state -1 2, match:class ^(firefox)$, match:title ^((?!Enter name of file to save to…|Save))"
          "workspace special,match:title ^(Firefox — Sharing Indicator)$"
          "workspace special,match:title ^(zen — Sharing Indicator)$"
        ];
        # Keybinds

        # workspace = [
        #   "w[t1], gapsout:80"
        #   "w[tg1], gapsout:80"
        #   "w[t2], gapsout:40"
        #   "w[tg2], gapsout:40"
        #   "f[1], gapsout:80"
        # ];

        "monitorv2[desc:AOC Q27G3XMN 1APQ7JA005710]" = {
          mode = "2560x1440@180.0019999";
          position = "0x0";
          scale = 1;
          supports_wide_color = 1;
          supports_hdr = 1;
          sdr_min_luminance = 0.005;
          sdr_max_luminance = 250;
        };
        "monitorv2[HDMI-A-1]" = {
          mode = "1920x1080@120";
          position = "2560x0";
          scale = 1;
        };
        "monitorv2[eDP-1]" = {
          mode = "1920x1200@60";
          position = "0x0";
          scale = 1;
        };
        "monitorv2[desc:Seiko Epson Corporation EPSON PJ 0x01010101]" = {
          mode = "preferred";
          position = "auto";
          scale = 1.5;
        };

        monitor = [
          ",preferred,auto,1"
        ];
        # render.cm_fs_passthrough = true;
        # render.cm_auto_hdr = 1;
        input = {
          kb_layout = "eu, it";
          kb_options = "grp:alt_space_toggle";
          follow_mouse = 2;
          touchpad = {
            natural_scroll = "yes";
            disable_while_typing = true;
            clickfinger_behavior = true;
            scroll_factor = 0.5;
          };
        };
        gesture = [
          "3, down, mod: SUPER, close"
          "3, up, mod: SUPER, scale: 1.5, fullscreen"
          "3, horizontal, workspace"
          "3, vertical, special, special"
        ];
        general = {
          # Gaps and border
          gaps_in = 4;
          gaps_out = 5;
          # gaps_workspaces = 50;
          border_size = 1;

          resize_on_border = true;
          layout = "scrolling";

          #focus_to_other_workspaces = true # ahhhh i still haven't properly implemented this
          allow_tearing = false; # some guy told me tearing might make things smoother idk
        };
        master = {
          new_on_top = 0;
        };
        binde = [
          # "SUPER,h,resizeactive,-20 0"
          # "SUPER,l,resizeactive,20 0"
          "SUPERCTRL,h,resizeactive,-20 0 # [hidden]"
          "SUPERCTRL,l,resizeactive,20 0 # [hidden]"
          "SUPERCTRL,k,resizeactive,0 -20 # [hidden]"
          "SUPERCTRL,j,resizeactive,0 20 # [hidden]"
          "SUPER,h,layoutmsg,focus left"
          "SUPER,l,layoutmsg,focus right"
          "SUPER,k,layoutmsg,focus up"
          "SUPER,j,layoutmsg,focus down"
          "SUPER,equal,layoutmsg,colresize -0.02"
          "SUPERSHIFT,equal,layoutmsg,colresize +0.02"
        ];
        bindle = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          # ",XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
          # ",XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"

          # Brightness
          ",XF86MonBrightnessUp, exec, brightnessctl set '12.75+'"
          ",XF86MonBrightnessDown, exec, brightnessctl set '12.75-'"
          ",XF86MonBrightnessUp, exec, brightness-ddcutil 10"
          ",XF86MonBrightnessDown, exec, brightness-ddcutil -10"
          # ",XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
          # ",XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
          ",Caps_Lock, exec,sleep 0.1 && swayosd-client --caps-lock"
        ];
        bindl = [
          # ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle && notify-send \"Toggling Microphone\" "
          # ",XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle && notify-send \"Toggling Microphone\" "
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-volume"
          "$mod+Shift,M, exec, swayosd-client --output-volume mute-toggle"
          ",XF86AudioMedia, exec, playerctl play-pause"
          ",XF86AudioPlay, exec, playerctl play-pause"
          ",XF86AudioPrev, exec, playerctl previous"
          ",XF86AudioNext, exec, playerctl next"
        ];
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, z, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
        bind =
          [
            ", XF86PowerOff, exec, wlogout"
            "$mod, V, exec, pkill fuzzel || cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
            "$mod,tab,focuscurrentorlast"
            "$mod,c,exec, swaync-client -t"
            "$mod+Shift,c,exec, swaync-client -d"
            "$mod, mouse_up, workspace, +1"
            "$mod, mouse_down, workspace, -1"
            "$mod, F1, exec, ${lib.getExe gamemode}"
            "$mod+Shift, space, togglefloating"
            "$mod+Alt, l, exec, swaylock"
            "$mod, t, exec, notify-time"
            "$mod+Shift, v, exec, notify-volume"
            "$mod, b, exec, notify-battery"
            ", Print, exec, grimblast copy area"
            "$mod, E, exec, nautilus --new-window"
            "$mod+Shift+Alt, Period, exec, fuzzel-emoji"
            "$mod, Comma, focusmonitor, -1"
            "$mod, Period, focusmonitor, +1"
            "$mod+Shift, Comma, movewindow, mon:-1"
            "$mod+Shift, Period, movewindow, mon:+1"
            "$mod+Ctrl, Comma, movecurrentworkspacetomonitor, -1"
            "$mod+Ctrl, Period, movecurrentworkspacetomonitor, +1"
            "Alt, tab, focusurgentorlast"
            "$mod, w, exec, $browser"
            "$mod, Return, exec, $term"
            "$mod, Q, killactive, "
            "$mod, n, exec, dm-notes"
            "$mod+Shift, n, exec, $term -e notes"
            "$mod+Shift, Q, exec, hyprctl kill"
            "$mod, d, exec, $(tofi-run)"
            "$mod, o, exec, dm-hub"
            "$mod+shift, semicolon, exec, dm-expand"
            "$mod, minus, exec, wtype -k emdash"
            "$mod SHIFT, d, exec, fuzzel-run"
            "$mod+Alt, s, movetoworkspacesilent, special"
            "$mod, s, togglespecialworkspace"
            "$mod+Alt, p, pin"

            # Scrolling Layout Movements

            "SUPERSHIFT,h,layoutmsg,movewindowto l"
            "SUPERSHIFT,l,layoutmsg,movewindowto r"
            "SUPER,r,layoutmsg,colresize +conf"
            "SUPERSHIFT,r,layoutmsg,colresize -conf"
            "SUPER,space,layoutmsg,promote"

            # Master Layout Movements

            "SUPER,j,layoutmsg,cyclenext # Focus on next window in the layout"
            "SUPERALTSHIFT,j,bringactivetotop # [hidden]"
            "SUPERSHIFT,j,layoutmsg,swapnext # [hidden]"
            "SUPER,k,layoutmsg,cycleprev # [hidden]"
            "SUPERSHIFT,k,layoutmsg,swapprev # [hidden]"
            "SUPER,space,layoutmsg,swapwithmaster # [hidden]"
            "SUPERSHIFT,h,layoutmsg,addmaster # [hidden]"
            "SUPERSHIFT,l,layoutmsg,removemaster # [hidden]"
            " SUPER, f, fullscreen, 1  # [hidden]"
            " SUPERSHIFT, f, fullscreen, 0  # [hidden]"

            # Special
            "$mod+Alt, F, fullscreenstate, -1 2"

            # Plugins
            "$mod+Shift, g, hyprexpo:expo, toggle"
            # "$mod, g, overview:toggle"

            # screenshots
            "$mod, P,exec, hyprshot -m output -c -r - | swappy -f - # [hidden]"
            "$mod+Shift,P,exec, hyprshot -m window -r - | swappy -f - # [hidden]"
            "$mod+Shift, S, exec, hyprshot -m region -r - |swappy -f - # [hidden]"
          ]
          ++ (
            # workspaces
            # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
            builtins.concatLists (builtins.genList (
                x: let
                  ws = let
                    c = (x + 1) / 10;
                  in
                    builtins.toString (x + 1 - (c * 10));
                in [
                  "$mod, ${ws}, split-workspace, ${toString (x + 1)}"
                  "$mod SHIFT, ${ws}, split-movetoworkspacesilent, ${toString (x + 1)}"
                  "Alt $mod, ${ws}, focusworkspaceoncurrentmonitor, ${toString (x + 1)}"
                  "Alt $mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                ]
              )
              10)
          );
        plugin = {
          hyprtrails = {
            color = "$primary";
          };
          split-monitor-workspaces = {
            count = 10;
            enable_persistent_workspaces = false;
          };
          hyprscrolling = {
            focus_fit_method = 1;
          };
        };
        exec-once = [
          "iio-hyprland"
          "wl-paste --type text --watch cliphist store &"
          "wl-paste --type image --watch cliphist store &"
          "batsignal &"
          "swayosd-server"
          "swww-daemon &"
          "nm-applet &"
          "swaync &"
          "protonvpn-app &"
          "darkman run &"
          "kanshi &"
        ];
      };
      plugins = [
        # inputs.Hyprspace.packages.${pkgs.stdenv.hostPlatform.system}.Hyprspace
        inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
        inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprscrolling
        # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprtrails
        inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
      ];
    };
  };
}
