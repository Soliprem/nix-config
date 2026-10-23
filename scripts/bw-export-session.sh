if [ ! -r /run/agenix/bitwarden_clientid ] \
  || [ ! -r /run/agenix/bitwarden_clientsecret ] \
  || [ ! -r /run/agenix/bitwarden_password ]; then
  exit 0
fi

BW_CLIENTID="$(tr -d '\n' < /run/agenix/bitwarden_clientid)"
BW_CLIENTSECRET="$(tr -d '\n' < /run/agenix/bitwarden_clientsecret)"
BW_PASSWORD="$(tr -d '\n' < /run/agenix/bitwarden_password)"
export BW_CLIENTID BW_CLIENTSECRET BW_PASSWORD

bw_status="$(bw status 2>/dev/null || true)"

case "$bw_status" in
  *'"status":"unauthenticated"'* | *'"status": "unauthenticated"'*)
    bw login --apikey --nointeraction >/dev/null 2>&1 || exit 0
    bw_status="$(bw status 2>/dev/null || true)"
    ;;
esac

case "$bw_status" in
  *'"status":"unlocked"'* | *'"status": "unlocked"'*)
    if [ -n "${BW_SESSION:-}" ]; then
      printf '%s\n' "$BW_SESSION"
    fi
    ;;
  *'"status":"locked"'* | *'"status": "locked"'* | *'"status":"unauthenticated"'* | *'"status": "unauthenticated"'*)
    bw_session="$(bw unlock --passwordenv BW_PASSWORD --raw 2>/dev/null || true)"
    if [ -n "$bw_session" ]; then
      printf '%s\n' "$bw_session"
    fi
    ;;
esac
