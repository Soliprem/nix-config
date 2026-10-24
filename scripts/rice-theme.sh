export XDG_DATA_DIRS="$NIXRICE_GSETTINGS_SCHEMA_PATH${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/nixrice"

apply_app_theme() {
  style="$1"
  profile_dir="$HOME/.config/nixrice/themes/$style"
  theme_dir="$state_dir/app-theme"
  kvantum_config="$HOME/.config/Kvantum/kvantum.kvconfig"
  kvantum_saved="$theme_dir/kvantum.kvconfig.material"
  kvantum_saved_marker="$theme_dir/kvantum-config-saved"
  mkdir -p "$theme_dir" "$HOME/.config/Kvantum"

  for version in 3.0 4.0; do
    ln -sfn "$profile_dir/gtk-settings.ini" "$HOME/.config/gtk-$version/settings.ini"
    ln -sfn "$profile_dir/gtk.css" "$HOME/.config/gtk-$version/rice.css"
  done

  if [ "$style" = cyberpunk ]; then
    for key in icon-theme cursor-theme color-scheme; do
      saved="$theme_dir/gsettings-$key"
      if [ ! -s "$saved" ]; then
        gsettings get org.gnome.desktop.interface "$key" > "$saved"
      fi
    done

    if [ ! -e "$kvantum_saved_marker" ]; then
      if [ -e "$kvantum_config" ] || [ -L "$kvantum_config" ]; then
        cp -a "$kvantum_config" "$kvantum_saved"
      fi
      touch "$kvantum_saved_marker"
    fi
    ln -sfn "$profile_dir/kvantum.kvconfig" "$kvantum_config"

    gsettings set org.gnome.desktop.interface icon-theme CyberArch
    gsettings set org.gnome.desktop.interface cursor-theme CyberArch-cursors
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark

    unset GTK_THEME
    systemctl --user unset-environment GTK_THEME
    export XCURSOR_THEME=CyberArch-cursors XCURSOR_SIZE=48
    export QT_STYLE_OVERRIDE=kvantum
    systemctl --user set-environment \
      XCURSOR_THEME=CyberArch-cursors XCURSOR_SIZE=48 \
      QT_STYLE_OVERRIDE=kvantum
    if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
      hyprctl eval '
        hl.env("GTK_THEME", "")
        hl.env("HYPRCURSOR_THEME", "")
        hl.env("HYPRCURSOR_SIZE", "")
        hl.env("XCURSOR_THEME", "CyberArch-cursors")
        hl.env("XCURSOR_SIZE", "48")
        hl.env("QT_STYLE_OVERRIDE", "kvantum")
      ' >/dev/null || true
      hyprctl setcursor CyberArch-cursors 48 >/dev/null || true
    fi
  else
    if [ -L "$kvantum_config" ] \
      && [ "$(readlink "$kvantum_config")" = "$HOME/.config/nixrice/themes/cyberpunk/kvantum.kvconfig" ]; then
      rm "$kvantum_config"
    fi
    if [ -e "$kvantum_saved" ] || [ -L "$kvantum_saved" ]; then
      mv "$kvantum_saved" "$kvantum_config"
    fi
    rm -f "$kvantum_saved_marker"

    for key in icon-theme cursor-theme color-scheme; do
      saved="$theme_dir/gsettings-$key"
      if [ -s "$saved" ]; then
        gsettings set org.gnome.desktop.interface "$key" "$(cat "$saved")"
      fi
    done

    unset GTK_THEME XCURSOR_THEME XCURSOR_SIZE QT_STYLE_OVERRIDE
    systemctl --user unset-environment \
      GTK_THEME XCURSOR_THEME XCURSOR_SIZE QT_STYLE_OVERRIDE
    if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
      hyprctl eval '
        hl.env("GTK_THEME", "")
        hl.env("XCURSOR_THEME", "")
        hl.env("XCURSOR_SIZE", "24")
        hl.env("HYPRCURSOR_THEME", "Hypr-Bibata-Modern-Ice")
        hl.env("HYPRCURSOR_SIZE", "24")
        hl.env("QT_STYLE_OVERRIDE", "")
      ' >/dev/null || true
      hyprctl setcursor Hypr-Bibata-Modern-Ice 24 >/dev/null || true
    fi

    rm -f \
      "$theme_dir/gsettings-gtk-theme" \
      "$theme_dir/gsettings-icon-theme" \
      "$theme_dir/gsettings-cursor-theme" \
      "$theme_dir/gsettings-color-scheme"
  fi
}

apply_app_theme "${1:?usage: rice-theme material|cyberpunk}"
