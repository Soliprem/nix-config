{ pkgs, lib, ... }:
let
  workspaceBinds = builtins.concatLists (
    builtins.genList (
      x:
      let
        ws = toString (x + 1);
        key = if x == 9 then "0" else toString (x + 1);
      in
      [
        "bind = $mod, ${key}, split:workspace, ${ws}"
        "bind = $mod+SHIFT, ${key}, split:movetoworkspacesilent, ${ws}"
        "bind = $mod+Alt, ${key}, focusworkspaceoncurrentmonitor, ${ws}"
        "bind = $mod+Alt+SHIFT, ${key}, split:movetoworkspace, ${ws}"
      ]
    ) 10
  );

in
{
  files.".config/hypr/hyprland.conf".text = /* hyprlang */ ''
    # -----------------------------------------------------
    # VARIABLES & SOURCE
    # -----------------------------------------------------
    $mod     = SUPER
    $browser = zen
    $term    = ghostty
    $editor  = nvim

    source = ~/.config/hypr/colors.conf

    # -----------------------------------------------------
    # PLUGINS (Loaded via Nix store paths)
    # -----------------------------------------------------
    exec-once = hyprctl plugin load ${pkgs.hyprlandPlugins.hyprscrolling}/lib/libhyprscrolling.so
    exec-once = hyprctl plugin load ${pkgs.hyprlandPlugins.hyprsplit}/lib/libhyprsplit.so

    plugin {
        hyprscrolling {
            focus_fit_method = 1
        }
        split-monitor-workspaces {
            count = 10
            enable_persistent_workspaces = false
        }
        hyprtrails {
            color = $primary
        }
    }

    # -----------------------------------------------------
    # MONITORS
    # -----------------------------------------------------
    # Syntax: name, resolution, position, scale
    monitor = eDP-1, 1920x1200@60, 0x0, 1
    monitor = , preferred, auto, 1


    monitorv2 {
      output = HDMI-A-1
      mode = 1920x1080@120
      position = 2560x0
    }

    monitorv2 {
      output = desc:AOC Q27G3XMN 1APQ7JA005710
      mode = 2560x1440@180
      position = 0x0
      supports_wide_color = 1
      supports_hdr = 1
      sdr_min_luminance = 0.005
      sdr_max_luminance = 250
    }

    monitorv2 {
      output = Seiko Epson Corporation EPSON PJ 0x01010101
      mode = preferred
      position = auto
      scale = 1.5
    }

    # -----------------------------------------------------
    # AUTOSTART
    # -----------------------------------------------------
    exec-once = iio-hyprland
    exec-once = batsignal &
    exec-once = swayosd-server
    exec-once = swww-daemon &
    exec-once = nm-applet &
    exec-once = swaync &
    exec-once = protonvpn-app &
    exec-once = darkman run &
    exec-once = kanshi &
    exec-once = wl-paste --type text --watch cliphist store &
    exec-once = wl-paste --type image --watch cliphist store &
    exec-once = sunsetr &

    # -----------------------------------------------------
    # GENERAL & DECORATION
    # -----------------------------------------------------
    general {
        gaps_in = 4
        gaps_out = 5
        border_size = 1
        layout = scrolling
        resize_on_border = true
        allow_tearing = false
    }

    decoration {
        rounding = 20
        dim_inactive = false
        dim_strength = 0.1
        
        blur {
            enabled = true
        }
    }

    input {
        kb_layout = eu, it
        kb_options = grp:alt_space_toggle
        follow_mouse = 2
        
        touchpad {
            natural_scroll = true
            disable_while_typing = true
            clickfinger_behavior = true
            scroll_factor = 0.5
        }
    }

    misc {
        vrr = 1
        vfr = 0
        disable_hyprland_logo = true
        force_default_wallpaper = 0
        focus_on_activate = true
        animate_manual_resizes = false
        animate_mouse_windowdragging = false
        
        enable_swallow = true
        swallow_regex = ^(com.mitchellh.ghostty|kitty|foot)$
        swallow_exception_regex = ^(nvim|v|vi|wev|R|glxgears|julia)b.*$
    }

    debug {
        full_cm_proto = 1
    }

    # -----------------------------------------------------
    # ANIMATIONS
    # -----------------------------------------------------
    animations {
        enabled = true

        bezier = linear, 0, 0, 1, 1
        bezier = md3_standard, 0.2, 0, 0, 1
        bezier = md3_decel, 0.05, 0.7, 0.1, 1
        bezier = md3_accel, 0.3, 0, 0.8, 0.15
        bezier = overshot, 0.05, 0.9, 0.1, 1.1
        bezier = crazyshot, 0.1, 1.5, 0.76, 0.92 
        bezier = hyprnostretch, 0.05, 0.9, 0.1, 1.0
        bezier = fluent_decel, 0, 1, 0, 1
        bezier = easeInOutCirc, 0.85, 0, 0.15, 1
        bezier = easeOutCirc, 0, 0.55, 0.45, 1
        bezier = easeOutExpo, 0.16, 1, 0.3, 1
        bezier = easeOutQuint, 0.23, 1, 0.32, 1
        bezier = easeInOutCubic, 0.65, 0.05, 0.36, 1
        bezier = almostLinear, 0.5, 0.5, 0.75, 1.0
        bezier = quick, 0.15, 0, 0.1, 1

        animation = global, 1, 10, default
        animation = border, 1, 5.39, easeOutQuint
        animation = windows, 1, 4.79, easeOutQuint
        animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
        animation = windowsOut, 1, 1.49, linear, popin 87%
        animation = fadeIn, 1, 1.73, almostLinear
        animation = fadeOut, 1, 1.46, almostLinear
        animation = fade, 1, 3.03, quick
        animation = layers, 1, 3.81, easeOutQuint
        animation = layersIn, 1, 4, easeOutQuint, fade
        animation = layersOut, 1, 1.5, linear, fade
        animation = fadeLayersIn, 1, 1.79, almostLinear
        animation = fadeLayersOut, 1, 1.39, almostLinear
        animation = workspaces, 1, 1.94, almostLinear, fade
        animation = workspacesIn, 1, 1.21, almostLinear, fade
        animation = workspacesOut, 1, 1.94, almostLinear, fade
    }

    # -----------------------------------------------------
    # WINDOW RULES
    # -----------------------------------------------------
    # Floating Rules
    windowrulev2 = float, title:^(Julia|flame|script-fu|org.gtk_rs.HelloWorld2)$
    windowrulev2 = float, title:^(Picture-in-Picture)$
    windowrulev2 = float, title:^(Open File|Select a File|Choose wallpaper|Open Folder|Save As|Library)(.*)$
    windowrulev2 = float, class:^(org.kde.polkit-kde-authentication-agent-1)$

    # Specific Placements
    windowrulev2 = move 1275 45, title:^(Picture-in-Picture)$
    windowrulev2 = move 700 250, title:^(flame|script-fu)$

    # Workspace Specific
    windowrulev2 = rounding 20, workspace:1
    windowrulev2 = opacity 1 override 1 override, class:^(mpv|steam_app)(.*)$
    windowrulev2 = opacity 1 override 1 override, title:^(.*.)(YouTube|Invidious)(.*)$

    # Firefox/Zen Sharing Indicators (Move to special workspace to hide them)
    windowrulev2 = workspace special, title:^(Firefox — Sharing Indicator|zen — Sharing Indicator)$

    # Fix Firefox file dialogs going full screen
    windowrulev2 = fullscreenstate -1 2, class:^(firefox)$, title:^((?!Enter name of file to save to…|Save))

    # -----------------------------------------------------
    # ENVIRONMENT VARIABLES
    # -----------------------------------------------------
    env = QT_IM_MODULE, fcitx
    env = XMODIFIERS, @im=fcitx
    env = SDL_IM_MODULE, fcitx
    env = GLFW_IM_MODULE, ibus
    env = INPUT_METHOD, fcitx
    env = HYPRCURSOR_THEME,Hypr-Bibata-Modern-Ice
    env = HYPRCURSOR_SIZE,24
    env = WLR_NO_HARDWARE_CURSORS, 1

    # -----------------------------------------------------
    # BINDINGS
    # -----------------------------------------------------
    # System
    bind = , XF86PowerOff, exec, wlogout
    bind = $mod SHIFT, Q, exec, hyprctl kill
    bind = $mod, Q, killactive
    bind = $mod, F1, exec, gamemode  # Requires gamemode in system packages
    bind = $mod+Alt, l, exec, swaylock
    bind = , Print, exec, grimblast copy area
    bind = $mod, P,exec, hyprshot -m output -c -r - | swappy -f -
    bind = $mod+Shift,P,exec, hyprshot -m window -r - | swappy -f -
    bind = $mod+Shift, S, exec, hyprshot -m region -r - |swappy -f -
    bind = $mod+Alt, N, exec, dm-sunsetr

    
    bindm=$mod, mouse:272, movewindow
    bindm=$mod, z, movewindow
    bindm=$mod, mouse:273, resizewindow

    # Applications
    bind = $mod, Return, exec, $term
    bind = $mod, w, exec, $browser
    bind = $mod, E, exec, nautilus --new-window
    bind = $mod, n, exec, dm-notes
    bind = $mod SHIFT, n, exec, $term -e notes
    bind = $mod+Ctrl, t, exec, $term -e tray-tui
    bind = $mod+Ctrl, b, exec, overskride
    bind = $mod+Ctrl, v, exec, pwvuctontrol

    # Launchers / Menus
    bind = $mod, d, exec, fuzzel-run
    bind = $mod SHIFT, d, exec, fuzzel
    bind = $mod, V, exec, pkill fuzzel || cliphist list | fuzzel --dmenu | cliphist decode | wl-copy
    bind = $mod+Shift+Alt, Period, exec, fuzzel-emoji
    bind = $mod, o, exec, dm-hub
    bind = $mod SHIFT, semicolon, exec, dm-expand
    bind = $mod, minus, exec, wtype -k emdash

    # Navigation
    bind = $mod, tab, focuscurrentorlast
    bind = Alt, tab, focusurgentorlast
    bind = $mod, j, layoutmsg, cyclenext
    bind = $mod, k, layoutmsg, cycleprev
    bind = $mod, space, layoutmsg, swapwithmaster

    bind = $mod SHIFT,h,layoutmsg,movewindowto l
    bind = $mod SHIFT,l,layoutmsg,movewindowto r
    bind = $mod,r,layoutmsg,colresize +conf
    bind = $mod+Shift,r,layoutmsg,colresize -conf
    bind = $mod+Shift,space,layoutmsg,promote

    bind = $mod,h,layoutmsg,focus left
    bind = $mod,l,layoutmsg,focus right
    bind = $mod,k,layoutmsg,focus up
    bind = $mod,j,layoutmsg,focus down
    bind = $mod,equal,layoutmsg,colresize -0.02
    bind = $mod SHIFT,equal,layoutmsg,colresize +0.02
    bind = $mod,space,layoutmsg,promote



    # Monitor Focus
    bind = $mod, Comma, focusmonitor, -1
    bind = $mod, Period, focusmonitor, +1
    bind = $mod SHIFT, Comma, movewindow, mon:-1
    bind = $mod SHIFT, Period, movewindow, mon:+1
    bind = $mod CTRL, Comma, movecurrentworkspacetomonitor, -1
    bind = $mod CTRL, Period, movecurrentworkspacetomonitor, +1

    # Special Workspaces
    bind = $mod, s, togglespecialworkspace
    bind = $mod ALT, s, movetoworkspacesilent, special
    bind = $mod ALT, p, pin

    # Window State
    bind = $mod SHIFT, space, togglefloating
    bind = $mod, f, fullscreen, 1
    bind = $mod SHIFT, f, fullscreen, 0
    bind = $mod ALT, F, fullscreenstate, -1 2

    # Media & Hardware Keys
    bindl = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle && notify-send "Toggling Microphone"
    bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-volume
    bindl = $mod SHIFT, m, exec, swayosd-client --output-volume mute-toggle
    bindl = , XF86AudioPlay, exec, playerctl play-pause
    bindl = , XF86AudioPrev, exec, playerctl previous
    bindl = , XF86AudioNext, exec, playerctl next

    bindle = , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
    bindle = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bindle = , XF86MonBrightnessUp, exec, brightnessctl set '12.75+'
    bindle = , XF86MonBrightnessDown, exec, brightnessctl set '12.75-'
    bindle = , Caps_Lock, exec, sleep 0.1 && swayosd-client --caps-lock

    # Gestures
    gesture = 3, down, mod:SUPER, close
    gesture = 3, up, mod:SUPER, scale:1.5, fullscreen
    gesture = 3, horizontal, workspace
    gesture = 3, vertical, special, special

    # -----------------------------------------------------
    # GENERATED WORKSPACE BINDS
    # -----------------------------------------------------
    ${lib.concatStringsSep "\n" workspaceBinds}
  '';
  files = {
    ".config/hypr/hypridle.conf".text = /* hyprlang */ ''
      general {
        after_sleep_cmd=hyprctl dispatch dpms on
        before_sleep_cmd=loginctl lock-session
        ignore_dbus_inhibit=false
        lock_cmd=pidof hyprlock || hyprlock
      }

      listener {
        on-resume=brightnessctl -rd rgb:kbd_backlight
        on-timeout=brightnessctl -sd rgb:kbd_backlight set 0
        timeout=150
      }

      listener {
        on-timeout=loginctl lock-session
        timeout=300
      }

      listener {
        on-resume=hyprctl dispatch dpms on
        on-timeout=hyprctl dispatch dpms off
        timeout=330
      }

      listener {
        on-timeout=systemctl suspend
        timeout=1800
      }
    '';

    ".config/hypr/hyprlock.conf".text = ''
          background {
        blur_passes=3
        blur_size=8
        path=screenshot
      }

      general {
        disable_loading_bar=true
        grace=300
        hide_cursor=true
        no_fade_in=false
      }

      input-field {
        monitor=
        size=200, 50
        dots_center=true
        fade_on_empty=false
        font_color=rgba(f1f2f8ff)
        inner_color=rgba(b5897aff)
        outer_color=rgba(1c1b1bff)
        outline_thickness=5
        placeholder_text=Password...
        position=0, -80
        shadow_passes=2
      }

      label {
        monitor=
        font_color=rgba(f1f2f8ff)
        font_family=Noto Sans
        font_size=25
        halign=center
        position=0, 160
        rotate=0
        text=$TIME
        text_align=center
        valign=center
      }

      label {
        monitor=
        font_color=rgba(f1f2f8ff)
        font_family=Noto Sans
        font_size=25
        halign=center
        position=0, 80
        rotate=0
        text=Hi, $USER
        text_align=center
        valign=center
      }

      label {
        monitor=
        font_color=rgba(f1f2f8ff)
        font_family=Noto Sans
        font_size=40
        halign=center
        position=0, 4
        rotate=0
        text=🐘
        text_align=center
        valign=center
      }
    '';
  };
}
