state_file="${XDG_STATE_HOME:-$HOME/.local/state}/nixrice/style"
style="$(cat "$state_file" 2>/dev/null || printf 'material\n')"

if [ "$style" = cyberpunk ] && [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
  exec cyberarch-lock
elif [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
  pidof hyprlock >/dev/null || exec hyprlock
else
  pidof swaylock >/dev/null || exec swaylock
fi
