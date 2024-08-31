# home.nix
{
  inputs,
  home,
  pkgs,
  config,
  ...
}: let
  inherit (config.lib.stylix) colors;
in {
  home.packages = with pkgs; [
    gammastep
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$term" = "foot";
      "$editor" = "nvim";
      "$browser" = "zen";
      decoration = {
        rounding = 20;

        blur = {
          enabled = true;
        };
        # Shadow
        drop_shadow = false;
        shadow_ignore_window = true;
        shadow_range = 20;
        shadow_offset = " 0 2";
        shadow_render_power = 2;

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
        # Animation curves

        bezier = [
          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92 "
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "fluent_decel, 0.1, 1, 0, 1"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
        ];
        # Animation configs
        animation = [
          "windows, 1, 3, md3_decel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 2.5, md3_decel"
          # animation = workspaces, 1, 3.5, md3_decel, slide
          "workspaces, 1, 7, fluent_decel, slide"
          # animation = workspaces, 1, 7, fluent_decel, slidefade 15%
          # animation = specialWorkspace, 1, 3, md3_decel, slidefadevert 15%
          "specialWorkspace, 1, 3, md3_decel, slidevert"
        ];
      };

      misc = {
        vfr = 1;
        vrr = 1;
        # layers_hog_mouse_focus = true
        focus_on_activate = true;
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;

        disable_hyprland_logo = true;
        force_default_wallpaper = 0;
        new_window_takes_over_fullscreen = 2;

        enable_swallow = true;
        swallow_regex = "^(foot|kitty)$";
        swallow_exception_regex = "^(nvim|v|vi|wev|R|glxgears|julia)\b.*$";
      };

      debug = {
        # overlay = true
        # damage_tracking = 0

        # damage_blink = yes
      };

      # Window and layer rules
      layerrule = [
        "noanim, selection"
      ];

      # Dynamic colors

      windowrule = [
        "opacity 0.89 override 0.89 override, .* # Applies transparency to EVERY WINDOW"
        "float,Julia"
        "float,org.kde.polkit-kde-authentication-agent-1"
        "float,title:^(Picture-in-Picture)$"
        "move 1275 45,title:^(Picture-in-Picture)$"
        # --------- FOR GIMP ---------
        "float,flame"
        "move 700 250,flame"
        "float,script-fu"
        "move 700 250,script-fu"
        "float,org.gtk_rs.HelloWorld2"

        # Dialogs
        "float,title:^(Open File)(.*)$"
        "float,title:^(Select a File)(.*)$"
        "float,title:^(Choose wallpaper)(.*)$"
        "float,title:^(Open Folder)(.*)$"
        "float,title:^(Save As)(.*)$"
        "float,title:^(Library)(.*)$ "
      ];
      # Keybinds

      windowrulev2 = [
        "rounding 20, onworkspace:1"
        "opacity 1 override 1 override, class: ^(mpv|steam_app)(.*)$"
        "opacity 1 override 1 override, title: ^(.*.)(YouTube|Invidious)(.*)$"
        "fullscreenstate -1 2,class:^(firefox)$, title:^((?!Enter name of file to save to…|Save))"
        "workspace special,title:^(Firefox — Sharing Indicator)$"
        "workspace special,title:^(zen — Sharing Indicator)$"
      ];
      monitor = [
        ",preferred,auto,1"
        "eDP-1, 1920x1200@60.0030,0x0,1"
        "HDMI-A-1, 1920x1080@120,0x0,1"
      ];
      input = {
        kb_layout = "eu, it";
        kb_options = "caps:swapescape, grp:alt_space_toggle";
        follow_mouse = 2;
        touchpad = {
          natural_scroll = "yes";
          disable_while_typing = true;
          clickfinger_behavior = true;
          scroll_factor = 0.5;
        };
      };
      general = {
        # Gaps and border
        gaps_in = 4;
        gaps_out = 5;
        gaps_workspaces = 50;
        border_size = 1;

        resize_on_border = true;
        no_focus_fallback = true;
        layout = "master";

        #focus_to_other_workspaces = true # ahhhh i still haven't properly implemented this
        allow_tearing = false; # some guy told me tearing might make things smoother idk
      };
      master = {
        new_on_top = 0;
        no_gaps_when_only = 0;
      };
      binde = [
        "SUPER,h,resizeactive,-20 0 # [hidden]"
        "SUPER,l,resizeactive,20 0 # [hidden]"
        "SUPERCTRL,h,resizeactive,-20 0 # [hidden]"
        "SUPERCTRL,l,resizeactive,20 0 # [hidden]"
        "SUPERCTRL,k,resizeactive,0 -20 # [hidden]"
        "SUPERCTRL,j,resizeactive,0 20 # [hidden]"
      ];
      bindle = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && notify-volume# [hidden]"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify-volume # [hidden]"

        # Brightness
        ",XF86MonBrightnessUp, exec, brightnessctl set '12.75+' && notify-brightness"
        ",XF86MonBrightnessDown, exec, brightnessctl set '12.75-' && notify-brightness"
        # ",XF86MonBrightnessUp, exec, ags run-js 'brightness.screen_value += 0.05;' # [hidden]"
        # ",XF86MonBrightnessDown, exec, ags run-js 'brightness.screen_value -= 0.05;' # [hidden]"
      ];
      bindl = [
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
        "$mod ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
        "$mod+Shift,M, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, z, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      bind =
        [
          # "$mod, V, exec, pkill fuzzel || cliphist list | fuzzel --no-fuzzy --dmenu | cliphist decode | wl-copy"
          "$mod, V, exec, pkill walker || cliphist list | walker -dk | cliphist decode | wl-copy"
          "$mod,tab,focuscurrentorlast"
          "$mod+Shift, space, togglefloating"
          "$mod, t, exec, notify-time"
          "$mod+Shift, v, exec, notify-volume"
          "$mod, b, exec, notify-battery"
          ", Print, exec, grimblast copy area"
          "$mod, E, exec, nautilus --new-window"
          "$mod, Period, exec, walker -m emoji"
          "$mod, w, exec, $browser"
          "$mod, Return, exec, $term"
          "$mod, Q, killactive, "
          "$mod, n, exec, dm-notes"
          "$mod+Shift, Q, exec, hyprctl kill"
          "$mod, d, exec, walker"
          "$mod, o, exec, dm-hub"
          "$mod+Shift, o, exec, walker -m finder"
          "$mod SHIFT, d, exec, walker -m run"
          "$mod+Alt, s, movetoworkspacesilent, special"
          "$mod, s, togglespecialworkspace"

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
          "$mod,P,exec, hyprshot -m output -c # [hidden]"
          "$mod+Shift,P,exec, hyprshot -m window # [hidden]"
          "$mod+Shift, S, exec, hyprshot -m region # [hidden]"
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
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
                "Alt $mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            10)
        );
      plugin = {
        hyprtrails = {
          color = "rgba(${colors.base09}ff)";
        };
        # hycov = {
        #   enable_hotarea = 0;
        # };
      };
      exec-once = [
        "iio-hyprland"
        "keepassxc &"
        # "nextcloud"
        "wl-paste --type text --watch cliphist store &"
        "wl-paste --type image --watch cliphist store &"
        "walker --gapplication-service"
      ];
    };
    plugins = [
      # inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
      pkgs.hyprlandPlugins.hyprexpo
      pkgs.hyprlandPlugins.hyprtrails
      # inputs.hycov.packages.${pkgs.system}.hycov
    ];
  };
}
