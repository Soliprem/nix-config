{
  inputs,
  pkgs,
  ...
}: let
  sys = pkgs.stdenv.hostPlatform.system;
  stremioFixed = pkgs.stremio-linux-shell.overrideAttrs (old: {
    nativeBuildInputs =
      (old.nativeBuildInputs or [])
      ++ [
        pkgs.makeWrapper
      ];

    postFixup =
      (old.postFixup or "")
      + ''
        mv $out/bin/stremio $out/bin/stremio-unwrapped

        makeWrapper ${pkgs.strace}/bin/strace $out/bin/stremio \
          --add-flags "-f" \
          --add-flags "-qq" \
          --add-flags "-o" \
          --add-flags "/dev/null" \
          --add-flags "-e" \
          --add-flags "trace=none" \
          --add-flags "$out/bin/stremio-unwrapped"
      '';
  });
in {
  environment.systemPackages = with pkgs; [
    # Flake inputs and custom derivations
    (runCommand "stash-symlinks" {} ''
      mkdir -p $out/bin
      for bin in stash-copy stash-paste wl-copy wl-paste; do
        ln -s ${lib.getExe stash-clipboard} $out/bin/$bin
      done
    '')
    inputs.agenix.packages.${sys}.default
    inputs.deploy-rs.packages.${sys}.default
    inputs.self.packages.${sys}.nvf
    inputs.thumbpick.packages.${sys}.default
    inputs.roam-graph.packages.${sys}.default
    inputs.zen-browser.packages.${sys}.default
    inputs.tuicr.packages.${sys}.default
    inputs.ferrosonic.packages.${sys}.default
    inputs.beer.packages.${sys}.default
    cava
    stash-clipboard
    codex
    t3code
    zk
    graphviz
    inputs.self.packages.${sys}.doom-emacs
    mu
    inputs.self.packages.${sys}.isync-oauth
    msmtp
    oama
    ispell

    # CLI, shells, and core tools
    gnupg
    xleak
    drawy
    atuin
    bat
    btop-rocm
    carapace
    # comma
    cowsay
    eza
    fastfetch
    fd
    fortune
    fzf
    git
    pijul
    gdb
    killall
    lazygit
    nix-your-shell
    nushell
    ripgrep
    scarab
    starship
    tealdeer
    termdown
    timer
    udict
    wget
    wiki-tui
    zoxide

    # Editors, development, and authoring
    impression
    zoom-us
    jujutsu
    openai-whisper
    typst
    tinymist
    (texliveSmall.withPackages (ps: [ps.dvipng]))
    zed-editor

    # Wayland, theming, and desktop utilities
    adw-gtk3
    bibata-cursors
    brightnessctl
    darkly
    fuzzel
    gammastep
    ghostty
    hyprshot
    hyprshutdown
    iio-hyprland
    hyprlock
    glib
    kanshi
    kdePackages.polkit-kde-agent-1
    kdePackages.qt6ct
    qt5.qtgraphicaleffects
    libsForQt5.qt5ct
    linearicons-free
    matugen
    networkmanagerapplet
    overskride
    satty
    swaylock-effects
    quickshell
    swayosd
    awww
    tofi
    tray-tui
    wayneko
    wtype
    wlogout
    xwayland-satellite

    # Browsers, communication, and network clients
    beeper
    cinny-desktop
    (callPackage ../packages/sable.nix {
      src = inputs.sable;
      version = "1.21.0";
    })
    gomuks-web
    bitwarden-desktop
    rnote
    chromium
    legcord
    nextcloud-client
    qutebrowser
    telegram-desktop
    super-productivity
    thunderbird
    himalaya
    transmission_4-gtk

    # General desktop applications
    anki-bin
    appimage-run
    darktable
    foot
    gale
    gowall
    imv
    keyutils
    loupe
    lumafly
    lutgen-studio
    mediawriter
    meow
    nautilus
    obsidian
    papers
    stremioFixed
    losange
    proton-vpn-cli
    proton-vpn
    yad
    zathura
    sioyek
    zotero

    # Audio, video, and creative tools
    alsa-utils
    audacity
    ffmpeg
    gimp
    kdePackages.qtmultimedia
    libnotify
    mpv
    muse-sounds-manager
    musescore
    pipewire
    pwvucontrol
    qpwgraph
    spek
    spotdl
    tauon
    strawberry
    wiremix

    # Gaming
    beyond-all-reason
    gamemode
    heroic
    mangohud
    goverlay
    prismlauncher
    protonplus
    umu-launcher

    # Miscellaneous apps and helpers
    bluetui
    wifitui
    via
    dotacat
    nicotine-plus
    sunsetr
  ];
  programs = {
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-all;
    };
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        input-overlay
        obs-livesplit-one
      ];
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        glib
        nss
        nspr
        dbus
        atk
        cups
        gtk3
        alsa-lib
        at-spi2-atk
        at-spi2-core
        pango
        cairo
        fontconfig
        freetype
        harfbuzz
        libgbm
        libdrm
        gdk-pixbuf
        expat
        glibc
        # X11 libraries
        libx11
        libxcomposite
        libxdamage
        libxext
        libxfixes
        libxrandr
        libxrender
        libxtst
        libxscrnsaver
        libxcb
        libxi
        libxcursor
        # Additional libraries that might be needed
        libxkbcommon
        wayland
      ];
    };
    kdeconnect.enable = true;
    # river.enable = true;
    niri.enable = true;
    hyprland.enable = true;
    mango = {
      enable = true;
    };
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/soliprem/.local/src/nix-config";
    };
  };
}
