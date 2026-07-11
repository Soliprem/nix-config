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
  imports = [inputs.mango.nixosModules.mango];
  environment.systemPackages = with pkgs; [
    # Flake inputs and custom derivations
    inputs.agenix.packages.${sys}.default
    inputs.self.packages.${sys}.nvf
    inputs.thumbpick.packages.${sys}.default
    inputs.roam-graph.packages.${sys}.default
    inputs.zen-browser.packages.${sys}.default
    inputs.stash.packages.${sys}.default
    inputs.tuicr.packages.${sys}.default
    inputs.ferrosonic.packages.${sys}.default
    inputs.beer.packages.${sys}.default
    cava
    codex
    t3code
    zk
    graphviz
    ladybird
    waypipe

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
    swappy
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
      pinentryPackage = pkgs.pinentry-curses;
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
