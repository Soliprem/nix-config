{pkgs, ...}: {
  services.gnome.gnome-keyring.enable = true;
  home.packages = with pkgs; [
    wlr-randr
  ];
  imports = [
    ./mako.nix
    ./kanshi.nix
  ];
  wayland.windowManager.river = {
    enable = true;
    settings = {
      attach-mode = "bottom";
      keyboard-layout = "eu";
      set-cursor-warp = "on-output-change";
      declare-mode = [
        "passthrough"
        "normal"
        "locked"
      ];
      map = {
        normal = {
          "Super Return" = ''spawn foot'';
          "Super colon" = ''spawn dm-expand'';
          "Super minus" = ''spawn 'wtype -k emdash' '';
          "Super Tab" = ''focus-previous-tags'';
          "Super T" = ''spawn notify-time'';
          "Super B" = ''spawn notify-battery'';
          "Super Period" = ''focus-output next'';
          "Super V" = ''spawn 'pkill fuzzel || cliphist list | fuzzel --dmenu | cliphist decode | wl-copy' '';
          "Super Comma" = ''focus-output previous'';
          "Super+Shift Period" = ''send-to-output next'';
          "Super+Shift Comma" = ''send-to-output previous'';
          "Super+Shift S" = ''spawn wayshotpick'';
          "Super Q" = ''close'';
          "Super d" = ''spawn fuzzel'';
          "Super+Shift d" = ''spawn fuzzel-run'';
          "Super w" = ''spawn qutebrowser'';
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
          "Super+Shift n" = ''spawn 'cd ~/Documents/Nextcloud/Notes/; foot nvim -c Oil' '';
          "Super+Shift e" = ''spawn dm-special'';
          "Super e" = ''spawn nautilus'';
          "Super+Shift o" = ''spawn dm-documents'';
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
      rule-add = {
        "-app-id" = {
          "'Julia*'"."-title"."'Julia'" = "float";
          "'zen*'" = {
            "-title" = {
              "'*Picture-in-Picture*'" = "float";
              "'Open File*'" = "float";
              "'Select a File*'" = "float";
              "'Open Folder*'" = "float";
              "'Save As*'" = "float";
              "'Library*'" = "float";
            };
          };
          "'yad*'"."-title"."'Choose wallpaper*'" = "float";
          # Make sure all apps display borders correctly by enforcing ssd
          "'*'" = "ssd";

          # Make all views with app-id "bar" and any title use client-side decorations
          # riverctl rule-add -app-id "bar" csd
        };
      };
      spawn = [
        ## Autostart
        "'wl-paste --type text --watch cliphist store &'"
        "'wl-paste --type image --watch cliphist store &'"
        "swww-daemon"
        "kanshi"
      ];
    };
    xwayland.enable = true;
    extraConfig = ''
      # Setting up scratchpads and sticky tags
      all_tags=$(((1 << 32) - 1))

      scratch_tag=$((1 << 20))
      all_but_scratch_tag=$(( $all_tags ^ $scratch_tag))
      riverctl spawn-tagmask $all_but_scratch_tag
      riverctl map normal Super P toggle-focused-tags $scratch_tag
      riverctl map normal Super+Shift P set-view-tags $scratch_tag

      sticky_tag=$((1 << 31))
      all_but_sticky_tag=$(( $all_but_scratch_tag ^ $sticky_tag ))
      riverctl spawn-tagmask $all_but_sticky_tag
      riverctl map normal Super S toggle-view-tags $sticky_tag;


      riverctl map normal Super 0 set-focused-tags $all_tags
      riverctl map normal Super+Shift 0 set-view-tags $all_tags

      riverctl input '*ouchpad' tap enabled
      riverctl input '*ouchpad' tap-button-map left-right-middle
      riverctl input '*ouchpad' natural-scroll enabled

      for i in $(seq 1 9)
      do
          tags=$((1 << ($i - 1)))

          # Super+[1-9] to focus tag [0-8]
          riverctl map normal Super $i set-focused-tags $(($sticky_tag + $tags))

          # Super+Shift+[1-9] to tag focused view with tag [0-8]
          riverctl map normal Super+Shift $i set-view-tags $tags

          # Super+Control+[1-9] to toggle focus of tag [0-8]
          riverctl map normal Super+Control $i toggle-focused-tags $tags

          # Super+Shift+Control+[1-9] to toggle tag [0-8] of focused view
          riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
      done

      # modify the normal keybind to always select the sticky tag

      # Set background and border color
      riverctl background-color 0x002b36
      riverctl border-color-focused 0x93a1a1
      riverctl border-color-unfocused 0x586e75


      # Set and exec into the default layout generator, rivertile.
      # River will send the process group of the init executable SIGTERM on exit.
      riverctl default-layout rivertile
      # bash "$HOME"/.config/river/process.sh
      # usage: import-gsettings

      # Make all views with an app-id that starts with "float" and title "foo" start floating.

      # Set the default layout generator to be rivertile and start it.
      # River will send the process group of the init executable SIGTERM on exit.
      riverctl default-layout rivertile
      rivertile -view-padding 6 -outer-padding 6 &
    '';
  };
}
