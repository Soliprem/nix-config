_: {
  hjem.users.soliprem.files = {
    ".config/hypr/hypridle.conf".text = ''
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
