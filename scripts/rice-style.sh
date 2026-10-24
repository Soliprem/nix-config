state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/nixrice"
state_file="$state_dir/shell"
mkdir -p "$state_dir"

current_shell() {
  cat "$state_file" 2>/dev/null || printf '%s\n' "$NIXRICE_DEFAULT_SHELL"
}

available() {
  [ -x "$NIXRICE_SHELLS/$1/on" ] && "$NIXRICE_SHELLS/$1/available"
}

list_shells() {
  for profile in "$NIXRICE_SHELLS"/*; do
    name="${profile##*/}"
    if available "$name"; then
      printf '%s\n' "$name"
    fi
  done
}

case "${1:-current}" in
  current|get|print)
    current_shell
    exit 0
    ;;
  list)
    list_shells
    exit 0
    ;;
  action|wallpaper)
    action="${2:-wallpaper}"
    [ "$1" = wallpaper ] || shift
    shift
    profile="$(current_shell)"
    exec "$NIXRICE_SHELLS/$profile/$action" "$@"
    ;;
esac

# Keep rapid switches from interleaving their off/on sequences.
exec 9>"$state_dir/switch.lock"
flock 9
current="$(current_shell)"

case "$1" in
  on|apply)
    next="$current"
    if ! available "$next"; then
      next="$NIXRICE_DEFAULT_SHELL"
    fi
    ;;
  off)
    "$NIXRICE_SHELLS/$current/off"
    exit 0
    ;;
  toggle)
    mapfile -t profiles < <(list_shells)
    next="$NIXRICE_DEFAULT_SHELL"
    for i in "${!profiles[@]}"; do
      if [ "${profiles[$i]}" = "$current" ]; then
        next="${profiles[$(((i + 1) % ${#profiles[@]}))]}"
        break
      fi
    done
    ;;
  *) next="$1" ;;
esac

if ! available "$next"; then
  printf 'rice-style: shell unavailable in this session: %s\n' "$next" >&2
  exit 1
fi

systemctl --user unset-environment WAYLAND_DISPLAY DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP XDG_SESSION_TYPE
systemctl --user import-environment WAYLAND_DISPLAY DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP XDG_SESSION_TYPE 2>/dev/null || true

if [ "$current" != "$next" ] && [ -x "$NIXRICE_SHELLS/$current/off" ]; then
  "$NIXRICE_SHELLS/$current/off"
fi
if ! "$NIXRICE_SHELLS/$next/on"; then
  "$NIXRICE_SHELLS/$next/off"
  "$NIXRICE_SHELLS/$current/on"
  exit 1
fi
printf '%s\n' "$next" > "$state_file.tmp"
mv "$state_file.tmp" "$state_file"

if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
  hyprctl reload >/dev/null
fi
