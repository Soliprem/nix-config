_: {
  files = {
    ".config/dmscripts/config".text = /* bash */ ''
      #!/usr/bin/env bash
      # shellcheck disable=SC2034

      # --- Main Program Definitions ---

      # DMENU variable
      DMENU="fuzzel --cache "$XDG_CACHE_HOME/fuzzel-dmscripts-history" -dp"

      # Fallback/Alternative Menus (defaults preserved)
      RMENU="rofi -dmenu -i -p"
      FMENU="fzf --bind=enter:replace-query+print-query --border=rounded --margin=5% --color=dark --height 100% --reverse --header=$(basename "$0") --info=hidden --header-first --prompt"

      # Applications
      PDF_VIEWER="zathura"
      DMBROWSER="zen"
      DMTERM="ghostty -e"
      DMEDITOR="''${DMTERM} nvim"
      DMLOCKER="swaylock"

      # --- Script Specific Configurations ---

      # dm-bookman
      bookman_show_source=1

      # dm-sounds
      sounds_dir="''${HOME}/.config/dmscripts/dmsounds"

      # dm-setbg
      setbg_dir="''${HOME}/.local/src/wallpapers"
      use_imv=0

      # dm-maim
      maim_dir="''${HOME}/Screenshots"
      maim_file_prefix="maim"

      # dm-note
      note_dir="''${HOME}/.config/dmscripts/dmnote"

      # --- Lists and Arrays (Note: All must use -g flag now) ---

      # dm-confedit config
      declare -Ag confedit_list
      confedit_list[confedit]="$HOME/.config/dmscripts/config"
      confedit_list[dwm]="$HOME/.local/src/suckless/dwm/config.h"
      confedit_list[alacritty]="$HOME/.config/alacritty/alacritty.yml"
      confedit_list[awesome]="$HOME/.config/awesome/rc.lua"
      confedit_list[bash]="$HOME/.bashrc"
      confedit_list[broot]="$HOME/.config/broot/conf.toml"
      confedit_list[bspwm]="$HOME/.config/bspwm/bspwmrc"
      confedit_list[doom emacs config.el]="$HOME/.config/doom/config.el"
      confedit_list[doom emacs config.org]="$HOME/.config/doom/config.org"
      confedit_list[doom emacs init.el]="$HOME/.config/doom/init.el"
      confedit_list[doom emacs packages.el]="$HOME/.config/doom/packages.el"
      confedit_list[dunst]="$HOME/.config/dunst/dunstrc"
      confedit_list[fish]="$HOME/.config/fish/config.fish"
      confedit_list[herbstluftwm]="$HOME/.config/herbstluftwm/autostart"
      confedit_list[i3]="$HOME/.config/i3/config"
      confedit_list[ncmpcpp]="$HOME/.config/ncmpcpp/config"
      confedit_list[neovim]="$HOME/.config/nvim/init.vim"
      confedit_list[picom]="$HOME/.config/picom/picom.conf"
      confedit_list[polybar]="$HOME/.config/polybar/config"
      confedit_list[qtile]="$HOME/.config/qtile/config.py"
      confedit_list[qutebrowser bookmarks]="$HOME/.config/qutebrowser/bookmarks/urls"
      confedit_list[qutebrowser quickmarks]="$HOME/.config/qutebrowser/quickmarks"
      confedit_list[qutebrowser config.py]="$HOME/.config/qutebrowser/config.py"
      confedit_list[spectrwm]="$HOME/.spectrwm.conf"
      confedit_list[ssh]="$HOME/.ssh/config"
      confedit_list[st]="$HOME/st-distrotube/config.def.h"
      confedit_list[stumpwm]="$HOME/.config/stumpwm/config"
      confedit_list[surf]="$HOME/surf-distrotube/config.def.h"
      confedit_list[sxhkd]="$HOME/.config/sxhkd/sxhkdrc"
      confedit_list[tabbed]="$HOME/tabbed-distrotube/config.def.h"
      confedit_list[vifm]="$HOME/.config/vifm/vifmrc"
      confedit_list[vim]="$HOME/.vimrc"
      confedit_list[xmobar mon1]="$HOME/.config/xmobar/xmobarrc0"
      confedit_list[xmobar mon2]="$HOME/.config/xmobar/xmobarrc1"
      confedit_list[xmobar mon3]="$HOME/.config/xmobar/xmobarrc2"
      confedit_list[xmonad]="$HOME/.xmonad/README.org"
      confedit_list[xinitrc]="$HOME/.xinitrc"
      confedit_list[xresources]="$HOME/.Xresources"
      confedit_list[zsh]="$HOME/.zshrc"

      # dm-websearch config
      declare -Ag websearch
      # Search Engines
      websearch[bing]="https://www.bing.com/search?q="
      websearch[brave]="https://search.brave.com/search?q="
      websearch[duckduckgo]="https://duckduckgo.com/?q="
      websearch[gemini search \(https\)]="https://portal.mozz.us/gemini/geminispace.info/search%3F"
      websearch[google]="https://www.google.com/search?q="
      websearch[qwant]="https://www.qwant.com/?q="
      websearch[swisscows]="https://swisscows.com/web?query="
      websearch[yandex]="https://yandex.com/search/?text="
      # Information/News
      websearch[bbcnews]="https://www.bbc.co.uk/search?q="
      websearch[cnn]="https://www.cnn.com/search?q="
      websearch[googlenews]="https://news.google.com/search?q="
      websearch[wikipedia]="https://en.wikipedia.org/w/index.php?search="
      websearch[wiktionary]="https://en.wiktionary.org/w/index.php?search="
      # Social Media
      websearch[reddit]="https://www.reddit.com/search/?q="
      websearch[odysee]="https://odysee.com/$/search?q="
      websearch[youtube]="https://www.youtube.com/results?search_query="
      # Online Shopping
      websearch[amazon]="https://www.amazon.com/s?k="
      websearch[craigslist]="https://www.craigslist.org/search/sss?query="
      websearch[ebay]="https://www.ebay.com/sch/i.html?&_nkw="
      websearch[gumtree]="https://www.gumtree.com/search?search_category=all&q="
      # Linux
      websearch[archaur]="https://aur.archlinux.org/packages/?O=0&K="
      websearch[archpkg]="https://archlinux.org/packages/?sort=&q="
      websearch[archwiki]="https://wiki.archlinux.org/index.php?search="
      websearch[debianpkg]="https://packages.debian.org/search?suite=default&section=all&arch=any&searchon=names&keywords="
      # Development
      websearch[github]="https://github.com/search?q="
      websearch[gitlab]="https://gitlab.com/search?search="
      websearch[googleOpenSource]="https://opensource.google/projects/search?q="
      websearch[sourceforge]="https://sourceforge.net/directory/?q="
      websearch[stackoverflow]="https://stackoverflow.com/search?q="

      # dm-youtube config
      declare -Ag youtube_channels
      youtube_channels[distrotube]="https://www.youtube.com/c/DistroTube/featured"

      # dm-radio config
      DMRADIOVOLUME="100"
      declare -Ag radio_stations
      radio_stations[50s Rewind]="https://zeno.fm/radio/50s-rewind/"
      radio_stations[60s Rewind]="https://zeno.fm/radio/60s-rewind/"
      radio_stations[70s Rewind]="https://zeno.fm/radio/70s-rewind/"
      radio_stations[80s Rewind]="https://zeno.fm/radio/80s-rewind/"
      radio_stations[90s Rock]="https://zeno.fm/radio/90s-rock/"
      radio_stations[The 2000s]="https://zeno.fm/radio/the-2000s/"
      radio_stations[Classical Radio]="https://zeno.fm/radio/classical-radio/"
      radio_stations[Classical Relaxation]="https://zeno.fm/radio/radio-christmas-non-stop-classical/"
      radio_stations[Classic Rock]="https://zeno.fm/radio/classic-rockdnb2sav8qs8uv/"
      radio_stations[Gangsta49]="https://zeno.fm/radio/gangsta49/"
      radio_stations[HipHop49]="https://zeno.fm/radio/hiphop49/"
      radio_stations[Madhouse Country Radio]="https://zeno.fm/radio/madhouse-country-radio/"
      radio_stations[PopMusic]="https://zeno.fm/radio/popmusic74vyurvmug0uv/"
      radio_stations[PopStars]="https://zeno.fm/radio/popstars/"
      radio_stations[RadioMetal]="https://zeno.fm/radio/radio-metal/"
      radio_stations[RocknRoll Radio]="https://zeno.fm/radio/rocknroll-radio994c7517qs8uv/"

      # dm-colpick config
      declare -Ag colpick_list
      colpick_list[black]="#282a36"
      colpick_list[red]="#ff5555"
      colpick_list[green]="#5af78e"
      colpick_list[yellow]="#f1fa8c"
      colpick_list[blue]="#57c7ff"
      colpick_list[magenta]="#ff6ac1"
      colpick_list[cyan]="#8be9fd"
      colpick_list[white]="#f1f1f0"
      colpick_list[orange]="#ffb86c"
      colpick_list[purple]="#bd9cf9"

      # dm-reddit config
      declare -ag reddit_list=(
          "r/archlinux"
          "r/bash"
          "r/commandline"
          "r/emacs"
          "r/freesoftware"
          "r/linux"
          "r/linux4noobs"
          "r/linuxmasterrace"
          "r/linuxquestions"
          "r/suckless"
          "r/Ubuntu"
          "r/unixporn"
          "r/vim"
      )

      # dm-weather config
      # Note: Old 'declare -A' style is no longer supported. Use the string format below.
      # Example: weather_locations="New York, United States\nLondon, United Kingdom"
      weather_locations=""
      weather_opts=""

      # current revision (do not touch unless you know what you're doing)
      _revision=27

    '';
  };
}
