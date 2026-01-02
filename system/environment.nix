_: {
  environment = {
    localBinInPath = true;
    variables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      DXVK_HDR = 1;
      TERMINAL = "foot";
      MANPAGER = "nvim -c 'Man!'";
      XKB_DEFAULT_OPTIONS = "grp:alt_space_toggle";
      XKD_DEFAULT_LAYOUT = "eu";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_CACHE_HOME = "$HOME/.cache";
      XINITRC = "$HOME/.config/x11/xinitrc";
      NOTMUCH_CONFIG = "$HOME/.config/notmuch-config";
      GTK2_RC_FILES = "$HOME/.config/gtk-2.0/gtkrc-2.0";
      LESSHISTFILE = "$XDG_CACHEHOME/less/history";
      WGETRC = "$HOME/.config/wget/wgetrc";
      INPUTRC = "$HOME/.config/shell/inputrc";
      ZDOTDIR = "$HOME/.config/zsh";
      # ALSA_CONFIG_PATH = "$HOME/.config/alsa/asoundrc";
      GNUPGHOME = "$HOME/.local/share/gnupg";
      WINEPREFIX = "$HOME/.local/share/wineprefixes/default";
      JULIA_DEPOT_PATH = "$HOME/.local/share/julia:$JULIA_DEPOT_PATH";
      KODI_DATA = "$HOME/.local/share/kodi";
      PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
      TMUX_TMPDIR = "$XDG_RUNTIME_DIR";
      ANDROID_SDK_HOME = "$HOME/.config/android";
      CARGO_HOME = "$HOME/.local/share/cargo";
      GOPATH = "$HOME/.local/share/go";
      LEIN_HOME = "$HOME/.local/share/lein";
      ANSIBLE_CONFIG = "$HOME/.config/ansible/ansible.cfg";
      UNISON = "$HOME/.local/share/unison";
      HISTFILE = "$HOME/.local/share/history";
      WEECHAT_HOME = "$HOME/.config/weechat";
      MBSYNCRC = "$HOME/.config/mbsync/config";
      ELECTRUMDIR = "$HOME/.local/share/electrum";
      # Other program settings:;
      DICS = "/usr/share/stardict/dic/";
      SUDO_ASKPASS = "$HOME/.local/bin/dmenupass";
      FZF_DEFAULT_OPTS = "--layout=reverse --height 40%";
      LESS = "-R";
      LESS_TERMCAP_mb = "$(printf '%b' '[1;31m')";
      LESS_TERMCAP_md = "$(printf '%b' '[1;36m')";
      LESS_TERMCAP_me = "$(printf '%b' '[0m')";
      LESS_TERMCAP_so = "$(printf '%b' '[01;44;33m')";
      LESS_TERMCAP_se = "$(printf '%b' '[0m')";
      LESS_TERMCAP_us = "$(printf '%b' '[1;32m')";
      LESS_TERMCAP_ue = "$(printf '%b' '[0m')";
      QT_QPA_PLATFORMTHEME = "qt6ct"; # Have QT use gtk2 theme.
      QT_QPA_PLATFORM = "wayland";
      MOZ_USE_XINPUT2 = "1"; # Mozilla smooth scrolling/touchpads.
      AWT_TOOLKIT = "MToolkit wmname LG3D"; # May have to install wmname
      _JAVA_AWT_WM_NONREPARENTING = "1"; # Fix for Java applications
    };
    shellAliases = {
      # Verbosity and settings that you pretty much just always are going to want.
      river = "XKB_DEFAULT_LAYOUT=eu river";
      rcow = "fortune | cowsay -r | lolcat";
      cp = "cp -iv";
      nnn = "nnn -e";
      mv = "mv -iv";
      rm = "rm -vI";
      bc = "bc -ql";
      rg = "cd .steam/steam/steamapps/compatdata/813780/pfx/drive_c/users/steamuser/Games/Age\ of\ Empires\ 2\ DE/76561199050658286/savegame";
      mkd = "mkdir -pv";
      yt = "yt-dlp --embed-metadata -i";
      yta = "yt -x -f bestaudio/best";
      ffmpeg = "ffmpeg -hide_banne";
      # Colorize commands when possible.;
      ls = "exa --header --icons --group-directories-first";
      nvimtutor = "nvim -c Tutor";
      cat = "bat";
      ll = "exa --long --header --icons --color-scale all --group-directories-first";
      l = "exa --long --header --icons --color-scale all --group-directories-first";
      nn = "cd ~/.config/nvim/ && ls";
      grep = "grep --color=auto";
      diff = "diff --color=auto";
      ccat = "highlight --out-format=ansi";
      ip = "ip -color";
      # These common commands are just too long! Abbreviate them.;
      ka = "killall";
      g = "git";
      trem = "transmission-remote";
      YT = "youtube-viewer";
      sdn = "shutdown -h now";
      e = "nvim";
      v = "nvim";
      p = "pacman";
      update = "sudo pacman -Sy && sudo powerpill -Su && yay -Su";
      xi = "sudo xbps-install";
      xr = "sudo xbps-remove -R";
      xq = "xbps-query";
      config = "/usr/bin/git --git-dir=/home/soliprem/.cfg/ --work-tree=/home/soliprem";
      z = "zathura";

      "cd.." = "cd ..";
      lf = "lfub";
      # alias yay="paru"
      magit = "nvim -c MagitOnly";
      #alias ref="shortcuts >/dev/null; source $HOME/.config/shell/shortcutrc ; source $HOME/.config/.config}/shell/zshnameddirrc"
      #alias weath="less -S $XDG_DATA_HOME/share}/weatherreport"

      # vim: filetype=sh

      cac = "cd $HOME/.cache && ls -a";
      cf = "cd $HOME/.config && ls -a";
      D = "cd $HOME/Downloads && ls -a";
      i = "cd /home/soliprem/Images && ls -a";
      d = "cd $HOME/Documents && ls -a";
      dt = "cd $HOME/.local/share && ls -a";
      rr = "cd $HOME/.local/src && ls -a";
      h = "cd $HOME && ls -a";
      m = "cd $HOME/Music && ls -a";
      mn = "cd /mnt && ls -a";
      pp = "cd $HOME/Pictures && ls -a";
      sc = "cd $HOME/.local/bin && ls -a";
      src = "cd $HOME/.local/src && ls -a";
      vv = "cd $HOME/Videos && ls -a";
      bf = "$EDITOR $HOME/.config/shell/bm-files";
      bd = "$EDITOR $HOME/.config/shell/bm-dirs";
      cfx = "$EDITOR $HOME/.config/x11/xresources";
      cfb = "$EDITOR ~/.local/src/dwmblocks/config.h";
      cfv = "$EDITOR $HOME/.config/nvim/init.vim";
      cfz = "$EDITOR $HOME/.config/zsh/.zshrc";
      cfa = "$EDITOR $HOME/.config/shell/aliasrc";
      cfp = "$EDITOR $HOME/.config/shell/profile";
      cfm = "$EDITOR $HOME/.config/mutt/muttrc";
      cfn = "$EDITOR $HOME/.config/newsboat/config";
      cfu = "$EDITOR $HOME/.config/newsboat/urls";
      cfmb = "$EDITOR $HOME/.config/ncmpcpp/bindings";
      cfmc = "$EDITOR $HOME/.config/ncmpcpp/config";
      cfl = "$EDITOR $HOME/.config/lf/lfrc";
      cfL = "$EDITOR $HOME/.config/lf/scope";
      cfX = "$EDITOR $HOME/.config/sxiv/exec/key-handler";
    };
  };
}
