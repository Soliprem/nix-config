_: let
  batteryCommand =
    "sh -c 'for f in /sys/class/power_supply/BAT*/capacity /sys/class/power_supply/*/capacity; do [ -r $f ] || continue; xargs printf 0.%s < $f; exit; done; printf 0'";

  mkBacklightSlider = {
    edge,
    monitor,
  }: ''
      slider {
        pinnable
        pin-with-key
        ignore-exclusive
        edge "${edge}"
        position "top"
        monitor ${monitor}
        layer "overlay"
        margins {
          top "20%"
        }
        thickness 40
        length "25%"
        fg-color "#85C9E8cc"
        bg-color "#0000"
        border-color "#85C9E8ff"
        fg-text-color "#fffa"
        bg-text-color "#fffa"
        radius 10
        obtuse-angle 90
        preset "backlight"
      }
  '';

  mkWorkspace = {
    edge,
    monitor,
  }: ''
      workspace {
        ignore-exclusive
        edge "${edge}"
        position "bottom"
        layer "overlay"
        monitor ${monitor}
        thickness 40
        length "50%"
        hover-color "#4E884Faa"
        active-increase 0.2
        focus-color "#4E884F"
        default-color "#000"
        focused-only
        preset "hyprland"

        // Niri fallback:
        // preset "niri" {
        //   preserve-empty
        // }
      }
  '';

  mkBatterySlider = {
    position,
    monitor,
    marginSide,
    marginValue,
  }: ''
      slider {
        pinnable
        pin-with-key
        ignore-exclusive
        edge "right"
        position "${position}"
        monitor ${monitor}
        layer "overlay"
        margins {
          ${marginSide} "${marginValue}"
        }
        thickness 10
        border-width 1
        length "12.5%"
        fg-color "#FF8700cc"
        bg-color "#0000"
        border-color "#FF8700"
        fg-text-color "#0000"
        bg-text-color "#0000"
        redraw-only-on-internal-update
        pin-on-startup
        preset "custom" {
          update-interval 1000
          update-command "${batteryCommand}"
        }
      }
  '';

  ringItem = {
    prefix,
    preset,
    fgColor ? null,
  }: ''
        item "ring" {
          font-size 20
          font-family "JetBrainsMono Nerd Font"
          ${if fgColor != null then ''fg-color "${fgColor}"'' else ""}
          bg-color "#00000044"
          prefix "${prefix}"
          suffix " {preset}"
          suffix-hide
          preset "${preset}" {
            update-interval 500
          }
        }
  '';

  trayItem = ''
        item "tray" {
          font-family "sans-serif"
          icon-size 40
          header-menu-stack "menu-top"
          header-menu-align "left"
          menu-draw-config {
            font-pixel-height 18
            text-color "#eee"
            border-color "#111"
          }
          header-draw-config {
            text-color "#eee"
          }
          grid-align "bottom-left"
        }
  '';

  mkTrayWrapBox = {
    position,
    monitor,
  }: ''
      wrap-box {
        namespace "tray"
        pin-with-key
        pinnable
        ignore-exclusive
        edge "bottom"
        position "${position}"
        monitor ${monitor}
        layer "overlay"
        align "bottom-left"
        outlook "window" {
          color "#0C986C"
        }
${trayItem}      }
  '';
in {
  files = {
    ".config/way-edges/config.kdl".text = ''
${mkBacklightSlider {
  edge = "left";
  monitor = "\"eDP-1\" \"eDP-2\"";
}}
${mkBacklightSlider {
  edge = "right";
  monitor = "\"HDMI-A-1\"";
}}
      btn {
        ignore-exclusive
        edge "top"
        position "left"
        monitor "*"
        layer "overlay"
        margins {
          left "25%"
        }
        thickness 20
        length "25%"
        color "#333"
        event-map {
          mouse-left "hyprctl dispatch layoutmsg focus l"
          mouse-right "hyprctl dispatch layoutmsg cycleprev"

          // Niri fallback:
          // mouse-left "niri msg action focus-column-left"
          // mouse-right "niri msg action focus-workspace-up"
        }
      }
      btn {
        ignore-exclusive
        edge "top"
        position "right"
        monitor "*"
        layer "overlay"
        margins {
          right "25%"
        }
        thickness 20
        length "25%"
        color "#333"
        event-map {
          mouse-left "hyprctl dispatch layoutmsg focus r"
          mouse-right "hyprctl dispatch layoutmsg cyclenext"

          // Niri fallback:
          // mouse-left "niri msg action focus-column-right"
          // mouse-right "niri msg action focus-workspace-down"
        }
      }
      btn {
        ignore-exclusive
        edge "bottom"
        monitor "*"
        layer "overlay"
        thickness 20
        length "40%"
        event-map {
          mouse-left "sh -c pkill nwg-drawer || nwg-drawer -ovl --closebtn left"
          mouse-right "hyprctl dispatch layoutmsg promote"
          mouse-middle "hyprctl dispatch killactive"
          mouse-side "hyprctl dispatch togglespecialworkspace"
          mouse-extra "hyprctl dispatch fullscreenstate -1 2"

          // Niri fallback:
          // mouse-right "niri msg action maximize-column"
          // mouse-middle "niri msg action close-window"
          // mouse-side "niri msg action toggle-overview"
          // mouse-extra "niri msg action toggle-column-tabbed-display"
        }
      }
${mkWorkspace {
  edge = "left";
  monitor = "\"eDP-1\" \"eDP-2\"";
}}
${mkWorkspace {
  edge = "right";
  monitor = "\"HDMI-A-1\"";
}}
      wrap-box {
        namespace "stats"
        edge "left"
        position "top"
        monitor "*"
        layer "overlay"
        margins {
          top 40
        }
        outlook "window" {
          color "#5d3f3c"
        }
${ringItem {
  prefix = " ";
  preset = "disk";
  fgColor = "#82B2E3";
}}
        // The upstream battery ring preset panics on hosts without a real battery.
        // Re-enable on laptop-only configs if that unwrap is fixed upstream:
        // item "ring" {
        //   font-size 20
        //   font-family "JetBrainsMono Nerd Font"
        //   fg-color "#FFB77B"
        //   bg-color "#00000044"
        //   prefix " "
        //   suffix " {preset}"
        //   suffix-hide
        //   preset "battery" {
        //     update-interval 500
        //   }
        // }
${ringItem {
  prefix = " ";
  preset = "cpu";
  fgColor = "#FB8893";
}}
${ringItem {
  prefix = "󰾶 ";
  preset = "swap";
  fgColor = "#BEAFD9";
}}
${ringItem {
  prefix = " ";
  preset = "ram";
}}
      }
      wrap-box {
        namespace "time"
        pin-with-key
        pinnable
        ignore-exclusive
        edge "top"
        position "right"
        monitor "*"
        layer "overlay"
        outlook "window" {
          color "#222"
          margins {
            top 10
            left 30
            right 30
            bottom 10
          }
        }
        item "text" {
          fg-color "#FFFFFF"
          font-size 30
          font-family "serif"
          preset "time" {
            update-interval 500
            format "%v %T %A"
          }
        }
      }
${mkBatterySlider {
  position = "bottom";
  monitor = "\"eDP-1\" \"eDP-2\"";
  marginSide = "bottom";
  marginValue = "2%";
}}
${mkBatterySlider {
  position = "top";
  monitor = "\"HDMI-A-1\"";
  marginSide = "top";
  marginValue = "5%";
}}
      slider {
        pinnable
        pin-with-key
        ignore-exclusive
        edge "top"
        monitor "*"
        layer "overlay"
        position "left"
        preview-size 9
        thickness 40
        border-width 3
        length "12.5%"
        radius 10
        obtuse-angle 90
        fg-color "#18A558cc"
        bg-color "#0000"
        border-color "#18A558"
        fg-text-color "#fffa"
        bg-text-color "#fffa"
        redraw-only-on-internal-update
        preset "speaker"
      }
      slider {
        pinnable
        pin-with-key
        ignore-exclusive
        edge "top"
        monitor "*"
        layer "overlay"
        position "left"
        margins {
          left "12.5%"
        }
        preview-size 9
        thickness 40
        border-width 3
        length "12.5%"
        radius 10
        obtuse-angle 90
        fg-color "#BD93F9cc"
        bg-color "#0000"
        border-color "#BD93F9"
        fg-text-color "#fffa"
        bg-text-color "#fffa"
        redraw-only-on-internal-update
        preset "microphone"
      }
${mkTrayWrapBox {
  position = "left";
  monitor = "\"HDMI-A-1\"";
}}
${mkTrayWrapBox {
  position = "right";
  monitor = "\"eDP-1\" \"eDP-2\"";
}}
    '';
  };
}
