printf '%s' "$*" | socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/astal/cyberpunk.sock" >/dev/null
