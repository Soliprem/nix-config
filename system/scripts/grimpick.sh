if [[ ${1:-} ]]; then
  mode="$1"
else
  mode="$(printf "region\\n\\nall" |\
    wmenu --p "Screenshot which area?")"
fi

case $mode in
  "region")
    grim -g "$(slurp)" - | satty -f -
    ;;
  "all")
    grim - | satty -f -
    ;;
  *)
    echo >&2 "unsupported command \"$mode\""
    echo >&2 "Usage:"
    echo >&2 "grimpick <region|all>"
    exit 1
    ;;
esac
