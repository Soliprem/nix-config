{
  pkgs,
  inputs,
  lib,
  ...
}: let
  workspaceBinds = builtins.concatLists (
    builtins.genList (
      x: let
        ws = toString (x + 1);
        key =
          if x == 9
          then "0"
          else toString (x + 1);
      in [
        "bind = $mod, ${key}, split:workspace, ${ws}"
        "bind = $mod+SHIFT, ${key}, split:movetoworkspacesilent, ${ws}"
        "bind = $mod+Alt, ${key}, focusworkspaceoncurrentmonitor, ${ws}"
        "bind = $mod+Alt+SHIFT, ${key}, split:movetoworkspace, ${ws}"
      ]
    )
    10
  );
  src = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in {
  files = {
    ".config/hypr/stubs".source = "${src.hyprland}/share/hypr/stubs";
    ".config/hypr/hyprland".source = ./hyprland;

    ".config/hypr/.luarc.json" = {
      generator = lib.generators.toJSON {};

      value = {
        "runtime.version" = "Lua 5.5";
        "workspace.checkThirdParty" = false;
        "diagnostics.globals" = ["hl"];
        "workspace.library" = ["./stubs"];
      };
    };
    ".config/hypr/hyprland.conf".text =
      /*
      lua
      */
      ''
        local config_home = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
        package.path = config_home .. "/hypr/hyprland/?.lua;" .. package.path

        require("vars")
        require("helpers")
        require("env")
        require("monitors")
        require("autostart")
        require("options")
        require("animations")
        require("rules")
        require("binds")
        require("gestures")
        require("colors")
      '';
    ".config/hypr/hypridle.conf".text =
      /*
      hyprlang
      */
      ''
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
    ".config/hypr/hyprlock.conf".text =
      /*
      hyprlang
      */
      ''
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
