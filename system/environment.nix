{ 
environment = {
  localBinInPath = true;
  variables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "foot";
    MANPAGER = "nvim -c 'Man!'";
    XKB_DEFAULT_OPTIONS="caps:swapescape";
    XKD_DEFAULT_LAYOUT="eu";
    XDG_CONFIG_HOME="$HOME/.config";
    XDG_DATA_HOME="$HOME/.local/share";
    XDG_CACHE_HOME="$HOME/.cache";
    XINITRC="$XDG_CONFIG_HOME/x11/xinitrc";
    NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch-config";
    GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0";
    LESSHISTFILE="$XDG_CACHEHOME/less/history";
    WGETRC="$XDG_CONFIG_HOME/wget/wgetrc";
    INPUTRC="$XDG_CONFIG_HOME/shell/inputrc";
    ZDOTDIR="$XDG_CONFIG_HOME/zsh";
    ALSA_CONFIG_PATH="$XDG_CONFIG_HOME/alsa/asoundrc";
    GNUPGHOME="$XDG_DATA_HOME/gnupg";
    WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default";
    JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH";
    KODI_DATA="$XDG_DATA_HOME/kodi";
    PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store";
    TMUX_TMPDIR="$XDG_RUNTIME_DIR";
    ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android";
    CARGO_HOME="$XDG_DATA_HOME/cargo";
    GOPATH="$XDG_DATA_HOME/go";
    LEIN_HOME="$XDG_DATA_HOME/lein";
    ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible/ansible.cfg";
    UNISON="$XDG_DATA_HOME/unison";
    HISTFILE="$XDG_DATA_HOME/history";
    WEECHAT_HOME="$XDG_CONFIG_HOME/weechat";
    MBSYNCRC="$XDG_CONFIG_HOME/mbsync/config";
    ELECTRUMDIR="$XDG_DATA_HOME/electrum";
    # Other program settings:;
    DICS="/usr/share/stardict/dic/";
    SUDO_ASKPASS="$HOME/.local/bin/dmenupass";
    FZF_DEFAULT_OPTS="--layout=reverse --height 40%";
    LESS="-R";
    LESS_TERMCAP_mb="$(printf '%b' '[1;31m')";
    LESS_TERMCAP_md="$(printf '%b' '[1;36m')";
    LESS_TERMCAP_me="$(printf '%b' '[0m')";
    LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')";
    LESS_TERMCAP_se="$(printf '%b' '[0m')";
    LESS_TERMCAP_us="$(printf '%b' '[1;32m')";
    LESS_TERMCAP_ue="$(printf '%b' '[0m')";
    QT_QPA_PLATFORMTHEME="gtk2";	# Have QT use gtk2 theme.
    QT_QPA_PLATFORM="wayland";
    MOZ_USE_XINPUT2="1";		# Mozilla smooth scrolling/touchpads.
    AWT_TOOLKIT="MToolkit wmname LG3D";	#May have to install wmname
    _JAVA_AWT_WM_NONREPARENTING="1";	# Fix for Java applications
    };
  };
}
