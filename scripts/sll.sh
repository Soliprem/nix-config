# very subtle easter egg, turn up the volume and wear headphones to get the best experience
trap "pkill mpv" EXIT
if ! [ -e ~/.cache/thomas.mp3 ]; then
  pushd .
  cd ~/.cache/ || exit 1
  wget -q thomasthetankengine.surge.sh/thomas.mp3
  popd || echo "bruh"
fi

if pgrep mpv; then
  sl "$@"
  exit
fi

mpv ~/.cache/thomas.mp3 &>/dev/null &
command sl "$@"
