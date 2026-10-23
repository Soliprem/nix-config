export XDG_DATA_DIRS="$NIXRICE_GSETTINGS_SCHEMA_PATH:$XDG_DATA_DIRS"
NIXRICE_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nixrice"
NIXRICE_TYPE_FILE="$NIXRICE_STATE_DIR/type"
DEFAULT_MATUGEN_TYPE="scheme-tonal-spot"
THEME_MODE=$(gsettings get org.gnome.desktop.interface color-scheme)

# Clean up quotes (returns 'prefer-dark' or 'default')
THEME_MODE="${THEME_MODE%\'}"
THEME_MODE="${THEME_MODE#\'}"

if [[ "$THEME_MODE" == "prefer-dark" ]]; then
  MATUGEN_MODE="dark"
else
  MATUGEN_MODE="light"
fi

mkdir -p "$NIXRICE_STATE_DIR"
if [ -r "$NIXRICE_TYPE_FILE" ]; then
  MATUGEN_TYPE="$(tr -d '\n' < "$NIXRICE_TYPE_FILE")"
else
  MATUGEN_TYPE="$DEFAULT_MATUGEN_TYPE"
fi

case "$MATUGEN_TYPE" in
  scheme-content|scheme-expressive|scheme-fidelity|scheme-fruit-salad|scheme-monochrome|scheme-neutral|scheme-rainbow|scheme-tonal-spot|scheme-vibrant)
    ;;
  *)
    MATUGEN_TYPE="$DEFAULT_MATUGEN_TYPE"
    ;;
esac

if [[ ${1:-} ]]; then
  wallpaper="$(realpath "$1")"
else
  cd "$HOME"/Pictures/wallpapers || return 1
  wallpaper="$(thumbpick ~/Pictures/wallpapers)"
  if [[ $wallpaper ]]; then
    wallpaper="$(realpath "$wallpaper")"
  fi
fi

if [[ $wallpaper ]]; then
  printf '%s\n' "$wallpaper" > "$HOME/.cache/bgpath"
  matugen image "$wallpaper" -m "$MATUGEN_MODE" -t "$MATUGEN_TYPE" --source-color-index 0
  cp "$wallpaper" ~/.local/src/nix-config/assets/bg
else
  echo "no wallpaper selected"
fi
