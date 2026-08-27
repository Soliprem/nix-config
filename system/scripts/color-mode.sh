export XDG_DATA_DIRS="$NIXRICE_GSETTINGS_SCHEMA_PATH:$XDG_DATA_DIRS"
state_file="${XDG_STATE_HOME:-$HOME/.local/state}/nixrice/type"
default_type="scheme-expressive"
types="scheme-content
scheme-expressive
scheme-fidelity
scheme-fruit-salad
scheme-monochrome
scheme-neutral
scheme-rainbow
scheme-tonal-spot
scheme-vibrant"

mkdir -p "$(dirname "$state_file")"
current_type="$(cat "$state_file" 2>/dev/null || printf '%s\n' "$default_type")"

case "${1:-pick}" in
  pick)
    type="$(printf '%s\n' "$types" | fuzzel --dmenu --prompt "Matugen type > " --placeholder "$current_type")"
    [ -n "$type" ] || exit 0
    ;;
  current|get|print)
    printf '%s\n' "$current_type"
    exit 0
    ;;
  list)
    printf '%s\n' "$types"
    exit 0
    ;;
  toggle)
    if [ "$current_type" = "scheme-expressive" ]; then
      type="scheme-vibrant"
    else
      type="scheme-expressive"
    fi
    ;;
  *)
    type="$1"
    ;;
esac

printf '%s\n' "$types" | grep -qxF "$type" || {
  printf 'change-mode: unsupported type: %s\n' "$type" >&2
  exit 1
}

printf '%s\n' "$type" > "$state_file"

read -r wallpaper < "$HOME/.cache/bgpath"

if [ -r "${wallpaper:-}" ]; then
  theme_mode="$(gsettings get org.gnome.desktop.interface color-scheme)"
  theme_mode="${theme_mode%\'}"
  theme_mode="${theme_mode#\'}"
  [ "$theme_mode" = "prefer-dark" ] && mode="dark" || mode="light"
  matugen image "$wallpaper" -m "$mode" -t "$type" --source-color-index 0
fi
