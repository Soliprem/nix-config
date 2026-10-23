export XDG_DATA_DIRS=$NIXRICE_GSETTINGS_SCHEMA_PATH:$XDG_DATA_DIRS
mode="${1:-toggle}"

case "$mode" in
  dark)
    next_mode="dark"
    color_scheme="prefer-dark"
    ;;
  light)
    next_mode="light"
    color_scheme="prefer-light"
    ;;
  toggle)
    current_scheme="$(gsettings get org.gnome.desktop.interface color-scheme)"
    current_scheme="${current_scheme#\'}"
    current_scheme="${current_scheme%\'}"

    if [ "$current_scheme" = "prefer-dark" ]; then
      next_mode="light"
      color_scheme="prefer-light"
    elif [ "$current_scheme" = "prefer-light" ]; then
      next_mode="dark"
      color_scheme="prefer-dark"
    else
      printf '%s\n' \
        "toggle-polarity: refusing to toggle because org.gnome.desktop.interface color-scheme is '$current_scheme'." \
        "Run 'toggle-polarity dark' or 'toggle-polarity light' once to establish an explicit state." \
        >&2
      exit 1
    fi
    ;;
  *)
    printf 'usage: %s [dark|light|toggle]\n' "$0" >&2
    exit 1
    ;;
esac

read -r wallpaper < "$HOME/.cache/bgpath"
matugen image "$wallpaper" -m "$next_mode" --source-color-index 0
gsettings set org.gnome.desktop.interface color-scheme "$color_scheme"
