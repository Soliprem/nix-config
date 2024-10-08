{pkgs, ...}: {
  home.packages = with pkgs; [
    wlr-randr
  ];
  wayland.windowManager.river = {
    enable = true;
    settings = {
      attach-mode = "bottom";
      set-cursor-warp = "on-output-change";
      declare-mode = [
        "passthrough"
        "normal"
        "locked"
      ];
      map = {
        normal = {
          "Super Return" = ''spawn foot'';
          "Super Period" = ''focus-output next'';
          "Super Comma" = ''focus-output previous'';
          "Super+Shift Period" = ''send-to-output next'';
          "Super+Shift Comma" = ''send-to-output previous'';
          "Super Q" = ''close'';
          "Super d" = ''spawn walker'';
          "Super w" = ''spawn zen'';
          "Super J" = ''focus-view next'';
          "Super K" = ''focus-view previous'';
          "Super+Shift E" = ''exit'';
          "Super+Shift J" = ''swap next'';
          "Super+Shift K" = ''swap previous'';
          "Super Space" = ''zoom'';
          "Super+Alt H" = ''move left 100'';
          "Super+Alt J" = ''move down 100'';
          "Super+Alt K" = ''move up 100'';
          "Super+Alt L" = ''move right 100'';
          "Super+Alt+Control H" = ''snap left'';
          "Super+Alt+Control J" = ''snap down'';
          "Super+Alt+Control K" = ''snap up'';
          "Super+Alt+Control L" = ''snap right'';
          "Super+Alt+Shift H" = ''resize horizontal -100'';
          "Super+Alt+Shift J" = ''resize vertical 100'';
          "Super+Alt+Shift K" = ''resize vertical -100'';
          "Super+Alt+Shift L" = ''resize horizontal 100'';
          "Super H" = ''send-layout-cmd rivertile "main-ratio -0.05"'';
          "Super L" = ''send-layout-cmd rivertile "main-ratio +0.05"'';
          "Super+Shift H" = ''send-layout-cmd rivertile "main-count +1"'';
          "Super+Shift L" = ''send-layout-cmd rivertile "main-count -1"'';
          "Super o" = ''spawn dm-hub'';
          "Super n" = ''spawn dm-notes'';
          "Super e" = ''spawn walker -m emojis'';
          "Super+Shift o" = ''spawn dm-documents'';
          "Super 0" = ''set-focused-tags $all_tags'';
          "Super+Shift 0" = ''set-view-tags $all_tags'';
          "Super+Shift Space" = ''toggle-float'';
          "Super F" = ''toggle-fullscreen'';
          "Super Up" = ''send-layout-cmd rivertile "main-location top"'';
          "Super Right" = ''send-layout-cmd rivertile "main-location right"'';
          "Super Down" = ''send-layout-cmd rivertile "main-location bottom"'';
          "Super Left" = ''send-layout-cmd rivertile "main-location left"'';
          "Super F11" = ''enter-mode passthrough'';
          "None XF86Eject" = ''spawn "eject -T"'';
          "None XF86AudioRaiseVolume " = ''spawn "pamixer -i 5 && notify-volume"'';
          "None XF86AudioLowerVolume " = ''spawn "pamixer -d 5 && notify-volume"'';
          "None XF86AudioMute        " = ''spawn "pamixer --toggle-mute && notify-volume"'';
          "None XF86AudioMedia" = ''spawn "playerctl play-pause"'';
          "None XF86AudioPlay " = ''spawn "playerctl play-pause"'';
          "None XF86AudioPrev " = ''spawn "playerctl previous"'';
          "None XF86AudioNext " = ''spawn "playerctl next"'';
          "None XF86MonBrightnessUp  " = ''spawn "brightnessctl set +5% && notify-brightness"'';
          "None XF86MonBrightnessDown" = ''spawn "brightnessctl set 5%- && notify-brightness"'';
        };
        locked = {
          "None XF86Eject" = ''spawn "eject -T"'';
          "None XF86AudioRaiseVolume " = ''spawn "pamixer -i 5 && notify-volume"'';
          "None XF86AudioLowerVolume " = ''spawn "pamixer -d 5 && notify-volume"'';
          "None XF86AudioMute        " = ''spawn "pamixer --toggle-mute && notify-volume"'';
          "None XF86AudioMedia" = ''spawn "playerctl play-pause"'';
          "None XF86AudioPlay " = ''spawn "playerctl play-pause"'';
          "None XF86AudioPrev " = ''spawn "playerctl previous"'';
          "None XF86AudioNext " = ''spawn "playerctl next"'';
          "None XF86MonBrightnessUp  " = ''spawn "brightnessctl set +5% && notify-brightness"'';
          "None XF86MonBrightnessDown" = ''spawn "brightnessctl set 5%- && notify-brightness"'';
        };
        passthrough = {
          "Super F11" = ''enter-mode normal'';
        };
      };
      map-pointer = {
        normal = {
          "Super BTN_LEFT" = ''move-view'';
          "Super BTN_RIGHT" = ''resize-view'';
          "Super BTN_MIDDLE" = ''toggle-float'';
        };
      };
    };
    xwayland.enable = true;
    extraConfig = ''

      for i in $(seq 1 9)
      do
          tags=$((1 << ($i - 1)))

          # Super+[1-9] to focus tag [0-8]
          riverctl map normal Super $i set-focused-tags $tags

          # Super+Shift+[1-9] to tag focused view with tag [0-8]
          riverctl map normal Super+Shift $i set-view-tags $tags

          # Super+Control+[1-9] to toggle focus of tag [0-8]
          riverctl map normal Super+Control $i toggle-focused-tags $tags

          # Super+Shift+Control+[1-9] to toggle tag [0-8] of focused view
          riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
      done
      all_tags=$(((1 << 32) - 1))


      # Set background and border color
      riverctl background-color 0x002b36
      riverctl border-color-focused 0x93a1a1
      riverctl border-color-unfocused 0x586e75


      ## Autostart
      riverctl spawn "wl-paste --type text --watch cliphist store &"
      riverctl spawn "wl-paste --type image --watch cliphist store &"
      riverctl spawn "walker --gapplication-service"
      riverctl spawn "wlr-randr --output HDMI-A-1 --mode 1920x1080@120Hz"
      # Set and exec into the default layout generator, rivertile.
      # River will send the process group of the init executable SIGTERM on exit.
      riverctl default-layout rivertile
      # bash "$HOME"/.config/river/process.sh
      # usage: import-gsettings

      # Make all views with an app-id that starts with "float" and title "foo" start floating.
      riverctl rule-add -app-id 'Julia*' -title 'Julia' float
      riverctl rule-add -app-id 'zen*' -title '*Picture-in-Picture*' float
      riverctl rule-add -app-id 'zen*' -title 'Open File*' float
      riverctl rule-add -app-id 'zen*' -title 'Select a File*' float
      riverctl rule-add -app-id 'yad*' -title 'Choose wallpaper*' float
      riverctl rule-add -app-id 'zen*' -title 'Open Folder*' float
      riverctl rule-add -app-id 'zen*' -title 'Save As*' float
      riverctl rule-add -app-id 'zen*' -title 'Library*' float

      # Make all views with app-id "bar" and any title use client-side decorations
      # riverctl rule-add -app-id "bar" csd

      # Set the default layout generator to be rivertile and start it.
      # River will send the process group of the init executable SIGTERM on exit.
      riverctl default-layout rivertile
      rivertile -view-padding 6 -outer-padding 6 &
    '';
  };
}
