printf -v hour '%(%H)T' -1

if ((10#$hour < 5)); then
  greeting="Good Night"
elif ((10#$hour < 12)); then
  greeting="Good Morning"
elif ((10#$hour < 17)); then
  greeting="Good Day"
elif ((10#$hour < 20)); then
  greeting="Good Afternoon"
elif ((10#$hour < 23)); then
  greeting="Good Evening"
else
  greeting="Good Night"
fi

elephant() {
  printf '%s%s\n' "$1" "$greeting, Soli!"
  printf '%s%s\n' "$1" '     \/'
  printf '%s%s\n' "$1" '      ,  __'
  printf '%s%s\n' "$1" "      '.'°()--."
  printf '%s%s\n' "$1" "        ', . ,|'"
  printf '%s%s\n' "$1" '         /_)-_!'
}

cols=$(tput cols)
min_inline_cols=100

case "${1:-}" in
  --hide)
    narrow_mode=hide
    ;;
  --stack|"")
    narrow_mode=stack
    ;;
  *)
    printf 'Usage: greeting [--hide|--stack]\n' >&2
    exit 2
    ;;
esac

if ((cols < min_inline_cols)); then
  microfetch

  if [[ $narrow_mode == stack ]]; then
    printf '\n'
    elephant '    ' | dotacat
  fi

  exit 0
fi

# 21 columns for the elephant and a 2-column right margin.
width=$((cols - 23))

paste -d '\0' \
  <(
    microfetch |
      awk -v width="$width" '
        {
          plain = $0
          gsub(/\033\[[0-9;]*m/, "", plain)

          padding = width - length(plain)

          if (padding < 0) {
            padding = 0
          }

          printf "%s%*s\n", $0, padding, ""
        }
      '
  ) \
  <(
    {
      printf '\n\n\n\n\n'
      elephant "" | dotacat
    }
  )
