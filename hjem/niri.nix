_: {
  files = {
    ".config/niri/config.kdl".text = ''
      include "colors.kdl"
      input {
          keyboard {
              xkb {
                  layout "eu,it"
                  options "grp:alt_space_toggle"
              }
          }

          touchpad {
              tap
              natural-scroll
          }

          workspace-auto-back-and-forth
      }

      output "HDMI-A-1" {
        mode "1920x1080@120"
        position x=2560 y=0
      }

      output "PNP(AOC) Q27G3XMN 1APQ7JA005710" {
        focus-at-startup
        mode "2560x1440@180.002"
        position x=0 y=0
      }

      layout {
          gaps 16
          center-focused-column "never"
          preset-column-widths {
              proportion 0.33333
              proportion 0.5
              proportion 0.66667
          }
          default-column-width { proportion 0.5; }
          struts {
              // left 64
              // right 64
              // top 64
              // bottom 64
          }
      }

      environment {
          DISPLAY ":0"
      }

      spawn-at-startup "wl-paste --watch cliphist store"
      spawn-at-startup "xwayland-satellite"
      spawn-at-startup "swww-daemon"
      spawn-at-startup "batsignal"
      spawn-at-startup "darkman run"
      spawn-at-startup "swaync"
      spawn-at-startup "nm-applet"
      spawn-at-startup "kanshi"
      spawn-at-startup "protonvpn-app"
      spawn-at-startup "swayosd-server"

      prefer-no-csd

      screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

      animations {
          // Uncomment to turn off all animations.
          // off

          // Slow down all animations by this factor. Values below 1 speed them up instead.
          // slowdown 3.0
      }

      window-rule {
          // This regular expression is intentionally made as specific as possible,
          // since this is the default config, and we want no false positives.
          // You can get away with just app-id="wezterm" if you want.
          match app-id=r#"^org\.wezfurlong\.wezterm$"#
          default-column-width {}
      }
      window-rule {
          match app-id="protonvpn-app"
          open-floating true
      }
      window-rule {
          match app-id="zen$" title=r#"^(Picture-in-Picture|YouTube|Invidious|zen — Sharing Indicator|Enter name of file to save to…|Save)(.*)$"#
          match app-id="eu.soliprem.thumbpick$"
          open-floating true
      }

      // Example: block out two password managers from screen capture.
      // (This example rule is commented out with a "/-" in front.)
      /-window-rule {
          match app-id=r#"^org\.keepassxc\.KeePassXC$"#
          match app-id=r#"^org\.gnome\.World\.Secrets$"#

          block-out-from "screen-capture"

          // Use this instead if you want them visible on third-party screenshot tools.
          // block-out-from "screencast"
      }

      // Example: enable rounded corners for all windows.
      // (This example rule is commented out with a "/-" in front.)
      /-window-rule {
          geometry-corner-radius 12
          clip-to-geometry true
      }

      binds {
          // NOTE: using keynames as found in wev

          Mod+Shift+Slash { show-hotkey-overlay; }

          Mod+Control+T { spawn "ghostty" "-e" "tray-tui"; }
          Mod+Return { spawn "ghostty"; }
          Mod+Minus { spawn "wtype" "-k" "emdash"; }
          Mod+W { spawn "zen"; }
          Mod+E { spawn "nautilus"; }
          Mod+Shift+B { spawn "overskride"; }
          Mod+D { spawn "bash" "-c" "$(tofi-run)"; }
          Mod+Shift+D { spawn "bash" "-c" "$(tofi-drun)"; }
          Super+Alt+L { spawn "swaylock"; }
          Super+Shift+C { spawn "swaync-client" "-t"; }
          Super+V {spawn "clipmenu"; }
          Mod+T     { spawn "notify-time"; }
          Mod+Control+W     { spawn "ghostty" "-e" "wiki-tui"; }
          Mod+B     { spawn "notify-battery"; }

          XF86AudioRaiseVolume allow-when-locked=true { spawn "swayosd-client" "--output-volume" "raise"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn "swayosd-client" "--output-volume" "lower"; }
          XF86AudioMute        allow-when-locked=true { spawn "swayosd-client" "--output-volume" "mute-toggle"; }
          XF86AudioMicMute     allow-when-locked=true { spawn "swayosd-client" "--output-volume" "mute-toggle"; }
          XF86MonBrightnessUp allow-when-locked=true { spawn "swayosd-client" "--brightness" "raise"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn "swayosd-client" "--brightness" "raise"; }
          Caps_Lock { spawn "sleep" "0.1" "&&" "swayosd-client" "--caps-lock"; }

          Mod+Q { close-window; }
          Mod+Shift+Space { toggle-window-floating; }
          Mod+Control+Space { switch-focus-between-floating-and-tiling; }

          Mod+H     { focus-column-left; }
          Mod+J     { focus-window-down; }
          Mod+K     { focus-window-up; }
          Mod+L     { focus-column-right; }

          Mod+Shift+T     { toggle-column-tabbed-display; }

          Mod+Ctrl+H     { move-column-left; }
          Mod+Ctrl+J     { move-window-down; }
          Mod+Ctrl+K     { move-window-up; }
          Mod+Ctrl+L     { move-column-right; }

          Mod+Home { focus-column-first; }
          Mod+End  { focus-column-last; }
          Mod+Ctrl+Home { move-column-to-first; }
          Mod+Ctrl+End  { move-column-to-last; }

          Mod+Shift+Comma  { focus-monitor-previous; }
          Mod+Shift+Period { focus-monitor-next; }
          Mod+Shift+H     { focus-monitor-left; }
          Mod+Shift+J     { focus-monitor-down; }
          Mod+Shift+K     { focus-monitor-up; }
          Mod+Shift+L     { focus-monitor-right; }

          Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
          Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
          Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

          // Alternatively, there are commands to move just a single window:
          // Mod+Shift+Ctrl+Left  { move-window-to-monitor-left; }
          // ...

          // And you can also move a whole workspace to another monitor:
          // Mod+Shift+Ctrl+Left  { move-workspace-to-monitor-left; }
          // ...

          Mod+Page_Down      { focus-workspace-down; }
          Mod+Page_Up        { focus-workspace-up; }
          Mod+U              { focus-workspace-down; }
          Mod+I              { focus-workspace-up; }
          Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
          Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
          Mod+Ctrl+U         { move-column-to-workspace-down; }
          Mod+Ctrl+I         { move-column-to-workspace-up; }

          // Alternatively, there are commands to move just a single window:
          // Mod+Ctrl+Page_Down { move-window-to-workspace-down; }
          // ...

          Mod+Shift+Page_Down { move-workspace-down; }
          Mod+Shift+Page_Up   { move-workspace-up; }
          Mod+Shift+U         { move-workspace-down; }
          Mod+Shift+I         { move-workspace-up; }

          Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
          Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
          Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
          Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

          Mod+WheelScrollRight      { focus-column-right; }
          Mod+WheelScrollLeft       { focus-column-left; }
          Mod+Ctrl+WheelScrollRight { move-column-right; }
          Mod+Ctrl+WheelScrollLeft  { move-column-left; }

          Mod+Shift+WheelScrollDown      { focus-column-right; }
          Mod+Shift+WheelScrollUp        { focus-column-left; }
          Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
          Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }


          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }

          Mod+Shift+1 { move-window-to-workspace 1; }
          Mod+Shift+2 { move-window-to-workspace 2; }
          Mod+Shift+3 { move-window-to-workspace 3; }
          Mod+Shift+4 { move-window-to-workspace 4; }
          Mod+Shift+5 { move-window-to-workspace 5; }
          Mod+Shift+6 { move-window-to-workspace 6; }
          Mod+Shift+7 { move-window-to-workspace 7; }
          Mod+Shift+8 { move-window-to-workspace 8; }
          Mod+Shift+9 { move-window-to-workspace 9; }

          Mod+Ctrl+1 { move-column-to-workspace 1; }
          Mod+Ctrl+2 { move-column-to-workspace 2; }
          Mod+Ctrl+3 { move-column-to-workspace 3; }
          Mod+Ctrl+4 { move-column-to-workspace 4; }
          Mod+Ctrl+5 { move-column-to-workspace 5; }
          Mod+Ctrl+6 { move-column-to-workspace 6; }
          Mod+Ctrl+7 { move-column-to-workspace 7; }
          Mod+Ctrl+8 { move-column-to-workspace 8; }
          Mod+Ctrl+9 { move-column-to-workspace 9; }

          Mod+Tab { focus-workspace-previous; }

          Mod+Comma  { consume-or-expel-window-left; }
          Mod+Period  { consume-or-expel-window-right; }
          Mod+BracketLeft  { consume-or-expel-window-left; }
          Mod+BracketRight { consume-or-expel-window-right; }

          Mod+R { switch-preset-column-width; }
          Mod+Shift+R { switch-preset-window-height; }
          Mod+Ctrl+R { reset-window-height; }
          Mod+F { maximize-column; }
          Mod+Shift+F { fullscreen-window; }
          Mod+C { center-column; }
          Mod+G { toggle-overview; }

          Mod+Ctrl+Minus { set-column-width "-10%"; }
          Mod+Ctrl+Equal { set-column-width "+10%"; }

          Mod+Shift+Minus { set-window-height "-10%"; }
          Mod+Shift+Equal { set-window-height "+10%"; }

          // Actions to switch layouts.
          // Note: if you uncomment these, make sure you do NOT have
          // a matching layout switch hotkey configured in xkb options above.
          // Having both at once on the same hotkey will break the switching,
          // since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
          // Mod+Space       { switch-layout "next"; }
          // Mod+Shift+Space { switch-layout "prev"; }

          Mod+P { screenshot; }
          Mod+Shift+P { screenshot-screen; }
          Mod+Alt+P { screenshot-window; }

          Mod+Shift+E { quit; }
          Ctrl+Alt+Delete { quit; }

          Mod+Ctrl+Shift+P { power-off-monitors; }
      }

    '';
  };
}
