{config, ...}: let
  inherit (config.lib.stylix) colors;
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 300;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgba(${colors.base07}ff)";
          inner_color = "rgba(${colors.base09}ff)";
          outer_color = "rgba(${colors.base00}ff)";
          outline_thickness = 5;
          placeholder_text = ''Password...'';
          shadow_passes = 2;
        }
      ];
      label = [
        {
          position = "0, 160";
          monitor = "";
          text = "$TIME";
          text_align = "center"; # center/right or any value for default left. multi-line text alignment inside label container
          font_color = "rgba(${colors.base07}ff)";
          font_size = "25";
          font_family = "Noto Sans";
          rotate = "0"; # degrees, counter-clockwise

          halign = "center";
          valign = "center";
        }
        {
          position = "0, 80";
          monitor = "";
          text = "Hi, $USER";
          text_align = "center"; # center/right or any value for default left. multi-line text alignment inside label container
          font_color = "rgba(${colors.base07}ff)";
          font_size = "25";
          font_family = "Noto Sans";
          rotate = "0"; # degrees, counter-clockwise

          halign = "center";
          valign = "center";
        }
        {
          position = "0, 4";
          monitor = "";
          text = "🐘";
          text_align = "center"; # center/right or any value for default left. multi-line text alignment inside label container
          font_color = "rgba(${colors.base07}ff)";
          font_size = "40";
          font_family = "Noto Sans";
          rotate = "0"; # degrees, counter-clockwise

          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
